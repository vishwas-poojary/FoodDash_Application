package com.Tap.servlet;

import java.io.IOException;
import java.util.List;

import com.Tap.DAOImpl.MenuDAOImpl;
import com.Tap.Model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
        
        // FIXED: Uses lowercase "restaurantId" to perfectly match your incoming URL
        String resIdParam = req.getParameter("restaurantId");
        
        if (resIdParam != null && !resIdParam.isEmpty()) {
            int restaurantID = Integer.parseInt(resIdParam);
            List<Menu> MenusByRestaurant = menuDAOImpl.getMenusByRestaurant(restaurantID);
            
            // FIXED: Matches the exact name the JSP looks for: "getMenusByRestaurant"
            req.setAttribute("getMenusByRestaurant", MenusByRestaurant);
           
            RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
            rd.forward(req, resp);
        } else {
            // Graceful fallback if the parameter goes completely missing
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing restaurantId parameter.");
        }
    }
}