# Development

## Setup

1. Create a virtual environment:
   `make venv`
2. Install dependencies:
   `make install`
3. Copy `.env.example` to `.env` and update values.

## Run locally

- Polling: `make run`
- Webhook (FastAPI): set `TG__WEBHOOK_USE=True`

## Migrations

- Create a migration: `make migration MESSAGE="create users"`
- Apply migrations: `uv run alembic upgrade head`

## Tests

- Run unit tests: `uv run pytest tests/`

## Pre-commit

- Install hooks: `pre-commit install`
- Run all hooks: `pre-commit run --all-files`
