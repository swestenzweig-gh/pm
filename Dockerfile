FROM python:3.12-slim AS base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

COPY backend/requirements.txt .
RUN uv pip install --system -r requirements.txt

COPY backend/ .

FROM base AS test

RUN uv pip install --system -r requirements-dev.txt
RUN pytest && touch /tmp/tests-passed

FROM base AS runtime

COPY --from=test /tmp/tests-passed /tmp/tests-passed

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
