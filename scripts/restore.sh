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

# 1. Securely copy the backup file INTO the container
docker cp "${BACKUP_FILE}" hotel-db:/tmp/restore_target.dump

# 2. Run pg_restore completely inside the container
docker exec hotel-db pg_restore -U postgres -d hotel_bookings_db --clean --if-exists /tmp/restore_target.dump

# 3. Clean up the temporary file
docker exec hotel-db rm /tmp/restore_target.dump

echo "✅ Restore complete! Your data is safe."
