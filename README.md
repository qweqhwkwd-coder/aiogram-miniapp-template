<div align="center">

<img width="250" height="250" alt="image" src="https://github.com/user-attachments/assets/a67162ea-bf43-4713-a27e-0581a8534b5b" />

<h1>Aiogram Bot Template</h1>

<img alt="Static Badge" src="https://img.shields.io/badge/tag-v1.1-8A2BE2?style=flat&logo=task&logoColor=8A2BE2&labelColor=gray">
<img alt="Static Badge" src="https://img.shields.io/badge/python-v3.12-FBDE02?style=flat&logo=python&logoColor=FBDE02&labelColor=gray">
<img alt="Static Badge" src="https://img.shields.io/badge/license-MIT-12C4C4?style=flat&logo=gitbook&logoColor=12C4C4">
<br>
<img alt="Static Badge" src="https://img.shields.io/badge/Aiogram-v3.22.0-blue?style=flat">

</div>

## 📌 Description
⠀

**Aiogram Bot Template** — This template helps you quickly bootstrap Telegram bots on the `aiogram` 3.x stack. It already includes a ready project structure, command and message handlers, optional PostgreSQL/Redis integration, logging with `loguru`, internationalization, support for `aiogram-dialog`, and dependency injection via `dishka` with optional webhook handling on `FastAPI`. The template is designed to remove routine setup and let you focus on your bot’s logic.

⠀
## 🔨 Functions
⠀

*   `/start` - Start the bot
*   `/language` - Change language
*   `/help` - Help
*   `/admin` - Command for administrators
*   `/dialog` - Demo dialog using `aiogram-dialog`
*   `/fsm` - Demo finite state machine form

⠀
## 🗂️ Template structure
⠀

```
📁 aiogram_bot_template/
├───┐ 📂 .github/
│   └───┐ 📂 ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
│
├───┐ 📂 source/
│   ├───┐ 📂 config/
│   │   ├── __init__.py
│   │   └── config_reader.py
│   │
│   ├───┐ 📂 constants/
│   │   ├── __init__.py
│   │   ├── throttling.py
│   │   └── logging.py
│   │
│   ├───┐ 📂 data/
│   │   ├── __init__.py
│   │   ├── 📂 error_logs/
│   │   └── 📂 full_logs/
│   │
│   ├───┐ 📂 database/
│   │   ├───┐ 📂 core/
│   │   │   ├── __init__.py
│   │   │   └── manager.py
│   │   │
│   │   ├───┐ 📂 models/
│   │   │   ├── __init__.py
│   │   │   ├── base.py
│   │   │   └── user.py
│   │   │
│   │   ├───┐ 📂 repositories/
│   │   │   ├── __init__.py
│   │   │   ├── base.py
│   │   │   └── user.py
│   │   │
│   │   ├───┐ 📂 tools/
│   │   │   ├── __init__.py
│   │   │   ├── mixin.py
│   │   │   └── uow.py
│   │   │
│   │   └── __init__.py
│   │
│   ├───┐ 📂 enums/
│   │   ├── __init__.py
│   │   └── roles.py
│   │
│   ├───┐ 📂 factory/
│   │   ├── __init__.py
│   │   ├── bot.py
│   │   ├── dispatcher.py
│   │   ├── dishka.py
│   │   └── server.py
│   │
│   ├───┐ 📂 locales/
│   │   ├───┐ 📂 en/
│   │   │   ├── buttons.ftl
│   │   │   └── messages.ftl
│   │   └───┐ 📂 ru/
│   │       ├── buttons.ftl
│   │       └── messages.ftl
│   │
│   ├───┐ 📂 services/
│   │   ├── __init__.py
│   │   └── user_service.py
│   │
│   ├───┐ 📂 telegram/
│   │   ├───┐ 📂 filters/
│   │   │   ├── __init__.py
│   │   │   ├── admin_protect.py
│   │   │   └── chat_type.py
│   │   │
│   │   ├───┐ 📂 handlers/
│   │   │   ├───┐ 📂 admin/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── callbacks.py
│   │   │   │   ├── commands.py
│   │   │   │   ├── fsm.py
│   │   │   │   └── messages.py
│   │   │   ├───┐ 📂 errors/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── common.py
│   │   │   │   ├── orm.py
│   │   │   │   └── telegram.py
│   │   │   └───┐ 📂 user/
│   │   │       ├── __init__.py
│   │   │       ├── callbacks.py
│   │   │       ├── commands.py
│   │   │       ├── fsm.py
│   │   │       └── messages.py
│   │   │
│   │   ├───┐ 📂 keyboards/
│   │   │   ├── __init__.py
│   │   │   ├── builder.py
│   │   │   ├── callback_factory.py
│   │   │   ├── inline.py
│   │   │   └── reply.py
│   │   │
│   │   ├───┐ 📂 middlewares/
│   │   │   ├── __init__.py
│   │   │   ├── callback_throttling.py
│   │   │   ├── message_throttling.py
│   │   │   └── reporting.py
│   │   │
│   │   ├───┐ 📂 states/
│   │   │   ├── __init__.py
│   │   │   ├── dialog.py
│   │   │   └── form.py
│   │   │
│   │   └───┐ 📂 dialogs/
│   │       ├── __init__.py
│   │       └── dialog.py
│   │
│   ├───┐ 📂 utils/
│   │   ├── __init__.py
│   │   ├── logger.py
│   │   ├── set_commands.py
│   │   └── translator.py
│   │
│   └── 📄 __main__.py
│
├── .env.example
├── .dockerignore
├── .gitignore
├── Dockerfile
├── LICENSE
├── Makefile
├── SECURITY.md
├── docker-compose.yml
├── pyproject.toml
└── README.md
```

