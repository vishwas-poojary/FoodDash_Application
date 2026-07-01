package com.Tap.servlet;

import java.io.IOException;

import com.Tap.DAOImpl.MenuDAOImpl;
import com.Tap.Model.Cart;
import com.Tap.Model.CartItem;
import com.Tap.Model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Fetch cart and OLD restaurantId from session
        // BUG FIX: Use Integer (wrapper) not int (primitive) — session returns null initially
        Cart cart = (Cart) session.getAttribute("cart");
        Integer oldRestaurantId = (Integer) session.getAttribute("restaurantId");

        // New restaurantId coming from the menu page form
        int newRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));

        // Create new cart if:
        // 1. Cart doesn't exist yet (first item ever)
        // 2. User is ordering from a different restaurant
        // BUG FIX: Use .equals() to compare Integer objects, not !=
        // BUG FIX: Also check oldRestaurantId == null to avoid NullPointerException
        if (cart == null || oldRestaurantId == null || !oldRestaurantId.equals(newRestaurantId)) {
            cart = new Cart();
            session.setAttribute("cart", cart);
            // BUG FIX: was saving oldRestaurantId — must save newRestaurantId
            session.setAttribute("restaurantId", newRestaurantId);
        }

        // BUG FIX: Added null check on action to prevent NullPointerException
        String action = req.getParameter("action");

        if (action != null) {
            if (action.equals("add")) {
                addItemToCart(req, cart);
            } else if (action.equals("update")) {
                updateItemInCart(req, cart);
            } else if (action.equals("delete")) {
                deleteItemFromCart(req, cart);
            }
        }

        resp.sendRedirect("Cart.jsp");
    }

    private void addItemToCart(HttpServletRequest req, Cart cart) {
        int menuId   = Integer.parseInt(req.getParameter("menuId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
        Menu menu = menuDAOImpl.getMenu(menuId);

        CartItem cartItem = new CartItem(
            menu.getMenuId(),
            menu.getRestaurantId(),
            menu.getItemName(),
            menu.getPrice(),
            quantity
        );

        // BUG FIX: was Cart.addItem() (static call) — must be cart.addItem() (instance call)
        cart.addItem(cartItem);
    }

    private void updateItemInCart(HttpServletRequest req, Cart cart) {
        // BUG FIX: was empty — now implemented
        int menuId   = Integer.parseInt(req.getParameter("menuId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
 
        cart.updateItem(menuId, quantity);
    }

    private void deleteItemFromCart(HttpServletRequest req, Cart cart) {
        // BUG FIX: was empty — now implemented
        int menuId = Integer.parseInt(req.getParameter("menuId"));

        cart.removeItem(menuId);
    }
}