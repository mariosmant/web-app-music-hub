#!/bin/sh
set -e

# Wait for Postgres
until nc -z postgres 5432; do
  echo "Waiting for Postgres..."
  sleep 2
done

echo "Applying Liquibase changelog..."
liquibase \
  --defaultsFile=/liquibase/liquibase.properties \
  update

echo "Liquibase finished."
