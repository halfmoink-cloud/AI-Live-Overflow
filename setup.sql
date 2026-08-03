-- SQL Script to initialize the tables for AI-Live-Overflow
-- Copy and run this in your Supabase SQL Editor!

-- 1. Table for tracking gesture logs (taps, double taps, etc.)
create table if not exists gesture_log (
    id bigserial primary key,
    gesture_type text not null,  -- tap, double_tap, long_press, fling
    x integer,
    y integer,
    created_at timestamptz default now()
);

-- Enable RLS and allow public access for anon key in personal project
alter table gesture_log enable row level security;
create policy "Allow public insert to gesture_log" on gesture_log for insert with check (true);
create policy "Allow public select to gesture_log" on gesture_log for select using (true);

-- 2. Table for tracking foreground app usage
create table if not exists app_usage (
    id bigserial primary key,
    package_name text not null,
    started_at timestamptz default now()
);

alter table app_usage enable row level security;
create policy "Allow public insert to app_usage" on app_usage for insert with check (true);
create policy "Allow public select to app_usage" on app_usage for select using (true);

-- 3. Table for syncing the AI pet state (mood, accessory, speech bubbles)
create table if not exists pet_state (
    id bigserial primary key,
    state_key text not null,     -- mood, accessory, speech_bubble
    state_value text,
    updated_at timestamptz default now()
);

alter table pet_state enable row level security;
create policy "Allow public insert to pet_state" on pet_state for insert with check (true);
create policy "Allow public select to pet_state" on pet_state for select using (true);
create policy "Allow public update to pet_state" on pet_state for update using (true);

-- Insert initial mood state so the app has something to read
insert into pet_state (state_key, state_value) values ('mood', 'normal') on conflict do nothing;
insert into pet_state (state_key, state_value) values ('speech_bubble', '阿郁！阿炽来啦！') on conflict do nothing;
