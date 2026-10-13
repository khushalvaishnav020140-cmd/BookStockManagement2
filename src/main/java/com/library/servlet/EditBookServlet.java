package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/editBook")
public class EditBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String idText = request.getParameter("id");

        if (idText == null || idText.trim().isEmpty()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Book ID is required."
            );
            return;
        }

        try {
            int id = Integer.parseInt(idText);

            try (Connection con = DBConnection.getConnection()) {

                String sql =
                    "SELECT id, title, author, category_id, location, " +
                    "call_number, total_copies, available_copies, book_type " +
                    "FROM books WHERE id = ?";

                try (PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setInt(1, id);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {

                            request.setAttribute("bookId", rs.getInt("id"));
                            request.setAttribute("title", rs.getString("title"));
                            request.setAttribute("author", rs.getString("author"));
                            request.setAttribute("categoryId", rs.getObject("category_id"));
                            request.setAttribute("location", rs.getString("location"));
                            request.setAttribute("callNumber", rs.getString("call_number"));
                            request.setAttribute("totalCopies", rs.getInt("total_copies"));
                            request.setAttribute("availableCopies", rs.getInt("available_copies"));
                            request.setAttribute("bookType", rs.getString("book_type"));

                            request.getRequestDispatcher("/editBook.jsp")
                                   .forward(request, response);

                        } else {
                            response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Book not found."
                            );
                        }
                    }
                }

            } catch (Exception e) {
                throw new ServletException("Book details load karne mein error aaya.", e);
            }

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid Book ID."
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idText = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String categoryText = request.getParameter("categoryId");
        String location = request.getParameter("location");
        String callNumber = request.getParameter("callNumber");
        String totalText = request.getParameter("totalCopies");
        String bookType = request.getParameter("bookType");

        if (idText == null || title == null || author == null ||
            categoryText == null || location == null ||
            callNumber == null || totalText == null || bookType == null) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please fill in all required fields."
            );
            return;
        }

        title = title.trim();
        author = author.trim();
        location = location.trim();
        callNumber = callNumber.trim();
        bookType = bookType.trim();

        if (title.isEmpty() || author.isEmpty() ||
            categoryText.trim().isEmpty() || totalText.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Title, author, category and total copies are required."
            );
            return;
        }

        if (!"Lending".equals(bookType) &&
            !"Reference".equals(bookType) &&
            !"Online".equals(bookType)) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid book type."
            );
            return;
        }

        try {
            int id = Integer.parseInt(idText);
            int categoryId = Integer.parseInt(categoryText);
            int totalCopies = Integer.parseInt(totalText);

            if (id <= 0 || categoryId <= 0 || totalCopies < 1) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid book details."
                );
                return;
            }

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    int oldTotal;
                    int oldAvailable;

                    String lockSql =
                        "SELECT total_copies, available_copies " +
                        "FROM books WHERE id = ? FOR UPDATE";

                    try (PreparedStatement ps = con.prepareStatement(lockSql)) {
                        ps.setInt(1, id);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                con.rollback();
                                response.sendError(
                                    HttpServletResponse.SC_NOT_FOUND,
                                    "Book not found."
                                );
                                return;
                            }

                            oldTotal = rs.getInt("total_copies");
                            oldAvailable = rs.getInt("available_copies");
                        }
                    }

                    int issuedCopies = oldTotal - oldAvailable;

                    if (totalCopies < issuedCopies) {
                        con.rollback();
                        response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Total copies cannot be less than currently issued copies."
                        );
                        return;
                    }

                    int newAvailable = totalCopies - issuedCopies;

                    String updateSql =
                        "UPDATE books SET title = ?, author = ?, category_id = ?, " +
                        "location = ?, call_number = ?, total_copies = ?, " +
                        "available_copies = ?, book_type = ? WHERE id = ?";

                    try (PreparedStatement ps = con.prepareStatement(updateSql)) {

                        ps.setString(1, title);
                        ps.setString(2, author);
                        ps.setInt(3, categoryId);
                        ps.setString(4, location);
                        ps.setString(5, callNumber);
                        ps.setInt(6, totalCopies);
                        ps.setInt(7, newAvailable);
                        ps.setString(8, bookType);
                        ps.setInt(9, id);

                        ps.executeUpdate();
                    }

                    con.commit();

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                } finally {
                    con.setAutoCommit(true);
                }
            }

            response.sendRedirect(
                request.getContextPath() + "/books?updated=success"
            );

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid numeric value."
            );

        } catch (Exception e) {
            throw new ServletException("Book update karne mein error aaya.", e);
        }
    }
}