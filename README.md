# 📚 Book Stock Management System

A Java-based web application designed to manage books, categories, stock availability, and book issue/return records. The system uses Java Servlets, JSP, JDBC, and MySQL to simplify library book inventory management.

---

# Week 1: Project Administration and Planning

## 1. Project Title

**Book Stock Management System**

## 2. Project Guide

* **Project Guide:** [Er. Ram Babu Buri]
* **Project Type:** Java Web Application
* **Development Environment:** Eclipse IDE
### Team Members

| **Name** | **Enrollment** | **Email** | **Mobile** |
| -------- | -------------- | --------- | ---------- |
| Khushal Vaishnav | 24E1ARADM30P080| Khushalvaishnav020140@gmail.com | 81122 10487 |

## 3. Research Area and Specialization

The project focuses on developing a web-based system for maintaining book inventory and circulation records.

**Areas of specialization:**

* Java Web Development
* Database Management Systems
* MySQL Database Connectivity
* Java Servlets and JSP
* Software Engineering
* Inventory and Stock Management


## 4. Project Details

| Field                 | Details                      |
| --------------------- | ---------------------------- |
| Project Name          | Book Stock Management System |
| Programming Language  | Java                         |
| Frontend              | HTML, CSS, JSP               |
| Backend               | Java Servlets                |
| Database              | MySQL                        |
| Database Connectivity | JDBC                         |
| IDE                   | Eclipse IDE                  |
| Server                | Apache Tomcat 10.1           |
| JDBC Driver           | MySQL Connector/J            |

## 5. Abstract

The Book Stock Management System is a web-based application developed to simplify the process of managing books and maintaining library inventory records. Traditional book stock management may involve manual registers and spreadsheets, making it difficult to track available books, update quantities, and maintain issue/return records efficiently.

This project provides a centralized system for managing book details, categories, stock quantities, and circulation records. It allows users to add and update book information, search for books, monitor stock availability, and maintain book issue and return information.

The application is developed using Java, JSP, Servlets, JDBC, and MySQL. Apache Tomcat is used to run the web application, while MySQL stores the information persistently.

The main objective is to make book inventory management easier, more organized, and less dependent on manual record keeping.

## 6. Project Objectives

* To maintain book records in a centralized database.
* To organize books by category.
* To add, edit, and search book information.
* To track book stock and availability.
* To maintain book issue and return records.
* To reduce manual record-keeping errors.
* To provide a simple and user-friendly interface.

---

# Week 2: Requirements Analysis and System Architecture

## 1. User Roles

The system provides book and stock management functionality through its web interface.

The actual operations available depend on the implemented application. The main management operations include:

* Viewing the dashboard.
* Managing book information.
* Managing book categories.
* Checking book stock.
* Searching for books.
* Recording book issue and return transactions.

> Note: Add separate administrator or staff roles here only if authentication and role-based access are implemented in your application.

## 2. Software Requirements Specification (SRS)

[View SRS PDF](./SRS.pdf)

### Functional Requirements

**Book Management**

* Add new book records.
* View book details.
* Update existing book information.
* Search for books.

**Category Management**

* Maintain book categories.
* Associate books with their relevant categories.

**Stock Management**

* Maintain book quantities.
* View book stock information.
* Check book availability.

**Circulation Management**

* Record book issue transactions.
* Record book return transactions.
* Maintain circulation information.

**Dashboard**

* Provide an overview of book stock and related information according to the implemented dashboard features.

### Non-Functional Requirements

* **Usability:** The interface should be simple to understand and operate.
* **Reliability:** Book information should be stored consistently in the database.
* **Maintainability:** Java classes, Servlets, and JSP pages should be organized into appropriate packages and folders.
* **Performance:** Database queries should retrieve and update records efficiently.
* **Data Integrity:** Book, category, and circulation records should maintain valid relationships.
* **Security:** Database credentials should not be exposed in the public repository, and database operations should use appropriate input validation and parameterized queries.

## 3. System Architecture

The application follows a Java web application architecture.

```text
          User / Browser
                 |
                 v
          JSP Web Pages
                 |
                 v
          Java Servlets
                 |
                 v
          JDBC / DBConnection
                 |
                 v
          MySQL Database
```

### Architecture Components

**Presentation Layer**

* JSP pages
* HTML
* CSS
* Forms and tables

**Application Layer**

* Java Servlets
* Request handling
* Book management operations
* Stock and circulation operations

