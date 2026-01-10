from typing import Any

from source.config import settings


def cors_settings() -> dict[str, Any]:
    """
    CORS settings for FastAPI.
    Restricts access to Telegram WebApp and configured domains only.
    """
    allowed_origins = [
        "https://web.telegram.org",
        "https://webk.telegram.org",
        "https://webz.telegram.org",
    ]

    if hasattr(settings, "webapp") and settings.webapp.url:
        allowed_origins.append(settings.webapp.url)

    if getattr(settings, "environment", "production") == "development":
        allowed_origins.extend(
            [
                "http://localhost:5173",
                "http://localhost:3000",
                "http://127.0.0.1:5173",
                "http://127.0.0.1:3000",
            ]
        )

    return {
        "allow_origins": allowed_origins,
        "allow_credentials": True,
        "allow_methods": ["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
        "allow_headers": ["Authorization", "Content-Type", "X-Requested-With"],
        "max_age": 600,
    }
