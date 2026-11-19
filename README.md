# BelongSphere

Find your people. Find your place.

A responsive React + TypeScript application for discovering flatmates, travel partners, communities, places, rentals, and events. Built with Vite, Tailwind CSS v4, Lucide icons, and Supabase JS.

## Start locally

```sh
npm install
npm run dev
```

Use the Local URL printed by Vite. Run `npm run build` for a production build, `npm run preview` to serve it, and `npm test` for discovery logic checks. Requires Node 22.12+ or a supported newer release.

## Connect Supabase

1. Create a Supabase project.
2. Execute `supabase/migrations/001_initial_schema.sql` in its SQL editor.
3. Optionally execute `supabase/seed.sql` to populate the example catalog. Example people are fictional; seed listings have no owner and cannot receive real replies.
4. Copy `.env.example` to `.env.local` and set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` using the project URL and public publishable/anon key. Never use a service-role or secret key in the frontend.
5. Enable email authentication. In Supabase Authentication → URL Configuration, set the Site URL to your deployed origin and allow your development origin, such as `http://127.0.0.1:5173`, as a redirect URL.
6. Restart Vite. For deployment, rebuild after setting the environment variables: Vite embeds public configuration at build time.

Without configuration, the app uses a clearly labelled demonstration catalog. Bookmarks, joined groups, discussion posts, connection requests, created listings, and trip outlines are saved to this browser's local storage. No emails or messages are sent in demo mode. With Supabase configured, the app uses database listings, magic-link authentication, account-scoped bookmarks and memberships, connection requests, and member-only community posts. A database error is shown instead of claiming a write succeeded.

## Included

- Responsive dashboard with mobile navigation, keyboard-accessible modal dialogs, and reduced-motion support.
- Discovery across people, places, communities, and events; city, interest, budget, text search, and sorting.
- Keyword search with budget extraction (e.g. `flatmates under 15k`). This is deterministic search, not an LLM.
- Saved collection, community joining, event interest, member discussions, and listing creation.
- Connection request tracking. These are requests, not a real-time messaging system or confirmed bookings.
- Trip outline builder with origin, destination, date, duration, travellers, budget allocations, travel style, and local saving.
- Supabase schema, RLS policies, and optional sample seed data.

## Production roadmap

This is a working MVP foundation, not the complete production system described in the brief. Remaining work includes profile editing and personal preference onboarding, real compatibility scoring, private communities and moderation, live messaging and incoming-request management, photo uploads, geospatial search, service-provider tools, bookings/payments, and notification delivery. The trip planner is an explicitly labelled local template, with illustrative budget allocations and no live travel prices or availability. An AI service should run behind a Supabase Edge Function or another backend, with its provider key stored as a server secret; do not expose an AI key through `VITE_*` variables. Add rate limits, abuse protection, and verified travel data before offering AI travel recommendations.

The schema enforces ownership of listings and private account records. Community posts require membership. Production deployments should validate those policies using separate user accounts before launch. Supabase integration cannot be verified until project credentials and a migrated database are supplied.

Photography is loaded from Unsplash; fonts are loaded from Google Fonts. These require network access. All example names, listings, memberships, and match percentages are illustrative.

## Project layout

`src/App.tsx` — screens and interactions; `src/data.ts` — sample catalog; `src/lib.ts` — Supabase and filtering; `src/styles.css` — Tailwind and visual styles; `supabase/` — schema and seed data.

Implementation references: [Tailwind with Vite](https://tailwindcss.com/docs/installation/using-vite), [Supabase magic-link authentication](https://supabase.com/docs/reference/javascript/auth-signinwithotp), and [Supabase row-level security](https://supabase.com/docs/guides/database/postgres/row-level-security).
