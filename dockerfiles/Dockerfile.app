ARG PYTHON_VERSION=3.10.12

FROM python:${PYTHON_VERSION}-alpine

RUN apk update && \
    apk add --no-cache --update musl-locales

ARG UID=499
ARG APP_USER=appuser
ARG FLASK_ENV

RUN addgroup -S ${APP_USER} && \
    adduser -S -H \
    -u "${UID}" \ 
    -G ${APP_USER} \
    ${APP_USER}

RUN mkdir -p /app && chown ${APP_USER}:${APP_USER} /app

WORKDIR /app

COPY --chown=${APP_USER}:${APP_USER} requirements/ requirements/

RUN --mount=type=cache,target=/root/.cache/pip \
    if [ "$FLASK_ENV" = "production" ]; then \
      echo "Using production requirements file"; \
      cp requirements/requirements_locked.txt /tmp/requirements.txt; \
    else \
      echo "Using development requirements file"; \
      cp requirements/requirements_locked_dev.txt /tmp/requirements.txt; \
    fi && \
    python -m pip install --upgrade pip && \
    python -m pip install -r /tmp/requirements.txt

COPY --chown=${APP_USER}:${APP_USER} entrypoints/flask_docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY --chown=${APP_USER}:${APP_USER} app/. .

EXPOSE 5000

USER ${APP_USER}

ENTRYPOINT ["/docker-entrypoint.sh"]