**Database Connectivity Layer**

* JDBC
* `DBConnection.java`
* MySQL Connector/J

**Database Layer**

* `book_stock_db`
* `books`
* `categories`
* `circulation`

## 4. Database Strategy

MySQL is used to store and manage the application data.

The database is named `book_stock_db` and contains tables for book categories, book information, and circulation records.

The database connection is handled by the Java database connection class located in the `com.library.db` package.

## 5. Technology Stack

| Technology         | Purpose                       |
| ------------------ | ----------------------------- |
| Java               | Application logic             |
| JSP                | Web page rendering            |
| Java Servlets      | HTTP request handling         |
| HTML               | Web page structure            |
| CSS                | User interface styling        |
| JDBC               | Java-to-database connectivity |
| MySQL              | Data storage                  |
| Apache Tomcat 10.1 | Web application server        |
| Eclipse IDE        | Development environment       |
| MySQL Connector/J  | MySQL JDBC driver             |

---

# Week 3: UML Design and System Modeling

## 1. Use Case Overview
## Project Screenshot

The main use cases of the Book Stock Management System are:

* View dashboard.
* View book records.
* Add a book.
* Edit book information.
* Search for a book.
* Manage book categories.
* View stock information.
* Issue a book.
* Return a book.

These use cases represent the principal operations supported by the application.

## 2. Main System Components

### Book Management

Responsible for storing and updating book information.

### Category Management

Organizes books into categories.

### Stock Management

Maintains information about book quantities and availability.

### Circulation Management

Maintains book issue and return records.

### Database Connectivity

Establishes a connection between the Java application and the MySQL database.

## 3. Database Relationship Overview

![](ERDiagram.png)




## 4. UML Diagram



![UML Class Diagram](UML.png)



## 5. System Architecture Diagram

![System Architecture Diagram](ManagementArchitecture.png)



---

# Week 4: Database Design and UI Mock-ups

## 1. Database Design

**Database Name:** `book_stock_db`

### Table 1: categories

This table stores the available book categories.

| Field           | Description               |
| --------------- | ------------------------- |
| `category_id`   | Identifier for a category |
| `category_name` | Name of the category      |

### Table 2: books

This table stores book information and stock details.

| Field         | Description                    |
| ------------- | ------------------------------ |
| `book_id`     | Unique identifier for a book   |
| `title`       | Book title                     |
| `category_id` | Associated category identifier |
| `quantity`    | Number of copies in stock      |

> The table above lists the conceptual fields. Add any other fields present in your actual database, such as author, ISBN, publisher, or price, only if your schema contains them.

### Table 3: circulation

This table maintains book issue and return information.

| Field            | Description                         |
| ---------------- | ----------------------------------- |
| `circulation_id` | Identifier for a circulation record |
| `book_id`        | Reference to the associated book    |
| Issue details    | Information about book issuance     |
| Return details   | Information about book return       |

> Update the fields above to match your actual `circulation` table.

## 2. Database Connectivity

The project uses JDBC to connect Java application components to MySQL.

The connection class is located in:

`src/main/java/com/library/db/DBConnection.java`

The application uses MySQL Connector/J as its JDBC driver.

Database connectivity is required for operations such as:

* Retrieving book records.
* Adding and updating book details.
* Retrieving category information.
* Maintaining circulation records.
* Updating and checking stock information.

## 3. User Interface Design

The web interface is designed to provide access to the main book stock management features.

### Dashboard

The dashboard provides an overview of the system.

![Dashboard Screenshot](dashboard.png)

### Book Management

The book management interface is used to view and manage book information.

![Book Management Screenshot](books.png)

### Category Management

The category section is used to organize books by category.

![Category Management Screenshot](categories.png)

### Stock Management

The stock section displays book quantities and related stock information.

![Stock Management Screenshot](bookstock.png)

### Issue and Return Management

The circulation section is used to maintain book issue and return records.

![Circulation Screenshot](circulation.png)

**Important:** Upload the actual screenshots before using these image paths. Remove any screenshot section for a page that your project does not contain.

---

# Week 5: Project Directory Structure

The project is developed in Eclipse as a Java web application.

A simplified view of the project structure is shown below.

