<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.library.db.DBConnection" %>

<%
    Object bookId = request.getAttribute("bookId");
    Object title = request.getAttribute("title");
    Object author = request.getAttribute("author");
    Object categoryId = request.getAttribute("categoryId");
    Object location = request.getAttribute("location");
    Object callNumber = request.getAttribute("callNumber");
    Object totalCopies = request.getAttribute("totalCopies");
    Object availableCopies = request.getAttribute("availableCopies");
    Object bookType = request.getAttribute("bookType");

    if (bookId == null) {
        response.sendRedirect(request.getContextPath() + "/books");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Book - Library Management</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            max-width: 750px;
            margin: 35px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #243447;
            margin-top: 0;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            color: #333;
        }

        input,
        select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        button {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            background: #3498db;
            color: white;
            cursor: pointer;
            font-size: 15px;
        }

        button:hover {
            background: #217dbb;
        }

        .cancel-button {
            display: inline-block;
            padding: 12px 20px;
            border-radius: 5px;
            background: #6c757d;
            color: white;
            text-decoration: none;
        }

        .info {
            padding: 12px;
            background: #e8f4fd;
            color: #245269;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Edit Book</h1>

    <div class="info">
        Update the book details below and click Save Changes.
        The available copies will be adjusted to account for books
        that are currently issued.
    </div>

    <form action="<%= request.getContextPath() %>/editBook"
          method="post">

        <input type="hidden"
               name="id"
               value="<%= bookId %>">

        <div class="form-group">
            <label for="title">Book Title *</label>
            <input type="text"
                   id="title"
                   name="title"
                   maxlength="200"
                   value="<%= title == null ? "" : title %>"
                   required>
        </div>

        <div class="form-group">
            <label for="author">Author *</label>
            <input type="text"
                   id="author"
                   name="author"
                   maxlength="150"
                   value="<%= author == null ? "" : author %>"
                   required>
        </div>

        <div class="form-group">
            <label for="categoryId">Category *</label>

            <select id="categoryId"
                    name="categoryId"
                    required>

                <option value="">Select Category</option>

                <%
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement ps = con.prepareStatement(
                             "SELECT id, category_name FROM categories ORDER BY category_name");
                         ResultSet rs = ps.executeQuery()) {

                        while (rs.next()) {
                            String currentCategory =
                                String.valueOf(rs.getInt("id"));

                            boolean selected =
                                categoryId != null &&
                                currentCategory.equals(String.valueOf(categoryId));
                %>

                    <option value="<%= currentCategory %>"
                        <%= selected ? "selected" : "" %>>
                        <%= rs.getString("category_name") %>
                    </option>

                <%
                        }
                    } catch (Exception e) {
                %>

                    <option value="" disabled>
                        Could not load categories
                    </option>

                <%
                    }
                %>

            </select>
        </div>

        <div class="form-group">
            <label for="location">Rack / Location</label>
            <input type="text"
                   id="location"
                   name="location"
                   maxlength="100"
                   value="<%= location == null ? "" : location %>">
        </div>

        <div class="form-group">
            <label for="callNumber">Call Number</label>
            <input type="text"
                   id="callNumber"
                   name="callNumber"
                   maxlength="50"
                   value="<%= callNumber == null ? "" : callNumber %>">
        </div>

        <div class="form-group">
            <label for="totalCopies">Total Copies *</label>
            <input type="number"
                   id="totalCopies"
                   name="totalCopies"
                   min="1"
                   value="<%= totalCopies == null ? 1 : totalCopies %>"
                   required>
        </div>

        <div class="form-group">
            <label for="bookType">Book Type *</label>

            <select id="bookType" name="bookType" required>

                <option value="Lending"
                    <%= "Lending".equals(String.valueOf(bookType))
                        ? "selected" : "" %>>
                    Lending
                </option>

                <option value="Reference"
                    <%= "Reference".equals(String.valueOf(bookType))
                        ? "selected" : "" %>>
                    Reference
                </option>

                <option value="Online"
                    <%= "Online".equals(String.valueOf(bookType))
                        ? "selected" : "" %>>
                    Online
                </option>

            </select>
        </div>

        <div class="button-group">
            <button type="submit">Save Changes</button>

            <a class="cancel-button"
               href="<%= request.getContextPath() %>/books">
                Cancel
            </a>
        </div>

    </form>

</div>

</body>
</html>