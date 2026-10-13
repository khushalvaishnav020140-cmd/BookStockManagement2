# Book Stock Management System

## Week 1

## Project Administration

**Project Title:** Book Stock Management System
**Project Domain:** Library Management
**Technologies:** Java, JSP, Servlets, MySQL, JDBC, Apache Tomcat
**Development Environment:** Eclipse IDE

## Abstract

The Book Stock Management System is a web-based application designed to simplify the management of books in a library. It helps users maintain book records, manage available stock, search for books, and track book issue and return activities.

The application uses Java, JSP, and Servlets for its web functionality and MySQL for storing book and circulation records. JDBC connects the application to the database. The system aims to improve the accuracy of book records and make routine library operations easier.

---

## Week 2

## Project Objectives

* Maintain book records in a centralized database.
* Add and edit book information.
* Search for books efficiently.
* Manage book stock and availability.
* Record book issue and return activities.
* Display relevant information on the dashboard.

## Functional Requirements

1. The system should allow book records to be added and updated.
2. The system should support book searches.
3. The system should maintain stock information.
4. The system should record book issue and return transactions.
5. The system should store information in a MySQL database.

## Technology Stack

* **Programming Language:** Java
* **Frontend:** JSP, HTML, CSS
* **Backend:** Java Servlets
* **Database:** MySQL
* **Database Connectivity:** JDBC
* **Server:** Apache Tomcat 10.1
* **IDE:** Eclipse

---

## Week 3

## System Architecture

The application follows a Java web application architecture:

1. **Presentation Layer:** JSP pages display the user interface.
2. **Servlet Layer:** Java Servlets process user requests.
3. **Database Connectivity Layer:** JDBC establishes connections to MySQL.
4. **Database Layer:** MySQL stores book, category, and circulation records.

### Application Flow

User → JSP Page → Servlet → JDBC → MySQL Database

---

## Week 4: Database Design

## Database Information

**Database Name:** `book_stock_db`

### Main Tables

* `categories` — stores book category information.
* `books` — stores book details and stock information.
* `circulation` — records book issue and return activities.

### Database Objectives

* Maintain organized book records.
* Track available book stock.
* Store circulation information.
* Support book searching and management operations.

*Note: Confirm the exact columns and relationships against your actual MySQL schema before adding a database diagram.*

---

## Week 5: Implementation and Project Structure

## Main Features

* Dashboard
* Add books
* Edit book information
* Search books
* Manage book stock
* Issue books
* Return books
* MySQL database integration

## Project Structure

The project is developed in Eclipse as a Java web application.

* `src/` — Java source code and web application files.
* `com.library.db` — database connectivity code.
* `com.library.servlet` — servlet classes.
* `src/main/webapp/` — JSP pages and web resources, if present in the project.
* `.project` — Eclipse project configuration.
* `.classpath` — Eclipse classpath configuration.

*The exact directory layout may vary according to the project's current structure.*

---

## Week 6: Testing and Documentation

## Testing

The following areas should be tested:

* Database connectivity
* Adding and editing books
* Searching for books
* Updating stock information
* Issuing and returning books
* Dashboard functionality

## Project Repository

The source code and documentation are maintained in this GitHub repository.

## Future Enhancements

* User login and role-based access
* Reports for issued and returned books
* Improved validation and error handling
* Fine calculation for overdue books
* Enhanced dashboard and reporting

## Conclusion

The Book Stock Management System provides a structured way to manage library book records, stock availability, and circulation activities using Java web technologies and MySQL.
