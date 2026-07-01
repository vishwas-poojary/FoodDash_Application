//package com.Tap.utility;

//import java.util.List;
//import java.util.Scanner;
//
//import com.Tap.DAOImpl.UserDAOImpl;
//import com.Tap.Model.User;
//
//public class Launch {
//
//	public static void main(String[] args) {
//		 Scanner scan =new Scanner(System.in);
//		 System.out.println("Enter thr userName: ");
//		 String userName=scan.next();
//		 
//		 System.out.println("Enter the password: ");
//		 String password=scan.next();
//
//		 System.out.println("Enter the emeil: ");
//		 String email=scan.next();
//
//		 System.out.println("Enter the address: ");
//		 String address=scan.next();
//
//	     System.out.println("Enter the role: ");
//	      String role=scan.next();
//
//		 User u = new User(userName,password,email,address,role);
//		 UserDAOImpl userDAO = new UserDAOImpl();
//		 udao.addUser(u);
//		 User u = udao.getUser(1);
//		 u.setAddress("Bangalore");
//		 udao.updateUser(u);
//		 System.out.println("user updated");
//		 udao.deleteUser(1);
//		 System.out.println("user deleted");
//		List<User> allUser= udao.getAllUsers();
//		for(User user: allUser) {
//			System.out.println(user);
//		}
//	}
//
//}

//package com.Tap.utility;
//
//import java.sql.Timestamp;
//
//import com.Tap.DAOImpl.MenuDAOImpl;
//import com.Tap.DAOImpl.OrderItemDAOImpl;
//import com.Tap.DAOImpl.OrderTableDAOImpl;
//import com.Tap.DAOImpl.RestaurantDAOImpl;
//import com.Tap.DAOImpl.UserDAOImpl;
//
//import com.Tap.Model.Menu;
//import com.Tap.Model.OrderItem;
//import com.Tap.Model.OrderTable;
//import com.Tap.Model.Restaurant;
//import com.Tap.Model.User;
//
//public class Launch {
//
//    public static void main(String[] args) {

//        UserDAOImpl userDAO = new UserDAOImpl();
//
//        User user = new User();
//
//       user.setUserName("shashank");
//      user.setPassword("shashank123");
//       user.setEmail("shashank@gmail.com");
//       user.setAddress("Bangalore");
//       user.setRole("CUSTOMER");	
//       user.setCreateDate(new Timestamp(System.currentTimeMillis()));
//       user.setLastLoginDate(new Timestamp(System.currentTimeMillis()));
//
//      userDAO.addUser(user);
//
//      System.out.println("User Inserted Successfully");

//
//      RestaurantDAOImpl restaurantDAO =
//                new RestaurantDAOImpl();
//
//       Restaurant restaurant = new Restaurant();
//
//        restaurant.setName("Pizza Hut");
//        restaurant.setCuisineType("Italian");
//        restaurant.setDeliveryTime(30);
//        restaurant.setAddress("BTM Bangalore");
//        restaurant.setAdminUserID(1);
//        restaurant.setRating(4.5);
//        restaurant.setActive(true);
//
//        restaurantDAO.addRestaurant(restaurant);
//
//        System.out.println("Restaurant Inserted Successfully");

//
//        MenuDAOImpl menuDAO = new MenuDAOImpl();
//
//        Menu menu = new Menu();
//
//        menu.setRestaurantID(2);
//        menu.setItemName("Veg Pizza");
//        menu.setDescription("Cheese Loaded Pizza");
//        menu.setPrice(299.00);
//        menu.setAvailable(true);
//        menu.setCategory("Pizza");
//        menu.setCreatedAt(
//                new Timestamp(System.currentTimeMillis()));
//        menu.setUpdatedAt(
//                new Timestamp(System.currentTimeMillis()));
//        menu.setDeletedAt(null);
//
//        menuDAO.addMenu(menu);
//
//        System.out.println("Menu Inserted Successfully");

