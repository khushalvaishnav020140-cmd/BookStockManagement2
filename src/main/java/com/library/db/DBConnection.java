package com.library.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {

        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        // Local computer par testing ke liye
        if (host == null || host.isBlank()) {
            host = "localhost";
            port = "3306";
            database = "book_stock_db";
            user = "root";
            password = "juned";
        }

        if (port == null || port.isBlank()) {
            port = "3306";
        }

        if (database == null || database.isBlank()
                || user == null || user.isBlank()
                || password == null || password.isBlank()) {
            throw new SQLException(
                "Database environment variables missing hain."
            );
        }

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?serverTimezone=UTC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver nahi mila.", e);
        }

        return DriverManager.getConnection(url, user, password);
    }
}
