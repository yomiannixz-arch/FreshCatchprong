-- FreshCatch NG backend schema aligned to the current app code
-- Safe for a clean reset in a test environment

drop table if exists public.inventory cascade;
drop table if exists public.riders cascade;
drop table if exists public.vendors cascade;
drop table if exists public.orders cascade;
drop table if exists public.product_price_lists cascade;

create extension if not exists pgcrypto;

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  reference text unique not null,
  customer_name text,
  customer_phone text,
  customer_email text,
  delivery_address text,
  payment_method text,
  amount_ngn numeric default 0,
  items jsonb default '[]'::jsonb,
  status text default 'pending',
  paystack_reference text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.vendors (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  email text,
  location text,
  specialty text,
  created_at timestamptz default now()
);

create table public.riders (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  bike text,
  status text default 'available',
  lat double precision,
  lng double precision,
  last_seen timestamptz,
  created_at timestamptz default now()
);

create table public.inventory (
  id uuid primary key default gen_random_uuid(),
  vendor_id uuid references public.vendors(id) on delete cascade,
  product_name text,
  quantity numeric default 0,
  unit text,
  unit_price numeric default 0,
  stock_status text default 'in-stock',
  created_at timestamptz default now()
);

create table public.product_price_lists (
  id uuid primary key default gen_random_uuid(),
  sku text unique not null,
  name text,
  unit text,
  price_ngn numeric,
  price_min_ngn numeric,
  price_max_ngn numeric,
  pricing_type text default 'fixed',
  category text,
  market text default 'Nigeria',
  notes text,
  created_at timestamptz default now()
);

-- For initial testing only:
alter table public.orders disable row level security;
alter table public.vendors disable row level security;
alter table public.riders disable row level security;
alter table public.inventory disable row level security;
alter table public.product_price_lists disable row level security;
