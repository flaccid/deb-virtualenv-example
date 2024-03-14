DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = deb-virtualenv-example
IMAGE_VERSION = latest
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

WORKING_DIR := $(shell pwd)

.DEFAULT_GOAL := build

.PHONY: build

build:: ## build it
	dpkg-buildpackage -uc -us -b

docker-build:: ## builds the docker image locally
	@docker build  \
		--pull \
		-t $(IMAGE_TAG) \
			$(WORKING_DIR)

docker-rm:: ## removes the running docker container
	@docker rm -f deb-virtualenv-example

docker-run:: ## runs the docker image
	docker run \
		--name deb-virtualenv-example \
		-it \
		--hostname deb-virtualenv-example \
		-p 8080:8080 \
		$(DOCKER_OPTS) \
			$(IMAGE_TAG)

run: ## runs the python program
	python server.py

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)