⠀
## 📋 About the content
⠀

*   `📁 source/` - Main application source code.
*   `📁 source/config/` - Application configuration settings.
*   `📁 source/constants/` - Project constants.
*   `📁 source/data/` - Data generated by the application (e.g., logs).
*   `📁 source/data/error_logs/` - Log files containing only errors.
*   `📁 source/data/full_logs/` - Full log files.
*   `📁 source/database/` - Database interaction logic.
*   `📁 source/database/core/` - Database core modules (connection, sessions).
*   `📁 source/database/models/` - Database model definitions.
*   `📁 source/database/repositories/` - Repositories for database data access.
*   `📁 source/database/specifications/` - Query specifications.
*   `📁 source/database/tools/` - Helper tools for working with the database.
*   `📁 source/domain/` - Domain events and value objects.
*   `📁 source/dto/` - Data transfer objects.
*   `📁 source/enums/` - Enum definitions.
*   `📁 source/factory/` - Factories for creating the bot, dispatcher, webhook server and DI container.
*   `📁 source/infrastructure/` - External integrations (cache, monitoring).
*   `📁 source/locales/` - Localization files (translations).
*   `📁 source/locales/en/` - English language localization.
*   `📁 source/locales/ru/` - Russian language localization.
*   `📁 source/services/` - Business logic layer.
*   `📁 source/telegram/` - Components related to Telegram and `aiogram`.
*   `📁 source/telegram/filters/` - Custom `aiogram` filters.
*   `📁 source/telegram/handlers/` - Handlers for processing Telegram updates.
*   `📁 source/telegram/handlers/admin/` - Handlers for administrators.
*   `📁 source/telegram/handlers/errors/` - Error handlers.
*   `📁 source/telegram/handlers/user/` - Handlers for users.
*   `📁 source/telegram/keyboards/` - Telegram keyboards.
*   `📁 source/telegram/middlewares/` - `aiogram` middlewares (throttling, error reporting).
*   `📁 source/telegram/states/` - `aiogram` FSM states.
*   `📁 source/telegram/dialogs/` - Dialog windows built with `aiogram-dialog`.
*   `📁 source/utils/` - Helper utilities (logger setup, commands, translations).
*   `📄 source/__main__.py` - Main entry point within the `source` package.
*   `📄 .env.example` - Example file for sensitive data (.env).
*   `📁 docs/` - Development and deployment documentation.
*   `📁 scripts/` - Helper scripts for development tasks.
*   `📁 tests/` - Test suite.

⠀
## ⚙️ Configuration
⠀

Before running the bot, you need to set up your environment variables. Copy the `.env.example` file to `.env` and fill in your credentials and settings:

```shell
cp .env.example .env
# Then edit the .env file with your configurations
```

⠀
## 🔓 Bot .env Variables
⠀

| Environment Variable Name | Description |
|---------------------------|-------------|
| ENVIRONMENT               | Application environment (`development`, `test`, `production`). |
| TG__WEBHOOK_USE           | Boolean value (`True`/`False`) indicating whether to use webhooks (`True`) or long polling (`False`). |
| TG__WEBHOOK_PATH          | Path for Telegram to send webhook updates (appended to `WEBHOOK__URL`). |
| TG__BOT_TOKEN             | Your Telegram bot token, obtained from `@BotFather` in Telegram. |
| TG__ADMIN_IDS             | List of Telegram user IDs (JSON list or comma-separated) who will have administrator rights in the bot. |
| WEBHOOK__URL              | Public URL where Telegram will send updates if webhooks are enabled. |
| WEBHOOK__HOST             | Host or IP address where the webhook server will listen for incoming connections (usually `0.0.0.0`). |
| WEBHOOK__PORT             | Port on which the webhook server will listen for incoming connections. |
| WEBHOOK__PATH             | Specific path on the server where Telegram will send POST requests with updates. |
| WEBHOOK__SECRET           | Secret token that Telegram includes in webhook request headers to verify authenticity. |
| DB__HOST                  | Database server host. |
| DB__PORT                  | Port for connecting to the database. |
| DB__USER                  | Username for database authentication. |
| DB__PASSWORD              | Password for database authentication. |
| DB__NAME                  | Name of the database to connect to. |
| REDIS__HOST               | Redis server host used for FSM and/or caching. |
| REDIS__PORT               | Port for connecting to the Redis server. |
| REDIS__USER               | Username for Redis authentication (if used). |
| REDIS__PASSWORD           | Password for Redis authentication (if used). |
| REDIS__DB                 | Redis database index to use (a number from 0 to 15, default is 0). |

