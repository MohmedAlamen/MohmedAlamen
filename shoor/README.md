# Shoor (شور) — Saudi Legal Directory & Consultation Platform

Production-grade Next.js 14 + Supabase architecture.

## Step 1 — Folder Structure
- `app/` App Router pages (lawyers, questions, articles, admin dashboard)
- `components/` UI and domain components
- `lib/` services, validations, SEO, scoring, payments
- `supabase/migrations/` SQL schema and policies
- `types/` DB and domain types

## Step 2 — SQL Schema
See `supabase/migrations/0001_init.sql`.

## Step 3 — TypeScript Database Types
See `types/database.ts`.

## Step 4 — Auth Setup
- Supabase Auth with roles (`client`, `lawyer`, `admin`) via profile metadata + DB role checks.
- Middleware guard in `middleware.ts`.

## Step 5 — Tailwind + shadcn
- Base setup in `tailwind.config.ts` and `app/globals.css`.

## Step 6–12 — Core modules + SEO
Implemented route foundations and service abstractions for:
- Home, directory, profile, questions, chat models, payments, admin.
- Metadata API, JSON-LD helpers, sitemap, robots.

## Step 13 — Deployment
1. Create Supabase project and apply migration.
2. Add env vars (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`).
3. Deploy to Vercel with edge runtime for realtime endpoints.
