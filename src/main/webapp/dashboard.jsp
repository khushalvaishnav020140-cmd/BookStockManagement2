<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.List,java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AutoLibSys - Book Stock Dashboard</title>

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

.sidebar {
    width: 240px;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    background: #153b70;
    color: white;
    padding: 28px 18px;
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

.main {
    margin-left: 240px;
    padding: 30px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    gap: 15px;
}

.topbar h1 {
    font-size: 28px;
    color: #18385e;
}

.subtitle {
    margin-top: 8px;
    color: #718096;
    font-size: 14px;
}

.user {
    background: white;
    padding: 12px 18px;
    border-radius: 8px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.05);
}

.cards {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.card {
    background: white;
    padding: 23px;
    border-radius: 12px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.05);
    border-left: 5px solid #3984db;
}

.card:nth-child(2) {
    border-left-color: #8a63d2;
}

.card:nth-child(3) {
    border-left-color: #25a779;
}

.card:nth-child(4) {
    border-left-color: #f1a43c;
}

.card-title {
    color: #718096;
    font-size: 14px;
    margin-bottom: 15px;
}

.card-number {
    font-size: 32px;
    font-weight: bold;
    color: #18385e;
}

.section {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.05);
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 22px;
    gap: 15px;
}

.section-header h2 {
    color: #18385e;
    font-size: 21px;
}

.add-button {
    background: #2169b5;
    color: white;
    text-decoration: none;
    padding: 11px 16px;
    border-radius: 7px;
    font-size: 14px;
}

.add-button:hover {
    background: #174e8a;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 850px;
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
    font-size: 13px;
    color: #526174;
}

tbody tr:hover {
    background: #f8fbff;
}

.badge {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    background: #e5f7ee;
    color: #168454;
    font-size: 12px;
}

.reference {
    background: #fff0dc;
    color: #a86409;
}

.empty {
    text-align: center;
    padding: 30px;
    color: #718096;
}

.footer {
    margin-top: 25px;
    text-align: center;
    color: #8a96a6;
    font-size: 12px;
}

@media (max-width: 1100px) {
    .cards {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 700px) {
    .sidebar {
        width: 100%;
        height: auto;
        position: relative;
    }

    .logo {
        margin-bottom: 15px;
    }

    .main {
        margin-left: 0;
        padding: 18px;
    }

    .topbar {
        align-items: flex-start;
        flex-direction: column;
    }

    .cards {
        grid-template-columns: 1fr;
    }

    .section-header {
        align-items: flex-start;
        flex-direction: column;
    }
}
</style>
</head>

<body>

<%
    Object lendingObj = request.getAttribute("lendingBooks");
    Object referenceObj = request.getAttribute("referenceBooks");
    Object onlineObj = request.getAttribute("onlineBooks");
    Object totalObj = request.getAttribute("totalBooks");

    int lendingBooks = lendingObj != null
            ? ((Number) lendingObj).intValue() : 0;

    int referenceBooks = referenceObj != null
            ? ((Number) referenceObj).intValue() : 0;

    int onlineBooks = onlineObj != null
            ? ((Number) onlineObj).intValue() : 0;

    int totalBooks = totalObj != null
            ? ((Number) totalObj).intValue() : 0;

    List<Map<String, Object>> books =
            (List<Map<String, Object>>) request.getAttribute("books");
%>

<div class="sidebar">

    <div class="logo">Auto<span>LibSys</span></div>

    <a href="${pageContext.request.contextPath}/dashboard"
       class="active">Dashboard</a>

    <a href="${pageContext.request.contextPath}/books">Book Stock</a>

    <a href="${pageContext.request.contextPath}/addBook.jsp">Add New Book</a>

    <a href="${pageContext.request.contextPath}/categories.jsp">Categories</a>

    <a href="${pageContext.request.contextPath}/circulation.jsp">Circulation</a>

</div>

<div class="main">

    <div class="topbar">
        <div>
            <h1>Book Stock Dashboard</h1>
            <p class="subtitle">
                Welcome to AutoLibSys Library Management System
            </p>
        </div>

        <div class="user">Library Administrator</div>
    </div>

    <div class="cards">

        <div class="card">
            <div class="card-title">Lending Books</div>
            <div class="card-number"><%= lendingBooks %></div>
        </div>

        <div class="card">
            <div class="card-title">Reference Books</div>
            <div class="card-number"><%= referenceBooks %></div>
        </div>

        <div class="card">
            <div class="card-title">Online Books</div>
            <div class="card-number"><%= onlineBooks %></div>
        </div>

        <div class="card">
            <div class="card-title">Total Book Copies</div>
            <div class="card-number"><%= totalBooks %></div>
        </div>

    </div>

    <div class="section">

        <div class="section-header">
            <h2>Book Stock Details</h2>

            <a class="add-button"
               href="${pageContext.request.contextPath}/addBook.jsp">
                + Add New Book
            </a>
        </div>

        <div class="table-wrapper">

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
                        <th>Available</th>
                        <th>Book Type</th>
                    </tr>
                </thead>

                <tbody>

                <%
                    if (books != null && !books.isEmpty()) {
                        for (Map<String, Object> book : books) {
                %>

                    <tr>
                        <td><%= book.get("id") != null
                                ? book.get("id") : "" %></td>

                        <td><%= book.get("title") != null
                                ? book.get("title") : "" %></td>

                        <td><%= book.get("author") != null
                                ? book.get("author") : "" %></td>

                        <td><%= book.get("category") != null
                                ? book.get("category") : "" %></td>

                        <td><%= book.get("location") != null
                                ? book.get("location") : "" %></td>

                        <td><%= book.get("callNumber") != null
                                ? book.get("callNumber") : "" %></td>

                        <td><%= book.get("totalCopies") != null
                                ? book.get("totalCopies") : 0 %></td>

                        <td><%= book.get("availableCopies") != null
                                ? book.get("availableCopies") : 0 %></td>

                        <td>
                            <%
                                String bookType = String.valueOf(
                                    book.get("bookType") != null
                                    ? book.get("bookType") : "Lending"
                                );

                                if ("Reference".equalsIgnoreCase(bookType)) {
                            %>
                                <span class="badge reference">
                                    <%= bookType %>
                                </span>
                            <%
                                } else {
                            %>
                                <span class="badge">
                                    <%= bookType %>
                                </span>
                            <%
                                }
                            %>
                        </td>
                    </tr>

                <%
                        }
                    } else {
                %>

                    <tr>
                        <td colspan="9" class="empty">
                            No books found in database.
                        </td>
                    </tr>

                <%
                    }
                %>

                </tbody>
            </table>

        </div>
    </div>

    <div class="footer">
        AutoLibSys &copy; 2026 | Library Book Stock Management System
    </div>

</div>

</body>
</html>