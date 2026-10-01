# RentEase — Modern Monthly Property & Room Rental Platform

A production-grade, full-stack **Monthly Rental Discovery, Tenancy Agreement & Rent Collection Platform** built specifically for monthly rental of **rooms, 1/2/3 BHK apartments, houses, hostels, PGs, godowns and commercial spaces** in **Urban & Rural** regions.

---

## 🌟 Core Pillars & Architectural Overview

The application is structured into three unified, interconnected role-based portals:

1. **👥 CUSTOMER APP**:
   - Location Selector supporting **Urban** (*Varanasi, Lucknow, Delhi, Mumbai*) and **Rural** (*Harahua, Kashi Rural, Babatpur, Bakshi Ka Talab, Mohanlalganj, Najafgarh, Palghar*).
   - Mandatory **"Suitable For"** eligibility matching (*Single, Couple, Family, Boys, Girls, Students, Working Professional, Hostels, PG*).
   - OYO-style discovery feed with verified amenities, sub-meter electricity info, maintenance details, and large photos.
   - **Owner Privacy Control**: Direct call/message contact actions strictly obey owner visibility preferences.
   - Rental Request Submission & Terms Confirmation.
   - **Aadhaar e-KYC Legal Verification**: Paperless OTP authentication and 11-month digital tenancy agreement execution.
   - **Customer Rent Dashboard**: Active rental overview, "Pay Rent Now" (UPI, Online, Bank Transfer), "Record Cash Payment", Month-wise Rent Ledger timeline.
   - **Digital Rent Receipt Generator**: Official verifiable digital receipt with QR code, watermark, and PDF/Print support.
   - Maintenance ticket & complaint tracker.

2. **🏢 PROPERTY OWNER APP**:
   - Multi-Property & Multi-Room Portfolio Management (e.g. *Ganga Heights Deluxe Complex* managing *Room 101 [Available], Room 102 [Rented], Room 103 [Rental Request], Room 104 [Available]*).
   - **Add Property Wizard**: Categorize as Urban/Rural, select Suitable For categories, set Rent Start Date, Monthly Rent, Security Deposit & Due Day (e.g. 5th of every month).
   - **Request Management**: Accept or Reject tenant applications with instant state transitions.
   - **Rent Collection Tracker**: Track dues, record received cash/UPI/bank payments with transaction references.
   - **Automated Rent Reminders**: In-app and push reminder triggers before due date, on due date, and overdue.
   - **Privacy Controls**: 4 granular contact options (*Call+Msg ON, Call ON/Msg OFF, Call OFF/Msg ON, Both OFF*).

3. **🛡️ ADMIN PANEL**:
   - **Executive Dashboard**: Live metrics for Total Customers, Owners, Properties, Occupancy Rate, Total Rent Collected, Overdue Rent, and Transactions.
   - **Master Property Directory**: Urban/Rural breakdown, unit-level occupancy, rent ranges.
   - **Areas Master**: Manage Urban cities and Rural village hubs.
   - **Agreements & Active Leases Pipeline**: Full traceability from rental request to active lease.
   - **Rent Payment Ledger**: Complete financial audit trail with receipts.
   - **Maintenance & Complaints Resolution**: Admin ticketing response system.
   - **System Notification Broadcaster**: Send targeted alerts to Customers, Owners, or platform-wide.

---

## 📋 18 Core Business Rules Enforced

1. **Available Properties Rule**: Customers only see properties/rooms with status `Available`.
2. **Double-Booking Prevention**: Rented rooms are strictly hidden from customer search and cannot accept requests.
3. **Single Active Rental**: One room can have only ONE active rental at any given time.
4. **Owner Privacy Protection**: Direct contact details are masked unless owner enables permissions.
5. **Contact Permission Options**: Owners control whether Call, Message, Both, or Neither is allowed.
6. **"Suitable For" Eligibility**: Search results and bookings validate customer category against owner's suitability settings.
7. **Agreement Completion State Transition**: Agreement completion changes room status: `Available` $\rightarrow$ `Rented`.
8. **Urban & Rural Support**: First-class support for rural villages, godowns, and urban apartments.
9. **Multi-Room Management**: Apartments can have multiple independent rooms with separate leases.
10. **Multi-Property Portfolios**: Owners can manage arbitrary numbers of properties and rooms.
11. **Rent Start Date**: Every active lease stores a definitive rent start date.
12. **Monthly Rent Amount**: Explicit monthly recurring amount tied to active rental.
13. **Monthly Due Day**: Recurring due day (e.g. 1st, 5th, 10th of every month).
14. **Month-Wise Rent Records**: Payment records are tracked separately per billing cycle.
15. **Ledger Distinguishability**: `Paid` vs `Pending` states are visually and programmatically segregated.
16. **Automatic Due Reminders**: Notifications are dispatched 3-5 days before due date, on due date, and when overdue.
17. **Immutable Payment Records**: Ledger entries maintain audit trails and transaction references.
18. **Digital Rent Receipt**: Verified digital receipt issued for every completed payment.

---

## 🚀 Quick Start & Running Locally

### 1. Start Web Server
```bash
node server.js
```
Open **[http://localhost:3000](http://localhost:3000)** in any web browser.

### 2. Run Test Suite
```bash
node test/integration_test.js
```

---

## 📂 Project Structure

```
.
├── index.html               # Main single-page web shell & device simulator
├── server.js                # Zero-dependency Node.js static HTTP server
├── package.json             # Project configuration
├── css/
│   └── styles.css           # Design tokens, Outfit/Inter typography, cards, receipts
├── js/
│   ├── data.js              # Relational seed database (Properties, Rooms, Areas, Users, Ledger)
│   ├── state.js             # Reactive state engine enforcing all 18 business rules & persistence
│   ├── customer.js          # Customer App controller (Discovery, KYC, Rent Dashboard, History)
│   ├── owner.js             # Property Owner App controller (Portfolio, Requests, Rent Collection)
│   ├── admin.js             # Admin Panel controller (Analytics, Governance, Disputes, Broadcaster)
│   └── app.js               # Global coordinator, role switcher, toasts & digital receipt modal
└── test/
    └── integration_test.js  # Automated E2E verification test suite (100% Pass)
```
