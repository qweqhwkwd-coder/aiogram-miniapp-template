import hashlib
import hmac
import json
from datetime import datetime
from datetime import timezone
from typing import Any
from urllib.parse import parse_qs


def validate_init_data(
    init_data: str,
    bot_token: str,
    max_age_seconds: int = 3600,
) -> dict[str, Any] | None:
    """
    Validate initData from Telegram WebApp.

    Args:
        init_data: Raw initData string from Telegram WebApp
        bot_token: Bot token for HMAC validation
        max_age_seconds: Maximum age of initData in seconds (default: 1 hour)

    Returns:
        Parsed user data dict if valid, None otherwise.
    """
    try:
        parsed = parse_qs(init_data)

        received_hash = parsed.get("hash", [None])[0]
        if not received_hash:
            return None

        auth_date_str = parsed.get("auth_date", [None])[0]
        if not auth_date_str:
            return None

        try:
            auth_date = int(auth_date_str)
        except ValueError:
            return None

        current_timestamp = int(datetime.now(timezone.utc).timestamp())
        age = current_timestamp - auth_date

        if age > max_age_seconds:
            return None

        if age < 0:
            return None

        data_check_list = []
        for key in sorted(parsed.keys()):
            if key != "hash":
                data_check_list.append(f"{key}={parsed[key][0]}")

        data_check_string = "\n".join(data_check_list)

        secret_key = hmac.new(
            key=b"WebAppData",
            msg=bot_token.encode(),
            digestmod=hashlib.sha256,
        ).digest()

        calculated_hash = hmac.new(
            key=secret_key,
            msg=data_check_string.encode(),
            digestmod=hashlib.sha256,
        ).hexdigest()

        if not hmac.compare_digest(calculated_hash, received_hash):
            return None

        user_data = parsed.get("user", [None])[0]
        if user_data:
            return json.loads(user_data)

        return None
    except Exception:
        return None
