.PHONY: db-up db-down tf-fmt tf-init-dev tf-plan-dev

db-up:
	@echo "Starting local database..."
	cd database && docker compose up -d

db-down:
	@echo "Stopping local database..."
	cd database && docker compose down

tf-fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

tf-init-dev:
	@echo "Initializing Dev Environment..."
	cd infra/envs/dev && terraform init

tf-plan-dev:
	@echo "Planning Dev Environment..."
	cd infra/envs/dev && terraform plan -refresh=false
