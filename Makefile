DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = deb-virtualenv-example
IMAGE_VERSION = latest
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

export PIP_BREAK_SYSTEM_PACKAGES = 1

WORKING_DIR := $(shell pwd)

.DEFAULT_GOAL := help

.PHONY: build

build-deb:: ## build debian package
	dpkg-buildpackage -uc -us -b

check:: ## python setup check
	@python setup.py check

dist:: ## makes a python source dist
	python setup.py sdist

wdist:: ## makes a python wheel dist
	python setup.py bdist_wheel --universal

flush:: ## remove generated files
	rm -Rf build
	rm -Rf dist
	rm -Rf *.egg-info
	rm -Rf debian/.debhelper
	rm -Rf debian/helloart
	rm -f debian/helloart.*
	rm -f debian/files debian/debhelper-build-stamp
	rm -Rf helloart/__pycache__
	rm -Rf dist-deb

copy-dpkg-output:: ## copies the built files from building deb package
	mkdir -p dist-deb
	cp -v ../helloart_*_amd64.* ./dist-deb/

docker-build:: ## builds the docker image locally
	@docker build  \
		--pull \
		-t $(IMAGE_TAG) \
			$(WORKING_DIR)

docker-build-deb:: ## builds the debian package in docker
	@docker build  \
		--pull \
		-t $(IMAGE_TAG) \
		-f Dockerfile.dpkg \
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

docker-run-dev:: ## runs the image with a shell and bind mounted src
	docker run \
		--name deb-virtualenv-example \
		-it \
		--hostname deb-virtualenv-example \
		-p 8080:8080 \
		-v $(WORKING_DIR):/usr/local/src/helloart \
		$(DOCKER_OPTS) \
			$(IMAGE_TAG)

install:: ## installs with pip
	pip install -r requirements.txt
	pip install .
	@#python setup.py install  ## avoid using

install-deb:: ## installs the built deb package
	dpkg -i ../helloart_0.1.0_amd64.deb

uninstall:: ## uninstalls with pip
	pip uninstall -y -r requirements.txt
	pip uninstall -y helloart

uninstall-deb:: ## uninstalls the deb package
	apt remove helloart

upgrade:: ## upgrades with pip
	pip install --upgrade -r requirements.txt
	pip install --upgrade .

run:: ## runs the python program
	@python helloart/serve.py

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
