#!/bin/bash
set -euo pipefail

mkdir -p database/backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="database/backups/hotel_db_${TIMESTAMP}.dump"
CONTAINER_FILE="/tmp/hotel_db_${TIMESTAMP}.dump"

echo "🚀 Starting backup of hotel_bookings_db..."

# 1. Run the dump and save it INSIDE the container to protect the binary formatting
docker exec hotel-db pg_dump -U postgres -d hotel_bookings_db -F c -f "${CONTAINER_FILE}"

# 2. Securely copy the file from the container to your local folder
docker cp hotel-db:"${CONTAINER_FILE}" "${BACKUP_FILE}"

# 3. Clean up the temporary file inside the container
docker exec hotel-db rm "${CONTAINER_FILE}"

echo "✅ Backup successfully saved to: ${BACKUP_FILE}"
