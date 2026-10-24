package com.library.db;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Creates the database tables on startup if they do not exist yet,
 * so a fresh database (e.g. a new Railway MySQL) works out of the box.
 */
@WebListener
public class SchemaInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS categories ("
              + "id INT AUTO_INCREMENT PRIMARY KEY, "
              + "category_name VARCHAR(100) NOT NULL UNIQUE)");

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS books ("
              + "id INT AUTO_INCREMENT PRIMARY KEY, "
              + "title VARCHAR(255) NOT NULL, "
              + "author VARCHAR(255) NOT NULL, "
              + "category_id INT NULL, "
              + "location VARCHAR(100) NOT NULL DEFAULT '', "
              + "call_number VARCHAR(100) NOT NULL DEFAULT '', "
              + "total_copies INT NOT NULL DEFAULT 1, "
              + "available_copies INT NOT NULL DEFAULT 1, "
              + "book_type VARCHAR(20) NOT NULL DEFAULT 'Lending', "
              + "CONSTRAINT fk_books_category FOREIGN KEY (category_id) "
              + "REFERENCES categories(id) ON DELETE SET NULL)");

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS circulation ("
              + "id INT AUTO_INCREMENT PRIMARY KEY, "
              + "book_id INT NOT NULL, "
              + "student_name VARCHAR(255) NOT NULL, "
              + "student_id VARCHAR(100) NOT NULL, "
              + "issue_date DATE NOT NULL, "
              + "due_date DATE NOT NULL, "
              + "return_date DATE NULL, "
              + "status VARCHAR(20) NOT NULL DEFAULT 'Issued', "
              + "CONSTRAINT fk_circ_book FOREIGN KEY (book_id) "
              + "REFERENCES books(id))");

            try (ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) FROM categories")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    st.executeUpdate(
                        "INSERT INTO categories (category_name) VALUES "
                      + "('Computer Science'), ('Science'), ('Mathematics'), "
                      + "('Literature'), ('History'), ('General')");
                }
            }
        } catch (SQLException e) {
            // Do not block app startup; pages will surface DB errors.
            e.printStackTrace();
        }
    }
}
