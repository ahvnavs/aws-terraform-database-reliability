#!/bin/bash
set -euo pipefail

mkdir -p database/backups

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="database/backups/hotel_db_${TIMESTAMP}.dump"

echo "🚀 Starting backup of hotel_bookings_db..."
docker exec -t hotel-db pg_dump -U postgres -d hotel_bookings_db -F c > "${BACKUP_FILE}"
echo "✅ Backup successfully saved to: ${BACKUP_FILE}"
