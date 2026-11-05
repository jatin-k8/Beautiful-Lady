-- BEAUTIFUL LADY: upgrade existing database for the premium storefront
-- Run this ONCE in Supabase SQL Editor after your original setup script.
-- Safe for existing products: does not delete products or user accounts.

-- Expand product categories to match the new navigation.
do $$
declare c record;
begin
  for c in
    select conname from pg_constraint
    where conrelid = 'public.products'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%category%'
  loop
    execute format('alter table public.products drop constraint %I', c.conname);
  end loop;
end $$;
alter table public.products
  add constraint products_category_check
  check (category in ('Suit Sets','Co-ord Sets','Anarkalis','Indo Westerns','Sharara/Palazzo Sets','Drapes & Lehengas','Ethnic Wear','Indo-Western','Western Wear','Festive Collection','Ethnic','Western'));

-- Storefront settings used by the new customer site and owner studio.
alter table public.site_settings add column if not exists announcement text not null default 'A LITTLE EXTRA BEAUTY IN EVERY DETAIL · WHATSAPP US FOR PERSONAL STYLING';
alter table public.site_settings add column if not exists whatsapp_number text not null default '919011712222';
alter table public.site_settings add column if not exists hero_cta text not null default 'Explore the Collection';
insert into public.site_settings(id) values (1) on conflict (id) do nothing;

-- Optional customer reviews. Only approved reviews are visible publicly.
create table if not exists public.product_reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products(id) on delete cascade,
  customer_name text not null,
  rating integer not null check (rating between 1 and 5),
  review text not null,
  approved boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.product_reviews enable row level security;
drop policy if exists "public reads approved reviews" on public.product_reviews;
create policy "public reads approved reviews" on public.product_reviews for select to anon, authenticated using (approved = true);
drop policy if exists "admins manage reviews" on public.product_reviews;
create policy "admins manage reviews" on public.product_reviews for all to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

-- Optional enquiry log for future integrations. Public users may create an enquiry;
-- only the store admin can read or manage submitted enquiries.
create table if not exists public.customer_enquiries (
  id uuid primary key default gen_random_uuid(),
  customer_name text,
  customer_phone text,
  items jsonb not null default '[]'::jsonb,
  message text,
  created_at timestamptz not null default now()
);
alter table public.customer_enquiries enable row level security;
drop policy if exists "public can submit enquiries" on public.customer_enquiries;
create policy "public can submit enquiries" on public.customer_enquiries for insert to anon, authenticated with check (true);
drop policy if exists "admins read enquiries" on public.customer_enquiries;
create policy "admins read enquiries" on public.customer_enquiries for select to authenticated using (public.is_store_admin());
drop policy if exists "admins manage enquiries" on public.customer_enquiries;
create policy "admins manage enquiries" on public.customer_enquiries for all to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

-- Existing storage bucket and policies from the first setup are retained.

-- Store editable homepage section content and section image URLs.
alter table public.site_settings
  add column if not exists homepage_content jsonb not null default '{}'::jsonb;
