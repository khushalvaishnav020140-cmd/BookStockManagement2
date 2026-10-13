package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/returnBook")
public class ReturnBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String circulationIdText =
                request.getParameter("circulationId");

        if (circulationIdText == null
                || circulationIdText.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Circulation ID is required."
            );
            return;
        }

        try {
            int circulationId =
                    Integer.parseInt(circulationIdText);

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    int bookId;

                    // Lock the circulation record.
                    String selectSql =
                        "SELECT book_id, status FROM circulation "
                        + "WHERE id = ? FOR UPDATE";

                    try (PreparedStatement ps =
                            con.prepareStatement(selectSql)) {

                        ps.setInt(1, circulationId);

                        try (ResultSet rs = ps.executeQuery()) {

                            if (!rs.next()) {
                                throw new IllegalArgumentException(
                                    "Circulation record not found."
                                );
                            }

                            if (!"Issued".equalsIgnoreCase(
                                    rs.getString("status"))) {

                                throw new IllegalStateException(
                                    "This book has already been returned."
                                );
                            }

                            bookId = rs.getInt("book_id");
                        }
                    }

                    // Update return date and status.
                    String updateCirculation =
                        "UPDATE circulation "
                        + "SET return_date = ?, status = 'Returned' "
                        + "WHERE id = ? AND status = 'Issued'";

                    try (PreparedStatement ps =
                            con.prepareStatement(updateCirculation)) {

                        ps.setDate(1, new Date(
                            System.currentTimeMillis()
                        ));

                        ps.setInt(2, circulationId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                "Return record could not be updated."
                            );
                        }
                    }

                    // Increase available copies.
                    String updateBook =
                        "UPDATE books "
                        + "SET available_copies = available_copies + 1 "
                        + "WHERE id = ? "
                        + "AND available_copies < total_copies";

                    try (PreparedStatement ps =
                            con.prepareStatement(updateBook)) {

                        ps.setInt(1, bookId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                "Available book count could not be updated."
                            );
                        }
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
                request.getContextPath()
                + "/circulation?message=returned"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid circulation ID."
            );

        } catch (IllegalArgumentException
                | IllegalStateException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                e.getMessage()
            );

        } catch (Exception e) {
            throw new ServletException(
                "Book return karne mein error aaya.", e
            );
        }
    }
}