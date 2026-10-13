package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/categories")
public class CategoriesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> categories = new ArrayList<>();

        String sql =
            "SELECT c.id, c.category_name, COUNT(b.id) AS book_count " +
            "FROM categories c " +
            "LEFT JOIN books b ON c.id = b.category_id " +
            "GROUP BY c.id, c.category_name " +
            "ORDER BY c.id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();

                category.put("id", rs.getInt("id"));
                category.put("name", rs.getString("category_name"));
                category.put("bookCount", rs.getInt("book_count"));

                categories.add(category);
            }

            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/categories.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Categories load karne mein error aaya.", e);
        }
    }
}