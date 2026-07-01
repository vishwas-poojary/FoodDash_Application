package com.Tap.DAO;

import java.util.List;
import com.Tap.Model.Cart;

public interface CartDAO {
    void addToCart(Cart cart);
    Cart getCartItem(int cartId);
    List<Cart> getCartByUser(int userId);
    void updateQuantity(int cartId, int newQuantity);
    void removeFromCart(int cartId);
    void clearCart(int userId);
}