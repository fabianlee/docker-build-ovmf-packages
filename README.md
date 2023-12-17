# Builds OVMF images using gcc cross-compilation

Building the latest OVMF images with the correct libraries can be difficult, so it is better to package up all the OS level dependencies.

## on X86_64 Ubuntu

[Install Docker](https://fabianlee.org/2023/09/14/docker-installing-docker-ce-on-ubuntu/), then 

`
# required OS packages
sudo apt install -y make git

# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI image
make

# use image to build latest OVMF
make docker-build-archs

# results
find Build -name '*.fd'
`

## on MacOSX

To avoid the need for licensing Docker Desktop, use podman instead.

`
brew install podman
podman machine init
podman machine start

# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI image
make

# use image to build latest OVMF
make docker-build-archs

# results
find Build -name '*.fd'
`
