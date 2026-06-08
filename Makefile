COMPOSE_FILE       = srcs/docker-compose.yaml
COMPOSE            = docker compose -f $(COMPOSE_FILE)

all: up check

up: create-volumes
	@printf "Starting [MariaDB] ...\n"
	$(COMPOSE) up -d --build --no-recreate

down:
	@printf "Shutting down [MariaDB] ...\n"
	$(COMPOSE) down

build-%:
	$(COMPOSE) up -d --build $*

re: down remove-all-existing-images delete-volumes up

remove-all-existing-images:
	$(COMPOSE) down --rmi all

logs:
	$(COMPOSE) logs -f

shell-%:
	alacritty -e sh -c '$(COMPOSE) exec $* sh'

check:
	@if curl -fsSLk https://localhost:443 | grep -q "66Syj"; then \
		echo "\033[32m[NGINX] Status: OK\033[0m"; \
	else \
		echo "\033[31m[NGINX] Status: KO\033[0m"; \
		exit 1; \
	fi

create-volumes:
	mkdir -p ~/data/mysql ~/data/wordpress

delete-volumes:
	@sudo rm -rf ~/data/mysql
	@sudo rm -rf ~/data/wordpress 