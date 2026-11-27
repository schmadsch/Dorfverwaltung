begin;
create table public.locations (
  id bigint generated always as identity primary key,
  name text not null unique,
  active boolean not null default true
);
create table public.categories (
  id bigint generated always as identity primary key,
  name text not null unique,
  color text not null default '#3788d8',
  active boolean not null default true,
  constraint valid_color check (color ~ '^#[0-9A-Fa-f]{6}$')
);
create table public.profiles (
  id uuid primary key references auth.users (id) on delete CASCADE,
  display_name text not null,
  role text not null default 'member' check (role in ('member', 'admin')),
  active boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.events (
  id uuid primary key default gen_random_uuid (),
  title text not null check (length(trim(title)) > 0),
  description text,
  start_at timestamptz not null,
  end_at timestamptz not null,
  all_day boolean not null default false,
  venue text,
  organizer text,
  location_id bigint references public.locations (id),
  category_id bigint references public.categories (id),
  is_public boolean not null default false,
  created_by uuid default auth.uid () references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint valid_event_period check (end_at > start_at)
);
create index events_start_at_idx on public.events (start_at);
create index events_end_at_idx on public.events (end_at);
create index events_location_idx on public.events (location_id);
create index events_category_idx on public.events (category_id);
create index events_created_by_idx on public.events (created_by);
create function public.set_updated_at () RETURNS trigger LANGUAGE plpgsql
set search_path = '' as $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;
create trigger events_updated_at BEFORE update on public.events for EACH row execute FUNCTION public.set_updated_at ();
create trigger profiles_updated_at BEFORE update on public.profiles for EACH row execute FUNCTION public.set_updated_at ();
alter table public.locations ENABLE row LEVEL SECURITY;
alter table public.categories ENABLE row LEVEL SECURITY;
alter table public.profiles ENABLE row LEVEL SECURITY;
alter table public.events ENABLE row LEVEL SECURITY;
revoke all PRIVILEGES on table public.locations, public.categories, public.profiles, public.events from PUBLIC, anon, authenticated;
commit;
