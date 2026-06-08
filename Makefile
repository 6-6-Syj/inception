COMPOSE_FILE       = srcs/docker-compose.yaml
COMPOSE            = docker compose -f $(COMPOSE_FILE)

all: up check

up:
	@printf "Starting [MariaDB] ...\n"
	$(COMPOSE) up -d --build --no-recreate

down:
	@printf "Shutting down [MariaDB] ...\n"
	$(COMPOSE) down

build-%:
	$(COMPOSE) up -d --build $*

re: down remove-all-existing-images up

remove-all-existing-images:
	$(COMPOSE) down --rmi all

logs:
	$(COMPOSE) logs -f

shell-%:
	terminator -e "$(COMPOSE) exec $* sh"

check:
	@if curl -fsSLk https://localhost:8443 | grep -q "66Syj"; then \
		echo "\033[32m[NGINX] Status: OK\033[0m"; \
	else \
		echo "\033[31m[NGINX] Status: KO\033[0m"; \
		exit 1; \
	fi