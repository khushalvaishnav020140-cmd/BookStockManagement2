<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"
    import="com.library.db.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AutoLibSys - Add New Book</title>

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
}

.sidebar a:hover,
.sidebar a.active {
    background: #285792;
}

.main {
    margin-left: 240px;
    padding: 30px;
}

h1 {
    color: #18385e;
    font-size: 28px;
}

.subtitle {
    color: #718096;
    margin-top: 8px;
    margin-bottom: 28px;
}

.form-card {
    background: white;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.05);
    max-width: 950px;
}

.form-card h2 {
    color: #18385e;
    margin-bottom: 25px;
    font-size: 21px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 22px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    margin-bottom: 9px;
    font-weight: bold;
    font-size: 14px;
    color: #35516f;
}

.form-group input,
.form-group select {
    width: 100%;
    padding: 12px;
    border: 1px solid #d5deea;
    border-radius: 7px;
    outline: none;
    background: white;
    font-size: 14px;
}

.form-group input:focus,
.form-group select:focus {
    border-color: #2169b5;
    box-shadow: 0 0 0 2px rgba(33,105,181,0.1);
}

.required {
    color: #dc3545;
}

.actions {
    display: flex;
    gap: 12px;
    margin-top: 28px;
}

.button {
    display: inline-block;
    border: none;
    border-radius: 7px;
    padding: 12px 20px;
    font-size: 14px;
    text-decoration: none;
    cursor: pointer;
}

.submit-button {
    background: #2169b5;
    color: white;
}

.submit-button:hover {
    background: #174e8a;
}

.cancel-button {
    background: #e8edf4;
    color: #35516f;
}

.message {
    margin-bottom: 20px;
    padding: 12px;
    border-radius: 7px;
    background: #fff0dc;
    color: #a86409;
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
    }

    .logo {
        margin-bottom: 15px;
    }

    .main {
        margin-left: 0;
        padding: 18px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .form-card {
        padding: 20px;
    }
}
</style>
</head>

<body>

<div class="sidebar">
    <div class="logo">Auto<span>LibSys</span></div>

    <a href="${pageContext.request.contextPath}/dashboard">
        Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/books">
        Book Stock
    </a>

    <a href="${pageContext.request.contextPath}/addBook.jsp"
       class="active">
        Add New Book
    </a>

    <a href="${pageContext.request.contextPath}/categories.jsp">
        Categories
    </a>

    <a href="${pageContext.request.contextPath}/circulation.jsp">
        Circulation
    </a>
</div>

<div class="main">

    <h1>Add New Book</h1>

    <p class="subtitle">
        Enter book details to add a new book to the library stock.
    </p>

    <div class="form-card">

        <h2>Book Information</h2>

        <%
            String errorMessage = request.getParameter("error");

            if ("invalid".equals(errorMessage)) {
        %>
            <div class="message">
                Please enter valid book information and try again.
            </div>
        <%
            } else if ("category".equals(errorMessage)) {
        %>
            <div class="message">
                Please select a valid category.
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/addBook"
              method="post">

            <div class="form-grid">

                <div class="form-group">
                    <label for="title">
                        Book Title <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="title"
                           name="title"
                           maxlength="200"
                           required
                           placeholder="Enter book title">
                </div>

                <div class="form-group">
                    <label for="author">
                        Author Name <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="author"
                           name="author"
                           maxlength="150"
                           required
                           placeholder="Enter author name">
                </div>

                <div class="form-group">
                    <label for="categoryId">
                        Category <span class="required">*</span>
                    </label>

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
                        %>

                            <option value="<%= rs.getInt("id") %>">
                                <%= rs.getString("category_name") %>
                            </option>

                        <%
                                }
                            } catch (Exception e) {
                        %>

                            <option value="" disabled>
                                Unable to load categories
                            </option>

                        <%
                                application.log(
                                    "Could not load book categories", e);
                            }
                        %>

                    </select>
                </div>

                <div class="form-group">
                    <label for="location">Rack / Shelf Location</label>

                    <input type="text"
                           id="location"
                           name="location"
                           maxlength="100"
                           placeholder="Example: Rack A2">
                </div>

                <div class="form-group">
                    <label for="callNumber">Call Number</label>

                    <input type="text"
                           id="callNumber"
                           name="callNumber"
                           maxlength="50"
                           placeholder="Example: JAVA002">
                </div>

                <div class="form-group">
                    <label for="totalCopies">
                        Total Copies <span class="required">*</span>
                    </label>

                    <input type="number"
                           id="totalCopies"
                           name="totalCopies"
                           min="1"
                           value="1"
                           required>
                </div>

                <div class="form-group">
                    <label for="bookType">
                        Book Type <span class="required">*</span>
                    </label>

                    <select id="bookType" name="bookType" required>
                        <option value="Lending">Lending</option>
                        <option value="Reference">Reference</option>
                        <option value="Online">Online</option>
                    </select>
                </div>

            </div>

            <div class="actions">
                <button type="submit" class="button submit-button">
                    Save Book
                </button>

                <a href="${pageContext.request.contextPath}/books"
                   class="button cancel-button">
                    Cancel
                </a>
            </div>

        </form>

    </div>

    <div class="footer">
        AutoLibSys &copy; 2026 | Library Book Stock Management System
    </div>

</div>

</body>
</html>