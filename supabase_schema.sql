-- USERS TABLE
create table if not exists users (
    id uuid primary key default uuid_generate_v4(),
    username text not null unique,
    age int,
    photo_url text,
    location_tag text,
    race_preferences text,
    car_id uuid references cars(id)
);

-- CARS TABLE
create table if not exists cars (
    id uuid primary key default uuid_generate_v4(),
    make text not null,
    model text not null,
    year int,
    mods text,
    photo_url text,
    owner_id uuid references users(id)
);

-- MATCHES TABLE
create table if not exists matches (
    id uuid primary key default uuid_generate_v4(),
    user1_id uuid not null references users(id),
    user2_id uuid not null references users(id),
    timestamp timestamptz not null default now()
);

-- MESSAGES TABLE
create table if not exists messages (
    id uuid primary key default uuid_generate_v4(),
    content text not null,
    timestamp timestamptz not null default now(),
    sender_id uuid not null references users(id),
    match_id uuid not null references matches(id)
);

-- INDEXES FOR PERFORMANCE
create index if not exists idx_cars_owner_id on cars(owner_id);
create index if not exists idx_matches_user1_id on matches(user1_id);
create index if not exists idx_matches_user2_id on matches(user2_id);
create index if not exists idx_messages_match_id on messages(match_id);
create index if not exists idx_messages_sender_id on messages(sender_id);
-- For chats list: fast latest-message lookup per match
create index if not exists idx_messages_match_id_timestamp on messages(match_id, timestamp desc);

-- The schema above supports a chats list (all matches for a user, with latest message per match). 