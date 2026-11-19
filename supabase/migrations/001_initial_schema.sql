-- Run once in the Supabase SQL editor. Never put a service-role key in VITE_* variables.
create table public.listings (
 id text primary key default gen_random_uuid()::text,
 owner_id uuid references auth.users(id) on delete cascade,
 kind text not null check (kind in ('people','places','communities','events')),
 title text not null check (char_length(trim(title)) between 1 and 80),
 details jsonb not null check (jsonb_typeof(details) = 'object'),
 created_at timestamptz not null default now()
);
create table public.bookmarks (
 user_id uuid not null references auth.users(id) on delete cascade,
 item_id text not null references public.listings(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(user_id,item_id)
);
create table public.memberships (
 user_id uuid not null references auth.users(id) on delete cascade,
 item_id text not null references public.listings(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(user_id,item_id)
);
create table public.connection_requests (
 id uuid primary key default gen_random_uuid(),
 sender_id uuid not null references auth.users(id) on delete cascade,
 item_id text not null references public.listings(id) on delete cascade,
 title text not null,
 body text not null check (char_length(trim(body)) between 10 and 1000),
 created_at timestamptz not null default now(), unique(sender_id,item_id)
);
create table public.posts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 item_id text not null references public.listings(id) on delete cascade,
 author text not null check(char_length(author) <= 100),
 body text not null check(char_length(trim(body)) between 3 and 2000),
 created_at timestamptz not null default now()
);
create index listings_kind_idx on public.listings(kind);
create index listings_owner_idx on public.listings(owner_id);
create index requests_item_idx on public.connection_requests(item_id);
create index posts_item_idx on public.posts(item_id,created_at desc);
alter table public.listings enable row level security;
alter table public.bookmarks enable row level security;
alter table public.memberships enable row level security;
alter table public.connection_requests enable row level security;
alter table public.posts enable row level security;
create policy "Public discovery" on public.listings for select using(true);
create policy "Owners publish listings" on public.listings for insert to authenticated with check((select auth.uid()) = owner_id);
create policy "Owners edit listings" on public.listings for update to authenticated using((select auth.uid()) = owner_id) with check((select auth.uid()) = owner_id);
create policy "Owners remove listings" on public.listings for delete to authenticated using((select auth.uid()) = owner_id);
create policy "Own bookmarks" on public.bookmarks for all to authenticated using((select auth.uid()) = user_id) with check((select auth.uid()) = user_id);
create policy "Read own memberships" on public.memberships for select to authenticated using((select auth.uid()) = user_id);
create policy "Join communities and events" on public.memberships for insert to authenticated with check((select auth.uid()) = user_id and exists(select 1 from public.listings where id=item_id and kind in ('communities','events')));
create policy "Leave own memberships" on public.memberships for delete to authenticated using((select auth.uid()) = user_id);
create policy "Read sent or received requests" on public.connection_requests for select to authenticated using((select auth.uid()) = sender_id or exists(select 1 from public.listings where id=item_id and owner_id=(select auth.uid())));
create policy "Send requests to people and places" on public.connection_requests for insert to authenticated with check((select auth.uid()) = sender_id and exists(select 1 from public.listings where id=item_id and kind in ('people','places')));
create policy "Members read discussions" on public.posts for select to authenticated using(exists(select 1 from public.memberships where item_id=posts.item_id and user_id=(select auth.uid())));
create policy "Members post discussions" on public.posts for insert to authenticated with check((select auth.uid()) = user_id and exists(select 1 from public.memberships join public.listings on listings.id=memberships.item_id where memberships.item_id=posts.item_id and memberships.user_id=(select auth.uid()) and listings.kind='communities'));
create policy "Authors remove posts" on public.posts for delete to authenticated using((select auth.uid()) = user_id);
grant select on public.listings to anon,authenticated;
grant insert,update,delete on public.listings to authenticated;
grant select,insert,update,delete on public.bookmarks to authenticated;
grant select,insert,delete on public.memberships to authenticated;
grant select,insert on public.connection_requests to authenticated;
grant select,insert,delete on public.posts to authenticated;
