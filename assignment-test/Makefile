BUILT_REG := quay.io/
BUILT_REPO := rh_ee_keli/ucsls:
BUILT_TAG := test-mof-burosa-devS23 
BUILT_IMAGE := ${BUILT_REG}${BUILT_REPO}${BUILT_TAG}

CWD := $(shell pwd)
CONTAINER_DIR := /home/jovyan

test:
	docker run -it -u 0 -v $(CWD):$(CONTAINER_DIR) $(BUILT_IMAGE) ./testassignments.sh

