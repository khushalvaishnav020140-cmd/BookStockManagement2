package com.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import com.library.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/issueBook")
public class IssueBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String bookIdText = request.getParameter("bookId");
        String studentName = request.getParameter("studentName");
        String studentId = request.getParameter("studentId");
        String issueDateText = request.getParameter("issueDate");
        String dueDateText = request.getParameter("dueDate");

        String contextPath = request.getContextPath();

        if (bookIdText == null || studentName == null
                || studentId == null || issueDateText == null
                || dueDateText == null
                || studentName.trim().isEmpty()
                || studentId.trim().isEmpty()
                || issueDateText.isEmpty()
                || dueDateText.isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please fill all required fields."
            );
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdText);

            LocalDate issueDate = LocalDate.parse(issueDateText);
            LocalDate dueDate = LocalDate.parse(dueDateText);

            if (dueDate.isBefore(issueDate)) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Due date cannot be before issue date."
                );
                return;
            }

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    // Check availability and lock the selected book row.
                    String checkSql =
                        "SELECT available_copies FROM books "
                        + "WHERE id = ? FOR UPDATE";

                    try (PreparedStatement checkPs =
                            con.prepareStatement(checkSql)) {

                        checkPs.setInt(1, bookId);

                        try (ResultSet rs = checkPs.executeQuery()) {

                            if (!rs.next()) {
                                con.rollback();
                                response.sendError(
                                    HttpServletResponse.SC_BAD_REQUEST,
                                    "Selected book was not found."
                                );
                                return;
                            }

                            if (rs.getInt("available_copies") <= 0) {
                                con.rollback();
                                response.sendError(
                                    HttpServletResponse.SC_BAD_REQUEST,
                                    "This book is currently unavailable."
                                );
                                return;
                            }
                        }
                    }

                    // Save circulation record.
                    String insertSql =
                        "INSERT INTO circulation "
                        + "(book_id, student_name, student_id, "
                        + "issue_date, due_date, status) "
                        + "VALUES (?, ?, ?, ?, ?, 'Issued')";

                    try (PreparedStatement insertPs =
                            con.prepareStatement(insertSql)) {

                        insertPs.setInt(1, bookId);
                        insertPs.setString(2, studentName.trim());
                        insertPs.setString(3, studentId.trim());
                        insertPs.setDate(4, Date.valueOf(issueDate));
                        insertPs.setDate(5, Date.valueOf(dueDate));

                        insertPs.executeUpdate();
                    }

                    // Reduce available copies by one.
                    String updateSql =
                        "UPDATE books "
                        + "SET available_copies = available_copies - 1 "
                        + "WHERE id = ? AND available_copies > 0";

                    try (PreparedStatement updatePs =
                            con.prepareStatement(updateSql)) {

                        updatePs.setInt(1, bookId);

                        if (updatePs.executeUpdate() != 1) {
                            throw new SQLException(
                                "Book availability could not be updated."
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
                contextPath + "/circulation?message=issued"
            );

        } catch (NumberFormatException
                | java.time.DateTimeException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter valid book and date details."
            );

        } catch (Exception e) {
            throw new ServletException("Book issue karne mein error aaya.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/issueBook.jsp"
        );
    }
}