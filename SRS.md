# SOFTWARE REQUIREMENTS SPECIFICATION
# Book Stock Management System

**Version:** 1.0  
**Prepared Date:** 13 October 2026

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification (SRS) describes the requirements of the Book Stock Management System. It is a Java-based web application designed to manage book records, categories, stock information, and book issue/return records.

### 1.2 Scope
The system provides a web interface for managing book inventory. Its scope includes viewing dashboard information, managing books and categories, searching for books, checking stock, and recording circulation transactions where supported by the implementation.

### 1.3 Intended Audience
- Project developers
- Project guide and evaluators
- Software testers
- Future maintainers

### 1.4 Definitions and Acronyms
- **SRS:** Software Requirements Specification
- **JSP:** JavaServer Pages
- **JDBC:** Java Database Connectivity
- **DBMS:** Database Management System
- **UI:** User Interface

---

## 2. Overall Description

### 2.1 Product Perspective
The application is a browser-based Java web application. JSP pages display the user interface, Java Servlets process requests, JDBC connects to MySQL, and the database stores application records.

### 2.2 Product Functions
The system is intended to support:
- Displaying dashboard information
- Adding and viewing books
- Updating book records
- Searching for books
- Managing book categories
- Viewing stock quantities
- Recording book issue and return transactions where implemented
- Storing and retrieving records from MySQL

### 2.3 User Classes
The system assumes an operator who uses the book-management functions. Separate administrator, librarian, or member roles are not assumed unless implemented in the application.

### 2.4 Operating Environment
- **IDE:** Eclipse IDE
- **Programming Language:** Java
- **Web Technologies:** JSP and Servlets
- **Server:** Apache Tomcat 10.1
- **Database:** MySQL
- **Connectivity:** JDBC and MySQL Connector/J
- **Client:** Modern web browser

### 2.5 Constraints and Assumptions
- MySQL must be available for database operations.
- Java and Tomcat versions must be compatible.
- The database schema must match the application's SQL queries.
- Database credentials must be configured securely.
- Requirements must be verified against the actual implementation.

---

## 3. Functional Requirements

### FR-01: Dashboard
The system shall display the dashboard and the summary information supported by the application.

### FR-02: View Books
The system shall retrieve and display book records from the database.

### FR-03: Add Book
The system shall allow an operator to enter book details and save valid records.

### FR-04: Update Book
The system shall allow existing book information to be updated.

### FR-05: Search Books
The system shall support searching for books using the criteria provided by the interface.

### FR-06: Manage Categories
The system shall retrieve and maintain category information according to the implemented operations.

### FR-07: Associate Categories
The system shall associate books with categories where supported by the database schema.

### FR-08: View Stock
The system shall display available book stock information stored in the database.

### FR-09: Issue Book
Where implemented, the system shall record book issue transactions and apply the configured stock rules.

### FR-10: Return Book
Where implemented, the system shall record book return transactions and apply the configured stock rules.

### FR-11: Data Storage
The system shall store and retrieve supported records using MySQL.

### FR-12: Input Validation
The system should validate required fields and handle invalid input safely.

### FR-13: Error Handling
The system should handle application and database errors without exposing sensitive configuration.

---

## 4. External Interface Requirements

### 4.1 User Interface
The interface uses JSP and HTML pages with associated CSS. Forms should have clear labels, tables should display records clearly, and navigation should provide access to implemented features.

### 4.2 Software Interfaces
- Java Servlets process application requests.
- JSP pages display application views.
- JDBC connects Java components to MySQL.
- MySQL Connector/J provides the JDBC driver.
- Apache Tomcat hosts the web application.

### 4.3 Communication Interfaces
The browser communicates with the Tomcat server through HTTP or HTTPS, depending on the configuration. The application communicates with MySQL through the configured database connection.

---

## 5. Non-Functional Requirements

### NFR-01: Usability
The interface should be easy to understand for users familiar with basic web forms and tables.

### NFR-02: Performance
Common operations should complete within a reasonable time under the expected project workload.

### NFR-03: Reliability
The application should handle failed database operations appropriately.

### NFR-04: Data Integrity
Book, category, and circulation information should remain consistent with the database schema and business rules.

### NFR-05: Maintainability
The application should use an organized structure that makes its components easier to maintain.

### NFR-06: Security
Database credentials must not be exposed in public source code. SQL queries using user input should use parameterized statements where applicable.

### NFR-07: Compatibility
The application should work with compatible Java, Tomcat, Jakarta Servlet, and MySQL Connector/J versions.

---

## 6. Data Requirements

The database name is `book_stock_db`.

The principal tables are:

### 6.1 Categories
Stores information used to organize books into categories.

### 6.2 Books
Stores book details and stock quantities.

### 6.3 Circulation
Stores book issue and return information where supported by the implementation.

**Note:** Exact columns, data types, keys, and relationships must be verified against the actual database schema.

### 6.4 Data Validation
- Required fields should not be empty.
- Referenced records should exist where relationships are defined.
- Stock quantities should not be negative.
- Issue and return operations should follow the application's implemented rules.

---

## 7. High-Level System Architecture

The system consists of the following layers:

1. **Presentation Layer:** JSP, HTML, and CSS
2. **Request Processing Layer:** Java Servlets in `com.library.servlet`
3. **Database Connectivity Layer:** JDBC and database connection components in `com.library.db`
4. **Persistence Layer:** MySQL database `book_stock_db`

### System Flow

**Browser → JSP Pages → Java Servlets → JDBC / DBConnection → MySQL**

---

## 8. Acceptance Criteria

The project will be considered acceptable when:

- The application deploys successfully on the configured Tomcat server.
- The application connects to the configured MySQL database.
- Implemented book operations work correctly.
- Category information is displayed and managed correctly.
- Search results and stock information match the database.
- Issue and return operations pass their defined tests, if implemented.
- Invalid input and database errors are handled appropriately.
- No database password or other secret is exposed in the public repository.

---

## 9. Testing Requirements

Testing should cover database connectivity, book management, category management, searching, stock information, input validation, and error handling.

| Test Area | Expected Result | Actual Result |
|---|---|---|
| Database Connection | Connection succeeds with valid configuration | To be tested |
| Book Management | Valid book operations work correctly | To be tested |
| Category Management | Category information is handled correctly | To be tested |
| Search and Stock | Results match stored data | To be tested |
| Issue and Return | Transactions follow implemented rules | To be tested |
| Error Handling | Invalid operations are handled safely | To be tested |

---

## 10. Limitations and Future Enhancements

Potential future enhancements include:

- User authentication
- Role-based access control
- Member management
- Due-date tracking
- Overdue fine calculation
- Low-stock alerts
- Report generation and export
- Dashboard analytics
- Automated testing

These are proposed enhancements and are not claims about the current implementation.

---

## 11. Project Information

**Project Name:** Book Stock Management System

**Technology Stack:** Java, JSP, Servlets, JDBC, MySQL, Apache Tomcat 10.1, Eclipse IDE

**Database Name:** `book_stock_db`

**GitHub Repository:** [BookStockManagement2](https://github.com/khushalvaishnav020140-cmd/BookStockManagement2)

**Prepared By:** Add your name

**Project Guide:** Add guide name, if applicable

**Document Status:** Draft — verify the requirements against the actual source code and database schema before final submission.
