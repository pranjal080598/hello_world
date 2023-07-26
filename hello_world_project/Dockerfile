# We suggest using the major.minor tag, not major.minor.patch.
FROM python:3.7 AS builder

# Sets an environmental variable that ensures output from python is sent straight to the terminal without buffering it first
ENV PYTHONUNBUFFERED 1

WORKDIR /app/

############################# Application image ##############################

FROM python:3.7

# Choose an ID that will be consistent across all machines in the network
# To avoid overlap with user IDs, use an ID over
# /etc/login.defs:/UID_MAX/, which defaults to 60,000
ARG UID_GID=60004
ARG WSGI_USER=speech-db
# Create the user/group for the application
RUN groupadd --system --gid ${UID_GID} ${WSGI_USER} \
 && useradd --no-log-init --system --gid ${WSGI_USER} --uid ${UID_GID} ${WSGI_USER} \
 && mkdir /app \

USER ${WSGI_USER}:${WSGI_USER}
WORKDIR /app/

# Copies all files from our local project into the container
COPY --from=builder --chown=${WSGI_USER}:${WSGI_USER} /app/.venv /app/.venv
COPY --chown=${WSGI_USER}:${WSGI_USER} . .

ENV VIRTUAL_ENV="/app/.venv"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

EXPOSE 8000
ENV UWSGI_HTTP=:8000 UWSGI_MASTER=1 UWSGI_HTTP_KEEPALIVE=1 UWSGI_AUTO_CHUNKED=1 UWSGI_WSGI_ENV_BEHAVIOUR=holy
CMD ["uwsgi", "-w", "recvalsite.wsgi", "--processes", "10", "--static-map"]
