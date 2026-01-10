import hashlib
import hmac
from typing import Any
from urllib.parse import parse_qs


def validate_init_data(init_data: str, bot_token: str) -> dict[str, Any] | None:
    """
    Validate initData from Telegram WebApp.

    Returns parsed user data if valid, otherwise None.
    """
    try:
        parsed = parse_qs(init_data)

        received_hash = parsed.get("hash", [None])[0]
        if not received_hash:
            return None

        data_check_list = []
        for key, value in sorted(parsed.items()):
            if key != "hash":
                data_check_list.append(f"{key}={value[0]}")

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

        if calculated_hash != received_hash:
            return None

        user_data = parsed.get("user", [None])[0]
        if user_data:
            import json

            return json.loads(user_data)

        return None
    except Exception:
        return None
