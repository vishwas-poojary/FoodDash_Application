package com.Tap.servlet;

import java.io.IOException;
import java.util.List;

import com.Tap.DAOImpl.RestaurantDAOImpl;
import com.Tap.Model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/callRestaurantServlet")
public class RestaurantServlet extends HttpServlet {
   

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
	    List<Restaurant> allRestaurents = restaurantDAOImpl.getAllRestaurants();
	    
	    // CHANGE THIS LINE: Use an 'a' in the attribute string
	    req.setAttribute("allRestaurants", allRestaurents);
	    
	    RequestDispatcher rd = req.getRequestDispatcher("Restaurant.jsp");
	    rd.forward(req, resp);
	}

   
}