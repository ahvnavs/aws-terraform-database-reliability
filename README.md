```markdown
# AWS Infrastructure & Database Reliability Assessment

This repository implements a production-ready AWS cloud architecture via Terraform and a fully containerized local PostgreSQL environment engineered for high reliability, automated disaster recovery, and query optimization[cite: 1].

Built strictly according to the AWS Well-Architected Framework, this project emphasizes secure networking, modular code reusability, and automated CI/CD validation.

---

## 📁 Repository Structure

```text
.
├── .github/workflows/      # Automated Matrix CI/CD pipeline (tfsec/validation)
├── database/               # Local Database Engine
│   ├── init/               # Auto-executing SQL (Schema, 150 Seed Rows, B-Tree Indexes)
│   └── docker-compose.yml  # Healthcheck-monitored Postgres core
├── infra/                  # Terraform Infrastructure as Code
│   ├── envs/               # Target state deployments (dev / prod)
│   └── modules/            # Reusable core components (network, security_group, rds, ecs)
├── scripts/                # Disaster Recovery automation
│   ├── backup.sh           # OS-agnostic container-isolated binary export
│   └── restore.sh          # Destructive-safe data tier recovery script
├── Makefile                # Developer workflow shortcuts
└── README.md               # Project documentation

```

---

## 🏗️ Phase 1: Terraform Infrastructure & Environments

The AWS architecture uses strict Security Group Chaining to ensure the PostgreSQL RDS vault is entirely private and only accessible via the ECS Fargate Compute layer, which routes through a public Application Load Balancer.

Infrastructure is split into two distinct environments via variable injection:

* **Development (`envs/dev`):** `db.t3.micro`, 1-day backup retention, deletion protection disabled.
* **Production (`envs/prod`):** `db.t3.large` (different CIDR), 30-day backup retention, deletion protection enabled.

### Verification Steps

Actual AWS deployment is not required. To validate the structural integrity of the codebase locally:

```bash
# 1. Format the codebase
make tf-fmt

# 2. Navigate to an environment
cd infra/envs/dev

# 3. Initialize plugins (Safe, requires no AWS credentials)
terraform init

# 4. Validate logic and syntax
terraform validate

# 5. Generate the execution blueprint
terraform plan -refresh=false

```

---

## 🗄️ Phase 2: Local Database Setup & Disaster Recovery

The data plane uses a containerized PostgreSQL 15 environment with isolated persistent volumes.

### Prerequisites

* Docker & Docker Compose installed.

### Verification Steps

Run the following commands sequentially from the root of the repository to test initialization, seeding, and the disaster recovery loop.

**1. Initialize and Seed the Database**
Starts the cluster, creates the schema, and automatically seeds 150 randomized hotel booking rows.

```bash
make db-up

```

**2. Generate a Backup**
Runs the OS-agnostic backup script, exporting a compressed custom binary dump.

```bash
./scripts/backup.sh

```

*(Note the newly generated filename in the `database/backups/` directory).*

**3. Simulate Catastrophic Data Loss**
Forcefully delete all data from the database:

```bash
docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "TRUNCATE TABLE hotel_bookings CASCADE;"

```

*(Verify it is empty by running: `docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "SELECT COUNT(*) FROM hotel_bookings;"` — It will return 0).*

**4. Execute the Restore Script**
Pass the exact filename generated in Step 2 to the restore script:

```bash
./scripts/restore.sh database/backups/<YOUR_TIMESTAMPED_FILE>.dump

```

**5. Confirm Successful Recovery**
Verify the tables have been fully restored. The row count will match exactly 150:

```bash
docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "SELECT COUNT(*) FROM hotel_bookings;"

```

---

## ⚡ Phase 3: Query Optimization Analysis

**The Target Query:**
The application frequently runs this analytics query:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi' AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;

```

**The Applied Optimization:**
A specialized **Composite B-Tree Index** was deployed during database initialization:

```sql
CREATE INDEX idx_hotel_bookings_city_created_at ON hotel_bookings(city, created_at);

```

**Technical Justification:**

* **Preventing Full Table Scans:** Without this index, PostgreSQL performs a sequential scan across every block on the disk.
* **Deterministic Column Ordering:** In composite structures, column position dictates performance. `city` is prioritized first because it uses a highly selective equality operator (`=`). `created_at` is placed second to process the variable range boundary (`>=`). This allows the query engine to rapidly traverse the tree directly to the specific city partition, and efficiently scan only the required date ranges.

---

## 🤖 Phase 4: CI/CD Pipeline Automation

This repository includes a fully automated DevSecOps GitHub Actions pipeline triggered on Pull Requests.

* **Matrix Strategy:** Concurrently evaluates both `dev` and `prod` environments to reduce pipeline runtime.
* **Security Guardrails:** Integrates `tfsec` static analysis to catch infrastructure vulnerabilities before they are merged.
* **Automated PR Feedback:** Posts the `terraform plan` output directly as a comment on the Pull Request for streamlined code review.



```

```
