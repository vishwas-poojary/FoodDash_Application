package com.Tap.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.Tap.DAOImpl.CartDAOImpl;
import com.Tap.Model.Cart;
import com.Tap.utility.DBConnection;

public class OrderService {

    private CartDAOImpl cartDAO = new CartDAOImpl();

    public int placeOrder(int userId, int restaurantId, String paymentMethod, String deliveryAddress) {
        Connection con = null;
        int generatedOrderId = -1;

        List<Cart> cartItems = cartDAO.getCartByUser(userId);
        if (cartItems.isEmpty()) {
            System.out.println("Cart is empty");
            return -1;
        }

        double totalAmount = 0.0;
        for (Cart item : cartItems) {
            double price = getMenuPrice(item.getMenuId());
            totalAmount += price * item.getQuantity();

            int availableStock = getMenuStock(item.getMenuId());
            if (availableStock < item.getQuantity()) {
                System.out.println("Insufficient stock for menuId " + item.getMenuId());
                return -1;
            }
        }

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String orderSQL = "INSERT INTO ordertable (userId, restaurantId, orderDate, totalAmount, status, paymentMethod, deliveryAddress) VALUES (?,?,?,?,?,?,?)";
            try (PreparedStatement pstmt = con.prepareStatement(orderSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, userId);
                pstmt.setInt(2, restaurantId);
                pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                pstmt.setDouble(4, totalAmount);
                pstmt.setString(5, "PLACED");
                pstmt.setString(6, paymentMethod);
                pstmt.setString(7, deliveryAddress);
                pstmt.executeUpdate();

                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) generatedOrderId = rs.getInt(1);
                }
            }

            if (generatedOrderId == -1) throw new SQLException("Order insert failed");

            String itemSQL = "INSERT INTO orderitem (orderId, menuId, quantity, itemTotal) VALUES (?,?,?,?)";
            for (Cart item : cartItems) {
                double price = getMenuPrice(item.getMenuId());
                double itemTotal = price * item.getQuantity();

                try (PreparedStatement pstmt = con.prepareStatement(itemSQL)) {
                    pstmt.setInt(1, generatedOrderId);
                    pstmt.setInt(2, item.getMenuId());
                    pstmt.setInt(3, item.getQuantity());
                    pstmt.setDouble(4, itemTotal);
                    pstmt.executeUpdate();
                }

                reduceStock(item.getMenuId(), item.getQuantity(), con);
            }

            String clearSQL = "DELETE FROM cart WHERE userId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(clearSQL)) {
                pstmt.setInt(1, userId);
                pstmt.executeUpdate();
            }

            con.commit();
            System.out.println("Order placed, ID: " + generatedOrderId);

        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            generatedOrderId = -1;
        } finally {
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return generatedOrderId;
    }

    private double getMenuPrice(int menuId) {
        String sql = "SELECT price FROM menu WHERE menuId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, menuId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("price");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private int getMenuStock(int menuId) {
        String sql = "SELECT stock FROM menu WHERE menuId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, menuId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("stock");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private void reduceStock(int menuId, int quantity, Connection con) throws SQLException {
        String sql = "UPDATE menu SET stock = stock - ? WHERE menuId = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, menuId);
            pstmt.executeUpdate();
        }
    }

    public void updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE ordertable SET status = ? WHERE orderId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}