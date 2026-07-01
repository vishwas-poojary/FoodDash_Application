package com.Tap.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.Tap.DAO.OrderItemDAO;
import com.Tap.Model.OrderItem;
import com.Tap.utility.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT = "INSERT INTO orderitem (orderId, menuId, quantity, itemTotal) VALUES (?,?,?,?)";
    private static final String SELECT_BY_ID = "SELECT * FROM orderitem WHERE orderItemId = ?";
    private static final String SELECT_ALL = "SELECT * FROM orderitem";
    private static final String SELECT_BY_ORDER = "SELECT * FROM orderitem WHERE orderId = ?";
    private static final String UPDATE = "UPDATE orderitem SET orderId=?, menuId=?, quantity=?, itemTotal=? WHERE orderItemId=?";
    private static final String DELETE = "DELETE FROM orderitem WHERE orderItemId=?";

    @Override
    public void addOrderItem(OrderItem oi) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT)) {

            System.out.println("=== Inserting OrderItem ===");
            System.out.println("  OrderId: " + oi.getOrderId());
            System.out.println("  MenuId: " + oi.getMenuId());
            System.out.println("  Quantity: " + oi.getQuantity());
            System.out.println("  ItemTotal: " + oi.getItemTotal());

            pstmt.setInt(1, oi.getOrderId());
            pstmt.setInt(2, oi.getMenuId());
            pstmt.setInt(3, oi.getQuantity());
            pstmt.setDouble(4, oi.getItemTotal());

            int rows = pstmt.executeUpdate();
            System.out.println("  Rows inserted: " + rows);

        } catch (SQLException e) {
            System.err.println("❌ SQL ERROR inserting order item:");
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int id) {
        OrderItem oi = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) oi = extract(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return oi;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        List<OrderItem> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<OrderItem> getItemsByOrder(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ORDER)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(extract(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public void updateOrderItem(OrderItem oi) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE)) {
            pstmt.setInt(1, oi.getOrderId());
            pstmt.setInt(2, oi.getMenuId());
            pstmt.setInt(3, oi.getQuantity());
            pstmt.setDouble(4, oi.getItemTotal());
            pstmt.setInt(5, oi.getOrderItemId());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void deleteOrderItem(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private OrderItem extract(ResultSet rs) throws SQLException {
        return new OrderItem(
            rs.getInt("orderItemId"),
            rs.getInt("orderId"),
            rs.getInt("menuId"),
            rs.getInt("quantity"),
            rs.getDouble("itemTotal")
        );
    }
}