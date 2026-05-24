# Build a Postgres image that runs nuq.sql during initdb
ARG PG_MAJOR=18
ARG VARIANT=alpine
FROM postgres:${PG_MAJOR}-${VARIANT}

ARG POSTGRES_DB=postgres

# Install pg_cron for the specified Postgres major version
RUN set -eux; \
    apk update; apk upgrade; \
    apk add --no-cache postgresql-pg_cron;

# Ensure pg_cron is preloaded on first startup by modifying the initdb template
# This must be set before the first server start (init scripts run after start)
RUN set -eux; \
    conf_sample="/usr/local/share/postgresql/postgresql.conf.sample"; \
    sed -ri "s/^#?shared_preload_libraries\s*=.*/shared_preload_libraries = 'pg_cron'/" "$conf_sample"; \
    printf "\n# Added for pg_cron\ncron.database_name = 'postgres'\n" >> "$conf_sample"

RUN ln -s /usr/lib/postgresql18/pg_cron.so /usr/local/lib/postgresql/pg_cron.so && \
    ln -s /usr/share/postgresql18/extension/pg_cron* /usr/local/share/postgresql/extension


# Copy nuq.sql so it is executed as part of the initdb sequence
COPY nuq.sql /docker-entrypoint-initdb.d/010-nuq.sql
# Copy tuning.sql so it is executed as part of the initdb sequence
COPY tuning.sql /docker-entrypoint-initdb.d/020-tuning.sql

