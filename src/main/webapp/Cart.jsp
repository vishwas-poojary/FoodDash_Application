<%@ page import="com.Tap.Model.Cart" %>
<%@ page import="com.Tap.Model.CartItem" %>
<%@ page import="com.Tap.Model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #1a1a2e;
            color: #eee;
            min-height: 100vh;
        }

        /* ── NAV ── */
        nav {
            background: #16213e;
            padding: 14px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #0f3460;
        }
        .nav-logo {
            font-size: 22px;
            font-weight: 700;
            color: #e94560;
            text-decoration: none;
        }
        .nav-logo span { color: #fff; }
        .nav-links {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .nav-links a {
            color: #ccc;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s;
        }
        .nav-links a:hover { color: #e94560; }
        .cart-badge {
            background: #e94560;
            color: #fff;
            border-radius: 50%;
            padding: 0px 7px;
            font-size: 11px;
            font-weight: 700;
            margin-left: 2px;
            min-width: 18px;
            text-align: center;
        }

        /* ── PAGE WRAPPER ── */
        .page-wrapper {
            max-width: 960px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .page-title {
            font-size: 32px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 6px;
        }
        .page-subtitle {
            font-size: 14px;
            color: #aaa;
            margin-bottom: 30px;
        }

        /* ── CART TABLE ── */
        .cart-card {
            background: #16213e;
            border-radius: 14px;
            overflow: hidden;
            border: 1px solid #0f3460;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }
        .cart-table thead tr {
            background: #0f3460;
        }
        .cart-table th {
            padding: 14px 20px;
            font-size: 13px;
            font-weight: 600;
            color: #e94560;
            text-align: left;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .cart-table td {
            padding: 16px 20px;
            font-size: 14px;
            color: #ddd;
            border-bottom: 1px solid #0f3460;
            vertical-align: middle;
        }
        .cart-table tbody tr:last-child td {
            border-bottom: none;
        }
        .cart-table tbody tr:hover {
            background: rgba(233,69,96,0.05);
        }
        .item-name {
            font-weight: 600;
            color: #fff;
            font-size: 15px;
        }
        .price-cell {
            color: #e94560;
            font-weight: 600;
        }
        .total-cell {
            color: #fff;
            font-weight: 700;
            font-size: 15px;
        }

        /* ── QUANTITY CONTROLS ── */
        .qty-controls {
            display: flex;
            align-items: center;
            gap: 0;
            background: #0f3460;
            border-radius: 25px;
            overflow: hidden;
            width: fit-content;
            border: 1px solid #1a4a8a;
        }
        .qty-form { display: inline; margin: 0; padding: 0; }
        .qty-btn {
            background: transparent;
            border: none;
            color: #e94560;
            font-size: 18px;
            font-weight: 700;
            width: 34px;
            height: 34px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.15s;
        }
        .qty-btn:hover { background: rgba(233,69,96,0.2); }
        .qty-number {
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            min-width: 28px;
            text-align: center;
        }

        /* ── REMOVE BUTTON ── */
        .remove-form { display: inline; }
        .remove-btn {
            background: transparent;
            border: 1.5px solid #e94560;
            color: #e94560;
            padding: 7px 18px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .remove-btn:hover {
            background: #e94560;
            color: #fff;
        }

        /* ── GRAND TOTAL ROW ── */
        .grand-total-row {
            background: #0f3460;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 24px;
            border-top: 2px solid #e94560;
        }
        .grand-total-label {
            font-size: 16px;
            font-weight: 700;
            color: #fff;
        }
        .grand-total-amount {
            font-size: 22px;
            font-weight: 700;
            color: #e94560;
        }

        /* ── BOTTOM BUTTONS ── */
        .bottom-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 28px;
        }
        .btn-add-more {
            background: transparent;
            border: 2px solid #e94560;
            color: #e94560;
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-add-more:hover {
            background: #e94560;
            color: #fff;
        }
        .btn-checkout {
            background: linear-gradient(135deg, #e94560, #c73652);
            color: #fff;
            border: none;
            padding: 13px 36px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: opacity 0.2s;
            box-shadow: 0 4px 15px rgba(233,69,96,0.35);
        }
        .btn-checkout:hover { opacity: 0.88; }

        /* ── EMPTY CART ── */
        .empty-cart {
            background: #16213e;
            border-radius: 14px;
            border: 1px solid #0f3460;
            text-align: center;
            padding: 60px 20px;
        }
        .empty-cart-icon { font-size: 56px; margin-bottom: 16px; }
        .empty-cart h3 {
            font-size: 22px;
            color: #fff;
            margin-bottom: 8px;
        }
        .empty-cart p {
            color: #aaa;
            font-size: 14px;
            margin-bottom: 24px;
        }
        .btn-browse {
            background: #e94560;
            color: #fff;
            text-decoration: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: opacity 0.2s;
        }
        .btn-browse:hover { opacity: 0.88; }
    </style>
</head>
<body>

<!-- ── UPDATED NAVBAR ── -->
<%
    // Get cart count for badge
    Cart navbarCart = (Cart) session.getAttribute("cart");
    int count = 0;
    if (navbarCart != null && navbarCart.getItems() != null) {
        for (CartItem item : navbarCart.getItems().values()) {
            count += item.getQuantity();
        }
    }
    
    // Check if user is logged in
    User loggedUser = (User) session.getAttribute("user");
%>

<nav>
    <a href="callRestaurantServlet" class="nav-logo"><span>FoodDash</span></a>
    <div class="nav-links">
        <a href="callRestaurantServlet">Home</a>
        
        <%
            if (loggedUser != null) {
        %>
            <a href="OrderDetails">My Orders</a>
            <a href="login.html">Logout</a>
        <%
            } else {
        %>
            <a href="login.html">Login</a>
            <a href="register.html">Sign Up</a>
        <%
            }
        %>
        
        <a href="Cart.jsp">
            Cart
            <%
                if (count > 0) {
            %>
                <span class="cart-badge"><%= count %></span>
            <%
                }
            %>
        </a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-title">Your Cart</div>
    <div class="page-subtitle">Review your selected food items</div>

    <%
        /*
         * STEP 1: Fetch cart and restaurantId from session.
         * IMPORTANT: Use Integer (wrapper class) NOT int (primitive)
         * because session returns null on first load and int cannot hold null.
         * Instructor explained this bug fix at 1:01:22 in previous class.
         */
        Cart cart = (Cart) session.getAttribute("cart");
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        /*
         * STEP 2: Check if cart is not null AND has items inside.
         * Instructor: "if cart is not equal to null means inside
         * element is there, then I will display"
         */
        if (cart != null && !cart.getItems().isEmpty()) {

            double grandTotal = 0.0;
    %>

    <div class="cart-card">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Price</th>
                    <th>Total</th>
                    <th>Quantity</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    /*
                     * STEP 3: Loop through cart items using .values()
                     * Instructor: "cart.getItems() — in the key menuId is there,
                     * I want cart items dot values, each cart item I'll pass to item"
                     */
                    for (CartItem item : cart.getItems().values()) {
                        double itemTotal = item.getTotalPrice();
                        grandTotal += itemTotal;
                %>
                <tr>
                    <!-- Item Name -->
                    <td><span class="item-name"><%= item.getName() %></span></td>

                    <!-- Price -->
                    <td class="price-cell">₹<%= item.getPrice() %></td>

                    <!-- Total = price x quantity (getTotalPrice method) -->
                    <td class="total-cell">₹<%= (int) itemTotal %></td>

                    <!-- Quantity Controls: MINUS | number | PLUS -->
                    <td>
                        <div class="qty-controls">

                            <%--
                                MINUS BUTTON
                                Instructor: "when user will click on minus,
                                if quantity-1 <= 0 then action=delete,
                                else action=update with quantity-1"
                            --%>
                            <form action="cartServlet" method="get" class="qty-form">
                                <input type="hidden" name="menuId"       value="<%= item.getMenuId() %>" />
                                <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>" />
                                <%
                                    if ((item.getQuantity() - 1) <= 0) {
                                        // quantity will hit 0 — delete the item instead
                                %>
                                <input type="hidden" name="action"   value="delete" />
                                <input type="hidden" name="quantity" value="0" />
                                <% } else { %>
                                <input type="hidden" name="action"   value="update" />
                                <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>" />
                                <% } %>
                                <button type="submit" class="qty-btn">−</button>
                            </form>

                            <!-- Current quantity display -->
                            <span class="qty-number"><%= item.getQuantity() %></span>

                            <%--
                                PLUS BUTTON
                                Instructor: "when user will click on plus,
                                action=update, quantity = old quantity + 1"
                            --%>
                            <form action="cartServlet" method="get" class="qty-form">
                                <input type="hidden" name="menuId"       value="<%= item.getMenuId() %>" />
                                <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>" />
                                <input type="hidden" name="action"       value="update" />
                                <input type="hidden" name="quantity"     value="<%= item.getQuantity() + 1 %>" />
                                <button type="submit" class="qty-btn">+</button>
                            </form>

                        </div>
                    </td>

                    <!-- REMOVE BUTTON -->
                    <%--
                        Instructor: "remove button — action=delete,
                        just pass action=delete and menuId"
                    --%>
                   <td>
    <form action="cartServlet" method="get" class="remove-form">
        <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>" />
        
        <input type="hidden" name="menuId"  value="<%= item.getMenuId() %>" />
        <input type="hidden" name="action"  value="delete" />
        <button type="submit" class="remove-btn">Remove</button>
    </form>
</td>
                </tr>
                <% } // end for loop %>
            </tbody>
        </table>

        <!-- Grand Total -->
        <div class="grand-total-row">
            <span class="grand-total-label">Grand Total</span>
            <span class="grand-total-amount">₹<%= grandTotal %></span>
        </div>
    </div>

    <!-- Bottom Action Buttons -->
    <div class="bottom-actions">
    <% if (restaurantId != null) { %>
    <a href="menu?restaurantId=<%= restaurantId %>" class="btn-add-more">
        + Add More Items
    </a>
    <% } else { %>
    <a href="index.jsp" class="btn-add-more">+ Add More Items</a>
    <% } %>

    <a href="Checkout.jsp" class="btn-checkout">Proceed to Checkout →</a>
</div>

    <%
        } else {
            /*
             * EMPTY CART block
             * Instructor: "if cart is equal to null then else block will execute,
             * here display cart is empty, then call RestaurantServlet"
             */
    %>

    <div class="empty-cart">
        <div class="empty-cart-icon">🛒</div>
        <h3>Your cart is empty!</h3>
        <p>Looks like you haven't added anything yet. Browse our restaurants!</p>
        <a href="callRestaurantServlet" class="btn-browse">Browse Restaurants</a>
    </div>

    <% } %>

</div><!-- /page-wrapper -->

</body>
</html>