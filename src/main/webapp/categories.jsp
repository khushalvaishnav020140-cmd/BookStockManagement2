<%@ page import="java.sql.*" %>
<%@ page import="com.library.db.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Categories - AutoLibSys</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #243447;
        }

        .sidebar {
            width: 220px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: #193e70;
            padding: 25px 15px;
            box-sizing: border-box;
        }

        .sidebar h2 {
            color: white;
            margin-bottom: 45px;
        }

        .sidebar a {
            display: block;
            padding: 15px;
            margin-bottom: 5px;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #2d5b91;
        }

        .main {
            margin-left: 220px;
            padding: 30px;
        }

        h1 {
            margin-bottom: 8px;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #e0e5eb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background: #edf3fa;
        }

        .message {
            padding: 15px;
            background: #fff3cd;
            border-radius: 6px;
            margin-top: 15px;
        }

        footer {
            text-align: center;
            color: #8290a3;
            margin-top: 30px;
            font-size: 13px;
        }

        @media (max-width: 700px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .sidebar h2 {
                margin-bottom: 15px;
            }

            .main {
                margin-left: 0;
                padding: 15px;
            }
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h2>AutoLibSys</h2>

    <a href="<%= request.getContextPath() %>/dashboard">
        Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/books">
        Book Stock
    </a>

    <a href="<%= request.getContextPath() %>/addBook.jsp">
        Add New Book
    </a>

    <a class="active"
       href="<%= request.getContextPath() %>/categories.jsp">
        Categories
    </a>

    <a href="<%= request.getContextPath() %>/circulation">
        Circulation
    </a>
</div>

<div class="main">

    <h1>Book Categories</h1>

    <p class="subtitle">
        View all categories and the number of books in each category.
    </p>

    <div class="card">

        <h2>All Categories</h2>

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

                    <td><%= rs.getString("category_name") %></td>

                    <td><%= rs.getInt("book_count") %></td>
                </tr>

            <%
                    }

                    if (!found) {
            %>

                <tr>
                    <td colspan="3" style="text-align:center;">
                        No categories found.
                    </td>
                </tr>

            <%
                    }

                } catch (Exception e) {
                    application.log("Categories load karne mein error", e);
            %>

                <tr>
                    <td colspan="3" style="color:red;">
                        
                    </td>
                </tr>

            <%
                }
            %>

            </tbody>
        </table>

    </div>

    <footer>
        AutoLibSys &copy; 2026 | Library Book Stock Management System
    </footer>

</div>

</body>
</html>