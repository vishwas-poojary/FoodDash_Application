package com.Tap.DAO;

import java.util.List;
import com.Tap.Model.Menu;

public interface MenuDAO {
    void addMenu(Menu menu);
    Menu getMenu(int menuId);
    List<Menu> getAllMenus();
    List<Menu> getMenusByRestaurant(int restaurantId);
    void updateMenu(Menu menu);
    void deleteMenu(int menuId);
    void updateStock(int menuId, int newStock);
}