⠀
## 💻 Bot Setup
⠀

### 📦 Using UV
⠀
1.  Clone the repository and navigate into the project directory:

    ```shell
     git clone https://github.com/MrConsoleka/aiogram-bot-template.git
     cd aiogram-bot-template
    ```

2.  Ensure you have `uv` installed. If not, you can install it, for example, using `pip`:

    ```shell
    pip install uv
    ```

3.  Create a virtual environment:

    ```shell
    make venv
    ```

4.  Activate the virtual environment:

    ```shell
    # For Linux or macOS:
    source .venv/bin/activate

    # For Windows:
    .venv\Scripts\activate
    ```

5.  Install dependencies:

    ```shell
    make install
    ```

6.  To run the bot, use the command:

    ```shell
    make run
    ```
⠀
### 📦 Using Docker
⠀
1.  Clone the repository and navigate into the project directory:

    ```shell
    git clone https://github.com/MrConsoleka/aiogram-bot-template.git
    cd aiogram-bot-template
    ```

2.  Build the Docker Image:

    ```shell
    make docker-build
    ```

3.  Run the Project with Docker Compose:

    ```shell
    make docker-up
    ```

4.  Verify Bot is Running (Optional):

    ```shell
    make docker-logs
    ```
    or
    ```shell
    make docker-logs SERVICE=bot
    ```

5.  Stop the Project:

    ```shell
    make docker-down
    ```

⠀
## 🗄️ Migrations
⠀

Create and apply migrations with Alembic:

```shell
make migration MESSAGE="create users"
uv run alembic upgrade head
```

⠀
## 🧪 Testing
⠀

Run tests locally:

```shell
uv run pytest tests/
```

⠀
## 🧰 Pre-commit
⠀

```shell
pre-commit install
pre-commit run --all-files
```

⠀
## 🧩 Development Services
⠀

```shell
make dev-up
make dev-down
```

⠀
## 📋 Todo List
⠀

- [x] touch the grass
- [x] Alembic
- [x] Aiogram-dialog
- [x] .github/workflows

⠀
## 🗃️ Stack of Technologies
⠀

*   [aiogram-3x](https://github.com/aiogram/aiogram) - Asynchronous framework for the Telegram Bot API.
*   [aiogram-dialog](https://github.com/aiogram/aiogram-dialog) - Dialog manager for building interactive flows.
*   [dishka](https://github.com/arslnk/dishka) - Dependency injection container.
*   [fastapi](https://github.com/tiangolo/fastapi) & [uvicorn](https://github.com/encode/uvicorn) - Webhook server stack.
*   [pydantic](https://github.com/pydantic/pydantic) & [pydantic-settings](https://github.com/pydantic/pydantic-settings) - Data validation and configuration management.
*   [postgresql](https://github.com/postgres/postgres) with [sqlalchemy](https://github.com/sqlalchemy/sqlalchemy) and [asyncpg](https://github.com/MagicStack/asyncpg?tab=readme-ov-file) - Database layer.
*   [redis](https://redis.io/) - In-memory data store for FSM and caching.
*   [loguru](https://github.com/Delgan/loguru) - Logging library.
*   [prometheus-client](https://github.com/prometheus/client_python) - Metrics exporter (optional).
*   [cachetools](https://github.com/tkem/cachetools) & [fluentogram](https://github.com/Arustinal/fluentogram) - Caching and localization helpers.
*   [Ruff](https://github.com/astral-sh/ruff), [Mypy](https://github.com/python/mypy), [Pre-commit](https://github.com/pre-commit/pre-commit), [Isort](https://github.com/pycqa/isort), [Black](https://github.com/psf/black) - Code quality and formatting tools.

⠀
## 💼 Credits
⠀

-   [aiogram_template](https://github.com/Lems0n/aiogram_template) - Inspired by Abdullah's project, many thanks to him <3

⠀
## 👤 Author of Aiogram Template Bot
⠀
**© Roman Alekseev**
