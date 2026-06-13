-- ============================================================================
-- MY-OS · 001_initial_schema.sql
-- Полная схема v1 + Row Level Security на всех пользовательских таблицах.
--
-- Источник: Product Document v1.0, секция 6 ("Структура базы данных")
-- и секция 12 ("Supabase RLS").
--
-- НЕ включено намеренно: biometrics / sleep_stages / integrations
-- (секция 16 — носимые устройства — это v2, явно вне scope v1).
--
-- Замечание про auth.uid():
--   RLS-паттерн из документа — `user_id = auth.uid()`. Это означает, что JWT,
--   которым ходит пользователь, должен иметь sub = users.id. Авторизация в
--   проекте кастомная (Telegram initData), поэтому users.id НЕ ссылается на
--   auth.users — его выставляет бэкенд при онбординге так, чтобы он совпадал
--   с sub в выдаваемом JWT. Если позже перейдёшь на Supabase Auth — добавь
--   FK users.id -> auth.users(id).
-- ============================================================================

create extension if not exists pgcrypto;  -- gen_random_uuid()

-- ----------------------------------------------------------------------------
-- ПОЛЬЗОВАТЕЛИ
-- ----------------------------------------------------------------------------
create table users (
  id           uuid primary key default gen_random_uuid(),  -- = auth.uid()
  telegram_id  bigint unique not null,
  name         text,
  photo_url    text,
  weight       numeric,
  height       numeric,
  age          int,
  kcal_goal    int,
  protein_goal int,
  fat_goal     int,
  carb_goal    int,
  water_goal   int,
  timezone     text default 'Europe/Warsaw',
  language     text default 'ru',          -- 'ru' | 'ua' | 'en'
  onboarding_completed boolean not null default false,
  created_at   timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- RPG-СТАТЫ
-- ----------------------------------------------------------------------------
create table user_stats (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references users(id) on delete cascade,
  strength    int not null default 0,
  endurance   int not null default 0,
  nutrition   int not null default 0,
  discipline  int not null default 0,
  reflection  int not null default 0,
  level       int not null default 0,
  xp          int not null default 0,
  updated_at  timestamptz not null default now(),
  unique (user_id)
);

create table stats_history (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references users(id) on delete cascade,
  date        date not null,
  strength    int not null default 0,
  endurance   int not null default 0,
  nutrition   int not null default 0,
  discipline  int not null default 0,
  reflection  int not null default 0,
  level       int not null default 0
);

create table xp_events (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  source_module text not null,
  source_id     uuid,
  stat_affected text not null,  -- strength|endurance|nutrition|discipline|reflection
  xp_amount     int not null,
  created_at    timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- ЗАДАЧИ
-- ----------------------------------------------------------------------------
create table tasks (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references users(id) on delete cascade,
  title           text not null,
  description     text,
  priority        text default 'green',   -- red|yellow|green
  tag             text,                    -- work|personal|sport|health|finance
  deadline        timestamptz,
  is_recurring    boolean not null default false,
  recurrence_rule text,                    -- daily|weekly|custom (RRULE-like)
  parent_task_id  uuid references tasks(id) on delete cascade,
  is_completed    boolean not null default false,
  completed_at    timestamptz,
  is_archived     boolean not null default false,
  created_at      timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- РИТУАЛЫ + ВОДА
-- ----------------------------------------------------------------------------
create table rituals (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  title         text not null,
  icon          text,
  reminder_time time,
  days_of_week  int[] default '{0,1,2,3,4,5,6}',  -- 0=вс ... 6=сб
  is_active     boolean not null default true,
  created_at    timestamptz not null default now()
);

create table ritual_logs (
  id         uuid primary key default gen_random_uuid(),
  ritual_id  uuid not null references rituals(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  date       date not null,
  is_done    boolean not null default false,
  unique (ritual_id, date)
);

create table water_logs (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references users(id) on delete cascade,
  date       date not null,
  amount_ml  int not null default 0
);

-- ----------------------------------------------------------------------------
-- ВСТРЕЧИ
-- ----------------------------------------------------------------------------
create table meetings (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references users(id) on delete cascade,
  title        text not null,
  description  text,
  datetime     timestamptz not null,
  duration_min int,
  location     text,
  participants jsonb,
  status       text default 'planned',  -- planned|done|cancelled
  created_at   timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- ТРЕНИРОВКИ
-- ----------------------------------------------------------------------------
create table activity_templates (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  name          text not null,
  emoji         text,
  category      text not null,            -- cardio|strength|mixed|flexibility
  fields_schema jsonb,                    -- какие поля собирать
  sort_order    int default 0,
  use_count     int not null default 0,
  created_at    timestamptz not null default now()
);

create table workouts (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references users(id) on delete cascade,
  template_id     uuid references activity_templates(id) on delete set null,
  activity_name   text not null,
  category        text,
  date            date not null,
  duration_min    int,
  structured_data jsonb,                  -- специфичные поля активности
  notes           text,
  feedback        text,                   -- easy|normal|hard
  feedback_detail text,
  created_at      timestamptz not null default now()
);

-- Общая база упражнений (free-exercise-db). Публичная, без привязки к user_id.
create table exercises (
  id                uuid primary key default gen_random_uuid(),
  ext_id            text unique,          -- id из free-exercise-db (для идемпотентного импорта)
  name              text not null,
  category          text,
  equipment         text,
  primary_muscles   text[],
  secondary_muscles text[],
  level             text,
  instructions      text[],
  image_urls        text[]
);

-- ----------------------------------------------------------------------------
-- ПИТАНИЕ
-- ----------------------------------------------------------------------------
create table food_logs (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references users(id) on delete cascade,
  meal_type  text,                        -- breakfast|lunch|dinner|snack
  date       date not null,
  food_name  text not null,
  kcal       numeric,
  protein    numeric,
  fat        numeric,
  carbs      numeric,
  photo_url  text,
  source     text default 'manual',       -- manual|openfoodfacts|claude_vision
  ai_comment text,
  created_at timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- ДНЕВНИК
-- ----------------------------------------------------------------------------
create table diary_entries (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references users(id) on delete cascade,
  content    text,
  mood       int,                         -- 1..5
  tags       text[],
  voice_url  text,
  photo_url  text,
  created_at timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- ЦЕЛИ
-- ----------------------------------------------------------------------------
create table goals (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references users(id) on delete cascade,
  title          text not null,
  description    text,
  sphere         text,                    -- health|finance|career|...
  metric_type    text,                    -- number|percent|checkbox
  metric_target  numeric,
  metric_current numeric default 0,
  deadline       timestamptz,
  status         text default 'active',   -- active|done|archived
  created_at     timestamptz not null default now()
);

-- В документе goal_milestones без user_id. Добавлен user_id для единообразного
-- RLS-паттерна `user_id = auth.uid()` и производительности (без подзапроса).
create table goal_milestones (
  id      uuid primary key default gen_random_uuid(),
  goal_id uuid not null references goals(id) on delete cascade,
  user_id uuid not null references users(id) on delete cascade,
  title   text not null,
  is_done boolean not null default false
);

-- ----------------------------------------------------------------------------
-- ИДЕИ
-- ----------------------------------------------------------------------------
create table ideas (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references users(id) on delete cascade,
  content        text not null,
  tags           text[],
  status         text default 'raw',      -- raw|in_progress|done|postponed
  linked_task_id uuid references tasks(id) on delete set null,
  created_at     timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- AI-ТРЕНЕР
-- ----------------------------------------------------------------------------
create table athletic_profiles (
  id                     uuid primary key default gen_random_uuid(),
  user_id                uuid not null references users(id) on delete cascade,
  experience_json        jsonb,
  goals_json             jsonb,
  limitations_json       jsonb,
  equipment_json         jsonb,
  training_days_per_week int,
  preferences_json       jsonb,
  unique (user_id)
);

create table fitness_tests (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references users(id) on delete cascade,
  test_date      date not null,
  pushups_max    int,
  pullups_max    int,
  plank_sec      int,
  cooper_meters  int,
  swim_100m_sec  int,
  forward_bend_cm numeric,
  notes          text
);

create table training_programs (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references users(id) on delete cascade,
  name           text not null,
  goal           text,
  duration_weeks int,
  program_json   jsonb,
  is_active      boolean not null default true,
  created_at     timestamptz not null default now()
);

create table planned_workouts (
  id              uuid primary key default gen_random_uuid(),
  program_id      uuid not null references training_programs(id) on delete cascade,
  user_id         uuid not null references users(id) on delete cascade,
  scheduled_date  date not null,
  workout_json    jsonb,
  status          text default 'planned',  -- planned|done|skipped
  feedback        text,
  feedback_detail text
);

-- ----------------------------------------------------------------------------
-- СОН
-- ----------------------------------------------------------------------------
create table sleep_logs (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references users(id) on delete cascade,
  sleep_at     timestamptz,
  wake_at      timestamptz,
  duration_min int,
  quality      int,                       -- 1..5
  notes        text,
  created_at   timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- ФИНАНСЫ
-- ----------------------------------------------------------------------------
create table transactions (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references users(id) on delete cascade,
  amount     numeric not null,
  currency   text default 'PLN',
  category   text,
  notes      text,
  date       date not null,
  type       text default 'expense',      -- expense|income
  created_at timestamptz not null default now()
);

create table budgets (
  id       uuid primary key default gen_random_uuid(),
  user_id  uuid not null references users(id) on delete cascade,
  category text not null,
  amount   numeric not null,
  currency text default 'PLN',
  month    date not null,                 -- первое число месяца
  unique (user_id, category, month)
);

-- ----------------------------------------------------------------------------
-- ЗАМЕРЫ ТЕЛА
-- ----------------------------------------------------------------------------
create table body_measurements (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references users(id) on delete cascade,
  date         date not null,
  weight_kg    numeric,
  body_fat_pct numeric,
  waist_cm     numeric,
  hips_cm      numeric,
  chest_cm     numeric,
  bicep_cm     numeric,
  thigh_cm     numeric,
  photo_url    text,
  created_at   timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- INBOX
-- ----------------------------------------------------------------------------
create table inbox_items (
  id                   uuid primary key default gen_random_uuid(),
  user_id              uuid not null references users(id) on delete cascade,
  content              text,
  type                 text default 'text',  -- text|voice|photo
  media_url            text,
  ai_suggested_module  text,
  status               text default 'new',   -- new|processed|dismissed
  created_at           timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- КОЛЕСО БАЛАНСА
-- ----------------------------------------------------------------------------
create table life_balance (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  week_date     date not null,            -- понедельник недели
  health        int,
  finance       int,
  career        int,
  relationships int,
  growth        int,
  creativity    int,
  rest          int,
  spirituality  int,
  notes         text,
  created_at    timestamptz not null default now(),
  unique (user_id, week_date)
);

-- ============================================================================
-- ИНДЕКСЫ — типичный паттерн запросов "по пользователю и дате"
-- ============================================================================
create index idx_tasks_user            on tasks(user_id, is_completed, deadline);
create index idx_ritual_logs_user_date on ritual_logs(user_id, date);
create index idx_water_user_date       on water_logs(user_id, date);
create index idx_meetings_user_dt      on meetings(user_id, datetime);
create index idx_workouts_user_date    on workouts(user_id, date);
create index idx_food_user_date        on food_logs(user_id, date);
create index idx_diary_user_created    on diary_entries(user_id, created_at);
create index idx_goals_user_status     on goals(user_id, status);
create index idx_ideas_user            on ideas(user_id, status);
create index idx_sleep_user            on sleep_logs(user_id, sleep_at);
create index idx_tx_user_date          on transactions(user_id, date);
create index idx_body_user_date        on body_measurements(user_id, date);
create index idx_inbox_user_status     on inbox_items(user_id, status);
create index idx_balance_user_week     on life_balance(user_id, week_date);
create index idx_planned_user_date     on planned_workouts(user_id, scheduled_date);
create index idx_stats_hist_user_date  on stats_history(user_id, date);
create index idx_xp_user_created       on xp_events(user_id, created_at);
create index idx_exercises_category    on exercises(category);

-- ============================================================================
-- ROW LEVEL SECURITY
-- Паттерн из секции 12: владелец строки = auth.uid().
-- users: проверка по id; все остальные пользовательские таблицы: по user_id.
-- exercises: публичное чтение, без записи через anon.
-- ============================================================================

-- users (особый случай: ключ — id)
alter table users enable row level security;
create policy "users_self" on users
  for all using (id = auth.uid()) with check (id = auth.uid());

-- макрос вручную: одинаковая политика для всех таблиц с user_id
do $$
declare
  t text;
  user_tables text[] := array[
    'user_stats','stats_history','xp_events','tasks','rituals','ritual_logs',
    'water_logs','meetings','activity_templates','workouts','food_logs',
    'diary_entries','goals','goal_milestones','ideas','athletic_profiles',
    'fitness_tests','training_programs','planned_workouts','sleep_logs',
    'transactions','budgets','body_measurements','inbox_items','life_balance'
  ];
begin
  foreach t in array user_tables loop
    execute format('alter table %I enable row level security;', t);
    execute format(
      'create policy %I on %I for all using (user_id = auth.uid()) with check (user_id = auth.uid());',
      'user_owns_' || t, t
    );
  end loop;
end $$;

-- exercises: общая публичная база (только чтение для anon/authenticated)
alter table exercises enable row level security;
create policy "exercises_public_read" on exercises
  for select using (true);

-- ============================================================================
-- КОНЕЦ 001_initial_schema.sql
-- ============================================================================
