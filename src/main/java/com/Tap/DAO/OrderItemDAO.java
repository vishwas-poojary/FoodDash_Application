package com.Tap.DAO;

import java.sql.SQLException;
import java.util.List;

import com.Tap.Model.OrderItem;

public interface OrderItemDAO {
	void addOrderItem(OrderItem oi) throws SQLException;
    OrderItem getOrderItem(int orderItemId);
    List<OrderItem> getAllOrderItems();
    List<OrderItem> getItemsByOrder(int orderId);
    void updateOrderItem(OrderItem orderItem);
    void deleteOrderItem(int orderItemId);
}