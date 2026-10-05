FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY app/ ./

RUN pip install --no-cache-dir -e . waitress \
    && useradd --create-home appuser \
    && mkdir -p /app/instance \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["waitress-serve", "--listen=0.0.0.0:8080", "--call", "flaskr:create_app"]
