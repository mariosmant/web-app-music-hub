#!/bin/sh
set -e

# echo "Waiting for Postgres..."
# until wget -qO- postgres:5432 >/dev/null 2>&1; do
#   sleep 2
# done

echo "Applying Liquibase changelog..."
liquibase \
  --defaultsFile=/liquibase/liquibase.properties \
  update

echo "Liquibase finished."
