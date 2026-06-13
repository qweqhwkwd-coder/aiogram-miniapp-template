# MY-OS — Фаза 0: Настройка стека

Чеклист «Дня 1–5» из роадмапа. Помечено, **что уже сделано в этих файлах**
и **что делаешь ты сам** (аккаунты, креды, деплой — у меня к ним нет доступа).

> Документ местами пишет «Railway», но секции 13 и финальный план выбирают
> **Render** (бесплатный навсегда vs 30 дней у Railway). Везде ниже — Render.

---

## Что уже готово в этом наборе файлов

| Файл | Что это | Шаг роадмапа |
|---|---|---|
| `db/migrations/001_initial_schema.sql` | Все 27 таблиц v1 + RLS на каждой + индексы | День 3 (ядро) |
| `scripts/import_exercises.py` | Импорт free-exercise-db в `exercises` (идемпотентный) | День 3 |
| `backend/config.py` | pydantic-settings конфиг | День 5 |
| `backend/auth_initdata.py` | Эталонная верификация initData (сверить с шаблоном) | День 4 |
| `backend/requirements.txt` | Зависимости бэкенда | День 2 |
| `Dockerfile` | Под Render, 1 worker / 512MB | День 2 |
| `.env.example` | Все ключи с плейсхолдерами | День 1–2 |
| `.gitignore` | Чтобы `.env` не утёк в git | День 1 |

**Не включено намеренно:** биометрия/носимые устройства (секция 16 — это v2);
полный `main.py` с обвязкой aiogram↔FastAPI — её даёт клонируемый шаблон,
дублировать нельзя.

---

## Что делаешь ты (нужны твои аккаунты)

### День 1
- [ ] `git clone https://github.com/MrConsoleka/aiogram-miniapp-template` — основа проекта.
- [ ] Создать проект на supabase.com. Скопировать `URL`, `anon key`, `service_role key` в `.env`.
- [ ] @BotFather → `/newbot` → получить `BOT_TOKEN` → в `.env`.
- [ ] Скопировать файлы из этого набора в клон шаблона, сверив структуру (config, миграции, Dockerfile, .gitignore, .env.example).

### День 2 — Render
- [ ] render.com → New → Web Service → подключить GitHub-репо.
- [ ] Runtime: Docker (использует `Dockerfile`). Plan: Free.
- [ ] Добавить все переменные из `.env` в Environment Render.
- [ ] Дождаться деплоя, проверить `GET /health` → 200.
- [ ] Uptime Robot: мониторы на `…onrender.com/health` и Supabase URL, каждые 5 мин (анти-сон).

### День 3 — БД
- [ ] Установить Supabase CLI, `supabase init`, `supabase link`.
- [ ] Положить `001_initial_schema.sql` в `supabase/migrations/`, затем `supabase db push`.
- [ ] Прогнать `python scripts/import_exercises.py` локально (нужны `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY`). Проверить, что в `exercises` ~800 строк.
- [ ] `supabase gen types typescript --linked > frontend/src/types/supabase.ts`.

### День 4 — Mini App ↔ бот
- [ ] @BotFather → Mini App / кнопка меню → указать публичный URL фронта.
- [ ] Настроить вебхук бота на `WEBHOOK_BASE_URL` (как в шаблоне).
- [ ] Сверить авторизацию шаблона с `backend/auth_initdata.py`. Открыть Mini App из Telegram → «Hello World» рендерится, initData проходит проверку.

### День 5 — фронт-каркас
- [ ] Настроить TanStack Query + Zustand + shadcn/ui (Фаза 1 продолжит дизайн-систему).
- [ ] Bottom Tab Bar (5 вкладок) + FAB открывается/закрывается.

---

## Проверка RLS (обязательно перед любыми данными)

После `db push` в Supabase SQL Editor:

```sql
-- Все пользовательские таблицы должны иметь rowsecurity = true.
-- exercises тоже true (но с публичной политикой на чтение).
select relname, relrowsecurity
from pg_class
where relkind = 'r' and relnamespace = 'public'::regnamespace
order by relname;
```

Если у какой-то таблицы `relrowsecurity = false` — данные не изолированы, чинить
до того, как появятся реальные записи.

---

## Замечание по auth.uid()

RLS-политики используют `auth.uid()`. Это работает, только если JWT, которым
ходит фронт/бэк от имени пользователя, имеет `sub = users.id`. Авторизация в
проекте кастомная (через initData), поэтому при онбординге бэкенд должен
выставлять `users.id` так, чтобы он совпадал с `sub` выдаваемого токена.
Если позже переедешь на Supabase Auth — добавь FK `users.id → auth.users(id)`.
