<%@ page import="com.Tap.Model.Cart" %>
<%@ page import="com.Tap.Model.CartItem" %>
<%@ page import="com.Tap.Model.User" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed | FoodHub</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #1a1a2e; color: #eee; min-height: 100vh; }

        /* NAV */
        nav {
            background: #16213e;
            padding: 14px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
        }
        .nav-logo { font-size: 22px; font-weight: 700; color: #fff; text-decoration: none; }
        .nav-logo span { color: #e8a87c; }
        .nav-links { display: flex; gap: 28px; list-style: none; align-items: center; }
        .nav-links a { color: #ccc; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover { color: #e8a87c; }
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

        /* PAGE */
        .page-wrapper {
            max-width: 700px;
            margin: 50px auto;
            padding: 0 20px;
        }

        /* SUCCESS CARD */
        .success-card {
            background: #16213e;
            border-radius: 16px;
            padding: 40px 36px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.35);
            text-align: center;
            margin-bottom: 24px;
        }

        /* TICK ANIMATION */
        .tick-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e8a87c, #d4956a);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: popIn 0.5s ease;
        }
        .tick-circle svg {
            width: 40px;
            height: 40px;
            stroke: #1a1a2e;
            stroke-width: 3;
            fill: none;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            70%  { transform: scale(1.15); }
            100% { transform: scale(1); opacity: 1; }
        }

        .success-title {
            font-size: 26px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 8px;
        }
        .success-subtitle {
            font-size: 14px;
            color: #aaa;
            margin-bottom: 28px;
            line-height: 1.6;
        }

        /* ORDER META */
        .order-meta {
            display: flex;
            justify-content: center;
            gap: 32px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }
        .meta-item { text-align: center; }
        .meta-label { font-size: 11px; color: #888; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .meta-value { font-size: 15px; font-weight: 700; color: #e8a87c; }

        /* ORDER DETAILS CARD */
        .details-card {
            background: #16213e;
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.3);
            margin-bottom: 24px;
        }
        .details-card h3 {
            font-size: 16px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }

        /* ORDER ITEMS */
        .order-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .order-item:last-of-type { border-bottom: none; }
        .order-item-name  { font-size: 14px; font-weight: 600; color: #fff; flex: 1; }
        .order-item-qty   { font-size: 13px; color: #aaa; margin: 0 16px; }
        .order-item-price { font-size: 14px; font-weight: 700; color: #e8a87c; }

        /* BILL SUMMARY */
        .bill-section {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid rgba(255,255,255,0.07);
        }
        .bill-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #bbb;
            margin-bottom: 8px;
        }
        .bill-row.total-row {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px dashed rgba(232,168,124,0.3);
            font-size: 16px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 0;
        }
        .bill-row.total-row span:last-child { color: #e8a87c; }

        /* DELIVERY INFO */
        .delivery-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 4px;
        }
        @media (max-width: 500px) { .delivery-grid { grid-template-columns: 1fr; } }
        .info-box { background: #0f3460; border-radius: 10px; padding: 14px 16px; }
        .info-box-label { font-size: 11px; color: #888; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .info-box-value { font-size: 13px; color: #eee; font-weight: 500; line-height: 1.5; }

        /* BUTTONS */
        .btn-row { display: flex; gap: 14px; margin-top: 24px; }
        .btn-home {
            flex: 1;
            padding: 14px;
            background: linear-gradient(135deg, #e8a87c, #d4956a);
            border: none;
            border-radius: 30px;
            color: #1a1a2e;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: block;
            transition: opacity 0.2s;
        }
        .btn-home:hover { opacity: 0.9; }
        .btn-browse {
            flex: 1;
            padding: 14px;
            background: transparent;
            border: 2px solid #e8a87c;
            border-radius: 30px;
            color: #e8a87c;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: block;
            transition: background 0.2s, color 0.2s;
        }
        .btn-browse:hover { background: #e8a87c; color: #1a1a2e; }
    </style>
</head>
<body>

<!-- ── UPDATED NAVBAR ── -->
<nav>
    <a href="index.jsp" class="nav-logo">Food<span>Hub</span></a>
    <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        
        <%
            User loggedUser = (User) session.getAttribute("user");
            if (loggedUser != null) {
        %>
            <li><a href="OrderDetails">My Orders</a></li>
            <li><a href="Logout">Logout</a></li>
        <%
            } else {
        %>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="register.jsp">Sign Up</a></li>
        <%
            }
        %>
        
        <li>
            <a href="Cart.jsp">
                Cart
                <%
                    Cart cartForBadge = (Cart) session.getAttribute("cart");
                    int count = 0;
                    if (cartForBadge != null && !cartForBadge.getItems().isEmpty()) {
                        count = cartForBadge.getItems().size();
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

<%
    // ✅ FIX: Check for null cart — servlet clears it before forwarding
    Cart cart = (Cart) session.getAttribute("cart");
    
    // Delivery details passed from ChekoutServlet as request attributes
    String fullName       = (String) request.getAttribute("fullName");
    String mobileNumber   = (String) request.getAttribute("mobileNumber");
    String deliveryAddress= (String) request.getAttribute("deliveryAddress");
    String paymentMethod  = (String) request.getAttribute("paymentMethod");
    Double finalAmount    = (Double) request.getAttribute("finalAmount");

    // Fallback to empty string if null
    if (fullName        == null) fullName        = "";
    if (mobileNumber    == null) mobileNumber    = "";
    if (deliveryAddress == null) deliveryAddress = "";
    if (paymentMethod   == null) paymentMethod   = "";

    double deliveryFee = 40.0;
    double platformFee =  5.0;
    double grandTotal  =  0.0;

    // ✅ FIX: Only use cart if it exists (cart is cleared after checkout)
    if (cart != null && !cart.getItems().isEmpty()) {
        for (CartItem ci : cart.getItems().values()) {
            grandTotal += ci.getTotalPrice();
        }
    }

    if (finalAmount == null) {
        finalAmount = grandTotal + deliveryFee + platformFee;
    }

    // Generate a simple order ID for display
    String orderId = "FH" + System.currentTimeMillis() % 100000;
%>

<div class="page-wrapper">

    <!-- SUCCESS BANNER -->
    <div class="success-card">
        <div class="tick-circle">
            <svg viewBox="0 0 24 24">
                <polyline points="20 6 9 17 4 12"/>
            </svg>
        </div>
        <div class="success-title">Order Placed Successfully!</div>
        <div class="success-subtitle">
            Thank you for ordering with FoodHub.<br>
            Your food is being prepared and will be delivered soon.
        </div>

        <div class="order-meta">
            <div class="meta-item">
                <div class="meta-label">Order ID</div>
                <div class="meta-value">#<%= orderId %></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Payment</div>
                <div class="meta-value"><%= paymentMethod.isEmpty() ? "N/A" : paymentMethod %></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Est. Delivery</div>
                <div class="meta-value">30 – 45 mins</div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Amount Paid</div>
                <div class="meta-value">&#8377;<%= finalAmount %></div>
            </div>
        </div>
    </div>

    <!-- ORDER ITEMS + BILL (only if cart is available) -->
    <% if (cart != null && !cart.getItems().isEmpty()) { %>
    <div class="details-card">
        <h3>Order Summary</h3>

        <% for (CartItem item : cart.getItems().values()) { %>
        <div class="order-item">
            <span class="order-item-name"><%= item.getName() %></span>
            <span class="order-item-qty">x <%= item.getQuantity() %></span>
            <span class="order-item-price">&#8377;<%= (int) item.getTotalPrice() %></span>
        </div>
        <% } %>

        <div class="bill-section">
            <div class="bill-row">
                <span>Item Total</span>
                <span>&#8377;<%= grandTotal %></span>
            </div>
            <div class="bill-row">
                <span>Delivery Fee</span>
                <span>&#8377;<%= deliveryFee %></span>
            </div>
            <div class="bill-row">
                <span>Platform Fee</span>
                <span>&#8377;<%= platformFee %></span>
            </div>
            <div class="bill-row total-row">
                <span>Total Paid</span>
                <span>&#8377;<%= finalAmount %></span>
            </div>
        </div>
    </div>
    <% } else { %>
        <!-- ✅ If cart is null, show a message instead of error -->
        <div class="details-card">
            <h3>Order Summary</h3>
            <p style="color: #aaa; text-align: center; padding: 20px 0;">
                Your order has been placed successfully!<br>
                <span style="font-size: 12px; color: #888;">Items summary has been cleared from your cart.</span>
            </p>
        </div>
    <% } %>

    <!-- DELIVERY DETAILS -->
    <div class="details-card">
        <h3>Delivery Details</h3>
        <div class="delivery-grid">
            <div class="info-box">
                <div class="info-box-label">Full Name</div>
                <div class="info-box-value"><%= fullName.isEmpty() ? "—" : fullName %></div>
            </div>
            <div class="info-box">
                <div class="info-box-label">Mobile Number</div>
                <div class="info-box-value"><%= mobileNumber.isEmpty() ? "—" : mobileNumber %></div>
            </div>
            <div class="info-box">
                <div class="info-box-label">Delivery Address</div>
                <div class="info-box-value"><%= deliveryAddress.isEmpty() ? "—" : deliveryAddress %></div>
            </div>
            <div class="info-box">
                <div class="info-box-label">Payment Method</div>
                <div class="info-box-value"><%= paymentMethod.isEmpty() ? "—" : paymentMethod %></div>
            </div>
        </div>
    </div>

    <!-- ACTION BUTTONS -->
    <div class="btn-row">
        <a href="callRestaurantServlet" class="btn-home">Go to Home</a>
        <a href="callRestaurantServlet" class="btn-browse">Order Again</a>
    </div>

</div>
</body>
</html>