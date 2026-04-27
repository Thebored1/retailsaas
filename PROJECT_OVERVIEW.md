# RetailSaaS Overview

This project is a retail operations suite with two connected applications:

1. **Desktop App (RetailSaaS)**
   - Primary operations console for store staff.
   - Manages products, inventory, batches, billing, customers, vendors, purchases, stock adjustments, and accounting (general ledger + stock ledger).
   - Generates purchase orders, goods receipts, sales bills, debit notes, and payments.
   - Syncs with the webfront and keeps local data available offline.

2. **Webfront Server (RetailSaaS Webfront)**
   - Customer-facing storefront for browsing products and placing online orders.
   - Delivery console for delivery agents to view orders and mark deliveries complete.
   - Sync endpoints used by the desktop app to push/pull products, inventory, batches, customers, sales, and orders.

---

## What the Applications Are Made For

### Desktop App
- **Retail Operations**: Central place to run a store. Staff can manage:
  - Products, pricing, and tax setup
  - Inventory and batch tracking
  - Sales (POS), returns, and stock deductions
  - Purchases (POs), goods receipts, vendor management, and payments
- **Accounting & Reporting**: Maintains a **General Ledger** and **Stock Ledger** for auditability.
- **Sync Hub**: Acts as the authoritative system that pushes data to the webfront and receives online orders back.

### Webfront Server
- **Online Storefront**: Customers view products and place orders online.
- **Delivery Console**: Delivery agents log in separately, view orders out for delivery, and complete deliveries with photo proof if required.
- **Batch-aware Pricing**: Uses batch FIFO to show correct prices and allocations at checkout.
- **Sync API**: Receives product, inventory, batch, and customer data from desktop; exposes orders/sales for desktop to consume.

---

## How Sync Works (High-Level)

- **Desktop ➜ Webfront**
  - Products, inventory totals, batch prices, customers, and sales sync to the webfront.
- **Webfront ➜ Desktop**
  - Online orders and sales events sync back.
- **Offline Support**
  - Desktop continues to work offline and pushes changes when back online.
  - Webfront reflects the latest pushed data once sync is restored.

---

## Key Roles and Access

- **Admin/Staff (Desktop)**: Full control of store operations and sync.
- **Customers (Webfront)**: Browse and place orders only.
- **Delivery Agents (Webfront)**:
  - Separate role and login.
  - Access only the delivery console.
  - Cannot access the main storefront or customer pages.

---

## Recent Changes / New Capabilities

### Webfront (Server)
- **Batch-aware pricing**:
  - FIFO batch allocation for cart/checkout.
  - Lowest batch price shown on product list/detail.
  - Checkout and order confirmation show batch split.
- **Delivery agent console**:
  - Delivery role is isolated from customers and admin.
  - Orders “out for delivery” only.
  - Delivery completion can require photo proof (configurable).
  - Delivery status updates propagate to storefront and desktop.
- **Improved product list UX**:
  - Image/name are clickable to open product details.
  - Grid layout scales to 4+ columns on wider screens.
- **Settings-backed PO preview**:
  - Purchase order preview uses dynamic store settings (GSTIN, state code, address, phone).

### Desktop App
- **Webfront order acceptance now creates real sales bills**:
  - Ledger entry + stock deductions.
  - Sales bill tagged as webstore source.
- **Delivery agent account management**:
  - Create, reset password, enable/disable, and delete.
- **Customer/ledger safeguards**:
  - Ledger detail view fixed for short IDs.
  - Role-based separation for delivery agents vs customers.

---

## Notes
- The **server exists in two places**:
  1. As a folder in the desktop repo (for convenience).
  2. As a **separate webfront repo** for server-only deployment.

---

## Repositories

- **Desktop App (root repo)**: `https://github.com/Thebored1/retailsaas.git`
- **Webfront Server (separate)**: `https://github.com/Thebored1/retailsaas-webfront.git`

