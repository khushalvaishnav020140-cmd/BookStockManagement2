package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int totalBooks = 0;
        int lendingBooks = 0;
        int referenceBooks = 0;
        int onlineBooks = 0;

        List<Map<String, Object>> books = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            // Dashboard ke total copies
            String sql = "SELECT COALESCE(SUM(total_copies), 0) AS copies "
                       + "FROM books";

            try (Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {

                if (rs.next()) {
                    totalBooks = rs.getInt("copies");
                }
            }

            // Book type ke hisaab se copies
            String typeSql =
                    "SELECT book_type, COALESCE(SUM(total_copies), 0) AS copies "
                  + "FROM books GROUP BY book_type";

            try (PreparedStatement ps = con.prepareStatement(typeSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    String type = rs.getString("book_type");
                    int copies = rs.getInt("copies");

                    if ("Lending".equalsIgnoreCase(type)) {
                        lendingBooks = copies;
                    } else if ("Reference".equalsIgnoreCase(type)) {
                        referenceBooks = copies;
                    } else if ("Online".equalsIgnoreCase(type)) {
                        onlineBooks = copies;
                    }
                }
            }

            // Database se actual book details fetch karo
            String bookSql =
                    "SELECT b.id, b.title, b.author, "
                  + "c.category_name AS category, "
                  + "b.location, b.call_number, "
                  + "b.total_copies, b.available_copies, b.book_type "
                  + "FROM books b "
                  + "LEFT JOIN categories c ON b.category_id = c.id "
                  + "ORDER BY b.id DESC";

            try (PreparedStatement ps = con.prepareStatement(bookSql);
                 ResultSet rs = ps.executeQuery()) {

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

            // JSP ko data bhejo
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("lendingBooks", lendingBooks);
            request.setAttribute("referenceBooks", referenceBooks);
            request.setAttribute("onlineBooks", onlineBooks);
            request.setAttribute("books", books);

            request.getRequestDispatcher("/dashboard.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            throw new ServletException(
                    "Dashboard data load karne mein error aaya.", e);
        }
    }
}