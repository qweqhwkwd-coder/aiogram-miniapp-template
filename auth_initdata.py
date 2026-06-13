"""
auth_initdata.py — верификация Telegram Mini App initData (референс).

Шаблон MrConsoleka/aiogram-miniapp-template, скорее всего, уже содержит
свою реализацию авторизации. Этот файл — эталон, с которым стоит сверить
шаблонную версию (алгоритм по спецификации Telegram). Если в шаблоне всё
ок — этот файл можно не использовать.

Алгоритм (Telegram WebApp):
  1. Разобрать initData как query-string в пары ключ=значение.
  2. Вынуть hash.
  3. Отсортировать оставшиеся пары по ключу, склеить как "k=v" через \\n.
  4. secret = HMAC_SHA256(key="WebAppData", msg=bot_token).
  5. Сверить HMAC_SHA256(key=secret, msg=data_check_string) с hash.
"""

import hashlib
import hmac
import json
import time
from urllib.parse import parse_qsl


def verify_init_data(
    init_data: str, bot_token: str, max_age_sec: int = 86400
) -> dict | None:
    """Возвращает разобранный dict при валидной подписи, иначе None."""
    pairs = dict(parse_qsl(init_data, strict_parsing=False))
    received_hash = pairs.pop("hash", None)
    if not received_hash:
        return None

    data_check_string = "\n".join(f"{k}={pairs[k]}" for k in sorted(pairs))

    secret_key = hmac.new(
        b"WebAppData", bot_token.encode(), hashlib.sha256
    ).digest()
    computed = hmac.new(
        secret_key, data_check_string.encode(), hashlib.sha256
    ).hexdigest()

    if not hmac.compare_digest(computed, received_hash):
        return None

    # Защита от replay: initData не должна быть слишком старой.
    auth_date = pairs.get("auth_date")
    if auth_date and (time.time() - int(auth_date)) > max_age_sec:
        return None

    # Поле user приходит как JSON-строка — разворачиваем для удобства.
    if "user" in pairs:
        try:
            pairs["user"] = json.loads(pairs["user"])
        except (ValueError, TypeError):
            pass

    return pairs
