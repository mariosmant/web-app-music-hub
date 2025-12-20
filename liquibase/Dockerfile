# ---------- Stage 1: Download Liquibase ----------
FROM eclipse-temurin:25-jdk AS liquibase-downloader

ARG LIQUIBASE_VERSION=4.29.0

# Install curl and tar (required for download + extraction)
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      tar \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/liquibase \
    && curl -L "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
       -o /tmp/liquibase.tar.gz \
    && tar -xzf /tmp/liquibase.tar.gz -C /opt/liquibase \
    && rm /tmp/liquibase.tar.gz


# ---------- Stage 2: Final runtime image ----------
FROM eclipse-temurin:25-jdk

COPY --from=liquibase-downloader /opt/liquibase /opt/liquibase

RUN ln -s /opt/liquibase/liquibase /usr/local/bin/liquibase

COPY src/main/resources /liquibase/migrations

WORKDIR /liquibase
