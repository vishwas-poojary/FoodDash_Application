package com.Tap.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.jar.Attributes.Name;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.Tap.service.AuthService;
import com.Tap.DAOImpl.UserDAOImpl;
import com.Tap.Model.User;

@WebServlet("/callRegisterServlet")
public class RegisterServlet extends HttpServlet {
      
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	String firstName = req.getParameter("firstName");
    	String email = req.getParameter("email");
    	String password = req.getParameter("password");
    	String address = req.getParameter("address");
    	String role = req.getParameter("role");
    	
    	User user = new User(firstName, password, email, address, role);
    	UserDAOImpl userDAOImpl = new UserDAOImpl();
    	int res = userDAOImpl.addUser(user);
    	if(res==1) {
    		resp.sendRedirect("login.html");
    	}
    	else {
    		resp.sendRedirect("register.html");
    	}
        }

      
}