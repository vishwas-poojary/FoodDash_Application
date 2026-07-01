package com.Tap.service;

import com.Tap.DAOImpl.UserDAOImpl;
import com.Tap.Model.User;

public class AuthService {
    private UserDAOImpl userDAO = new UserDAOImpl();

    public boolean register(User user) {
        if (user.getUserName() == null || user.getUserName().trim().isEmpty()) {
            System.out.println("Username cannot be empty");
            return false;
        }
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            System.out.println("Invalid email");
            return false;
        }
        if (user.getPassword() == null || user.getPassword().length() < 4) {
            System.out.println("Password must be at least 4 characters");
            return false;
        }
        userDAO.addUser(user);
        return true;
    }

    public User login(String email, String password) {
        if (email == null || password == null) return null;
        return userDAO.login(email, password);
    }

    public boolean isEmailExists(String email) {
        return userDAO.getUserByEmail(email) != null;
    }
}