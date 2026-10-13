<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Map<String, Object>> circulationList =
        (List<Map<String, Object>>) request.getAttribute("circulationList");

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Circulation - BookStockManagement</title>

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

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .topbar h1 {
            margin: 0;
            color: #243447;
        }

        .add-button {
            background: #3498db;
            color: white;
            padding: 11px 16px;
            border-radius: 5px;
            text-decoration: none;
        }

        .message {
            padding: 13px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .success {
            background: #d4edda;
            color: #155724;
        }

        .table-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        th, td {
            padding: 13px 10px;
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

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .issued {
            background: #fff3cd;
            color: #856404;
        }

        .returned {
            background: #d4edda;
            color: #155724;
        }

        .return-button {
            background: #28a745;
            color: white;
            border: none;
            padding: 9px 12px;
            border-radius: 4px;
            cursor: pointer;
        }

        .return-button:hover {
            background: #218838;
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

            .topbar {
                align-items: flex-start;
                gap: 15px;
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

        <a href="<%= request.getContextPath() %>/books">
            Book Stock
        </a>

        <a href="<%= request.getContextPath() %>/addBook.jsp">
            Add Book
        </a>

        <a href="<%= request.getContextPath() %>/categories.jsp">
            Categories
        </a>

        <a href="<%= request.getContextPath() %>/circulation"
           class="active">
            Circulation
        </a>
    </div>

    <!-- Main Content -->
    <div class="main">

        <div class="topbar">
            <h1>Book Circulation</h1>

            <a class="add-button"
               href="<%= request.getContextPath() %>/issueBook.jsp">
                + Issue New Book
            </a>
        </div>

        <% if ("issued".equals(message)) { %>
            <div class="message success">
                Book issued successfully!
            </div>
        <% } %>

        <% if ("returned".equals(message)) { %>
            <div class="message success">
                Book returned successfully! Available stock has been updated.
            </div>
        <% } %>

        <div class="table-container">

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Book Title</th>
                        <th>Student Name</th>
                        <th>Student ID</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                <% if (circulationList != null && !circulationList.isEmpty()) { %>

                    <% for (Map<String, Object> item : circulationList) {
                        String status = String.valueOf(item.get("status"));
                    %>

                    <tr>
                        <td><%= item.get("id") %></td>

                        <td><%= item.get("title") %></td>

                        <td><%= item.get("studentName") %></td>

                        <td><%= item.get("studentId") %></td>

                        <td><%= item.get("issueDate") %></td>

                        <td><%= item.get("dueDate") %></td>

                        <td>
                            <%= item.get("returnDate") == null
                                ? "-"
                                : item.get("returnDate") %>
                        </td>

                        <td>
                            <% if ("Issued".equalsIgnoreCase(status)) { %>
                                <span class="status issued">Issued</span>
                            <% } else { %>
                                <span class="status returned">Returned</span>
                            <% } %>
                        </td>

                        <td>
                            <% if ("Issued".equalsIgnoreCase(status)) { %>

                                <form
                                    action="<%= request.getContextPath() %>/returnBook"
                                    method="post"
                                    onsubmit="return confirm('Are you sure you want to return this book?');">

                                    <input type="hidden"
                                           name="circulationId"
                                           value="<%= item.get("id") %>">

                                    <button type="submit" class="return-button">
                                        Return Book
                                    </button>
                                </form>

                            <% } else { %>

                                Already Returned

                            <% } %>
                        </td>
                    </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="9" class="empty-message">
                            No circulation records found.
                        </td>
                    </tr>

                <% } %>

                </tbody>
            </table>

        </div>

    </div>

</body>
</html>