<%@ page import="com.Tap.Model.OrderTable" %>
<%@ page import="com.Tap.Model.OrderItem" %>
<%@ page import="com.Tap.Model.User" %>
<%@ page import="com.Tap.Model.Cart" %>
<%@ page import="com.Tap.DAOImpl.OrderItemDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title> FoodDash</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: #1a1a2e; 
            color: #eee; 
            min-height: 100vh; 
        }
        nav {
            background: #16213e;
            padding: 14px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
        }
        .nav-logo { 
            font-size: 22px; 
            font-weight: 700; 
            color: #fff; 
            text-decoration: none; 
        }
        .nav-logo span { 
            color: #e8a87c; 
        }
        .nav-links { 
            display: flex; 
            gap: 28px; 
            list-style: none; 
            align-items: center;
        }
        .nav-links a { 
            color: #ccc; 
            text-decoration: none; 
            font-size: 14px; 
            font-weight: 500; 
            transition: color 0.2s; 
        }
        .nav-links a:hover { 
            color: #e8a87c; 
        }
        .nav-links a.active {
            color: #e8a87c;
            border-bottom: 2px solid #e8a87c;
            padding-bottom: 4px;
        }
        .cart-badge {
            background: #e8a87c;
            color: #1a1a2e;
            border-radius: 50%;
            padding: 0px 7px;
            font-size: 11px;
            font-weight: 700;
            margin-left: 2px;
            min-width: 18px;
            text-align: center;
        }
        .page-wrapper {
            max-width: 1100px;
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
        
        /* Order Card */
        .order-card {
            background: #16213e;
            border-radius: 14px;
            padding: 24px 28px;
            margin-bottom: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            border-left: 4px solid #e8a87c;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .order-id {
            font-size: 18px;
            font-weight: 700;
            color: #e8a87c;
        }
        .order-date {
            font-size: 13px;
            color: #888;
        }
        .order-status {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status-placed { background: #2d6a4f; color: #95d5b2; }
        .status-preparing { background: #7b2d26; color: #f4a261; }
        .status-out_for_delivery { background: #1a3a5c; color: #74b9ff; }
        .status-delivered { background: #1e3a2a; color: #81c784; }
        .status-cancelled { background: #4a1a1a; color: #ff6b6b; }
        
        .order-details {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 16px;
            margin-top: 12px;
        }
        @media (max-width: 600px) {
            .order-details {
                grid-template-columns: 1fr;
            }
        }
        .detail-item {
            background: #0f3460;
            border-radius: 8px;
            padding: 12px 16px;
        }
        .detail-label {
            font-size: 11px;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .detail-value {
            font-size: 14px;
            font-weight: 600;
            color: #eee;
        }
        
        /* Order Items Table */
        .items-section {
            margin-top: 16px;
            padding-top: 14px;
            border-top: 1px solid rgba(255,255,255,0.06);
        }
        .items-title {
            font-size: 13px;
            font-weight: 600;
            color: #aaa;
            margin-bottom: 10px;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            font-size: 14px;
        }
        .item-row:last-child {
            border-bottom: none;
        }
        .item-name {
            color: #ddd;
            flex: 1;
        }
        .item-qty {
            color: #888;
            margin: 0 20px;
        }
        .item-price {
            color: #e8a87c;
            font-weight: 600;
        }
        
        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            background: #16213e;
            border-radius: 14px;
        }
        .empty-orders p {
            font-size: 18px;
            color: #aaa;
            margin-bottom: 20px;
        }
        .btn-browse {
            padding: 12px 28px;
            background: #e8a87c;
            color: #1a1a2e;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
        }
        .btn-browse:hover {
            opacity: 0.9;
        }
        
        .total-amount {
            font-size: 16px;
            font-weight: 700;
            color: #e8a87c;
            text-align: right;
            margin-top: 12px;
        }
    </style>
</head>
<body>

<!-- ── UPDATED NAVBAR ── -->
<nav>
    <a href="callRestaurantServlet" class="nav-logo"><span> FoodDash</span></a>
    <ul class="nav-links">
        <li><a href="callRestaurantServlet">Home</a></li>
        
        <%
            User loggedUser = (User) session.getAttribute("user");
            if (loggedUser != null) {
        %>
            <li><a href="OrderDetails" class="active">My Orders</a></li>
            <li><a href="login.html">Logout</a></li>
        <%
            } else {
        %>
            <li><a href="login.html">Login</a></li>
            <li><a href="register.html">Sign Up</a></li>
        <%
            }
        %>
        
        <li>
            <a href="Cart.jsp">
                Cart
                <%
                    Cart cart = (Cart) session.getAttribute("cart");
                    int count = 0;
                    if (cart != null && !cart.getItems().isEmpty()) {
                        count = cart.getItems().size();
                    }
                    if (count > 0) {
                %>
                    <span class="cart-badge"><%= count %></span>
                <%
                    }
                %>
            </a>
        </li>
    </ul>
</nav>

<div class="page-wrapper">
    <div class="page-title">My Orders</div>
    <div class="page-subtitle">View all your past and current orders</div>

<%
    List<OrderTable> orderList = (List<OrderTable>) request.getAttribute("orderList");
    OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
    
    if (orderList != null && !orderList.isEmpty()) {
        for (OrderTable order : orderList) {
            String statusClass = "status-placed";
            String statusDisplay = order.getStatus();
            if (statusDisplay == null) statusDisplay = "PLACED";
            
            if ("PREPARING".equalsIgnoreCase(statusDisplay)) statusClass = "status-preparing";
            else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(statusDisplay)) statusClass = "status-out_for_delivery";
            else if ("DELIVERED".equalsIgnoreCase(statusDisplay)) statusClass = "status-delivered";
            else if ("CANCELLED".equalsIgnoreCase(statusDisplay)) statusClass = "status-cancelled";
            
            // Get order items
            List<OrderItem> items = orderItemDAO.getItemsByOrder(order.getOrderId());
%>

    <div class="order-card">
        <!-- Order Header -->
        <div class="order-header">
            <div>
                <span class="order-id">#<%= order.getOrderId() %></span>
                <span class="order-date" style="margin-left: 16px;">
                    <%= order.getOrderDate() %>
                </span>
            </div>
            <div>
                <span class="order-status <%= statusClass %>">
                    <%= statusDisplay.replace("_", " ") %>
                </span>
            </div>
        </div>
        
        <!-- Order Details -->
        <div class="order-details">
            <div class="detail-item">
                <div class="detail-label">Payment Method</div>
                <div class="detail-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "—" %></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Delivery Address</div>
                <div class="detail-value"><%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "—" %></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Total Amount</div>
                <div class="detail-value">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
            </div>
        </div>
        
        <!-- Order Items -->
        <div class="items-section">
            <div class="items-title">Order Items</div>
            <%
                if (items != null && !items.isEmpty()) {
                    for (OrderItem item : items) {
            %>
                <div class="item-row">
                    <span class="item-name">Item #<%= item.getMenuId() %></span>
                    <span class="item-qty">× <%= item.getQuantity() %></span>
                    <span class="item-price">₹<%= String.format("%.2f", item.getItemTotal()) %></span>
                </div>
            <%
                    }
                } else {
            %>
                <div style="color: #888; font-size: 13px;">No items found for this order.</div>
            <%
                }
            %>
        </div>
    </div>

<%
        }
    } else {
%>
    <div class="empty-orders">
        <p>You haven't placed any orders yet.</p>
        <a href="callRestaurantServlet" class="btn-browse">Browse Restaurants</a>
    </div>
<%
    }
%>

</div>
</body>
</html>