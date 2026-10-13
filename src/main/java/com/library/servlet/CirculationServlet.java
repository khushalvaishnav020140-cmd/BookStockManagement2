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

@WebServlet("/circulation")
public class CirculationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> circulationList = new ArrayList<>();

        String sql = "SELECT c.id, b.title, c.student_name, c.student_id, "
                   + "c.issue_date, c.due_date, c.return_date, c.status "
                   + "FROM circulation c "
                   + "JOIN books b ON c.book_id = b.id "
                   + "ORDER BY c.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();

                item.put("id", rs.getInt("id"));
                item.put("title", rs.getString("title"));
                item.put("studentName", rs.getString("student_name"));
                item.put("studentId", rs.getString("student_id"));
                item.put("issueDate", rs.getDate("issue_date"));
                item.put("dueDate", rs.getDate("due_date"));
                item.put("returnDate", rs.getDate("return_date"));
                item.put("status", rs.getString("status"));

                circulationList.add(item);
            }

            request.setAttribute("circulationList", circulationList);

            request.getRequestDispatcher("/circulation.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Circulation records load karne mein error aaya.", e);
        }
    }
}