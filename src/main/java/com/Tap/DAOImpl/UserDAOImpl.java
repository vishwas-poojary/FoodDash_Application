package com.Tap.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import com.Tap.DAO.UserDAO;
import com.Tap.Model.User;
import com.Tap.utility.DBConnection;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_QUERY = "INSERT INTO user (userName, password, email, address, role, createDate, lastLoginDate) VALUES (?,?,?,?,?,?,?)";
    private static final String SELECT_BY_ID = "SELECT * FROM user WHERE userId = ?";
    private static final String SELECT_BY_EMAIL = "SELECT * FROM user WHERE email = ?";
    private static final String UPDATE_QUERY = "UPDATE user SET userName=?, password=?, email=?, address=?, role=?, lastLoginDate=? WHERE userId=?";
    private static final String DELETE_QUERY = "DELETE FROM user WHERE userId = ?";
    private static final String SELECT_ALL = "SELECT * FROM user";

    @Override
    public int addUser(User user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_QUERY)) {
            pstmt.setString(1, user.getUserName());
            pstmt.setString(2, hashed);
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getRole());
            pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
           int i = pstmt.executeUpdate();
           return i;
           
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public User getUser(int userId) {
        User user = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) user = extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

//    @Override
//    public User getUserByEmail(String email) {
//        User user = null;
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_EMAIL)) {
//            pstmt.setString(1, email);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                if (rs.next()) {
//                    user = extractUser(rs);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return user;
//    }

    @Override
    public User login(String email, String plainPassword) {
        User user = getUserByEmail(email);
        if (user != null && BCrypt.checkpw(plainPassword, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public void updateUser(User user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_QUERY)) {
            pstmt.setString(1, user.getUserName());
            pstmt.setString(2, hashed);
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getRole());
            pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(7, user.getUserId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_QUERY)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
      @Override
      public User  getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM User WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setUserName(rs.getString("Username"));
                user.setPassword(rs.getString("Password")); // Ensure passwords are encrypted/hashed in production
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("Address"));
                user.setRole(rs.getString("Role"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace(); // Replace with more robust error handling
        }
        return user;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) list.add(extractUser(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setUserName(rs.getString("userName"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setCreateDate(rs.getTimestamp("createDate"));
        user.setLastLoginDate(rs.getTimestamp("lastLoginDate"));
        return user;
    }
}