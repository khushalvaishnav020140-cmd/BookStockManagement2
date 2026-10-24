<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Map<String, Object>> circulationList =
        (List<Map<String, Object>>) request.getAttribute("circulationList");

    String message = request.getParameter("message");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Book Circulation - AutoLibSys</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #526581;
        }

        /* Sidebar - Dashboard theme */
        .sidebar {
            width: 240px;
            height: 100vh;
            background: #183d70;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            padding: 25px 18px;
            overflow-y: auto;
        }

        .sidebar h2 {
            margin: 0 0 35px;
            padding-left: 5px;
            color: white;
            font-size: 25px;
            font-weight: bold;
        }

        .sidebar h2 span {
            color: #65c5ff;
        }

        .sidebar a {
            display: block;
            padding: 14px 15px;
            color: white;
            text-decoration: none;
            border-radius: 7px;
            margin-bottom: 8px;
            font-size: 15px;
            transition: background 0.2s;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #2b568e;
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
            margin-bottom: 28px;
        }

        .topbar h1 {
            margin: 0 0 8px;
            color: #18385e;
            font-size: 30px;
        }

        .subtitle {
            margin: 0;
            color: #7b8da8;
            font-size: 14px;
        }

        /* Buttons */
        .add-button {
            display: inline-block;
            background: #2874bd;
            color: white;
            padding: 12px 17px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 14px;
            white-space: nowrap;
            transition: background 0.2s;
        }

        .add-button:hover {
            background: #1e609f;
        }

        /* Success messages */
        .message {
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success {
            background: #dff5e8;
            color: #187447;
            border: 1px solid #c4ead4;
        }

        /* White table card */
        .table-container {
            background: white;
            padding: 24px;
            border-radius: 13px;
            box-shadow: 0 4px 14px rgba(25, 55, 90, 0.06);
            overflow-x: auto;
        }

        .table-container h2 {
            margin: 0 0 22px;
            color: #18385e;
            font-size: 21px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        th,
        td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid #e8edf4;
            font-size: 14px;
        }

        th {
            background: #edf3fb;
            color: #344d6d;
            font-weight: bold;
            white-space: nowrap;
        }

        tbody tr:hover {
            background: #f8faff;
        }

        /* Status badges */
        .status {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 18px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .issued {
            background: #fff0d9;
            color: #a96300;
        }

        .returned {
            background: #e0f6eb;
            color: #168054;
        }

        /* Return button */
        .return-button {
            background: #2874bd;
            color: white;
            border: none;
            padding: 9px 13px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            white-space: nowrap;
        }

        .return-button:hover {
            background: #1e609f;
        }

        .empty-message {
            text-align: center;
            padding: 28px;
            color: #7b8da8;
        }

        /* Responsive layout */
        @media (max-width: 900px) {
            .sidebar {
                width: 200px;
                padding: 20px 12px;
            }

            .main {
                margin-left: 200px;
                padding: 20px;
            }

            .topbar h1 {
                font-size: 25px;
            }
        }

        @media (max-width: 600px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 15px;
            }

            .sidebar h2 {
                margin-bottom: 15px;
            }

            .sidebar a {
                display: inline-block;
                margin: 3px;
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

            .table-container {
                padding: 15px;
            }
        }
    </style>
</head>

<body>

    <!-- Sidebar -->
    <div class="sidebar">

        <h2>Auto<span>LibSys</span></h2>

        <a href="<%= contextPath %>/dashboard">
            Dashboard
        </a>

        <a href="<%= contextPath %>/books">
            Book Stock
        </a>

        <a href="<%= contextPath %>/addBook.jsp">
            Add New Book
        </a>

        <a href="<%= contextPath %>/categories.jsp">
            Categories
        </a>

        <a href="<%= contextPath %>/circulation" class="active">
            Circulation
        </a>

    </div>

    <!-- Main Content -->
    <main class="main">

        <div class="topbar">
            <div>
                <h1>Book Circulation</h1>
                <p class="subtitle">
                    Manage issued and returned library books.
                </p>
            </div>

            <a class="add-button"
               href="<%= contextPath %>/issueBook.jsp">
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

            <h2>Circulation Records</h2>

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
                                    action="<%= contextPath %>/returnBook"
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

    </main>

</body>
</html>