//
//        OrderTableDAOImpl orderDAO =
//                new OrderTableDAOImpl();
//
//        OrderTable order = new OrderTable();
//
//        order.setUserID(3);
//        order.setRestaurantID(1);
//        order.setOrderDate(
//                new Timestamp(System.currentTimeMillis()));
//        order.setTotalAmount(299.00);
//        order.setStatus("PLACED");
//        order.setPaymentMethod("COD");
//
//        orderDAO.addOrder(order);
//
//        System.out.println("Order Inserted Successfully");

//
//        OrderItemDAOImpl orderItemDAO =
//                new OrderItemDAOImpl();
//
//        OrderItem item = new OrderItem();
//
//        item.setOrderID(1);
//        item.setMenuID(1);
//        item.setQuantity(2);
//        item.setItemTotal(598.00);
//
//        orderItemDAO.addOrderItem(item);
//
//        System.out.println("Order Item Inserted Successfully");

//
//        System.out.println("\n===== FETCH USER =====");

//        User fetchedUser = userDAO.getUser(3);
//
//        System.out.println(fetchedUser.getUserName());
//        System.out.println(fetchedUser.getEmail());

//
//        System.out.println("\n===== FETCH RESTAURANT =====");
//
//        Restaurant fetchedRestaurant =
//                restaurantDAO.getRestaurant(1);
//
//        System.out.println(fetchedRestaurant.getName());
//        System.out.println(fetchedRestaurant.getCuisineType());

//
//        System.out.println("\n===== FETCH MENU =====");
//
//        Menu fetchedMenu = menuDAO.getMenu(1);
//
//        System.out.println(fetchedMenu.getItemName());
//        System.out.println(fetchedMenu.getPrice());

//
//        System.out.println("\n===== FETCH ORDER =====");
//
//        OrderTable fetchedOrder =
//                orderDAO.getOrder(1);
//
//        System.out.println(fetchedOrder.getStatus());
//        System.out.println(fetchedOrder.getPaymentMethod());
//
//
//        System.out.println("\n===== FETCH ORDER ITEM =====");
//
//        OrderItem fetchedItem =
//                orderItemDAO.getOrderItem(1);
//
//        System.out.println(fetchedItem.getQuantity());
//        System.out.println(fetchedItem.getItemTotal());
//
//
//        System.out.println("\n===== PROJECT WORKING SUCCESSFULLY =====");
//   }
//}

//package com.Tap.utility;
//
//import com.Tap.DAOImpl.CartDAOImpl;
//import com.Tap.Model.Cart;
//import com.Tap.service.OrderService;
//
//public class Launch {
//    public static void main(String[] args) {
//
//        System.out.println("===== TESTING CART + ORDER SERVICE =====\n");
//
//        int userId = 1;      // make sure this user exists
//        int restaurantId = 1; // make sure this restaurant exists
//
//        CartDAOImpl cartDAO = new CartDAOImpl();
//        OrderService orderService = new OrderService();
//
//        // Clear any existing cart for this user (optional)
//        cartDAO.clearCart(userId);
//
//        // Add items to cart
//        System.out.println("Adding items to cart...");
//        cartDAO.addToCart(new Cart(userId, 1, 2)); // menuId=1, quantity=2
//        cartDAO.addToCart(new Cart(userId, 2, 1)); // menuId=2, quantity=1
//
//        // View cart
//        System.out.println("\nCurrent Cart:");
//        cartDAO.getCartByUser(userId).forEach(System.out::println);
//
//        // Place order
//        System.out.println("\nPlacing order...");
//        int orderId = orderService.placeOrder(userId, restaurantId, "COD", "Bangalore, India");
//
//        if (orderId != -1) {
//            System.out.println("\n✅ Order placed successfully! Order ID: " + orderId);
//        } else {
//            System.out.println("\n❌ Order placement failed.");
//        }
//
//        // Verify cart is empty after order
//        System.out.println("\nCart after order:");
//        cartDAO.getCartByUser(userId).forEach(System.out::println);
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//



















