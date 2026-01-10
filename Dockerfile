FROM python:3.12-slim

WORKDIR /app

RUN pip install uv

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen

COPY source/ ./source/
COPY migrations/ ./migrations/
COPY alembic.ini ./

CMD ["uv", "run", "python", "-m", "source"]
