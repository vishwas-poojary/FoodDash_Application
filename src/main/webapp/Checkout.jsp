<%@ page import="com.Tap.Model.Cart" %>
<%@ page import="com.Tap.Model.CartItem" %>
<%@ page import="com.Tap.Model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout | FoodHub</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #1a1a2e; color: #eee; min-height: 100vh; }
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
        .page-wrapper { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        .page-title    { font-size: 32px; font-weight: 700; color: #fff; margin-bottom: 6px; }
        .page-subtitle { font-size: 14px; color: #aaa; margin-bottom: 30px; }
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 420px;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 860px) { .checkout-grid { grid-template-columns: 1fr; } }
        .card { background: #16213e; border-radius: 14px; padding: 28px; box-shadow: 0 4px 20px rgba(0,0,0,0.3); }
        .card-title { font-size: 18px; font-weight: 700; color: #fff; margin-bottom: 24px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #bbb; margin-bottom: 8px; letter-spacing: 0.3px; }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%; padding: 13px 16px; background: #0f3460;
            border: 1.5px solid rgba(255,255,255,0.08); border-radius: 10px;
            color: #eee; font-size: 14px; font-family: inherit; transition: border-color 0.2s; outline: none;
        }
        .form-group input::placeholder, .form-group textarea::placeholder { color: #666; }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus { border-color: #e8a87c; }
        .form-group textarea { resize: vertical; min-height: 90px; }
        .form-group select option { background: #0f3460; }
        .order-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 14px 0; border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .order-item:last-of-type { border-bottom: none; }
        .order-item-name  { font-size: 14px; font-weight: 600; color: #fff; flex: 1; }
        .order-item-qty   { font-size: 13px; color: #aaa; margin: 0 18px; white-space: nowrap; }
        .order-item-price { font-size: 14px; font-weight: 700; color: #e8a87c; white-space: nowrap; }
        .bill-section { margin-top: 20px; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.08); }
        .bill-row { display: flex; justify-content: space-between; font-size: 14px; color: #bbb; margin-bottom: 10px; }
        .bill-row.total-row {
            margin-top: 14px; padding-top: 14px; border-top: 1px dashed rgba(232,168,124,0.3);
            font-size: 18px; font-weight: 800; color: #fff; margin-bottom: 0;
        }
        .bill-row.total-row span:last-child { color: #e8a87c; }
        .btn-place-order {
            display: block; width: 100%; margin-top: 22px; padding: 15px;
            background: linear-gradient(135deg, #e8a87c, #d4956a); border: none;
            border-radius: 30px; color: #1a1a2e; font-size: 16px; font-weight: 700;
            cursor: pointer; transition: opacity 0.2s, transform 0.1s; letter-spacing: 0.3px;
        }
        .btn-place-order:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-back-cart {
            display: block; width: 100%; margin-top: 12px; padding: 13px;
            background: transparent; border: 2px solid #e8a87c; border-radius: 30px;
            color: #e8a87c; font-size: 14px; font-weight: 700; cursor: pointer;
            text-align: center; text-decoration: none; transition: background 0.2s, color 0.2s;
        }
        .btn-back-cart:hover { background: #e8a87c; color: #1a1a2e; }
        .empty-box { text-align: center; padding: 60px 20px; background: #16213e; border-radius: 14px; }
        .empty-box p { font-size: 18px; color: #aaa; margin-bottom: 20px; }
        .btn-go-cart {
            padding: 12px 28px; background: #e8a87c; color: #1a1a2e;
            border-radius: 30px; font-size: 14px; font-weight: 700;
            text-decoration: none; display: inline-block;
        }
        .error-message {
            background: #ff6b6b;
            color: #fff;
            padding: 14px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }
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

<div class="page-wrapper">
    <div class="page-title">Checkout</div>
    <div class="page-subtitle">Confirm your delivery details and place your order</div>

<%
    // ✅ SAFE: Check if cart exists before using it
    Cart cart = (Cart) session.getAttribute("cart");
    Integer restaurantId = (Integer) session.getAttribute("restaurantId");

    // ✅ FIX: Check if cart is null or empty
    if (cart == null || cart.getItems().isEmpty()) {
%>
    <div class="empty-box">
        <p>Your cart is empty. Please add items before checkout.</p>
        <a href="Cart.jsp" class="btn-go-cart">Go to Cart</a>
    </div>
<%
        return; // Stop rendering the page
    }

    double deliveryFee = 40.0;
    double platformFee = 5.0;
    double grandTotal  = 0.0;
    double finalAmount = 0.0;

    for (CartItem ci : cart.getItems().values()) {
        grandTotal += ci.getTotalPrice();
    }
    finalAmount = grandTotal + deliveryFee + platformFee;
    session.setAttribute("finalAmount", finalAmount);
%>

    <div class="checkout-grid">

        <!-- LEFT: DELIVERY DETAILS FORM -->
        <div class="card">
            <div class="card-title">Delivery Details</div>

            <form action="Checkout" method="post" id="checkoutForm">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Enter your full name" required />
                </div>

                <div class="form-group">
                    <label>Mobile Number</label>
                    <input type="tel" name="mobileNumber" placeholder="Enter your mobile number" maxlength="10" required />
                </div>

                <div class="form-group">
                    <label>Delivery Address</label>
                    <textarea name="deliveryAddress" placeholder="Enter your complete delivery address" required></textarea>
                </div>

                <div class="form-group">
                    <label>Payment Method</label>
                    <select name="paymentMethod" required>
                        <option value="" disabled selected>Select Payment Method</option>
                        <option value="Cash on Delivery">Cash on Delivery</option>
                        <option value="UPI">UPI</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Net Banking">Net Banking</option>
                    </select>
                </div>

            </form>
        </div>

        <!-- RIGHT: ORDER SUMMARY -->
        <div class="card">
            <div class="card-title">Order Summary</div>

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
                    <span>Total</span>
                    <span>&#8377;<%= finalAmount %></span>
                </div>
            </div>

            <button type="submit" form="checkoutForm" class="btn-place-order">Place Order</button>
            <a href="Cart.jsp" class="btn-back-cart">Back to Cart</a>
        </div>

    </div>

</div>
</body>
</html>