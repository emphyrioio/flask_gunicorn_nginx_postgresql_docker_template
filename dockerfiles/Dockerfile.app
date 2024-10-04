ARG PYTHON_VERSION=3.10.12

FROM python:${PYTHON_VERSION}-alpine

RUN apk add --no-cache --update musl-locales

ARG UID=499
ARG APP_USER=appuser

RUN addgroup -S ${APP_USER} && \
    adduser -S -H \
    -u "${UID}" \ 
    -G ${APP_USER} \
    ${APP_USER}

RUN mkdir -p /app && chown ${APP_USER}:${APP_USER} /app
WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements/requirements_locked.txt,target=requirements/requirements_locked.txt \
    python -m pip install --upgrade pip && \
    python -m pip install -r requirements/requirements_locked.txt    

COPY --chown=${APP_USER}:${APP_USER} entrypoints/flask_docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY --chown=${APP_USER}:${APP_USER} app/. .

EXPOSE 5000

USER ${APP_USER}

ENTRYPOINT ["/docker-entrypoint.sh"]