<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page import="com.library.db.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Book Categories - AutoLibSys</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            background: #f4f7fb;
            color: #263445;
        }

        /* Dashboard-style sidebar */
        .sidebar {
            width: 240px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: #153b70;
            color: white;
            padding: 28px 18px;
            overflow-y: auto;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 40px;
        }

        .logo span {
            color: #71c6ff;
        }

        .sidebar a {
            display: block;
            padding: 14px 15px;
            margin-bottom: 8px;
            border-radius: 7px;
            color: #e5edfa;
            text-decoration: none;
            font-size: 15px;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #285792;
            color: white;
        }

        /* Main content */
        .main {
            margin-left: 240px;
            padding: 30px;
            min-height: 100vh;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .topbar h1 {
            font-size: 28px;
            color: #18385e;
        }

        .subtitle {
            margin-top: 8px;
            color: #718096;
            font-size: 14px;
            line-height: 1.5;
        }

        /* Category table card */
        .section {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
        }

        .section-header {
            margin-bottom: 22px;
        }

        .section-header h2 {
            color: #18385e;
            font-size: 21px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 500px;
        }

        thead {
            background: #eef4fb;
        }

        th {
            text-align: left;
            padding: 15px 12px;
            color: #35516f;
            font-size: 13px;
            white-space: nowrap;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #edf0f5;
            font-size: 14px;
            color: #526174;
        }

        tbody tr:hover {
            background: #f8fbff;
        }

        .count-badge {
            display: inline-block;
            min-width: 35px;
            padding: 6px 10px;
            text-align: center;
            border-radius: 20px;
            background: #e5f7ee;
            color: #168454;
            font-size: 12px;
            font-weight: bold;
        }

        .empty {
            text-align: center;
            padding: 30px;
            color: #718096;
        }

        .error-message {
            margin-top: 15px;
            padding: 14px;
            background: #fff0f0;
            color: #a52828;
            border: 1px solid #f1cccc;
            border-radius: 7px;
            font-size: 14px;
        }

        .footer {
            margin-top: 25px;
            text-align: center;
            color: #8a96a6;
            font-size: 12px;
        }

        @media (max-width: 700px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px 18px;
            }

            .logo {
                margin-bottom: 15px;
            }

            .sidebar a {
                display: inline-block;
                margin: 3px 2px;
                padding: 10px;
            }

            .main {
                margin-left: 0;
                padding: 18px;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .section {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

    <!-- Sidebar -->
    <div class="sidebar">

        <div class="logo">Auto<span>LibSys</span></div>

        <a href="${pageContext.request.contextPath}/dashboard">
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/books">
            Book Stock
        </a>

        <a href="${pageContext.request.contextPath}/addBook.jsp">
            Add New Book
        </a>

        <a href="${pageContext.request.contextPath}/categories.jsp"
           class="active">
            Categories
        </a>

        <a href="${pageContext.request.contextPath}/circulation">
            Circulation
        </a>

    </div>

    <!-- Main content -->
    <main class="main">

        <div class="topbar">
            <div>
                <h1>Book Categories</h1>
                <p class="subtitle">
                    View all categories and the number of books in each category.
                </p>
            </div>
        </div>

        <section class="section">

            <div class="section-header">
                <h2>All Categories</h2>
            </div>

            <div class="table-wrapper">

                <table>
                    <thead>
                        <tr>
                            <th>Category ID</th>
                            <th>Category Name</th>
                            <th>Number of Books</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        String sql =
                            "SELECT c.id, c.category_name, COUNT(b.id) AS book_count "
                          + "FROM categories c "
                          + "LEFT JOIN books b ON c.id = b.category_id "
                          + "GROUP BY c.id, c.category_name "
                          + "ORDER BY c.id";

                        boolean found = false;

                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement ps = con.prepareStatement(sql);
                             ResultSet rs = ps.executeQuery()) {

                            while (rs.next()) {
                                found = true;
                    %>

                        <tr>
                            <td><%= rs.getInt("id") %></td>

                            <td>
                                <%= rs.getString("category_name") == null
                                    ? ""
                                    : rs.getString("category_name") %>
                            </td>

                            <td>
                                <span class="count-badge">
                                    <%= rs.getInt("book_count") %>
                                </span>
                            </td>
                        </tr>

                    <%
                            }

                            if (!found) {
                    %>

                        <tr>
                            <td colspan="3" class="empty">
                                No categories found.
                            </td>
                        </tr>

                    <%
                            }

                        } catch (Exception e) {
                            application.log("Categories load karne mein error", e);
                    %>

                        <tr>
                            <td colspan="3" class="empty">
                                Unable to load categories. Please check the database connection.
                            </td>
                        </tr>

                    <%
                        }
                    %>
                    </tbody>
                </table>

            </div>

        </section>

        <div class="footer">
            AutoLibSys &copy; 2026 | Library Book Stock Management System
        </div>

    </main>

</body>
</html>
