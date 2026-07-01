package com.Tap.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.Tap.DAO.OrderTableDAO;
import com.Tap.Model.OrderTable;
import com.Tap.utility.DBConnection;

public class OrderTableDAOImpl implements OrderTableDAO {

    private static final String INSERT = "INSERT INTO ordertable (userId, restaurantId, orderDate, totalAmount, status, paymentMethod, deliveryAddress) VALUES (?,?,?,?,?,?,?)";
    private static final String SELECT_BY_ID = "SELECT * FROM ordertable WHERE orderId = ?";
    private static final String SELECT_ALL = "SELECT * FROM ordertable";
    private static final String SELECT_BY_USER = "SELECT * FROM ordertable WHERE userId = ?";
    private static final String UPDATE = "UPDATE ordertable SET userId=?, restaurantId=?, orderDate=?, totalAmount=?, status=?, paymentMethod=?, deliveryAddress=? WHERE orderId=?";
    private static final String DELETE = "DELETE FROM ordertable WHERE orderId=?";
    private static final String UPDATE_STATUS = "UPDATE ordertable SET status=? WHERE orderId=?";

    @Override
    public int addOrder(OrderTable o) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            
            System.out.println("=== Inserting Order ===");
            System.out.println("  UserId: " + o.getUserId());
            System.out.println("  RestaurantId: " + o.getRestaurantId());
            System.out.println("  OrderDate: " + o.getOrderDate());
            System.out.println("  TotalAmount: " + o.getTotalAmount());
            System.out.println("  Status: " + o.getStatus());
            System.out.println("  PaymentMethod: " + o.getPaymentMethod());
            System.out.println("  DeliveryAddress: " + o.getDeliveryAddress());
            
            pstmt.setInt(1, o.getUserId());
            pstmt.setInt(2, o.getRestaurantId());
            pstmt.setTimestamp(3, o.getOrderDate());
            pstmt.setDouble(4, o.getTotalAmount());
            pstmt.setString(5, o.getStatus());
            pstmt.setString(6, o.getPaymentMethod());
            pstmt.setString(7, o.getDeliveryAddress());
            
            int rows = pstmt.executeUpdate();
            System.out.println("  Rows inserted: " + rows);
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    o.setOrderId(generatedId);
                    System.out.println("  Generated OrderId: " + generatedId);
                    return generatedId;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ SQL ERROR inserting order:");
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public OrderTable getOrder(int id) {
        OrderTable o = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) o = extract(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return o;
    }

    @Override
    public List<OrderTable> getAllOrders() {
        List<OrderTable> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<OrderTable> getOrdersByUser(int userId) {
        List<OrderTable> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_USER)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(extract(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public void updateOrder(OrderTable o) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE)) {
            pstmt.setInt(1, o.getUserId());
            pstmt.setInt(2, o.getRestaurantId());
            pstmt.setTimestamp(3, o.getOrderDate());
            pstmt.setDouble(4, o.getTotalAmount());
            pstmt.setString(5, o.getStatus());
            pstmt.setString(6, o.getPaymentMethod());
            pstmt.setString(7, o.getDeliveryAddress());
            pstmt.setInt(8, o.getOrderId());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void deleteOrder(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void updateOrderStatus(int orderId, String status) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_STATUS)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private OrderTable extract(ResultSet rs) throws SQLException {
        return new OrderTable(
            rs.getInt("orderId"),
            rs.getInt("userId"),
            rs.getInt("restaurantId"),
            rs.getTimestamp("orderDate"),
            rs.getDouble("totalAmount"),
            rs.getString("status"),
            rs.getString("paymentMethod"),
            rs.getString("deliveryAddress")
        );
    }
}