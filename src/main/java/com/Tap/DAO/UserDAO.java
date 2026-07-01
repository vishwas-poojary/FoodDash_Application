package com.Tap.DAO;

import java.util.List;

import com.Tap.Model.User;

public interface UserDAO {
    int addUser(User user);
    User getUser(int userId);
    User  getUserByEmail(String email);
    User login(String email, String password);
    void updateUser(User user);
    void deleteUser(int userId);
    List<User> getAllUsers();
}
