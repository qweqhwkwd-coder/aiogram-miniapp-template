"""
config.py — конфигурация из .env через pydantic-settings.

Если используешь шаблон MrConsoleka/aiogram-miniapp-template — у него свой
Settings-класс. Эти поля специфичны для MY-OS; добавь недостающие в шаблонный
конфиг, а не плоди два источника правды.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", extra="ignore"
    )

    # Telegram
    bot_token: str
    webhook_base_url: str = ""  # публичный URL Render, напр. https://my-os-backend.onrender.com

    # Supabase
    supabase_url: str
    supabase_anon_key: str           # запросы от пользователя (с JWT, RLS работает)
    supabase_service_role_key: str   # внутренние операции: отчёты, APScheduler (обходит RLS)

    # AI-провайдеры (могут быть пустыми на Фазе 0 — нужны с Фазы 4)
    gemini_api_key: str = ""
    groq_api_key: str = ""
    anthropic_api_key: str = ""

    # Runtime
    port: int = 8000
    timezone: str = "Europe/Warsaw"


settings = Settings()
