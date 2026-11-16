# FOODBRIDGE — Production Deployment Guide

This guide details the step-by-step procedures to deploy FoodBridge to **Vercel** and configure a production **Supabase PostgreSQL** database cluster.

---

## 1. Supabase Production Setup

1. Log into [Supabase Dashboard](https://supabase.com/dashboard) and click **New Project**.
2. Name the project `FoodBridge Production` and select the region **South Asia (Mumbai) - ap-south-1** for lowest latency in India.
3. Once initialized, navigate to the **SQL Editor** tab:
   - Paste and execute `supabase/migrations/20261115000000_initial_schema.sql` (Creates all 11 tables and indexes).
   - Paste and execute `supabase/migrations/20261115000001_rls_and_functions.sql` (Enables Row Level Security and stored procedures).
   - (Optional for staging) Execute `supabase/seed.sql` to populate sample organizations, listings, and mission assignments.
4. Navigate to **Project Settings → API**:
   - Copy `Project URL` → Map to `NEXT_PUBLIC_SUPABASE_URL`
   - Copy `anon public` key → Map to `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - Copy `service_role secret` key → Map to `SUPABASE_SERVICE_ROLE_KEY` (Keep secure, server-only)
5. Navigate to **Authentication → URL Configuration**:
   - Add your production domain to Site URL (e.g. `https://foodbridge.org`) and Redirect URLs.

---

## 2. Vercel Deployment

1. Push your repository to GitHub:
   ```bash
   git init
   git add .
   git commit -m "feat: complete FoodBridge platform architecture"
   git remote add origin https://github.com/your-org/foodbridge.git
   git push -u origin main
   ```
2. In the [Vercel Dashboard](https://vercel.com/), select **Add New Project** and import the GitHub repository.
3. Configure Environment Variables in the Vercel project settings:
   - `NEXT_PUBLIC_APP_URL`: `https://your-domain.vercel.app`
   - `NEXT_PUBLIC_SUPABASE_URL`: `https://[PROJECT-ID].supabase.co`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`: `[YOUR-ANON-KEY]`
   - `SUPABASE_SERVICE_ROLE_KEY`: `[YOUR-SERVICE-ROLE-KEY]`
   - `NEXT_PUBLIC_DEFAULT_TIMEZONE`: `Asia/Kolkata`
   - `NEXT_PUBLIC_CURRENCY`: `INR`
   - `NEXT_PUBLIC_CURRENCY_SYMBOL`: `₹`
   - `NEXT_PUBLIC_MEASUREMENT_SYSTEM`: `metric`
4. Click **Deploy**. Vercel will run `npm run build` and provision the edge CDN deployment.

---

## 3. Production-Readiness Review Checklist

- [x] All 4 role portals (Donor, NGO, Volunteer, Admin) fully functional.
- [x] Concurrency-safe reservation logic implemented with PostgreSQL stored functions.
- [x] Strict Row Level Security (RLS) policies configured on all 11 database tables.
- [x] Service role key protected from client exposure.
- [x] Input sanitization and Zod validations in place for all user forms.
- [x] Responsive layout tested for Desktop, Tablet, and Mobile displays.
- [x] Food safety and FSSAI disclaimers visible on listings and public pages.
- [x] Metric units (kg, portions, liters, boxes) standardized.
- [x] INR (₹) formatting and Asia/Kolkata timezone standard applied.
- [x] Automated test suite verifying validation and state machine transitions.
