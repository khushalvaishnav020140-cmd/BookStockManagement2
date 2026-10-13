package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addBook")
public class AddBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String categoryIdText = request.getParameter("categoryId");
        String location = request.getParameter("location");
        String callNumber = request.getParameter("callNumber");
        String totalCopiesText = request.getParameter("totalCopies");
        String bookType = request.getParameter("bookType");

        if (title == null || title.trim().isEmpty()
                || author == null || author.trim().isEmpty()
                || categoryIdText == null
                || totalCopiesText == null) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please fill all required fields."
            );
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdText);
            int totalCopies = Integer.parseInt(totalCopiesText);

            if (categoryId <= 0 || totalCopies <= 0) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Category and total copies must be valid positive numbers."
                );
                return;
            }

            if (bookType == null
                    || !(bookType.equals("Lending")
                    || bookType.equals("Reference")
                    || bookType.equals("Online"))) {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid book type."
                );
                return;
            }

            String sql =
                "INSERT INTO books " +
                "(title, author, category_id, location, call_number, " +
                "total_copies, available_copies, book_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, title.trim());
                ps.setString(2, author.trim());
                ps.setInt(3, categoryId);
                ps.setString(4, location == null ? "" : location.trim());
                ps.setString(5, callNumber == null ? "" : callNumber.trim());
                ps.setInt(6, totalCopies);
                ps.setInt(7, totalCopies);
                ps.setString(8, bookType);

                ps.executeUpdate();
            }

            response.sendRedirect(
                request.getContextPath() + "/books?added=success"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Category ID and total copies must be numbers."
            );

        } catch (SQLException e) {

            throw new ServletException(
                "Book database mein save nahi ho saki.", e
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/addBook.jsp"
        );
    }
}
