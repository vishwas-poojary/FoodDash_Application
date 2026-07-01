package com.Tap.utility;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class ImageUpdater {
    
    // 🔑 REPLACE THIS WITH YOUR PEXELS API KEY
    private static final String PEXELS_API_KEY = "VGHDMFch9KDssB0tFdI8In7f7PoZOOMXmEFz8YDNDZwADYNdJwPUEiFy";
    
    // Database queries
    private static final String SELECT_ALL = "SELECT menuId, itemName FROM menu WHERE imageUrl IS NULL OR imageUrl = ''";
    private static final String UPDATE_IMAGE = "UPDATE menu SET imageUrl = ? WHERE menuId = ?";
    
    public static void main(String[] args) {
        System.out.println("🚀 Starting image update for menu items...");
        
        // Get all menu items without images
        List<MenuItem> items = fetchMenuItemsWithoutImage();
        System.out.println("📊 Found " + items.size() + " items to update.");
        
        if (items.isEmpty()) {
            System.out.println("✅ All items already have images! No update needed.");
            return;
        }
        
        HttpClient client = HttpClient.newHttpClient();
        int successCount = 0;
        int failCount = 0;
        
        for (MenuItem item : items) {
            try {
                // Build search query from item name
                String searchQuery = item.name.replace(" ", "+").toLowerCase();
                String apiUrl = "https://api.pexels.com/v1/search?query=" + searchQuery + "&per_page=1&orientation=square";
                
                // Make API request
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(apiUrl))
                        .header("Authorization", PEXELS_API_KEY)
                        .build();
                
                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                
                // Parse JSON response
                JSONObject json = new JSONObject(response.body());
                JSONArray photos = json.getJSONArray("photos");
                
                if (photos.length() > 0) {
                    JSONObject photo = photos.getJSONObject(0);
                    JSONObject src = photo.getJSONObject("src");
                    String imageUrl = src.getString("medium");
                    
                    // Update database
                    updateImageUrl(item.id, imageUrl);
                    System.out.println("✅ Updated: " + item.name + " → " + imageUrl);
                    successCount++;
                } else {
                    System.out.println("⚠️ No image found for: " + item.name);
                    failCount++;
                }
                
                // Be polite to the API (rate limit: 200 requests/hour)
                Thread.sleep(500);
                
            } catch (Exception e) {
                System.err.println("❌ Error for " + item.name + ": " + e.getMessage());
                failCount++;
            }
        }
        
        System.out.println("\n📊 Summary:");
        System.out.println("✅ Successfully updated: " + successCount + " items");
        System.out.println("❌ Failed to update: " + failCount + " items");
        System.out.println("🎉 Done!");
    }
    
    private static List<MenuItem> fetchMenuItemsWithoutImage() {
        List<MenuItem> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL)) {
            while (rs.next()) {
                list.add(new MenuItem(rs.getInt("menuId"), rs.getString("itemName")));
            }
        } catch (SQLException e) {
            System.err.println("❌ Database error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    private static void updateImageUrl(int menuId, String url) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_IMAGE)) {
            pstmt.setString(1, url);
            pstmt.setInt(2, menuId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("❌ Update failed for ID " + menuId + ": " + e.getMessage());
        }
    }
    
    static class MenuItem {
        int id;
        String name;
        MenuItem(int id, String name) {
            this.id = id;
            this.name = name;
        }
    }
}