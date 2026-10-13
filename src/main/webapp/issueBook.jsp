<%@ page import="java.sql.*" %>
<%@ page import="com.library.db.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issue Book</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            color: #333;
        }

        .header {
            background: #243447;
            color: white;
            padding: 20px 30px;
            font-size: 24px;
        }

        .container {
            width: 500px;
            max-width: calc(100% - 40px);
            margin: 35px auto;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px #ddd;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            box-sizing: border-box;
            padding: 11px;
            margin-top: 7px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 22px;
            border: none;
            border-radius: 5px;
            background: #2471a3;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1a5276;
        }

        a {
            display: inline-block;
            margin-top: 18px;
            color: #2471a3;
        }
    </style>
</head>

<body>

<div class="header">Issue Book</div>

<div class="container">
    <div class="card">

        <h2>Issue Book to Student</h2>

        <form action="<%= request.getContextPath() %>/issueBook"
              method="post">

            <label>Select Book</label>

            <select name="bookId" required>
                <option value="">-- Select Book --</option>

                <%
                    String sql = "SELECT id, title, available_copies "
                               + "FROM books "
                               + "WHERE available_copies > 0 "
                               + "ORDER BY title";

                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement ps = con.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {

                        while (rs.next()) {
                %>

                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("title") %>
                        (Available:
                        <%= rs.getInt("available_copies") %>)
                    </option>

                <%
                        }
                    } catch (Exception e) {
                        application.log("Books load karne mein error", e);
                %>

                    <option value="" disabled>
                        Books load nahi ho paayin
                    </option>

                <%
                    }
                %>

            </select>

            <label>Student Name</label>
            <input type="text"
                   name="studentName"
                   maxlength="150"
                   required>

            <label>Student ID</label>
            <input type="text"
                   name="studentId"
                   maxlength="50"
                   required>

            <label>Issue Date</label>
            <input type="date"
                   name="issueDate"
                   required>

            <label>Due Date</label>
            <input type="date"
                   name="dueDate"
                   required>

            <button type="submit">Issue Book</button>

        </form>

        <a href="<%= request.getContextPath() %>/circulation">
            Back to Circulation
        </a>

    </div>
</div>

</body>
</html>