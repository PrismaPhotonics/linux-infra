#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Error exit function
error_exit() {
    log "ERROR: $1"
    exit 1
}

wait_for_pod_readiness() {
  log "Waiting for postgres to be ready..."
  if ! kubectl wait --for=condition=ready pod -l "app.kubernetes.io/instance=postgres-shaked" -n postgres-shaked --timeout=180s; then
      error_exit "Pod with label app.kubernetes.io/instance=postgres-shake failed to become ready within 180s"
  fi
}

HOST="$THREE_FIRST_OCTETS.104"
PORT="5672"
DB="postgres"
USER="postgres"
PASSWORD="postgres"
SQL_FILE="postgres/scripts/database_script.sql"
DATA_SCRIPT="postgres/scripts/data_script.sql"

wait_for_postgres() {
  log "Waiting for PostgreSQL to accept connections (max 30s)..."
  for i in {1..6}; do
    PGPASSWORD="$PASSWORD" psql -h "$HOST" -U "$USER" -d "$DB" -c "SELECT 1;" >/dev/null 2>&1 && {
      log "PostgreSQL is ready."
      return 0
    }
    log "Attempt $i: not ready, sleeping 5s..."
    sleep 5
  done
  error_exit "PostgreSQL failed to become ready after 30 seconds."
}

init_db() {
  # Check if the SQL file exists
    if [[ ! -f "$SQL_FILE" ]]; then
        error_exit "SQL file $SQL_FILE not found."
    fi

    log "Executing $SQL_FILE..."
    PGPASSWORD="$PASSWORD" psql -h "$HOST" -U "$USER" -d "$DB" -f "$SQL_FILE" || error_exit "Failed to execute SQL script."
    log "SQL script executed successfully."

    log "Checking if data has already been inserted (looking for customer with id=17)..."
    DATA_CHECK=$(PGPASSWORD="$PASSWORD" psql -h "$HOST" -U "$USER" -d "$DB" -t -c "SELECT count(*) FROM prisma_projects.customers WHERE id = 17;") \
        || error_exit "Failed to query PostgreSQL for data."
    DATA_CHECK=$(echo "$DATA_CHECK" | xargs)  # trim whitespace

    if [[ "$DATA_CHECK" -eq 0 ]]; then
        log "Data not found. Executing $DATA_SCRIPT..."
        PGPASSWORD="$PASSWORD" psql -h "$HOST" -U "$USER" -d "$DB" -f "$DATA_SCRIPT" \
            || error_exit "Failed to execute data script."
        log "Data script executed successfully."
    else
        log "Data already exists. Skipping execution of $DATA_SCRIPT."
    fi
}

wait_for_pod_readiness
init_db
