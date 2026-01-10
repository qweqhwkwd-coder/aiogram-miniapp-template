# Docker

## Development commands
Use the dev compose file for local DB/Redis.
```bash
docker compose -f docker-compose.dev.yml up -d
docker compose -f docker-compose.dev.yml logs -f
docker compose -f docker-compose.dev.yml down
```

## Production commands
Use Makefile wrappers for the main compose file.
```bash
make docker-build
make docker-up
make docker-logs SERVICE=bot
```

## Mini App stack
The production compose file includes `webapp` and `nginx`.
`nginx` exposes port 80 and proxies `/api` to the bot API and `/` to the WebApp.

## Useful commands
Quick helpers for common docker checks.
```bash
docker compose ps
docker compose logs -f --tail=200
docker compose exec db psql -U $DB__USER -d $DB__NAME
```
