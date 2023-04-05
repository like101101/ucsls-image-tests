BUILT_REG := quay.io/
BUILT_REPO := rh_ee_keli/ucsls:
BUILT_TAG := stable-burosa-devS23 
BUILT_IMAGE := ${BUILT_REG}${BUILT_REPO}${BUILT_TAG}

ASSIGNMENT_BUILT_DIRS := PS1B PS4B

CWD := $(shell pwd)
CONTAINER_DIR := /home/jovyan

pull: REPO = $(BUILT_REPO)
pull: REG = $(BUILT_REG)
pull: TAG = $(BUILT_TAG)
pull: DARGS ?=
pull: ## pull most recent public version
	docker pull $(REG)$(REPO)$(TAG)

build:
	@for dir in $(ASSIGNMENT_BUILT_DIRS); do \
        $(MAKE) -C $$dir; \
    done

image-test: REPO = $(BUILT_REPO)
image-test: REG = $(BUILT_REG)
image-test: TAG = $(BUILT_TAG)
image-test: MOUNT = $(CWD):$(CONTAINER_DIR)
image-test: build pull
	docker run -it -u 0 -v $(MOUNT) $(REG)$(REPO)$(TAG) ./testassignments.sh

local-test: build
	./testassignments.sh

clean: 
	@for dir in $(ASSIGNMENT_BUILT_DIRS); do \
        $(MAKE) -C $$dir clean; \
    done


