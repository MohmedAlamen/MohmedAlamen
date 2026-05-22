create extension if not exists pgcrypto;
create extension if not exists pg_trgm;
create type public.user_role as enum ('client','lawyer','admin');
create type public.consultation_status as enum ('pending','active','completed','cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role public.user_role not null default 'client',
  full_name text not null,
  avatar_url text,
  city text,
  phone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.lawyer_profiles (
  id uuid primary key references public.profiles(id) on delete cascade,
  slug text unique not null,
  license_number text unique not null,
  verified boolean not null default false,
  score numeric(3,1) not null default 1.0 check (score between 1 and 10),
  years_experience int not null default 0,
  response_time_minutes int not null default 120,
  bio text,
  languages text[] not null default '{}',
  specializations text[] not null default '{}',
  consultation_price_sar numeric(10,2) not null default 0,
  completion_rate numeric(5,2) not null default 0
);
create table public.questions (id uuid primary key default gen_random_uuid(), user_id uuid references public.profiles(id) on delete set null, slug text unique not null, title text not null, body text not null, category text not null, is_anonymous boolean not null default true, status text not null default 'open', created_at timestamptz not null default now());
create index questions_fts_idx on public.questions using gin (to_tsvector('arabic', title || ' ' || body));
create table public.answers (id uuid primary key default gen_random_uuid(), question_id uuid not null references public.questions(id) on delete cascade, lawyer_id uuid not null references public.lawyer_profiles(id) on delete cascade, body text not null, quality_score int not null default 0, created_at timestamptz not null default now());
create table public.consultations (id uuid primary key default gen_random_uuid(), client_id uuid not null references public.profiles(id), lawyer_id uuid not null references public.lawyer_profiles(id), status public.consultation_status not null default 'pending', consultation_type text not null check (consultation_type in ('chat','voice','video')), scheduled_at timestamptz, started_at timestamptz, completed_at timestamptz, created_at timestamptz not null default now());
create table public.messages (id uuid primary key default gen_random_uuid(), consultation_id uuid not null references public.consultations(id) on delete cascade, sender_id uuid not null references public.profiles(id), body text, file_url text, read_at timestamptz, created_at timestamptz not null default now());
create table public.reviews (id uuid primary key default gen_random_uuid(), consultation_id uuid unique not null references public.consultations(id) on delete cascade, lawyer_id uuid not null references public.lawyer_profiles(id), client_id uuid not null references public.profiles(id), rating_speed int not null check (rating_speed between 1 and 5), rating_quality int not null check (rating_quality between 1 and 5), rating_communication int not null check (rating_communication between 1 and 5), comment text, created_at timestamptz not null default now());
create table public.article_categories (id uuid primary key default gen_random_uuid(), slug text unique not null, name_ar text not null, name_en text not null);
create table public.articles (id uuid primary key default gen_random_uuid(), author_id uuid references public.lawyer_profiles(id), category_id uuid not null references public.article_categories(id), slug text unique not null, title text not null, excerpt text, body text, published_at timestamptz, created_at timestamptz not null default now());
create table public.lawyer_availability (id uuid primary key default gen_random_uuid(), lawyer_id uuid not null references public.lawyer_profiles(id) on delete cascade, weekday int not null check (weekday between 0 and 6), start_time time not null, end_time time not null);
create table public.payments (id uuid primary key default gen_random_uuid(), consultation_id uuid not null references public.consultations(id), gateway text not null, amount_sar numeric(10,2) not null, status text not null, external_reference text, created_at timestamptz not null default now());
create table public.notifications (id uuid primary key default gen_random_uuid(), user_id uuid not null references public.profiles(id), type text not null, payload jsonb not null, read_at timestamptz, created_at timestamptz not null default now());
create table public.saved_lawyers (user_id uuid not null references public.profiles(id) on delete cascade, lawyer_id uuid not null references public.lawyer_profiles(id) on delete cascade, created_at timestamptz not null default now(), primary key (user_id, lawyer_id));
create table public.reports (id uuid primary key default gen_random_uuid(), reporter_id uuid references public.profiles(id), target_type text not null, target_id uuid not null, reason text not null, status text not null default 'open', created_at timestamptz not null default now());

alter table public.profiles enable row level security;
alter table public.lawyer_profiles enable row level security;
alter table public.questions enable row level security;
alter table public.answers enable row level security;
create policy "public profiles readable" on public.profiles for select using (true);
create policy "self profile write" on public.profiles for update using (auth.uid() = id);
create policy "public lawyers readable" on public.lawyer_profiles for select using (true);
create policy "lawyer self update" on public.lawyer_profiles for update using (auth.uid() = id);
create policy "questions readable" on public.questions for select using (true);
create policy "question owner insert" on public.questions for insert with check (auth.uid() = user_id);
create policy "answers readable" on public.answers for select using (true);
create policy "lawyer answers insert" on public.answers for insert with check (auth.uid() = lawyer_id);
