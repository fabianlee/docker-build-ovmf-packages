# Builds latest OVMF images

Building the latest OVMF images with the correct packages/libraries can be difficult, it is easier to package as an OCI (docker) image that can perform the task on your local host.

## X86_64 Ubuntu

[Install Docker](https://fabianlee.org/2023/09/14/docker-installing-docker-ce-on-ubuntu/), then run the following commands on Ubuntu.

```
# required OS packages
sudo apt install -y make git

# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI image
make

# use image to build latest OVMF
make docker-build-archs
```

## MacOSX M1

[Install Brew](https://docs.brew.sh/Installation) first.

To avoid the need for licensing Docker Desktop, install podman instead.

```
brew install podman
podman machine init
podman machine start
```

Then run the following commands on MacOSX.

```
# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI image
make

# use image to build latest OVMF
make docker-build-archs
```
