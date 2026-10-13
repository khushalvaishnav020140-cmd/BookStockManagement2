package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/books")
public class BookStockServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> books = new ArrayList<>();

        // Search parameters
        String search = request.getParameter("search");
        String category = request.getParameter("category");

        if (search == null) {
            search = "";
        }

        if (category == null) {
            category = "";
        }

        // SQL query with search filters
        StringBuilder sql = new StringBuilder(
            "SELECT b.id, b.title, b.author, " +
            "c.category_name AS category, " +
            "b.location, b.call_number, " +
            "b.total_copies, b.available_copies, b.book_type " +
            "FROM books b " +
            "LEFT JOIN categories c ON b.category_id = c.id " +
            "WHERE 1=1 "
        );

        if (!search.trim().isEmpty()) {
            sql.append(
                "AND (b.title LIKE ? OR b.author LIKE ?) "
            );
        }

        if (!category.trim().isEmpty()) {
            sql.append("AND b.category_id = ? ");
        }

        sql.append("ORDER BY b.id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int parameterIndex = 1;

            // Search by title or author
            if (!search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";

                ps.setString(parameterIndex++, keyword);
                ps.setString(parameterIndex++, keyword);
            }

            // Filter by category
            if (!category.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(category);
                    ps.setInt(parameterIndex++, categoryId);
                } catch (NumberFormatException e) {
                    // Invalid category: show no results
                    request.setAttribute("books", books);
                    request.setAttribute("search", search);
                    request.setAttribute("selectedCategory", "");
                    request.setAttribute("searchError",
                                         "Invalid category selected.");

                    request.getRequestDispatcher("/books.jsp")
                           .forward(request, response);
                    return;
                }
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> book = new HashMap<>();

                    book.put("id", rs.getInt("id"));
                    book.put("title", rs.getString("title"));
                    book.put("author", rs.getString("author"));
                    book.put("category", rs.getString("category"));
                    book.put("location", rs.getString("location"));
                    book.put("callNumber", rs.getString("call_number"));
                    book.put("totalCopies", rs.getInt("total_copies"));
                    book.put("availableCopies",
                             rs.getInt("available_copies"));
                    book.put("bookType", rs.getString("book_type"));

                    books.add(book);
                }
            }

            request.setAttribute("books", books);
            request.setAttribute("search", search);
            request.setAttribute("selectedCategory", category);

            request.getRequestDispatcher("/books.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Book stock load karne mein error aaya.", e);
        }
    }
}