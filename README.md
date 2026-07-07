# aws-terraform-database-reliability
AWS infrastructure deployment using Terraform with local Dockerized database reliability scripts.

## Database Query Optimization

**The Target Query:**
The application frequently runs an analytics query filtering by `city` (exact match) and `created_at` (range match), grouped by `org_id` and `status`.

**The Solution:**
I implemented a Composite B-Tree Index: `idx_hotel_bookings_city_created_at ON hotel_bookings(city, created_at)`.

**The Reasoning:**
1. **Avoid Full Table Scans:** Without an index, PostgreSQL must sequentially scan every row to find bookings in 'delhi'.
2. **Column Order Matters:** In a composite index, the order of columns is critical. I placed `city` first because the query uses an equality operator (`=`). `created_at` is placed second because it uses a range operator (`>=`). This allows the database engine to immediately jump to the 'delhi' section of the index tree, and then efficiently scan only the relevant date range within that section.

## Disaster Recovery (Backup & Restore)

This project includes automated scripts for disaster recovery using strict bash mode and custom-format PostgreSQL dumps.

### How to Test the Restore Process:

**1. Create a Backup:**
Run the backup script. It will generate a timestamped `.dump` file in the `database/backups/` directory.
```bash
./scripts/backup.sh
