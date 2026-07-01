package com.Tap.servlet;

import java.io.IOException;
import java.util.List;
import com.Tap.DAOImpl.OrderTableDAOImpl;
import com.Tap.Model.OrderTable;
import com.Tap.Model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrderDetails")
public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            resp.sendRedirect("login.html");
            return;
        }

        // Fetch orders for this user
        OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
        List<OrderTable> orderList = orderDAO.getOrdersByUser(user.getUserId());

        // Set orders as request attribute
        req.setAttribute("orderList", orderList);

        // Forward to JSP page
        RequestDispatcher rd = req.getRequestDispatcher("orderDetails.jsp");
        rd.forward(req, resp);
    }
}