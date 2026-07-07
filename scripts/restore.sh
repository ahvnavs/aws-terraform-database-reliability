#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
echo "❌ Error: No backup file specified."
echo "Usage: ./scripts/restore.sh <path_to_backup_file.dump>"
exit 1
fi

BACKUP_FILE=$1

if [ ! -f "${BACKUP_FILE}" ]; then
echo "❌ Error: File ${BACKUP_FILE} does not exist."
exit 1
fi

echo "🚀 Restoring database from ${BACKUP_FILE}..."

cat "${BACKUP_FILE}" | docker exec -i hotel-db pg_restore -U postgres -d hotel_bookings_db --clean --if-exists

echo "✅ Restore complete! Your data is safe."
