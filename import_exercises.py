"""
import_exercises.py — разовый импорт free-exercise-db в таблицу exercises.

Запускается ЛОКАЛЬНО (нужен сетевой доступ к GitHub + service_role ключ):

    pip install httpx supabase
    SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... python import_exercises.py

Источник данных: yuhonas/free-exercise-db (public domain, ~800 упражнений).
Импорт идемпотентный — повторный запуск не создаёт дублей (upsert по ext_id).
"""

import os
import sys

import httpx
from supabase import create_client

# Один JSON-файл со всеми упражнениями в репозитории free-exercise-db.
DATA_URL = (
    "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json"
)
# База, от которой строятся пути к картинкам в этом репозитории.
IMG_BASE = (
    "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"
)


def main() -> int:
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
    if not url or not key:
        print("Нужны переменные SUPABASE_URL и SUPABASE_SERVICE_ROLE_KEY", file=sys.stderr)
        return 1

    print("Скачиваю free-exercise-db…")
    raw = httpx.get(DATA_URL, timeout=60).json()
    print(f"Получено упражнений: {len(raw)}")

    rows = []
    for ex in raw:
        rows.append(
            {
                "ext_id": ex.get("id"),
                "name": ex.get("name"),
                "category": ex.get("category"),
                # в схеме free-exercise-db это поле — массив; берём первый элемент
                "equipment": ex.get("equipment"),
                "primary_muscles": ex.get("primaryMuscles") or [],
                "secondary_muscles": ex.get("secondaryMuscles") or [],
                "level": ex.get("level"),
                "instructions": ex.get("instructions") or [],
                "image_urls": [IMG_BASE + p for p in (ex.get("images") or [])],
            }
        )

    sb = create_client(url, key)

    # Грузим пачками — upsert по ext_id (уникальный индекс в схеме).
    BATCH = 200
    for i in range(0, len(rows), BATCH):
        chunk = rows[i : i + BATCH]
        sb.table("exercises").upsert(chunk, on_conflict="ext_id").execute()
        print(f"Загружено {min(i + BATCH, len(rows))}/{len(rows)}")

    print("Готово. Таблица exercises заполнена.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
