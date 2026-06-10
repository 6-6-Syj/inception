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

re: down up check

re-re: fclean up check
	
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
	@printf "$(YELLOW)Available:\n$(RESET)"
	@printf "  $(CYAN)make all$(RESET)         Build (if needed) and start stack\n"
	@printf "  $(CYAN)make up$(RESET)          Start stack (no rebuild)\n"
	@printf "  $(CYAN)make down$(RESET)        Stop stack\n"
	@printf "  $(CYAN)make re$(RESET)          Restart stack (keep data)\n"
	@printf "  $(CYAN)make build$(RESET)       Force rebuild images\n"
	@printf "  $(CYAN)make clean$(RESET)       Stop containers & remove anonymous volumes\n"
	@printf "  $(CYAN)make fclean$(RESET)      Remove everything\n"
	@printf "  $(CYAN)make logs$(RESET)        Follow logs\n"
	@printf "  $(CYAN)make ps$(RESET)          Compose status\n"
	@printf "  $(CYAN)make status$(RESET)      Docker status\n"
	@printf "  $(CYAN)make check$(RESET)       Check nginx\n"
	@printf "  $(CYAN)make shell-[]$(RESET)    Open shell (e.g. make shell-nginx)\n"