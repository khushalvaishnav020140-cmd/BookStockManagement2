<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.library.db.DBConnection" %>

<%
    List<Map<String, Object>> books =
        (List<Map<String, Object>>) request.getAttribute("books");

    String search = (String) request.getAttribute("search");
    String selectedCategory =
        (String) request.getAttribute("selectedCategory");

    String searchError = (String) request.getAttribute("searchError");
    String updated = request.getParameter("updated");

    if (search == null) {
        search = "";
    }

    if (selectedCategory == null) {
        selectedCategory = "";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Stock Management</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .sidebar {
            width: 230px;
            height: 100vh;
            background: #243447;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            padding: 25px 15px;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            padding: 13px 15px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 8px;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #3498db;
        }

        .main {
            margin-left: 230px;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin: 0;
            color: #243447;
        }

        .add-button {
            background: #28a745;
            color: white;
            padding: 11px 16px;
            text-decoration: none;
            border-radius: 5px;
            white-space: nowrap;
        }

        .search-panel,
        .table-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .search-panel h3,
        .table-container h3 {
            margin-top: 0;
            color: #243447;
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
        }

        .search-form input,
        .search-form select {
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            min-width: 180px;
            flex: 1;
        }

        .search-button,
        .edit-button {
            padding: 9px 14px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .search-button {
            padding: 11px 20px;
        }

        .search-button:hover,
        .edit-button:hover {
            background: #217dbb;
        }

        .clear-button {
            padding: 11px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 13px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 13px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1050px;
        }

        th,
        td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #243447;
            color: white;
        }

        tr:hover {
            background: #f7f9fb;
        }

        .available {
            color: #218838;
            font-weight: bold;
        }

        .unavailable {
            color: #dc3545;
            font-weight: bold;
        }

        .empty-message {
            text-align: center;
            padding: 25px;
            color: #666;
        }

        @media (max-width: 800px) {
            .sidebar {
                width: 180px;
            }

            .main {
                margin-left: 180px;
                padding: 15px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>📚 Library</h2>

        <a href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/books"
           class="active">
            Book Stock
        </a>

        <a href="<%= request.getContextPath() %>/addBook.jsp">
            Add Book
        </a>

        <a href="<%= request.getContextPath() %>/categories">
            Categories
        </a>

        <a href="<%= request.getContextPath() %>/circulation">
            Circulation
        </a>
    </div>

    <!-- Main Content -->
    <div class="main">

        <div class="page-header">
            <h1>Book Stock Management</h1>

            <a class="add-button"
               href="<%= request.getContextPath() %>/addBook.jsp">
                + Add New Book
            </a>
        </div>

        <% if ("success".equals(updated)) { %>
            <div class="success-message">
                Book details updated successfully!
            </div>
        <% } %>

        <% if (searchError != null) { %>
            <div class="error-message">
                <%= searchError %>
            </div>
        <% } %>

        <!-- Search Section -->
        <div class="search-panel">

            <h3>Search Books</h3>

            <form class="search-form"
                  action="<%= request.getContextPath() %>/books"
                  method="get">

                <input type="text"
                       name="search"
                       placeholder="Enter book title or author..."
                       value="<%= search %>">

                <select name="category">
                    <option value="">All Categories</option>

                    <%
                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement ps = con.prepareStatement(
                                 "SELECT id, category_name FROM categories ORDER BY category_name");
                             ResultSet rs = ps.executeQuery()) {

                            while (rs.next()) {
                                String categoryId =
                                    String.valueOf(rs.getInt("id"));

                                String categoryName =
                                    rs.getString("category_name");

                                boolean isSelected =
                                    categoryId.equals(selectedCategory);
                    %>

                        <option value="<%= categoryId %>"
                            <%= isSelected ? "selected" : "" %>>
                            <%= categoryName %>
                        </option>

                    <%
                            }
                        } catch (Exception e) {
                    %>

                        <option value="" disabled>
                            Categories could not be loaded
                        </option>

                    <%
                        }
                    %>
                </select>

                <button type="submit" class="search-button">
                    Search
                </button>

                <a class="clear-button"
                   href="<%= request.getContextPath() %>/books">
                    Clear
                </a>

            </form>
        </div>

        <!-- Book Inventory -->
        <div class="table-container">

            <h3>Book Inventory</h3>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Book Title</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Call Number</th>
                        <th>Total Copies</th>
                        <th>Available Copies</th>
                        <th>Book Type</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                <% if (books != null && !books.isEmpty()) { %>

                    <% for (Map<String, Object> book : books) { %>

                        <tr>
                            <td><%= book.get("id") %></td>

                            <td><%= book.get("title") %></td>

                            <td><%= book.get("author") %></td>

                            <td>
                                <%= book.get("category") == null
                                    ? "-"
                                    : book.get("category") %>
                            </td>

                            <td>
                                <%= book.get("location") == null
                                    ? "-"
                                    : book.get("location") %>
                            </td>

                            <td>
                                <%= book.get("callNumber") == null
                                    ? "-"
                                    : book.get("callNumber") %>
                            </td>

                            <td><%= book.get("totalCopies") %></td>

                            <td>
                                <% int availableCopies =
                                    ((Number) book.get("availableCopies")).intValue(); %>

                                <% if (availableCopies > 0) { %>
                                    <span class="available">
                                        <%= availableCopies %>
                                    </span>
                                <% } else { %>
                                    <span class="unavailable">
                                        0 (Out of Stock)
                                    </span>
                                <% } %>
                            </td>

                            <td><%= book.get("bookType") %></td>

                            <td>
                                <a class="edit-button"
                                   href="<%= request.getContextPath() %>/editBook?id=<%= book.get("id") %>">
                                    Edit
                                </a>
                            </td>
                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="10" class="empty-message">
                            No books found. Try a different search.
                        </td>
                    </tr>

                <% } %>

                </tbody>
            </table>

        </div>

    </div>

</body>
</html>