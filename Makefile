# Variables
COMPOSE=docker compose
FRONTEND_CONTAINER=frontend
BACKEND_CONTAINER=backend

FRONTEND_DIR=../frontend
BACKEND_DIR=../backend

# Default target
.DEFAULT_GOAL := up

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
	$(COMPOSE) up --build

# Stop containers
down: check-all
	$(COMPOSE) down

# Rebuild containers and reinstall dependencies
rebuild: check-all down up install
