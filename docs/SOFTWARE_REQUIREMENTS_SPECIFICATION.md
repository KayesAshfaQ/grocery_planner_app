# Software Requirements Specification (SRS)

## 1. Introduction

### 1.1 Purpose

This document provides a detailed specification of the requirements for the Grocery Planner App. It serves as the official agreement between stakeholders and developers, defining the system's functional and non-functional requirements, interfaces, and operating constraints.

### 1.2 Scope

The Grocery Planner App is a mobile application for iOS and Android that allows users to efficiently plan and manage their grocery shopping. The scope includes list creation, budget management, item cataloging, purchase tracking, and future integrations with cloud services for data synchronization and sharing.

### 1.3 Definitions, Acronyms, and Abbreviations

-   **SRS**: Software Requirements Specification
-   **FR**: Functional Requirement
-   **NFR**: Non-Functional Requirement
-   **API**: Application Programming Interface
-   **BLoC**: Business Logic Component
-   **ORM**: Object-Relational Mapping
-   **UI/UX**: User Interface / User Experience

### 1.4 References

-   Product Requirements Document (PRD)
-   System Design Documentation
-   Database Schema (`GroceryPlanner_v1.1.sql`)

## 2. Overall Description

### 2.1 Product Perspective

The app is a self-contained, standalone mobile application built with Flutter. It is designed to operate offline, with future capabilities to sync data with cloud storage services (Google Drive, iCloud) and integrate with third-party authentication providers (Google, Apple).

### 2.2 Product Functions

-   Create and manage grocery purchase lists with detailed attributes.
-   Maintain a catalog of reusable grocery items.
-   Organize items into user-defined categories.
-   Mark items as purchased and track spending against a budget.
-   (Future) Schedule shopping trips and receive reminders.
-   (Future) Generate spending reports and view price analytics.
-   (Future) Share lists and collaborate with other users.

### 2.3 User Characteristics

Target users are tech-savvy individuals aged 18+ who are comfortable with mobile applications. They are looking for an efficient tool to organize their grocery shopping, manage their budget, and plan their meals.

### 2.4 Operating Environment

-   **Client:** iOS 14+ and Android 9+.
-   **Storage:** Local SQLite database for offline caching.
-   **Backend (Future):** RESTful APIs over HTTPS for cloud synchronization and user management.

### 2.5 Design and Implementation Constraints

-   The application must be developed using the Flutter framework.
-   The architecture must adhere to Clean Architecture principles.
-   State management will be implemented using the BLoC pattern.
-   The local database will be managed by the Floor ORM.
-   The initial release will support English and Bengali.

## 3. Specific Requirements

### 3.1 Interface Requirements

#### 3.1.1 User Interfaces

-   **Dashboard:** Main screen displaying an overview of active lists and navigation to other features.
-   **Purchase List Page:** Tabbed view for "To Buy" and "Purchased" items.
-   **Purchase List Editor:** A form for creating a new list and adding/editing items.
-   **Catalog Page:** A view to manage and browse catalog items.
-   **Category Page:** A view to manage and browse categories.

#### 3.1.2 Hardware Interfaces

-   **Camera (Future):** For barcode scanning to add items to a list.
-   **Microphone (Future):** For voice-based commands to add items.

#### 3.1.3 Software Interfaces

-   **Cloud Storage APIs (Future):** Google Drive API, Apple iCloud API for data backup and sync.
-   **Authentication SDKs (Future):** Google Sign-In, Apple Sign-In for user authentication.

### 3.2 Functional Requirements

#### 3.2.1 Purchase List Management

-   **FR1.1:** The system shall allow users to create a purchase list with a unique name, a budget, and a currency symbol.
-   **FR1.2:** The system shall allow users to add items to a purchase list. An item can be selected from the catalog or entered as a custom item.
-   **FR1.3:** Each item in a list shall have a quantity, unit price (optional), and a category.
-   **FR1.4:** The system shall allow users to mark an item as "purchased," which moves it to the "Purchased" tab.
-   **FR1.5:** The system shall allow users to delete a purchase list.
-   **FR1.6:** The system shall allow users to remove items from a purchase list.

#### 3.2.2 Catalog Management

-   **FR2.1:** The system shall provide a pre-populated catalog of common grocery items.
-   **FR2.2:** The system shall allow users to add a new custom item to the catalog with a name, category, and default unit.
-   **FR2.3:** The system shall allow users to search the catalog by item name.

#### 3.2.3 Category Management

-   **FR3.1:** The system shall allow users to create a new category with a name, description, and an icon.
-   **FR3.2:** The system shall allow users to view all created categories.
-   **FR3.3:** The system shall allow users to assign a category to a catalog item or a purchase list item.

### 3.3 Database Requirements

-   The system shall use a local SQLite database to persist all user data for offline use.
-   The database schema must conform to the structure defined in `docs/GroceryPlanner_v1.1.sql`.
-   The Floor ORM will be used to manage all database operations, including migrations.

### 3.4 Non-Functional Requirements

-   **NFR1 (Performance):** List loading and rendering must complete within 1 second on a typical 4G connection.
-   **NFR2 (Availability):** All core CRUD (Create, Read, Update, Delete) operations for lists, items, and categories must be fully functional offline.
-   **NFR3 (Reliability):** The application shall have a crash-free rate of over 99%.
-   **NFR4 (Maintainability):** The codebase must follow the principles of Clean Architecture to ensure modularity and testability.
-   **NFR5 (Security):** Any future cloud-synchronized data must be encrypted both in transit (TLS) and at rest.
