## Include layers that will be mounted

MAKEFLAGS += -B
SHELL = /bin/bash

include layers.mk

USER := $(shell id -un)
UID := $(shell id -u)
GUID := $(shell id -g)

DOCKER_RUN := docker run --rm=true -it \
    -v /$(POKY_DIR):/$(POKY_DIR) \
    $(foreach layer,$(YOCTO_LAYERS),-v /$(layer):/$(layer))

## Check if oe-docker is up to date
DOCKER_TAG := $(shell shasum Dockerfile | awk '{print substr($$1,0,11);}')
DOCKER_IMAGE := oe-docker-$(USER)

DOCKER_BUILD := docker build \
    --build-arg user=$(USER) \
    --build-arg uid=$(UID) \
    --build-arg guid=$(GUID) \
    --build-arg poky_dir=$(POKY_DIR) \
    -t $(DOCKER_IMAGE) . && \
    docker tag $(DOCKER_IMAGE):latest $(DOCKER_IMAGE):$(DOCKER_TAG)

bash:
	@docker inspect --type image $(DOCKER_IMAGE):$(DOCKER_TAG) &> /dev/null || \
	    { echo Image $(DOCKER_IMAGE):$(DOCKER_TAG) not found. Building... ; \
	    $(DOCKER_BUILD) ; }
	@$(DOCKER_RUN) $(DOCKER_IMAGE):$(DOCKER_TAG) bash

oe-docker-build:
	$(DOCKER_BUILD)
