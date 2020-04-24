DOCKER_COMPOSE_DIR=./.docker
DOCKER_COMPOSE_FILE=$(DOCKER_COMPOSE_DIR)/docker-compose.yml
CONTAINER ?= nodejs
DOCKER_COMPOSE=docker-compose -f $(DOCKER_COMPOSE_FILE) --project-directory $(DOCKER_COMPOSE_DIR)

DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ [Docker] Build / Infrastructure
.docker/.env:
	cp $(DOCKER_COMPOSE_DIR)/.env.example $(DOCKER_COMPOSE_DIR)/.env

.PHONY: docker-clean
docker-clean: ## Remove the .env file for docker
	rm -f $(DOCKER_COMPOSE_DIR)/.env

.PHONY: docker-init
docker-init: .docker/.env ## Make sure the .env file exists for docker

.PHONY: docker-build-from-scratch
docker-build-from-scratch: docker-init ## Build all docker images from scratch, without cache etc. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
	$(DOCKER_COMPOSE) rm -fs $(CONTAINER) && \
	$(DOCKER_COMPOSE) build --pull --no-cache --parallel $(CONTAINER) && \
	$(DOCKER_COMPOSE) up -d --force-recreate $(CONTAINER)
	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) chmod +x ./.docker/install.sh

.PHONY: docker-test
docker-test: docker-init docker-up ## Run the infrastructure tests for the docker setup
	sh $(DOCKER_COMPOSE_DIR)/docker-test.sh

.PHONY: docker-pre-build
docker-pre-build:
	$(DOCKER_COMPOSE) build --parallel $(CONTAINER) && \
	$(DOCKER_COMPOSE) up -d --force-recreate $(CONTAINER)
	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) chmod +x ./.docker/install.sh

.PHONY: docker-build
docker-build: docker-init ## Build all docker images. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
	$(DOCKER_COMPOSE) up -d $(CONTAINER)
# 	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) rm dist/game.js dist/game.js.map
	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) npm run watch

.PHONY: docker-dev
docker-dev:
	$(DOCKER_COMPOSE) up -d $(CONTAINER)
# 	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) rm dist/game.js dist/game.js.map
	$(DOCKER_COMPOSE) exec -u node -d $(CONTAINER) npm run dev

.PHONY: docker-dist
docker-dist:
	$(DOCKER_COMPOSE) up -d $(CONTAINER)
# 	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) rm dist/game.js dist/game.js.map
	$(DOCKER_COMPOSE) exec -u node -d $(CONTAINER) npm run build

.PHONY: docker-clear-dist
docker-clear-dist:
	$(DOCKER_COMPOSE) exec -u node $(CONTAINER) rm dist/game.js dist/game.js.map

.PHONY: docker-prune
docker-prune: ## Remove unused docker resources via 'docker system prune -a -f --volumes'
	docker system prune -a -f --volumes

.PHONY: docker-up
docker-up: docker-init ## Start all docker containers. To only start one container, use CONTAINER=<service>
	$(DOCKER_COMPOSE) up -d $(CONTAINER)

.PHONY: docker-down
docker-down: docker-init ## Stop all docker containers. To only stop one container, use CONTAINER=<service>
	$(DOCKER_COMPOSE) down
