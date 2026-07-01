package com.Tap.Model;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class Cart {

    // BUG FIX: Removed 'static' — static means ALL users share one cart!
    // Each Cart object must have its OWN items map.
    private Map<Integer, CartItem> items;

    public Cart() {
        items = new HashMap<Integer, CartItem>();
    }

    public Cart(int int1, int int2, int int3, int int4, Timestamp timestamp) {
		// TODO Auto-generated constructor stub
	}

	public Map<Integer, CartItem> getItems() {
        return items;
    }

    // BUG FIX: Removed 'static' from addItem — must be instance method
    // so it works on the specific cart object stored in session
    public void addItem(CartItem cartItem) {
        int menuId = cartItem.getMenuId();

        if (items.containsKey(menuId)) {
            // Item already in cart — just increase quantity by 1
            CartItem existingCartItem = items.get(menuId);
            existingCartItem.setQuantity(existingCartItem.getQuantity() + 1);
        } else {
            // New item — add it to the map
            items.put(menuId, cartItem);
        }
    }

    // Update item quantity directly
    public void updateItem(int itemId, int quantity) {
        if (items.containsKey(itemId)) {
            if(quantity > 0) {
            	CartItem existingItem = items.get(itemId);
                existingItem.setQuantity(quantity);
            }
            else {
            	items.remove(itemId);
            }
        }
    }

    // Remove item from cart
    public void removeItem(int menuId) {
        items.remove(menuId);
    }

	public int getUserId() {
		// TODO Auto-generated method stub
		return 0;
	}

	public int getMenuId() {
		// TODO Auto-generated method stub
		return 0;
	}

	public int getQuantity() {
		// TODO Auto-generated method stub
		return 0;
	}


}