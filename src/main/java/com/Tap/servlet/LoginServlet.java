package com.Tap.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.Tap.DAOImpl.UserDAOImpl;
import com.Tap.Model.User;

@WebServlet("/callLoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
       
        HttpSession session = req.getSession();
        UserDAOImpl userDAOImpl = new UserDAOImpl();
        User user = userDAOImpl.getUserByEmail(email);
         
        // Fix: Check if the user exists in the database first before pulling the password
        if (user != null) {
            String dbPassword = user.getPassword();
            
            // Verify BCrypt hashed password
            if (BCrypt.checkpw(password, dbPassword)) {
                // Note: Changed "dbPassword" to "user.getName()" or similar, 
                // as saving a hashed password string as a "userName" is usually a typo.
                session.setAttribute("user", user); 
                resp.sendRedirect("callRestaurantServlet");
            } else {
                // Password incorrect
                resp.sendRedirect("login.html");
            }
        } else {
            // User email does not exist in the database
            resp.sendRedirect("login.html");
        }
    }
}