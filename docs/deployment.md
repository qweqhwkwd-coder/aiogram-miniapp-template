# Deployment

## Docker

1. Build image:
   `make docker-build`
2. Start services:
   `make docker-up`
3. View logs:
   `make docker-logs SERVICE=bot`

## Environment

- Set `ENVIRONMENT=production` in `.env` for production.
- Run Alembic migrations before starting the bot.
