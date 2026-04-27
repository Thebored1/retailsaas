# RetailSaaS: Project Analysis & Explanation

This document provides a comprehensive overview of the **RetailSaaS** project architecture, technology stack, and core business functionality.

## 🏗️ Core Concept
**RetailSaaS** is a hybrid "Online-to-Offline" (O2O) retail management suite. It allows businesses to manage physical store operations (POS, inventory, accounting) while simultaneously running a customer-facing e-commerce webfront.

---

## 💻 Technology Stack

### 1. Desktop Application (The Operations Hub)
*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite) for offline-first persistence.
*   **Key Dependencies**:
    *   `get_it`: Service locator for dependency injection.
    *   `fl_chart`: For real-time business analytics and dashboards.
    *   `pdf` & `printing`: For generating sales bills, purchase orders, and receipts.
    *   `lottie`: For premium UI micro-animations.

### 2. Webfront Server (The Customer Interface)
*   **Framework**: [Django](https://www.djangoproject.com/) (Python)
*   **Database**: SQLite (Development) / PostgreSQL (Production)
*   **Role**: Serves the customer e-commerce site, provides a delivery agent console, and hosts the Sync API for the desktop app.

---

## 🚀 Key Business Features

### 📦 Precision Inventory Management
*   **Batch Tracking**: Tracks products by batch numbers, essential for items with expiry dates.
*   **FIFO Valuation**: Automatically implements First-In-First-Out logic for inventory deductions and pricing.
*   **Bulk Uploads**: Support for Excel/CSV imports for large-scale inventory management.

### 🧾 Integrated Financials
*   **General Ledger**: A full double-entry accounting system integrated directly into the retail workflow.
*   **Stock Ledger**: Real-time audit trail of every stock movement (Sales, Purchases, Adjustments, Returns).
*   **Vendor Management**: Tracks purchase orders, goods receipts, and outstanding vendor payments.

### 🚚 Delivery Ecosystem
*   **Isolated Console**: Specialized login for delivery agents that only shows active deliveries.
*   **Proof of Delivery**: Supports capturing photo evidence and updating delivery statuses that sync back to the main dashboard.

### 🔄 Data Synchronization
*   **Offline-First**: The desktop app works without internet; data is queued and pushed to the webfront when connectivity returns.
*   **Bidirectional Sync**: Products and inventory flow *Desktop ➜ Web*, while online orders flow *Web ➜ Desktop*.

---

## 🌟 Why This Project Stands Out

1.  **Seamless O2O**: Most systems are either just POS or just E-commerce. RetailSaaS bridges both natively.
2.  **Auditability**: The deep integration of accounting ensures that the business "books" are always accurate without external tools.
3.  **Architecture**: The separation of the Management Console (Desktop) and the Storefront (Web) provides high security and performance.
4.  **Premium UX**: Use of modern typography, Lottie animations, and clean layouts makes it a "Premium" tool for store staff.

---

## 📁 Repository Structure
*   `lib/`: Flutter application source.
*   `server/`: Django backend and webfront source.
*   `backend/`: Database storage and sync configurations.
*   `assets/`: Visual assets and animations.
*   `scripts/`: Automation and build scripts.
