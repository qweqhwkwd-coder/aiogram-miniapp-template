# Architecture

This project follows a layered architecture with clear separation of concerns.

## Layers

- Presentation: Telegram handlers, dialogs, keyboards, filters, middlewares.
- Application: services and DTOs.
- Domain: domain events and value objects.
- Infrastructure: database, cache, monitoring, external services.

## Data flow

1. Update enters dispatcher and middlewares.
2. Handler calls a service.
3. Service uses Unit of Work and repositories.
4. Repository performs database operations.
5. Handler sends response back to Telegram.

## Database

- SQLAlchemy ORM models define schema.
- Alembic migrations manage schema changes.
- No destructive schema actions should be used in production.
