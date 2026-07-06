<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.Tap.Model.Restaurant" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodDash – Order Food Online</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Inter', sans-serif; background: #f8f8f8; color: #1c1c1c; }

  /* ── NAVBAR ── */
  nav {
    background: #fff;
    border-bottom: 1px solid #f0f0f0;
    padding: 0 2rem;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 100;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  }
  .nav-logo {
    font-size: 22px; font-weight: 700; color: #fc4b08;
    letter-spacing: -0.5px; display: flex; align-items: center; gap: 8px;
  }
  .nav-logo span { font-size: 26px; }
  .nav-center { flex: 1; max-width: 420px; margin: 0 2rem; }
  .nav-search {
    display: flex; align-items: center;
    background: #f5f5f5; border: 1.5px solid #eee;
    border-radius: 10px; padding: 8px 14px; gap: 8px; transition: border-color 0.2s;
  }
  .nav-search:focus-within { border-color: #fc4b08; }
  .nav-search svg { width: 16px; height: 16px; color: #999; flex-shrink: 0; }
  .nav-search input {
    border: none; background: transparent; font-size: 14px;
    color: #1c1c1c; outline: none; width: 100%; font-family: inherit;
  }
  .nav-search input::placeholder { color: #aaa; }
  .nav-links { display: flex; align-items: center; gap: 4px; }
  .nav-links a {
    text-decoration: none; font-size: 14px; font-weight: 500; color: #3d3d3d;
    padding: 8px 16px; border-radius: 8px;
    transition: background 0.15s, color 0.15s;
    display: flex; align-items: center; gap: 6px;
  }
  .nav-links a:hover { background: #f5f5f5; color: #fc4b08; }
  .nav-links a.btn-signup { background: #fc4b08; color: #fff; }
  .nav-links a.btn-signup:hover { background: #e04007; }
  .nav-profile {
    width: 36px; height: 36px; border-radius: 50%;
    background: #fc4b08; color: #fff; font-size: 13px; font-weight: 600;
    display: flex; align-items: center; justify-content: center;
    cursor: pointer; margin-left: 8px; border: 2px solid #ffe5d9;
  }

  /* ── HERO ── */
  .hero {
    background: linear-gradient(135deg, #fff5f0 0%, #fff 60%);
    padding: 2.5rem 2rem 2rem; border-bottom: 1px solid #f0f0f0;
  }
  .hero-inner {
    max-width: 1200px; margin: 0 auto;
    display: flex; align-items: center; justify-content: space-between; gap: 2rem;
  }
  .hero-text h1 { font-size: 32px; font-weight: 700; line-height: 1.2; margin-bottom: 6px; }
  .hero-text h1 span { color: #fc4b08; }
  .hero-text p { font-size: 15px; color: #666; margin-bottom: 1.5rem; }
  .hero-search {
    display: flex; align-items: center; background: #fff;
    border: 2px solid #eee; border-radius: 12px; padding: 12px 16px; gap: 10px;
    max-width: 520px; box-shadow: 0 4px 16px rgba(0,0,0,0.07); transition: border-color 0.2s;
  }
  .hero-search:focus-within { border-color: #fc4b08; }
  .hero-search svg { width: 20px; height: 20px; color: #fc4b08; flex-shrink: 0; }
  .hero-search input {
    border: none; background: transparent; font-size: 15px;
    color: #1c1c1c; outline: none; width: 100%; font-family: inherit;
  }
  .hero-search input::placeholder { color: #bbb; }
  .hero-loc {
    display: flex; align-items: center; gap: 6px;
    font-size: 13px; color: #fc4b08; font-weight: 500; cursor: pointer;
    border-left: 1px solid #eee; padding-left: 12px; white-space: nowrap;
  }
  .hero-stats { display: flex; gap: 1.5rem; margin-top: 1.5rem; }
  .stat { text-align: center; }
  .stat-num { font-size: 22px; font-weight: 700; }
  .stat-label { font-size: 12px; color: #999; margin-top: 2px; }
  .hero-img { font-size: 100px; line-height: 1; flex-shrink: 0; }

  /* ── FILTER BAR ── */
  .filter-bar {
    background: #fff; padding: 0 2rem; border-bottom: 1px solid #f0f0f0;
    display: flex; align-items: center; gap: 10px;
    overflow-x: auto; scrollbar-width: none;
  }
  .filter-bar::-webkit-scrollbar { display: none; }
  .filter-chip {
    white-space: nowrap; font-size: 13px; font-weight: 500;
    padding: 10px 18px; border-bottom: 2px solid transparent;
    cursor: pointer; color: #666; transition: all 0.15s;
    display: flex; align-items: center; gap: 6px; text-decoration: none;
  }
  .filter-chip:hover { color: #fc4b08; }
  .filter-chip.active { color: #fc4b08; border-bottom-color: #fc4b08; }

  /* ── SECTION ── */
  .section { max-width: 1200px; margin: 0 auto; padding: 2rem; }
  .section-header {
    display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem;
  }
  .section-header h2 { font-size: 22px; font-weight: 700; }
  .section-header a { font-size: 13px; color: #fc4b08; text-decoration: none; font-weight: 500; }

  /* ── CATEGORY GRID ── */
  .cat-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
    gap: 12px; margin-bottom: 2rem;
  }
  .cat-card {
    background: #fff; border-radius: 12px; padding: 16px 12px;
    text-align: center; cursor: pointer; border: 1.5px solid #f0f0f0; transition: all 0.15s;
  }
  .cat-card:hover { border-color: #fc4b08; background: #fff5f0; }
  .cat-icon { font-size: 28px; margin-bottom: 6px; }
  .cat-name { font-size: 12px; font-weight: 500; color: #444; }

  /* ── CARDS GRID ── */
  .cards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(255px, 1fr)); gap: 20px; }

  /* ── RESTAURANT CARD ── */
  .card {
    background: #fff; border-radius: 16px; overflow: hidden; cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  }
  .card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
  .card-img-wrap {
    position: relative; width: 100%; height: 180px; overflow: hidden; background: #f5f5f5;
  }
  .card-img-wrap img {
    width: 100%; height: 100%; object-fit: cover; display: block; transition: transform 0.3s;
  }
  .card:hover .card-img-wrap img { transform: scale(1.05); }
  .offer-tag {
    position: absolute; bottom: 0; left: 0; right: 0;
    background: linear-gradient(transparent, rgba(0,0,0,0.75));
    color: #fff; font-size: 12px; font-weight: 600; padding: 24px 10px 8px;
  }
  .offer-tag span { background: #fc4b08; padding: 3px 8px; border-radius: 4px; letter-spacing: 0.3px; }
  .inactive-tag {
    position: absolute; top: 10px; left: 10px;
    background: #555; color: #fff;
    font-size: 10px; font-weight: 600;
    padding: 3px 8px; border-radius: 4px;
    letter-spacing: 0.5px; text-transform: uppercase;
  }
  .card-body { padding: 12px 14px 14px; }
  .card-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 8px; margin-bottom: 3px; }
  .card-name { font-size: 15px; font-weight: 600; line-height: 1.3; color: #1c1c1c; }
  .card-cuisine { font-size: 12px; color: #888; margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .card-location { display: flex; align-items: center; gap: 4px; font-size: 12px; color: #666; margin-bottom: 10px; }
  .card-location svg { width: 12px; height: 12px; flex-shrink: 0; }
  .card-divider { border: none; border-top: 1px dashed #f0f0f0; margin-bottom: 10px; }
  .card-meta { display: flex; align-items: center; }
  .meta-item { display: flex; align-items: center; gap: 4px; font-size: 12px; color: #555; padding-right: 12px; }
  .meta-item:not(:last-child) { border-right: 1px solid #e8e8e8; margin-right: 12px; }
  .meta-item svg { width: 13px; height: 13px; color: #888; }
  .meta-item strong { font-weight: 600; color: #1c1c1c; }
  .rating-badge {
    display: flex; align-items: center; gap: 3px;
    background: #48c479; color: #fff;
    font-size: 12px; font-weight: 600;
    padding: 3px 8px; border-radius: 6px; flex-shrink: 0;
  }
  .rating-badge.high { background: #1a6e2e; }
  .rating-badge.low  { background: #9e9e9e; }

  .empty-state {
    text-align: center; padding: 4rem 2rem; color: #999;
  }
  .empty-state .empty-icon { font-size: 64px; margin-bottom: 1rem; }
  .empty-state h3 { font-size: 18px; font-weight: 600; color: #555; margin-bottom: 6px; }
  .empty-state p { font-size: 14px; }

  footer { background: #1c1c1c; color: #aaa; text-align: center; padding: 1.5rem; font-size: 13px; margin-top: 2rem; }
  footer span { color: #fc4b08; }
</style>
</head>
<body>

<!-- ── NAVBAR ── -->
<nav>
  <div class="nav-logo"><span>🍽</span> FoodDash</div>
  <div class="nav-center">
    <div class="nav-search">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
      </svg>
      <input type="text" placeholder="Search for restaurants, cuisines...">
    </div>
  </div>
  <div class="nav-links">
    <a href="#">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
      </svg>
      Home
    </a>
    <%
        if (session.getAttribute("user") != null) {
    %>
    <a href="OrderDetails" class="btn-signup">Order Details</a>
    <a href="login.html">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      Logout
    </a>
    <%
        } else {
    %>
    <a href="login.html">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
        <polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/>
      </svg>
      Login
    </a>
    <a href="register.html" class="btn-signup">Sign Up</a>
    <%
        }
    %>
    <a href="Cart.jsp" class="btn-signup">Cart</a>
  </div>
  <div class="nav-profile">AK</div>
</nav>

<!-- ── HERO ── -->
<!-- ── HERO ── -->
<div class="hero">
  <div class="hero-inner">
    <div class="hero-text">
      <h1>Hungry? We've got<br>you <span>covered 🔥</span></h1>
      <p>Order from the best restaurants near you in Bengaluru</p>
      
      <!-- Location box and its search container have been removed from here -->

      <div class="hero-stats">
       
      </div>
    </div>
    <div class="hero-img">🛵</div>
  </div>
</div>

<!-- ── FILTER BAR ── -->
<div class="filter-bar">
  <a href="#" class="filter-chip active">🍽 All</a>
  <a href="#" class="filter-chip">🍕 Pizza</a>
  <a href="#" class="filter-chip">🍔 Burgers</a>
  <a href="#" class="filter-chip">🍛 Biryani</a>
  <a href="#" class="filter-chip">🍣 Sushi</a>
  <a href="#" class="filter-chip">🥗 Healthy</a>
  <a href="#" class="filter-chip">🍜 Chinese</a>
  <a href="#" class="filter-chip">🥞 Breakfast</a>
  <a href="#" class="filter-chip">🍦 Desserts</a>
  <a href="#" class="filter-chip">☕ Cafe</a>
  <a href="#" class="filter-chip">🌮 Mexican</a>
  <a href="#" class="filter-chip">🍗 Chicken</a>
</div>

<!-- ── MAIN SECTION ── -->
<div class="section">

  <!-- Categories -->
  <div class="section-header"><h2>What's on your mind?</h2></div>
  <div class="cat-grid">
    <div class="cat-card"><div class="cat-icon">🍕</div><div class="cat-name">Pizza</div></div>
    <div class="cat-card"><div class="cat-icon">🍔</div><div class="cat-name">Burger</div></div>
    <div class="cat-card"><div class="cat-icon">🍛</div><div class="cat-name">Biryani</div></div>
    <div class="cat-card"><div class="cat-icon">🍣</div><div class="cat-name">Sushi</div></div>
    <div class="cat-card"><div class="cat-icon">🥗</div><div class="cat-name">Salads</div></div>
    <div class="cat-card"><div class="cat-icon">🍜</div><div class="cat-name">Noodles</div></div>
    <div class="cat-card"><div class="cat-icon">🍦</div><div class="cat-name">Desserts</div></div>
    <div class="cat-card"><div class="cat-icon">☕</div><div class="cat-name">Cafe</div></div>
    <div class="cat-card"><div class="cat-icon">🌮</div><div class="cat-name">Mexican</div></div>
    <div class="cat-card"><div class="cat-icon">🍗</div><div class="cat-name">Chicken</div></div>
  </div>

  <!-- Restaurants -->
  <div class="section-header">
    <h2>Restaurants near you</h2>
    <a href="#">See all →</a>
  </div>

  <div class="cards-grid">

   <%
    List<Restaurant> allRestaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
    
    if (allRestaurants != null && !allRestaurants.isEmpty()) {
        for (Restaurant restaurant : allRestaurants) {
      
        if (!restaurant.isActive()) continue;
        
        double rating = restaurant.getRating();
        String ratingClass = "";
        if (rating >= 4.5) {
            ratingClass = "high";
        } else if (rating < 4.0) {
            ratingClass = "low";
        }
%>
  <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>" >
<div class="card">
<div class="card-img-wrap">
    <img src="<%= restaurant.getImageUrl() != null ? restaurant.getImageUrl() : "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=220&fit=crop&auto=format" %>" 
         alt="<%= restaurant.getName() %>" 
         width="200" height="150">
    <div class="offer-tag"><span>50% OFF up to ₹100</span></div>
</div>
<div class="card-body">
    <div class="card-top">
        <div class="card-name"><%= restaurant.getName() %></div>
        <div class="rating-badge <%= ratingClass %>">★ <%= restaurant.getRating() %></div>
    </div>
    <div class="card-cuisine"><%= restaurant.getCuisineType() %></div>
    <div class="card-location">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
        </svg>
        <%= restaurant.getAddress() %>
    </div>
    <hr class="card-divider" />
    <div class="card-meta">
        <div class="meta-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12 6 12 12 16 14"/>
            </svg>
            <strong><%= restaurant.getDeliveryTime() %> mins</strong>
        </div>
        <div class="meta-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="6" y1="4" x2="18" y2="4"/>
                <line x1="6" y1="10" x2="18" y2="10"/>
                <path d="M6 4h6a6 6 0 0 1 0 12l6 4H6"/>
            </svg>
            <strong>₹200</strong> for two
        </div>
    </div>
</div>
</div>
</a>

<%
    } // end for loop
} else { // empty state
%>

<div class="empty-state">
<div class="empty-icon">🍽️</div>
<h3>No restaurants found</h3>
<p>Please check back later or try a different location.</p>
</div>

<%
} // end if-else
%>

  </div><!-- /cards-grid -->
</div><!-- /section -->
        

<footer>
  Made with <span>♥</span> by FoodDash &nbsp;·&nbsp; © 2026 FoodDash. All rights reserved.
</footer>

</body>
</html>
