OWNER := fabianlee
PROJECT := docker-build-ovmf-package
VERSION := 1.0.0
OPV := $(OWNER)/$(PROJECT):$(VERSION)
MACHINE = $(shell uname -m)

#
# Use 'podman' on MacOSX (to avoid Docker Desktop), else 'docker'
#
# architecture list for uefi-tools:
# https://github.com/tianocore/edk2-platforms
#
ifeq ($(MACHINE), arm64)

DOCKERCMD := "podman"
BUILD_ARCHS_CMD:= uefi-tools/edk2-build.sh armvirtqemu64 juno
# ovmfia32

else

# you may need to change to "sudo docker" if not a member of 'docker' group
# add user to docker group: sudo usermod -aG docker $USER
DOCKERCMD := "docker"
BUILD_ARCHS_CMD:= uefi-tools/edk2-build.sh ovmfx64

endif

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)


## builds docker image
docker-build:
	@echo Building on $(MACHINE) archiecture using $(DOCKERCMD)
	$(DOCKERCMD) --version
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build --progress plain --build-arg "EDK2_GIT_TAG=" -f Dockerfile -t localhost/$(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm localhost/$(OPV) | true

## runs container in foreground
docker-run-fg:
	mkdir -p Build
	$(DOCKERCMD) run -it -v $(PWD)/Build:/home/ubuntu/tianocore/Build --rm localhost/$(OPV)

## runs container in foreground, builds OVMF unto local 'Build/' directory
docker-build-archs:
	mkdir -p Build
	$(DOCKERCMD) run -it -v $(PWD)/Build:/home/ubuntu/tianocore/Build --rm localhost/$(OPV) $(BUILD_ARCHS_CMD)

## pushes to docker hub (must do 'docker login' first)
docker-push:
	$(DOCKERCMD) login docker.io
	$(DOCKERCMD) tag localhost/$(OPV) docker.io/$(OPV)
	$(DOCKERCMD) push $(OPV)
	@echo pushed to Hub: https://hub.docker.com/repository/docker/fabianlee/docker-build-ovmf-package

