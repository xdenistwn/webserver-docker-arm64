.PHONY: create-local-network remove-local-network build up stop down

create-local-network:
	docker network create local-network

remove-local-network:
	docker network rm local-network

build:
	docker compose -f dockerfiles/docker-compose.build.yml build

up:
	docker compose up -d

stop:
	docker compose stop

down:
	docker compose down