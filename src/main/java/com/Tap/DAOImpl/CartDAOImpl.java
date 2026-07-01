package com.Tap.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.Tap.DAO.CartDAO;
import com.Tap.Model.Cart;
import com.Tap.utility.DBConnection;

public class CartDAOImpl implements CartDAO {

    private static final String INSERT = "INSERT INTO cart (userId, menuId, quantity) VALUES (?,?,?)";
    private static final String SELECT_BY_ID = "SELECT * FROM cart WHERE cartId = ?";
    private static final String SELECT_BY_USER = "SELECT * FROM cart WHERE userId = ?";
    private static final String UPDATE = "UPDATE cart SET quantity = ? WHERE cartId = ?";
    private static final String DELETE = "DELETE FROM cart WHERE cartId = ?";
    private static final String DELETE_BY_USER = "DELETE FROM cart WHERE userId = ?";

    @Override
    public void addToCart(Cart cart) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT)) {
            pstmt.setInt(1, cart.getUserId());
            pstmt.setInt(2, cart.getMenuId());
            pstmt.setInt(3, cart.getQuantity());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public Cart getCartItem(int cartId) {
        Cart c = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, cartId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) c = extract(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return c;
    }

    @Override
    public List<Cart> getCartByUser(int userId) {
        List<Cart> list = new ArrayList<>();
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
    public void updateQuantity(int cartId, int newQuantity) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE)) {
            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, cartId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void removeFromCart(int cartId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE)) {
            pstmt.setInt(1, cartId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void clearCart(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_BY_USER)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Cart extract(ResultSet rs) throws SQLException {
        return new Cart(
            rs.getInt("cartId"),
            rs.getInt("userId"),
            rs.getInt("menuId"),
            rs.getInt("quantity"),
            rs.getTimestamp("addedDate")
        );
    }
}