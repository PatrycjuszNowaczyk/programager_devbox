.PHONY: help

# Variables
COMPOSE=docker compose
FRONTEND_CONTAINER=frontend
BACKEND_CONTAINER=backend
DB_CONTAINER=db

help:
	@echo "Available commands:"
	@echo "  up              	- Start containers"
	@echo "  down            	- Stop containers"
	@echo "  install         	- Install all dependencies"
	@echo "  rebuild         	- Rebuild containers and reinstall dependencies"
	@echo "  shell-frontend  	- Open shell in frontend container"
	@echo "  shell-backend   	- Open shell in backend container"
	@echo "  shell-db        	- Open shell in database container"
	@echo "  install-frontend	- Install frontend dependencies"
	@echo "  install-backend 	- Install backend dependencies"
	@echo "  check-all      	- Check if frontend and backend repositories exist"

FRONTEND_DIR=../programager_frontend
BACKEND_DIR=../programager_backend

# Default target
.DEFAULT_GOAL := help

# Function to check if directory exists and is a git repo
# --- Repo check function ---
define check_repo
	@if [ ! -d "$(1)" ]; then \
		echo "Error: $(1) does not exist."; \
		exit 1; \
	elif [ ! -d "$(1)/.git" ]; then \
		echo "Error: $(1) exists but is not a git repository."; \
		exit 1; \
	fi
endef

# Function to check if project running already
# --- Check if project is already running ---
check-running:
	@if [ "$$($(COMPOSE) ps -q)" ]; then \
		echo "Warning: project is already running."; \
		exit 1; \
	fi

# Run check for frontend and backend
check-all:
	$(call check_repo,$(FRONTEND_DIR))
	$(call check_repo,$(BACKEND_DIR))

# Check if frontend dependencies are installed
install-frontend: check-all
	@if [ ! -d "$(FRONTEND_DIR)/node_modules" ]; then \
		echo "Installing frontend dependencies..."; \
		$(COMPOSE) run --rm $(FRONTEND_CONTAINER) sh -c "npm install"; \
	else \
		echo "Frontend dependencies already installed."; \
	fi

# Check if backend dependencies are installed
install-backend: check-all
	@if [ ! -d "$(BACKEND_DIR)/vendor" ]; then \
		echo "Installing backend dependencies..."; \
		$(COMPOSE) run --rm $(BACKEND_CONTAINER) sh -c "composer install"; \
	else \
		echo "Backend dependencies already installed."; \
	fi

# Install all dependencies
install: install-frontend install-backend up

# Start containers
up: check-all
	$(COMPOSE) up -d --build

# Stop containers
down: check-all
	$(COMPOSE) down

# Rebuild containers and reinstall dependencies
rebuild: check-all down up install

# Ensure containers are up before opening a shell
ensure-up:
	@if [ -z "$$($(COMPOSE) ps -q)" ]; then \
		echo "Error: project is not running. Start it with 'make up'."; \
		exit 1; \
	fi

# Open an interactive shell in the backend container
shell-backend: ensure-up
	@echo "Opening shell in $(BACKEND_CONTAINER)..."
	@$(COMPOSE) exec $(BACKEND_CONTAINER) bash || $(COMPOSE) exec $(BACKEND_CONTAINER) sh

# Open an interactive shell in the frontend container
shell-frontend: ensure-up
	@echo "Opening shell in $(FRONTEND_CONTAINER)..."
	@$(COMPOSE) exec $(FRONTEND_CONTAINER) bash || $(COMPOSE) exec $(FRONTEND_CONTAINER) sh

# Open an interactive shell in the database container
shell-db: ensure-up
	@echo "Opening shell in $(DB_CONTAINER)..."
	@$(COMPOSE) exec $(DB_CONTAINER) bash || $(COMPOSE) exec $(DB_CONTAINER) sh

