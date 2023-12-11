OWNER := fabianlee
PROJECT := docker-build-ovmf-package
VERSION := 1.0.0
OPV := $(OWNER)/$(PROJECT):$(VERSION)

# you may need to change to "sudo docker" if not a member of 'docker' group
# add user to docker group: sudo usermod -aG docker $USER
DOCKERCMD := "docker"

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)

# https://github.com/tianocore/edk2-platforms
# list of target architectures for OVMF
BUILD_ARCHS_CMD:= uefi-tools/edk2-build.sh ovmfx64
#juno armvirtqemu64 ovmfia32


## builds docker image
docker-build:
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build --progress plain --build-arg "EDK2_GIT_TAG=" -f Dockerfile -t $(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm $(OPV) | true

## runs container in foreground
docker-run-fg:
	mkdir -p Build
	$(DOCKERCMD) run -it -v $(PWD)/Build:/home/ubuntu/tianocore/Build --rm $(OPV)

## runs container in foreground, builds OVMF unto local 'Build/' directory
docker-build-archs:
	mkdir -p Build
	$(DOCKERCMD) run -it -v $(PWD)/Build:/home/ubuntu/tianocore/Build --rm $(OPV) $(BUILD_ARCHS_CMD)

## runs container in foreground, override entrypoint to use use shell
docker-debug:
	$(DOCKERCMD) run -it --rm --entrypoint "/bin/bash" $(OPV)

## run container in background
docker-run-bg:
	$(DOCKERCMD) run -d --rm --name $(PROJECT) $(OPV)

## get into console of container running in background
docker-cli-bg:
	$(DOCKERCMD) exec -it $(PROJECT) /bin/bash

## tails $(DOCKERCMD)logs
docker-logs:
	$(DOCKERCMD) logs -f $(PROJECT)

## stops container running in background
docker-stop:
	$(DOCKERCMD) stop $(PROJECT)

## pushes to $(DOCKERCMD)hub
docker-push:
	$(DOCKERCMD) push $(OPV)

