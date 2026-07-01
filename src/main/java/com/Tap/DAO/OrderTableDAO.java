package com.Tap.DAO;

import java.sql.SQLException;
import java.util.List;
import com.Tap.Model.OrderTable;

public interface OrderTableDAO {
	int addOrder(OrderTable o) throws SQLException;
    OrderTable getOrder(int orderId);
    List<OrderTable> getAllOrders();
    List<OrderTable> getOrdersByUser(int userId);
    void updateOrder(OrderTable order);
    void deleteOrder(int orderId);
    void updateOrderStatus(int orderId, String status);
}