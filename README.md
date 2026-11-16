# FOODBRIDGE
> **Save Food. Share Hope.**  
> *AI-Powered Food Rescue & Donation Management Platform*

[![Next.js](https://img.shields.io/badge/Next.js-14.2-black?style=flat&logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-Strict-blue?style=flat&logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-CSS-06B6D4?style=flat&logo=tailwindcss)](https://tailwindcss.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL%20%26%20RLS-3ECF8E?style=flat&logo=supabase)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 1. Product Vision

FoodBridge is an enterprise-grade food rescue ecosystem built for urban India (initially centered in Bengaluru and architected for nationwide expansion across Mumbai, Delhi-NCR, Hyderabad, and Tier-1 cities). The platform connects:

1. **Food Donors**: 5-star hotels, banquet halls, restaurants, corporate cafeterias, and artisanal bakeries.
2. **Verified NGOs & Community Kitchens**: Accredited charities feeding street shelters, orphanages, daycares, and migrant communities.
3. **Rescue Logistics Volunteers**: Fleet of vetted citizens and organizations executing monitored thermal pickups.
4. **Platform Administrators**: Governance officers managing accreditation reviews, safety moderation, and audit logs.

### Core Objectives & Principles:
- **Zero Preventable Loss**: Eliminating edible food wastage from large-scale catering.
- **FSSAI Compliance**: Strict temperature control (&gt;65°C for hot holding, &lt;5°C for cold storage), allergen declarations, and preparation timestamps.
- **Atomic Concurrency Protection**: Multi-tenant database locking prevents race conditions and over-reserving when multiple charities request the same surplus batch.
- **No Speculative Metrics**: True metric accounting (portions, kilograms, boxes) instead of speculative universal conversion factors.

---

## 2. Technology Architecture & Stack

- **Frontend**: Next.js 14 App Router, React 18, TypeScript (Strict Mode), Tailwind CSS, Framer Motion, Lucide Icons.
- **Backend & Database**: Supabase PostgreSQL with Row Level Security (RLS), atomic stored procedures, Server Actions, Route Handlers.
- **State & Sync**: Unified React Context store with localStorage backup and mock-state fallback for instant offline/evaluation testing.
- **Mapping & Location**: Leaflet and OpenStreetMap with dynamic client hydration and external routing links.
- **Validation**: Zod schema validation for all mutations.
- **Testing**: Vitest for unit/integration tests, React Testing Library, Playwright for E2E.
- **Hosting**: Vercel & Supabase.

---

## 3. Database Schema (11 Tables & Stored Functions)

All SQL migrations are maintained in `supabase/migrations/`:
1. `profiles`: User accounts, roles (`donor`, `ngo`, `volunteer`, `admin`), avatars, account status.
2. `organizations`: Entity profile, FSSAI numbers, geo-coordinates, accreditation status.
3. `verification_documents`: Legal filings (FSSAI licenses, 80G/12A trust deeds).
4. `donations`: Surplus food batches, dietary classifications, allergens, prep & expiry windows, inventory balances.
5. `donation_images`: Photo evidence of packaging and food condition.
6. `reservation_requests`: NGO portion reservations with donor approval status.
7. `pickup_assignments`: Volunteer delivery missions (`PENDING` → `ACCEPTED` → `PICKED_UP` → `DELIVERED`).
8. `notifications`: In-app notification center.
9. `reports`: Food safety and hygiene complaint investigations.
10. `reviews`: Post-delivery ratings and quality feedback.
11. `audit_logs`: Immutable security ledger recording all transactional actions.

### Concurrency-Safe Stored Procedures:
- `claim_donation_reservation(...)`: Acquires `FOR UPDATE` row lock on donation, enforces quantity and expiry constraints, deducts available inventory atomically.
- `approve_reservation_request(...)`: Automatically creates volunteer pickup assignment and dispatches notifications.
- `cancel_reservation_request(...)`: Restores reserved quantity back into available stock.

---

## 4. Local Installation & Setup

### Prerequisites
- **Node.js**: v18.17+ or v20.x+
- **npm**: v9+ or v10+

### Step-by-Step Installation:

```bash
# 1. Clone repository
git clone https://github.com/your-org/foodbridge.git
cd foodbridge

# 2. Install dependencies
npm install

# 3. Configure environment
cp .env.example .env.local

# 4. Run database migrations (on your Supabase project)
# Copy and execute:
# - supabase/migrations/20261115000000_initial_schema.sql
# - supabase/migrations/20261115000001_rls_and_functions.sql
# - supabase/seed.sql (Optional demo seed)

# 5. Start local development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 5. Instant 1-Click Demo Evaluation

FoodBridge comes equipped with a **Quick Role Switcher** in the top navigation bar and login page. Reviewers can immediately evaluate all four stakeholder portals with zero friction:

- **Donor Portal**: Chef Ananya Deshmukh (`donor.taj@foodbridge.org`)
- **NGO Portal**: Kavita Menon (`ngo.robinhood@foodbridge.org`)
- **Volunteer Fleet**: Rahul Verma (`volunteer.rahul@foodbridge.org`)
- **Admin Governance**: Officer Vikram Singhania (`admin@foodbridge.org`)

---

## 6. Running Automated Tests

```bash
# Run unit and business logic tests
npm run test

# Run tests in watch mode
npm run test:watch
```

---

## 7. Production Build & Deployment

```bash
# Create optimized production build
npm run build

# Start production server
npm run start
```

For complete Vercel and production Supabase deployment steps, see [DEPLOYMENT.md](DEPLOYMENT.md).

---

## 8. Food Safety & Legal Compliance Notice

FoodBridge strictly observes the Food Safety and Standards Authority of India (FSSAI) guidelines on surplus food redistribution. Listing approvals verify legal entity credentials and regulatory filings; recipient organizations retain the duty of sensory inspection (temperature, smell, appearance) before beneficiary distribution.