```text
BookStockManagement/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── library/
│       │           ├── db/
│       │           │   └── DBConnection.java
│       │           │
│       │           └── servlet/
│       │               ├── Book-related Servlets
│       │               ├── Category-related Servlets
│       │               └── Circulation-related Servlets
│       │
│       └── webapp/
│           ├── WEB-INF/
│           │   └── lib/
│           │       └── mysql-connector-j.jar
│           │
│           ├── css/
│           ├── images/
│           ├── index.jsp
│           ├── dashboard.jsp
│           ├── books.jsp
│           └── other JSP pages
│
├── README.md
└── .gitignore
```

> This is an illustrative structure, not a verified file-by-file inventory. Adjust it to match your actual Eclipse project. Servlet class names, JSP names, and directories may differ.

## Package Description

### `com.library.db`

Contains the database connection class used to connect the application to MySQL.

### `com.library.servlet`

Contains Servlets responsible for handling application requests and performing book, category, stock, and circulation operations.

### `src/main/webapp`

Contains JSP pages, web resources, stylesheets, and other frontend files.

### `WEB-INF/lib`

Contains the MySQL JDBC driver JAR if it is packaged in this directory in your project.

---

# Week 6: Module Development and Implementation

## 1. Database Connection Module

**Purpose:** Connect the Java web application to the MySQL database.

**Main responsibilities:**

* Load the MySQL JDBC driver.
* Establish a database connection.
* Provide connections to application components.
* Handle database connection errors.

**Technology:** Java, JDBC, MySQL Connector/J.

## 2. Book Management Module

**Purpose:** Manage book information.

**Main responsibilities:**

* Add book records.
* Retrieve book information.
* Update book details.
* Search for books.

**Expected outcome:** Book information can be managed through the web interface and stored in MySQL.

## 3. Category Management Module

**Purpose:** Organize books into categories.

**Main responsibilities:**

* Retrieve category information.
* Associate books with categories.
* Maintain category-related information according to the implemented features.

## 4. Stock Management Module

**Purpose:** Maintain and display book stock information.

**Main responsibilities:**

* Retrieve stock information.
* Display book quantities.
* Support stock availability checks.
* Reflect relevant changes after book transactions.

## 5. Circulation Management Module

**Purpose:** Maintain book issue and return information.

**Main responsibilities:**

* Record book issue transactions.
* Maintain return information.
* Retrieve circulation records.
* Support accurate stock tracking according to the implemented transaction logic.

## 6. User Interface Module

**Purpose:** Provide a simple interface for accessing system functions.

**Main responsibilities:**

* Display dashboard information.
* Provide forms for book operations.
* Display book and category records.
* Provide search and stock views.
* Display circulation information.

---

# Week 7: Module Testing and Validation

## 1. Testing Objectives

The objective of testing is to verify that the application behaves correctly and that its modules interact properly with the database.

## 2. Book Management Testing

| Test Case            | Expected Result                        |
| -------------------- | -------------------------------------- |
| Add a valid book     | Book record is saved                   |
| View book records    | Existing records are displayed         |
| Update a book        | Updated information is saved           |
| Search for a book    | Matching records are displayed         |
| Submit invalid input | Invalid input is handled appropriately |

## 3. Category Testing

| Test Case                         | Expected Result                     |
| --------------------------------- | ----------------------------------- |
| View categories                   | Available categories are displayed  |
| Associate a book with a category  | The relationship is saved correctly |
| Use an invalid category reference | Invalid data is rejected or handled |

## 4. Stock Testing

| Test Case                   | Expected Result                                     |
| --------------------------- | --------------------------------------------------- |
| View book stock             | Current stock information is displayed              |
| Add or update book quantity | Updated quantity is reflected                       |
| Issue a book                | Stock is updated according to the implemented rules |
| Return a book               | Stock is updated according to the implemented rules |

## 5. Database Connectivity Testing

| Test Case                            | Expected Result                   |
| ------------------------------------ | --------------------------------- |
| Connect with valid database settings | Database connection succeeds      |
| Use invalid connection settings      | An appropriate error is handled   |
| Retrieve records from MySQL          | The expected records are returned |
| Save a database change               | The change persists in MySQL      |

*Record actual test results after running the corresponding tests. Do not mark a test as passed until it has been verified.*

---

# Week 8: Integration and Error Handling

## 1. Module Integration

The modules work together to provide the complete book stock management workflow.

The database connection module supports communication with MySQL. Book and category operations use database records, while stock and circulation operations depend on relevant book information.

## 2. Integration Workflow

