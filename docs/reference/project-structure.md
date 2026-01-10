# Project Structure

## Tree
```text
aiogram-bot-template/
├── nginx/
├── docs/
├── migrations/
├── scripts/
├── source/
│   ├── api/
│   ├── config/
│   ├── constants/
│   ├── database/
│   ├── factory/
│   ├── infrastructure/
│   ├── locales/
│   ├── schemas/
│   ├── services/
│   ├── telegram/
│   └── utils/
├── tests/
├── webapp/
├── alembic.ini
├── docker-compose.dev.yml
├── docker-compose.yml
├── pyproject.toml
└── source/__main__.py
```

## Folders
- `docs/` short guides and reference docs.
- `nginx/` reverse proxy configs for API + WebApp.
- `source/config/` pydantic settings and env loading.
- `source/constants/` project constants.
- `source/database/` models, repositories, UnitOfWork.
- `source/api/` FastAPI backend for Mini Apps.
- `source/services/` business logic layer.
- `source/telegram/` handlers, routers, filters, dialogs.
- `source/schemas/` Pydantic schemas for the API.
- `source/factory/` bot/dispatcher/app/container wiring.
- `source/infrastructure/` cache and external integrations.
- `source/utils/` logger, i18n, helpers.
- `migrations/` Alembic migration scripts.
- `scripts/` CLI helpers for ops tasks.
- `webapp/` React Mini App frontend.

## Key files
- `.env.example` sample configuration values.
- `alembic.ini` Alembic config.
- `docker-compose.yml` production compose stack.
- `docker-compose.dev.yml` local DB/Redis stack.
- `source/__main__.py` app entry point.
