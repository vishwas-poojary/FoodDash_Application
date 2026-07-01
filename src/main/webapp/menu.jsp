<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.Tap.Model.Menu, com.Tap.Model.User, com.Tap.Model.Cart, com.Tap.Model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Spice Garden – Menu | FoodDash</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Inter', sans-serif; background: #f8f8f8; color: #1c1c1c; }
  nav {
    background: #fff; border-bottom: 1px solid #f0f0f0; padding: 0 2rem; height: 64px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  }
  .nav-logo { font-size: 22px; font-weight: 700; color: #fc4b08; letter-spacing: -0.5px; display: flex; align-items: center; gap: 8px; text-decoration: none; }
  .nav-logo span { font-size: 26px; }
  .nav-back { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 500; color: #3d3d3d; text-decoration: none; padding: 8px 14px; border-radius: 8px; transition: background 0.15s; }
  .nav-back:hover { background: #f5f5f5; color: #fc4b08; }
  .nav-back svg { width: 16px; height: 16px; }
  
  /* Nav link styling for login/orders links */
  .nav-link-item {
    display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 500; 
    color: #3d3d3d; text-decoration: none; padding: 8px 14px; border-radius: 8px; 
    transition: background 0.15s, color 0.15s;
  }
  .nav-link-item:hover { background: #f5f5f5; color: #fc4b08; }
  .nav-link-item.btn-signup { background: #fc4b08; color: #fff; }
  .nav-link-item.btn-signup:hover { background: #e04007; }
  .nav-links-group { display: flex; align-items: center; gap: 4px; }
  
  .nav-cart-btn { display: flex; align-items: center; gap: 8px; background: #fc4b08; color: #fff; font-size: 14px; font-weight: 600; padding: 10px 20px; border-radius: 10px; border: none; cursor: pointer; transition: background 0.15s; position: relative; text-decoration: none; }
  .nav-cart-btn:hover { background: #e04007; }
  .nav-cart-btn svg { width: 16px; height: 16px; }
  .cart-count { background: #fff; color: #fc4b08; font-size: 11px; font-weight: 700; width: 20px; height: 20px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
  
  .restaurant-banner { background: #fff; border-bottom: 1px solid #f0f0f0; }
  .banner-img-wrap { width: 100%; height: 260px; overflow: hidden; position: relative; background: linear-gradient(135deg, #ffe5d9, #fff5f0); }
  .banner-img-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; filter: brightness(0.75); }
  .banner-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,0.65) 0%, transparent 55%); display: flex; align-items: flex-end; padding: 1.5rem 2rem; }
  .banner-info { color: #fff; max-width: 1200px; width: 100%; margin: 0 auto; }
  .banner-info h1 { font-size: 30px; font-weight: 700; margin-bottom: 4px; }
  .banner-cuisine { font-size: 14px; opacity: 0.85; margin-bottom: 10px; }
  .banner-meta { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
  .bmeta-item { display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 500; }
  .bmeta-item svg { width: 14px; height: 14px; }
  .banner-rating { display: flex; align-items: center; gap: 5px; background: #48c479; color: #fff; font-size: 13px; font-weight: 700; padding: 4px 10px; border-radius: 6px; }
  .banner-open-badge { background: rgba(255,255,255,0.15); backdrop-filter: blur(4px); border: 1px solid rgba(255,255,255,0.3); color: #fff; font-size: 12px; font-weight: 600; padding: 4px 10px; border-radius: 20px; }
  .banner-open-badge.open { color: #6ddc9a; border-color: #6ddc9a; }
  .cat-nav { background: #fff; border-bottom: 1px solid #f0f0f0; padding: 0 2rem; display: flex; align-items: center; gap: 4px; overflow-x: auto; scrollbar-width: none; position: sticky; top: 64px; z-index: 90; }
  .cat-nav::-webkit-scrollbar { display: none; }
  .cat-nav-item { white-space: nowrap; font-size: 13px; font-weight: 500; padding: 14px 18px; border-bottom: 2.5px solid transparent; cursor: pointer; color: #666; transition: all 0.15s; text-decoration: none; display: block; }
  .cat-nav-item:hover { color: #fc4b08; }
  .cat-nav-item.active { color: #fc4b08; border-bottom-color: #fc4b08; }
  .page-layout { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr 340px; gap: 24px; padding: 2rem; align-items: start; }
  @media (max-width: 900px) { .page-layout { grid-template-columns: 1fr; } .cart-panel { display: none; } }
  .menu-section { margin-bottom: 2.5rem; }
  .menu-section-title { font-size: 18px; font-weight: 700; color: #1c1c1c; margin-bottom: 1rem; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; display: flex; align-items: center; gap: 10px; }
  .menu-section-title span { font-size: 22px; }
  .section-count { font-size: 12px; font-weight: 500; color: #999; background: #f5f5f5; padding: 2px 8px; border-radius: 20px; }
  .menu-item { background: #fff; border-radius: 14px; border: 1px solid #f0f0f0; display: flex; gap: 0; margin-bottom: 14px; overflow: hidden; transition: box-shadow 0.2s, transform 0.2s; position: relative; }
  .menu-item:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.09); transform: translateY(-2px); }
  .menu-item-body { flex: 1; padding: 16px 16px 16px 18px; display: flex; flex-direction: column; justify-content: space-between; min-width: 0; }
  .menu-item-top { margin-bottom: 8px; }
  .veg-badge { display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; border-radius: 3px; margin-bottom: 6px; border: 1.5px solid; }
  .veg-badge.veg { border-color: #0f8a0f; }
  .veg-badge.veg::after { content: ''; width: 8px; height: 8px; background: #0f8a0f; border-radius: 50%; display: block; }
  .menu-item-name { font-size: 15px; font-weight: 600; color: #1c1c1c; margin-bottom: 4px; line-height: 1.3; }
  .menu-item-desc { font-size: 12px; color: #888; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
  .menu-item-bottom { display: flex; align-items: center; justify-content: space-between; margin-top: 12px; }
  .menu-item-price { font-size: 15px; font-weight: 700; color: #1c1c1c; }
  .menu-item-rating { display: flex; align-items: center; gap: 4px; font-size: 11px; font-weight: 600; color: #48c479; }
  .menu-item-rating svg { width: 11px; height: 11px; fill: #48c479; }
  .bestseller-tag { display: inline-block; background: #fff5e0; color: #c07000; font-size: 10px; font-weight: 700; letter-spacing: 0.4px; padding: 2px 7px; border-radius: 4px; border: 1px solid #f0d080; margin-bottom: 5px; text-transform: uppercase; }
  .menu-item-img-wrap { position: relative; flex-shrink: 0; width: 140px; height: 140px; align-self: center; margin: 12px 12px 12px 0; }
  .menu-item-img-wrap img { width: 100%; height: 100%; object-fit: cover; border-radius: 10px; display: block; }
  .add-btn { position: absolute; bottom: -10px; left: 50%; transform: translateX(-50%); background: #fff; color: #fc4b08; font-size: 13px; font-weight: 700; letter-spacing: 0.3px; border: 1.5px solid #fc4b08; border-radius: 8px; padding: 6px 22px; cursor: pointer; transition: background 0.15s, color 0.15s; white-space: nowrap; box-shadow: 0 2px 8px rgba(252,75,8,0.12); }
  .add-btn:hover { background: #fc4b08; color: #fff; }
  .cart-panel { background: #fff; border-radius: 16px; border: 1px solid #f0f0f0; box-shadow: 0 2px 12px rgba(0,0,0,0.06); position: sticky; top: 116px; overflow: hidden; }
  .cart-header { padding: 16px 18px; border-bottom: 1px solid #f0f0f0; display: flex; align-items: center; justify-content: space-between; }
  .cart-header h3 { font-size: 16px; font-weight: 700; }
  .cart-restaurant { font-size: 12px; color: #888; }
  .cart-items { padding: 12px 18px; }
  .cart-item { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 10px 0; border-bottom: 1px dashed #f0f0f0; }
  .cart-item-name { font-size: 13px; font-weight: 500; flex: 1; }
  .cart-item-qty { display: flex; align-items: center; gap: 8px; background: #fff5f0; border-radius: 6px; padding: 3px 8px; }
  .cq-btn { background: none; border: none; color: #fc4b08; font-size: 16px; font-weight: 700; cursor: pointer; line-height: 1; }
  .cq-num { font-size: 13px; font-weight: 600; color: #1c1c1c; min-width: 14px; text-align: center; }
  .cart-item-price { font-size: 13px; font-weight: 600; color: #1c1c1c; white-space: nowrap; }
  .cart-summary { padding: 12px 18px; border-top: 1px solid #f0f0f0; background: #fafafa; }
  .summary-row { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #555; margin-bottom: 6px; }
  .summary-row.total { font-size: 15px; font-weight: 700; color: #1c1c1c; margin-top: 8px; padding-top: 8px; border-top: 1px dashed #e8e8e8; margin-bottom: 0; }
  .checkout-btn { display: block; width: calc(100% - 36px); margin: 14px 18px; background: #fc4b08; color: #fff; font-size: 15px; font-weight: 700; border: none; border-radius: 12px; padding: 14px; cursor: pointer; text-align: center; transition: background 0.15s; }
  .checkout-btn:hover { background: #e04007; }
  .custom-note { font-size: 10px; color: #bbb; text-align: center; padding: 0 18px 14px; line-height: 1.4; }
  .menu-search-wrap { margin-bottom: 1.5rem; }
  .menu-search { display: flex; align-items: center; gap: 10px; background: #fff; border: 1.5px solid #eee; border-radius: 12px; padding: 11px 16px; transition: border-color 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
  .menu-search:focus-within { border-color: #fc4b08; }
  .menu-search svg { width: 16px; height: 16px; color: #999; flex-shrink: 0; }
  .menu-search input { border: none; background: transparent; font-size: 14px; color: #1c1c1c; outline: none; width: 100%; font-family: inherit; }
  .filter-row { display: flex; align-items: center; gap: 12px; margin-bottom: 1.5rem; flex-wrap: wrap; }
  .veg-toggle { display: flex; align-items: center; gap: 8px; background: #fff; border: 1.5px solid #e0e0e0; border-radius: 8px; padding: 8px 14px; cursor: pointer; font-size: 13px; font-weight: 500; color: #555; transition: border-color 0.15s; }
  .veg-toggle:hover { border-color: #0f8a0f; color: #0f8a0f; }
  .veg-dot { width: 12px; height: 12px; border-radius: 50%; background: #0f8a0f; }
  .filter-badge { display: flex; align-items: center; gap: 6px; background: #fff5f0; border: 1.5px solid #fc4b08; border-radius: 8px; padding: 8px 14px; font-size: 13px; font-weight: 500; color: #fc4b08; }
  footer { background: #1c1c1c; color: #aaa; text-align: center; padding: 1.5rem; font-size: 13px; margin-top: 2rem; }
  footer span { color: #fc4b08; }
  .offer-strip { background: linear-gradient(135deg, #fff5f0, #fff); border: 1px solid #ffe0d0; border-radius: 12px; padding: 12px 16px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px; }
  .offer-strip-icon { font-size: 22px; }
  .offer-strip-text { font-size: 13px; font-weight: 600; color: #fc4b08; }
  .offer-strip-sub { font-size: 11px; color: #888; font-weight: 400; margin-top: 2px; }
</style>
</head>
<body>

<!-- ── UPDATED NAVBAR ── -->
<%
    // Get cart count for badge
    com.Tap.Model.Cart navbarCart = (com.Tap.Model.Cart) session.getAttribute("cart");
    int count = 0;
    if (navbarCart != null && navbarCart.getItems() != null) {
        for (com.Tap.Model.CartItem item : navbarCart.getItems().values()) {
            count += item.getQuantity();
        }
    }
    
    // Check if user is logged in
    User loggedUser = (User) session.getAttribute("user");
%>

<nav>
  <a href="callRestaurantServlet" class="nav-logo"><span>🍽</span> FoodDash</a>
  
  <a href="callRestaurantServlet" class="nav-back">
    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
    Back to Restaurants
  </a>
  
  <!-- ── DYNAMIC LINKS (Login/Logout/My Orders) ── -->
  <div class="nav-links-group">
    <%
        if (loggedUser != null) {
    %>
        <a href="OrderDetails" class="nav-link-item">My Orders</a>
        <a href="Logout" class="nav-link-item">Logout</a>
    <%
        } else {
    %>
        <a href="login.html" class="nav-link-item">Login</a>
        <a href="register.html" class="nav-link-item btn-signup">Sign Up</a>
    <%
        }
    %>
  </div>
  
  <a href="Cart.jsp" class="nav-cart-btn">
    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
    My Cart 
    <div class="cart-count"><%= count %></div>
  </a>
</nav>

<div class="restaurant-banner">
  <div class="banner-img-wrap">
    <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&h=400&fit=crop&auto=format" alt="Spice Garden Restaurant">
    <div class="banner-overlay">
      <div class="banner-info">
        <h1>Spice Garden</h1>
        <div class="banner-cuisine">North Indian · Mughlai · Biryani · Kebabs</div>
        <div class="banner-meta">
          <div class="banner-rating">★ 4.5 (1.2K ratings)</div>
          <div class="bmeta-item">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            28–35 mins
          </div>
          <div class="bmeta-item">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="6" y1="4" x2="18" y2="4"/><line x1="6" y1="10" x2="18" y2="10"/><path d="M6 4h6a6 6 0 0 1 0 12l6 4H6"/></svg>
            ₹250 for two
          </div>
          <div class="banner-open-badge open">● Open Now</div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="cat-nav">
  <a href="#starters" class="cat-nav-item active">🥗 Starters</a>
  <a href="#breads" class="cat-nav-item">🫓 Breads</a>
  <a href="#mains" class="cat-nav-item">🍛 Main Course</a>
</div>

<div class="page-layout">
  <div class="menu-col">
    <div class="menu-search-wrap">
      <div class="menu-search">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input type="text" placeholder="Search within menu...">
      </div>
    </div>
    
    <div class="filter-row">
      <div class="veg-toggle"><div class="veg-dot"></div> Veg Only</div>
      <div class="filter-badge">🔥 Bestsellers</div>
    </div>

    <!-- ── FIXED: STARTERS MENU SECTION ── -->
    <div class="menu-section" id="starters">
      <div class="menu-section-title">
        <span>🥗</span> Starters
      </div>

      <%
        List<Menu> getMenusByRestaurant = (List<Menu>)request.getAttribute("getMenusByRestaurant");
        if (getMenusByRestaurant != null && !getMenusByRestaurant.isEmpty()) {
            for (Menu menu : getMenusByRestaurant) {
      %>			
          <!-- Dynamic Loop Item -->
          <div class="menu-item">
            <div class="menu-item-body">
              <div class="menu-item-top">
                <div class="veg-badge veg"></div>
                <div class="bestseller-tag">Bestseller</div>
                <div class="menu-item-name"><%= menu.getItemName() %></div>
                <div class="menu-item-desc"><%= menu.getDescription() %></div>
              </div>
              <div class="menu-item-bottom">
                <div>
                  <div class="menu-item-price">₹<%= menu.getPrice() %></div>
                  <div class="menu-item-rating">
                    <svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    4.6 (340)
                  </div>
                </div>
              </div>
            </div>
            <div class="menu-item-img-wrap">
             <img src="<%= menu.getImageUrl() != null ? menu.getImageUrl() : "https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=280&h=280&fit=crop&auto=format" %>" 
     alt="<%= menu.getItemName() %>">
              
              <form action="cartServlet"> 
               <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
              <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
              <input type="hidden" name="quantity" value="1">
               <input type="hidden" name="action" value="add">
                  <button class="add-btn">ADD +</button>
              
              </form>
            </div>
          </div> <!-- FIXED: Now closes safely within the loop bounds -->
      <%	  
            }
        } else {
      %>
          <p style="padding: 20px; color: #888;">No menu items found for this restaurant.</p>
      <% 
        }
      %>
    </div> <!-- /menu-section -->
  </div> <!-- /menu-col -->	  

 



</body>
</html>