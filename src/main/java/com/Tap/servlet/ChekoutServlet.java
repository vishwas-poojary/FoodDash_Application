package com.Tap.servlet;

import java.io.IOException;
import java.sql.Timestamp;

import com.Tap.DAOImpl.OrderItemDAOImpl;
import com.Tap.DAOImpl.OrderTableDAOImpl;
import com.Tap.Model.Cart;
import com.Tap.Model.CartItem;
import com.Tap.Model.OrderItem;
import com.Tap.Model.OrderTable;
import com.Tap.Model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Checkout")
public class ChekoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        Double finalAmountObj = (Double) session.getAttribute("finalAmount");
        Cart cart = (Cart) session.getAttribute("cart");
        String paymentMethod = req.getParameter("paymentMethod");
        String deliveryAddress = req.getParameter("deliveryAddress");

        System.out.println("=== CHECKOUT DEBUG ===");
        System.out.println("User ID: " + (user != null ? user.getUserId() : "null"));
        System.out.println("Restaurant ID: " + restaurantId);
        System.out.println("Final Amount: " + finalAmountObj);
        System.out.println("Payment Method (raw): " + paymentMethod);
        System.out.println("Delivery Address: " + deliveryAddress);
        System.out.println("Cart Size: " + (cart != null ? cart.getItems().size() : 0));

        if (user == null) {
            resp.sendRedirect("login.html");
            return;
        }

        if (user != null && cart != null && !cart.getItems().isEmpty()) {

            // ✅ FIX: Map payment method to database ENUM values
            if ("Cash on Delivery".equals(paymentMethod)) {
                paymentMethod = "COD";
            } else if ("Credit Card".equals(paymentMethod) || "Debit Card".equals(paymentMethod)) {
                paymentMethod = "CARD";
            } else if ("UPI".equals(paymentMethod)) {
                paymentMethod = "UPI";
            } else if ("Net Banking".equals(paymentMethod)) {
                paymentMethod = "CARD";  // Or add 'NETBANKING' to ENUM
            }

            System.out.println("Payment Method (mapped): " + paymentMethod);

            OrderTable orderTable = new OrderTable();
            orderTable.setUserId(user.getUserId());
            orderTable.setRestaurantId(restaurantId);
            orderTable.setOrderDate(new Timestamp(System.currentTimeMillis()));
            orderTable.setPaymentMethod(paymentMethod);
            // ✅ Status has default 'PLACED' in DB — no need to set it!
            // orderTable.setStatus("PLACED");  // Optional — DB will set default
            orderTable.setTotalAmount(finalAmountObj);
            orderTable.setDeliveryAddress(deliveryAddress);

            OrderTableDAOImpl orderTableDAOImpl = new OrderTableDAOImpl();
            int orderId = orderTableDAOImpl.addOrder(orderTable);
            System.out.println("Order ID saved: " + orderId);

            if (orderId > 0) {
                OrderItemDAOImpl orderItemDAOImpl = new OrderItemDAOImpl();

                for (CartItem items : cart.getItems().values()) {
                    System.out.println("Inserting item: " + items.getName());
                    System.out.println("  MenuId: " + items.getMenuId());
                    System.out.println("  Quantity: " + items.getQuantity());
                    System.out.println("  TotalPrice: " + items.getTotalPrice());

                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setMenuId(items.getMenuId());
                    orderItem.setQuantity(items.getQuantity());
                    orderItem.setItemTotal(items.getTotalPrice());
                    orderItemDAOImpl.addOrderItem(orderItem);
                }
                System.out.println("=== All items processed ===");
            } else {
                System.err.println("ERROR: Order ID is 0 — items not saved");
            }

            req.setAttribute("fullName", req.getParameter("fullName"));
            req.setAttribute("mobileNumber", req.getParameter("mobileNumber"));
            req.setAttribute("deliveryAddress", deliveryAddress);
            req.setAttribute("paymentMethod", paymentMethod);
            req.setAttribute("finalAmount", finalAmountObj);

            session.removeAttribute("cart");
            session.removeAttribute("restaurantId");
            session.removeAttribute("finalAmount");

            RequestDispatcher rd = req.getRequestDispatcher("orderConfirmation.jsp");
            rd.forward(req, resp);
            return;

        } else {
            resp.sendRedirect("Cart.jsp");
            return;
        }
    }
}