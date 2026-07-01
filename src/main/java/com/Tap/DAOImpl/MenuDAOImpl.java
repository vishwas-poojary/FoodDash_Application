package com.Tap.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.Tap.DAO.MenuDAO;
import com.Tap.Model.Menu;
import com.Tap.utility.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT = "INSERT INTO menu (restaurantId, itemName, description, price, isAvailable, category, createdAt, updatedAt, deletedAt, stock, imageUrl) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    private static final String SELECT_BY_ID = "SELECT * FROM menu WHERE menuId = ?";
    private static final String SELECT_ALL = "SELECT * FROM menu";
    private static final String SELECT_BY_RESTAURANT = "SELECT * FROM menu WHERE restaurantId = ?";
    private static final String UPDATE = "UPDATE menu SET restaurantId=?, itemName=?, description=?, price=?, isAvailable=?, category=?, updatedAt=?, deletedAt=?, stock=?, imageUrl=? WHERE menuId=?";
    private static final String DELETE = "DELETE FROM menu WHERE menuId=?";
    private static final String UPDATE_STOCK = "UPDATE menu SET stock = ? WHERE menuId = ?";

    @Override
    public void addMenu(Menu m) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT)) {
            pstmt.setInt(1, m.getRestaurantId());
            pstmt.setString(2, m.getItemName());
            pstmt.setString(3, m.getDescription());
            pstmt.setDouble(4, m.getPrice());
            pstmt.setBoolean(5, m.isAvailable());
            pstmt.setString(6, m.getCategory());
            pstmt.setTimestamp(7, m.getCreatedAt());
            pstmt.setTimestamp(8, m.getUpdatedAt());
            pstmt.setTimestamp(9, m.getDeletedAt());
            pstmt.setInt(10, m.getStock());
            pstmt.setString(11, m.getImageUrl());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public Menu getMenu(int id) {
        Menu m = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) m = extract(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return m;
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {
        List<Menu> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_RESTAURANT)) {
            pstmt.setInt(1, restaurantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(extract(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public void updateMenu(Menu m) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE)) {
            pstmt.setInt(1, m.getRestaurantId());
            pstmt.setString(2, m.getItemName());
            pstmt.setString(3, m.getDescription());
            pstmt.setDouble(4, m.getPrice());
            pstmt.setBoolean(5, m.isAvailable());
            pstmt.setString(6, m.getCategory());
            pstmt.setTimestamp(7, m.getUpdatedAt());
            pstmt.setTimestamp(8, m.getDeletedAt());
            pstmt.setInt(9, m.getStock());
            pstmt.setString(10, m.getImageUrl());
            pstmt.setInt(11, m.getMenuId());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void deleteMenu(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void updateStock(int menuId, int newStock) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_STOCK)) {
            pstmt.setInt(1, newStock);
            pstmt.setInt(2, menuId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Menu extract(ResultSet rs) throws SQLException {
        Menu m = new Menu();
        m.setMenuId(rs.getInt("menuId"));
        m.setRestaurantId(rs.getInt("restaurantId"));
        m.setItemName(rs.getString("itemName"));
        m.setDescription(rs.getString("description"));
        m.setPrice(rs.getDouble("price"));
        m.setAvailable(rs.getBoolean("isAvailable"));
        m.setCategory(rs.getString("category"));
        m.setCreatedAt(rs.getTimestamp("createdAt"));
        m.setUpdatedAt(rs.getTimestamp("updatedAt"));
        m.setDeletedAt(rs.getTimestamp("deletedAt"));
        m.setStock(rs.getInt("stock"));
        m.setImageUrl(rs.getString("imageUrl")); 
        return m;
    }
}