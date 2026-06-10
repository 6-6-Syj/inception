COMPOSE_FILE := srcs/docker-compose.yaml
COMPOSE      := docker compose -f $(COMPOSE_FILE)

GREEN  := \033[0;32m
RED    := \033[0;31m
CYAN   := \033[0;36m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: all up down re clean fclean build logs ps check help \
create-volumes delete-volumes

all: build up

up: create-volumes
	@$(COMPOSE) up -d
	@printf "$(GREEN)✓ Stack started$(RESET)\n"

down:
	@printf "$(YELLOW)🛑 Stopping containers...$(RESET)\n"
	@$(COMPOSE) down

build:
	@$(COMPOSE) build

re: down up

clean: down
	@printf "$(YELLOW)🧹 Cleaning containers & anonymous volumes...$(RESET)\n"
	@$(COMPOSE) down --volumes --remove-orphans

fclean:
	@printf "$(RED)💥 Full cleanup (Data will be lost!)...$(RESET)\n"
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
	@$(COMPOSE) build $*

shell-%:
	@docker exec -it $* sh

help:
	@printf "\n$(CYAN)Available targets:$(RESET)\n"
	@printf "  make all         Build (if needed) and start stack\n"
	@printf "  make up          Start stack (no rebuild)\n"
	@printf "  make down        Stop stack\n"
	@printf "  make re          Restart stack (keep data)\n"
	@printf "  make build       Force rebuild images\n"
	@printf "  make clean       Stop containers & remove anonymous volumes\n"
	@printf "  make fclean      Remove everything\n"
	@printf "  make logs        Follow logs\n"
	@printf "  make ps          Compose status\n"
	@printf "  make status      Docker status\n"
	@printf "  make check       Check nginx\n"
	@printf "  make shell-[]    Open shell (e.g. make shell-nginx)\n\n"