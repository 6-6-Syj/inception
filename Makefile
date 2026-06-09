COMPOSE_FILE := srcs/docker-compose.yaml
COMPOSE      := docker compose -f $(COMPOSE_FILE)

GREEN  := \033[0;32m
RED    := \033[0;31m
CYAN   := \033[0;36m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: all up down re clean fclean logs ps check help \
create-volumes delete-volumes

all: up check

up: create-volumes
	@$(COMPOSE) up -d --build
	@printf "$(GREEN)✓ Stack started$(RESET)\n"

down:
	@printf "$(YELLOW)🛑 Stopping containers...$(RESET)\n"
	@$(COMPOSE) down

re: fclean all

clean:
	@printf "$(YELLOW)🧹 Cleaning containers...$(RESET)\n"
	@$(COMPOSE) down

fclean:
	@printf "$(RED)💥 Full cleanup...$(RESET)\n"
	@$(COMPOSE) down --rmi all --volumes --remove-orphans
	@sudo rm -rf $$HOME/data/mysql
	@sudo rm -rf $$HOME/data/wordpress

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

check:
	@srcs/requirements/nginx/tools/check.sh

status:
	@printf "\n$(CYAN)Docker containers$(RESET)\n"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

create-volumes:
	@mkdir -p $$HOME/data/mysql
	@mkdir -p $$HOME/data/wordpress

delete-volumes:
	@rm -rf $$HOME/data/mysql
	@rm -rf $$HOME/data/wordpress

build-%:
	@printf "$(CYAN)🔨 Rebuilding $*...$(RESET)\n"
	@$(COMPOSE) up -d --build $*

shell-%:
	@docker exec -it $* sh

help:
	@printf "\n$(CYAN)Available targets$(RESET)\n\n"
	@printf "  make up          Start stack\n"
	@printf "  make down        Stop stack\n"
	@printf "  make re          Full rebuild\n"
	@printf "  make clean       Stop containers\n"
	@printf "  make fclean      Remove everything\n"
	@printf "  make logs        Follow logs\n"
	@printf "  make ps          Compose status\n"
	@printf "  make status      Docker status\n"
	@printf "  make check       Check nginx\n"
	@printf "  make shell-nginx\n"
	@printf "  make shell-wordpress\n"
	@printf "  make shell-mariadb\n"
	@printf "  make build-nginx\n"
	@printf "  make build-wordpress\n"
	@printf "  make build-mariadb\n\n"