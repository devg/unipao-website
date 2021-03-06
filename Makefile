REGISTRY?=registry.gitlab.com/pardacho/unipao-website
APP_VERSION?=latest

default: build

build: 
	yarn run build

deps:
	yarn install --pure-lockfile
	npm rebuild node-sass

test:
	yarn run test

registry: registry-build registry-push

registry-build:
	docker build --pull -t $(REGISTRY):$(APP_VERSION) .

registry-push:
	docker push $(REGISTRY):$(APP_VERSION)

stop-prod:
	docker stack rm unipao

prod:
	docker stack deploy --compose-file docker-stack.yml unipao --with-registry-auth
	clear
	@echo ""
	@echo "commands:"
	@echo "- make stop-prod"
	@echo ""
