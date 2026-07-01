package com.Tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.Tap.DAO.RestaurantDAO;
import com.Tap.Model.Restaurant;
import com.Tap.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {
    
    private static final String INSERT = "INSERT INTO restaurant (name, cuisineType, deliveryTime, address, adminUserId, rating, isActive) VALUES (?,?,?,?,?,?,?)";
    private static final String SELECT_ALL = "SELECT restaurantId, name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imageUrl FROM restaurant";
    private static final String SELECT_BY_ID = "SELECT restaurantId, name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imageUrl FROM restaurant WHERE restaurantId = ?";
    private static final String UPDATE = "UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, address=?, adminUserId=?, rating=?, isActive=? WHERE restaurantId=?";
    private static final String DELETE = "DELETE FROM restaurant WHERE restaurantId=?";
   
    @Override
    public void addRestaurant(Restaurant r) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT)) {
            pstmt.setString(1, r.getName());
            pstmt.setString(2, r.getCuisineType());
            pstmt.setInt(3, r.getDeliveryTime());
            pstmt.setString(4, r.getAddress());
            pstmt.setInt(5, r.getAdminUserId());
            pstmt.setDouble(6, r.getRating());
            pstmt.setBoolean(7, r.isActive());
            pstmt.executeUpdate();
            
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public Restaurant getRestaurant(int id) {
        Restaurant r = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) r = extract(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return r;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public void updateRestaurant(Restaurant r) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE)) {
            pstmt.setString(1, r.getName());
            pstmt.setString(2, r.getCuisineType());
            pstmt.setInt(3, r.getDeliveryTime());
            pstmt.setString(4, r.getAddress());
            pstmt.setInt(5, r.getAdminUserId());
            pstmt.setDouble(6, r.getRating());
            pstmt.setBoolean(7, r.isActive());
            pstmt.setInt(8, r.getRestaurantId());
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public void deleteRestaurant(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Restaurant extract(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getInt("restaurantId"));
        r.setName(rs.getString("name"));
        r.setCuisineType(rs.getString("cuisineType"));
        r.setDeliveryTime(rs.getInt("deliveryTime"));
        r.setAddress(rs.getString("address"));
        r.setAdminUserId(rs.getInt("adminUserId"));
        r.setRating(rs.getDouble("rating"));
        r.setActive(rs.getBoolean("isActive"));
        r.setImageUrl(rs.getString("imageUrl"));
   
        return r;
    }
   
}