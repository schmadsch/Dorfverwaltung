create table public.calendar_sources (
 id uuid primary key default gen_random_uuid(),
 name text not null check (btrim(name) <> ''),
 feed_url text not null check (feed_url ~ '^https://'),
 color text not null default '#64748B' check (color ~ '^#[0-9A-Fa-f]{6}$'),
 location_id bigint references public.locations(id),
 category_id bigint references public.categories(id),
 is_public boolean not null default false,
 active boolean not null default true,
 sync_interval integer not null default 30 check (sync_interval >= 15),
 last_sync_at timestamptz,
 sync_status text not null default 'pending'
);
alter table public.calendar_sources enable row level security;
revoke all on public.calendar_sources from public, anon, authenticated;
alter table public.events add column calendar_source_id uuid references public.calendar_sources(id) on delete cascade,
 add column external_uid text, add column external_recurrence_id text,
 add column last_synced_at timestamptz,
 add constraint events_external_identity check ((calendar_source_id is null and external_uid is null and external_recurrence_id is null and last_synced_at is null) or (calendar_source_id is not null and external_uid is not null and external_recurrence_id is not null));
create unique index events_external_unique on public.events(calendar_source_id,external_uid,external_recurrence_id);