```text
User Action
    |
    v
JSP Page / Form
    |
    v
Java Servlet
    |
    v
Database Connection
    |
    v
MySQL Database
    |
    v
Updated Result
    |
    v
JSP Page / Dashboard
```

## 3. Error Handling

The application should handle common errors, including:

* Database connection failures.
* Invalid form input.
* Missing book records.
* Invalid category references.
* Failed database queries.
* Invalid issue or return operations.
* Unexpected application errors.

## 4. Data Validation

Data validation helps maintain reliable records.

Recommended checks include:

* Required book fields should not be empty.
* Quantities should not be negative.
* Book and category identifiers should be valid.
* Issue and return operations should follow the application's stock rules.
* SQL queries that use user input should use `PreparedStatement` where appropriate.

## 5. Integration Verification

Verify the following operations in the running application:

* Book records can be added and retrieved.
* Category information is displayed correctly.
* Search results match the requested criteria.
* Stock information reflects relevant changes.
* Issue and return records are maintained correctly.
* Database errors are handled without exposing sensitive configuration details.

---

# Week 9: System Testing and Evaluation

## 1. System Testing

System testing evaluates the application as a complete web-based system rather than testing each module independently.

The following areas should be checked:

### Functional Testing

Verify that the implemented book, category, stock, search, and circulation operations work as intended.

### Database Testing

Verify that records are saved, retrieved, and updated correctly.

### User Interface Testing

Verify that forms, tables, navigation, and dashboard elements display correctly.

### Error Handling Testing

Verify that invalid inputs and database errors are handled appropriately.

### Integration Testing

Verify that the JSP pages, Servlets, database connection, and MySQL database work together.

## 2. Test Summary

Complete this table after running the tests.

| Feature              | Test Status | Remarks      |
| -------------------- | ----------- | ------------ |
| Database connection  | [Pass/Fail] | [Add result] |
| Book management      | [Pass/Fail] | [Add result] |
| Category management  | [Pass/Fail] | [Add result] |
| Search functionality | [Pass/Fail] | [Add result] |
| Stock management     | [Pass/Fail] | [Add result] |
| Issue and return     | [Pass/Fail] | [Add result] |
| Dashboard            | [Pass/Fail] | [Add result] |

## 3. Evaluation Criteria

The system should be evaluated based on:

* Correctness of book records.
* Accuracy of stock information.
* Reliability of database operations.
* Correctness of issue and return records.
* Ease of use.
* Error handling.
* Maintainability of the source code.

## 4. Known Limitations

Document any features that are not implemented or still need improvement.

Possible future improvements include:

* Login and role-based access control.
* Book issue history and reporting.
* Low-stock notifications.
* Exporting inventory reports.
* Improved input validation.
* Automated unit and integration tests.

*Only list a feature as a limitation if it is actually missing from your current implementation.*

---

## Week 10: Final System Evaluation, Project Deliverables & Submission Preparation

### Project Deliverables & Artifacts

| **Deliverable** | **Resource** | **Status** |
|---|---|---|
| Project Repository | [Book Stock Management System – GitHub](https://github.com/khushalvaishnav020140-cmd/BookStockManagement2) | Available |
| Project Report | [SRS Document (DOCX)](SRS.docx) | Prepared* |
| Software Requirements Specification | [SRS (PDF)](SRS.pdf) | Prepared* |
| ER Diagram | [View ER Diagram](ER%20Diagram.png) | Available |
| Dashboard Screenshot | [View Dashboard](dashboard.png) | Available |
| Book Stock Screenshot | [View Book Stock](book%20stock.png) | Available |
| Add Book Screenshot | [View Add Book](addbook.png) | Available |
| Circulation Screenshot | [View Circulation](circulation.png) | Available |
| Weekly Project Reports | [Project Reports on Google Drive](https://drive.google.com/drive/folders/1Envj5Ikl_qeaFq9owawc38kX8nWXffBi?usp=sharing) | Link Provided |
| Project Demonstration | Application demonstration of book management and circulation features | To Be Verified |

*Confirm that the documents are complete and up to date before marking them as finalized.*

---

## Quick Start

### Prerequisites

Ensure the following software is installed:

- Java Development Kit (JDK)
- Eclipse IDE
- Apache Tomcat 10.1
- MySQL Server
- MySQL JDBC Driver

### Setup Instructions

**1. Clone the repository**

```bash
git clone https://github.com/khushalvaishnav020140-cmd/BookStockManagement2.git
cd BookStockManagement2
