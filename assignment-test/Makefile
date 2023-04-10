BUILT_REG := quay.io/
BUILT_REPO := rh_ee_keli/ucsls:
BUILT_TAG := test-mof-burosa-devS23 
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

ibuild: REPO = $(BUILT_REPO)
ibuild: REG = $(BUILT_REG)
ibuild: TAG = $(BUILT_TAG)
ibuild: MOUNT = $(CWD):$(CONTAINER_DIR)
ibuild: pull
	docker run -it -u 0 -v $(MOUNT) $(REG)$(REPO)$(TAG) make build


itest: REPO = $(BUILT_REPO)
itest: REG = $(BUILT_REG)
itest: TAG = $(BUILT_TAG)
itest: MOUNT = $(CWD):$(CONTAINER_DIR)
itest: pull ibuild
	docker run -it -u 0 -v $(MOUNT) $(REG)$(REPO)$(TAG) ./testassignments.sh

run: REPO = $(BUILT_REPO)
run: REG = $(BUILT_REG)
run: TAG = $(BUILT_TAG)
run: MOUNT = $(CWD):$(CONTAINER_DIR)
run:
	docker run --privileged -it --rm -u 0 -v $(MOUNT) $(REG)$(REPO)$(TAG) /bin/bash

test: build
	./testassignments.sh 1

clean: 
	@for dir in $(ASSIGNMENT_BUILT_DIRS); do \
        $(MAKE) -C $$dir clean; \
    done
	rm -rf .bash_history tmp


