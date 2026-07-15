```markdown
# AWS Infrastructure & Database Reliability

A production-ready AWS cloud architecture via Terraform, paired with a fully containerized local PostgreSQL database engineered for high reliability, automated disaster recovery, and query optimization[cite: 2].

Built strictly according to the AWS Well-Architected Framework, this project emphasizes secure networking, modular code reusability, and automated CI/CD validation[cite: 2].

---

## 🛠️ Prerequisites
*   **Git**
*   **Docker Desktop**
*   **Terraform**
*   **GNU Make** (Optional)

---

## 🚀 1. Setup & Initialization

**Clone the repository:**
```bash
git clone https://github.com/ahvnavs/aws-terraform-database-reliability.git
cd aws-terraform-database-reliability

```

**Grant script execution permissions (Linux/macOS):**

```bash
chmod +x scripts/backup.sh scripts/restore.sh

```

*(Note for WSL/Linux users: If backup generation fails due to permissions, run `sudo chown -R $USER:$USER database/backups`)*

**Initialize the database (Creates schema, indexes, and seeds data):**

```bash
make db-up
# Alternative: cd database && docker compose up -d && cd ..

```

---

## 🛡️ 2. Disaster Recovery Verification

Test the automated backup and recovery pipeline.

**1. Create a binary snapshot:**

```bash
./scripts/backup.sh

```

*(Note the generated filename in `database/backups/`)*

**2. Simulate catastrophic data loss:**

```bash
docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "TRUNCATE TABLE hotel_bookings CASCADE;"
docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "SELECT COUNT(*) FROM hotel_bookings;" # Confirms 0

```

**3. Restore from the snapshot:**

```bash
./scripts/restore.sh database/backups/<YOUR_TIMESTAMPED_FILE>.dump

```

**4. Confirm data recovery:**

```bash
docker exec -it hotel-db psql -U postgres -d hotel_bookings_db -c "SELECT COUNT(*) FROM hotel_bookings;" # Confirms 150

```

---

## 🏗️ 3. Infrastructure as Code (Terraform)

Modular AWS architecture with isolated environments enforcing the Well-Architected Framework.

* **Dev:** Utilizes smaller instances (`db.t3.micro`) and shorter backup retention (1 day).


* **Prod:** Utilizes larger instances (`db.t3.large`), robust backup retention (30 days), and strict deletion protection.



**Validate the architecture locally (No AWS credentials required):**

```bash
# Format codebase
make tf-fmt
# Alternative: terraform fmt -recursive

# Navigate to target environment
cd infra/envs/prod

# Initialize, validate, and plan
terraform init
terraform validate
terraform plan -refresh=false

```

---

## ⚡ 4. Database Optimization

**Target:** High-frequency analytics query filtering by city and date.
**Solution:** Applied a Composite B-Tree Index prioritizing exact-match operators before range operators to completely eliminate sequential table scans.

```sql
CREATE INDEX idx_hotel_bookings_city_created_at ON hotel_bookings(city, created_at);

```

---

## 🤖 5. CI/CD DevSecOps

Automated GitHub Actions pipeline (`.github/workflows/terraform-plan.yml`) enforcing infrastructure quality.

* **Matrix Strategy:** Concurrently evaluates both `dev` and `prod` environments simultaneously.


* **Security Guardrails:** Integrates `tfsec` static analysis to scan the infrastructure code for security vulnerabilities before they are ever deployed.


* **Automated PR Feedback:** Posts the `terraform plan` blueprint directly as a comment on the Pull Request, making peer code reviews incredibly easy.



```

```
