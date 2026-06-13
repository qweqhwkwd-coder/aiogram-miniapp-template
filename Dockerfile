FROM python:3.12-slim
WORKDIR /app

# Системные зависимости faster-whisper (ffmpeg) — раскомментируй на Фазе 4.
# RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg \
#     && rm -rf /var/lib/apt/lists/*

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

EXPOSE 8000
# Render отдаёт порт в $PORT. Free tier = 512MB RAM → строго 1 worker.
CMD gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:${PORT:-8000} --timeout 120
