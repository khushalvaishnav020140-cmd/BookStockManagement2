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
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String searchError = (String) request.getAttribute("searchError");
    String updated = request.getParameter("updated");

    if (search == null) search = "";
    if (selectedCategory == null) selectedCategory = "";

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Book Stock Management | AutoLibSys</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f7fb;
            color: #263445;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            min-height: 100vh;
            background: #153b70;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            padding: 28px 18px;
        }

        .logo {
            text-align: center;
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 40px;
            color: white;
        }

        .logo span {
            color: #71c6ff;
        }

        .sidebar a {
            display: block;
            padding: 14px 15px;
            color: #e5edfa;
            text-decoration: none;
            border-radius: 7px;
            margin-bottom: 8px;
            font-size: 15px;
            transition: background 0.2s ease;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #285792;
        }

        /* Main Content */
        .main {
            margin-left: 240px;
            padding: 30px;
            min-width: 0;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .page-header h1 {
            color: #18385e;
            font-size: 28px;
            margin-bottom: 7px;
        }

        .subtitle {
            color: #718096;
            font-size: 14px;
            line-height: 1.5;
        }

        /* Add Button */
        .add-button {
            display: inline-block;
            background: #285792;
            color: white;
            padding: 11px 17px;
            text-decoration: none;
            border-radius: 7px;
            font-size: 14px;
            font-weight: bold;
            white-space: nowrap;
        }

        .add-button:hover,
        .search-button:hover,
        .edit-button:hover {
            background: #1d456f;
        }

        /* Cards */
        .search-panel,
        .table-container {
            background: white;
            padding: 22px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
        }

        .section-heading {
            color: #18385e;
            font-size: 18px;
            margin-bottom: 17px;
        }

        /* Search Form */
        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
        }

        .search-form input,
        .search-form select {
            flex: 1 1 210px;
            min-width: 0;
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #d5deea;
            border-radius: 7px;
            background: white;
            color: #263445;
            font-size: 14px;
            outline: none;
        }

        .search-form input:focus,
        .search-form select:focus {
            border-color: #5288c5;
            box-shadow: 0 0 0 3px rgba(82, 136, 197, 0.13);
        }

        .search-button,
        .clear-button,
        .edit-button {
            display: inline-block;
            border: none;
            border-radius: 7px;
            padding: 11px 17px;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            white-space: nowrap;
        }

        .search-button {
            background: #285792;
            color: white;
        }

        .clear-button {
            background: #e9eef5;
            color: #35516f;
        }

        .clear-button:hover {
            background: #dce5f0;
        }

        /* Messages */
        .success-message,
        .error-message {
            padding: 13px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success-message {
            background: #e4f6ea;
            color: #216e3a;
            border: 1px solid #c7ead2;
        }

        .error-message {
            background: #fff0f0;
            color: #a12b35;
            border: 1px solid #f2cdcf;
        }

        /* Inventory Table */
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
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid #edf0f5;
            vertical-align: middle;
            font-size: 13px;
        }

        th {
            background: #eef4fb;
            color: #35516f;
            font-weight: bold;
            white-space: nowrap;
        }

        td {
            color: #526174;
        }

        tbody tr:hover {
            background: #f8fafd;
        }

        /* Stock Status */
        .available,
        .unavailable {
            display: inline-block;
            padding: 5px 8px;
            border-radius: 6px;
            font-weight: bold;
            white-space: nowrap;
        }

        .available {
            color: #237846;
            background: #e6f6eb;
        }

        .unavailable {
            color: #b42332;
            background: #fff0f0;
        }

        /* Edit Button */
        .edit-button {
            background: #285792;
            color: white;
            padding: 8px 12px;
        }

        .empty-message {
            text-align: center;
            padding: 28px 15px;
            color: #718096;
            font-size: 14px;
        }

        /* Responsive Design */
        @media (max-width: 700px) {
            .sidebar {
                position: relative;
                width: 100%;
                min-height: auto;
                padding: 20px 15px;
            }

            .logo {
                margin-bottom: 18px;
            }

            .sidebar a {
                display: inline-block;
                margin: 3px;
                padding: 10px 12px;
            }

            .main {
                margin-left: 0;
                padding: 20px 15px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .search-panel,
            .table-container {
                padding: 16px;
            }

            .search-button,
            .clear-button {
                flex: 1 1 auto;
            }
        }
    </style>
</head>

<body>

    <!-- Sidebar -->
    <aside class="sidebar">

        <div class="logo">Auto<span>LibSys</span></div>

        <a href="<%= contextPath %>/dashboard">
            Dashboard
        </a>

        <a href="<%= contextPath %>/books" class="active">
            Book Stock
        </a>

        <a href="<%= contextPath %>/addBook.jsp">
            Add Book
        </a>

        <a href="<%= contextPath %>/categories">
            Categories
        </a>

        <a href="<%= contextPath %>/circulation">
            Circulation
        </a>

    </aside>

    <!-- Main Content -->
    <main class="main">

        <header class="page-header">

            <div>
                <h1>Book Stock Management</h1>
                <p class="subtitle">
                    View, search, and manage your library inventory.
                </p>
            </div>

            <a class="add-button"
               href="<%= contextPath %>/addBook.jsp">
                + Add New Book
            </a>

        </header>

        <!-- Success Message -->
        <% if ("success".equals(updated)) { %>

            <div class="success-message" role="status">
                Book details updated successfully!
            </div>

        <% } %>

        <!-- Error Message -->
        <% if (searchError != null) { %>

            <div class="error-message" role="alert">
                <%= searchError %>
            </div>

        <% } %>

        <!-- Search Section -->
        <section class="search-panel">

            <h2 class="section-heading">Search Books</h2>

            <form class="search-form"
                  action="<%= contextPath %>/books"
                  method="get">

                <input
                    type="text"
                    name="search"
                    placeholder="Enter book title or author..."
                    value="<%= search %>"
                    aria-label="Search by book title or author">

                <select name="category" aria-label="Filter by category">

                    <option value="">All Categories</option>

                    <%
                        try (
                            Connection con = DBConnection.getConnection();
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT id, category_name FROM categories ORDER BY category_name"
                            );
                            ResultSet rs = ps.executeQuery()
                        ) {
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

                            application.log(
                                "Unable to load book categories", e
                            );
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
                   href="<%= contextPath %>/books">
                    Clear
                </a>

            </form>

        </section>

        <!-- Book Inventory -->
        <section class="table-container">

            <h2 class="section-heading">Book Inventory</h2>

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

                                <%
                                    Object availableValue =
                                        book.get("availableCopies");

                                    int availableCopies =
                                        availableValue instanceof Number
                                        ? ((Number) availableValue).intValue()
                                        : 0;
                                %>

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
                                   href="<%= contextPath %>/editBook?id=<%= book.get("id") %>">
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

        </section>

    </main>

</body>
</html>
