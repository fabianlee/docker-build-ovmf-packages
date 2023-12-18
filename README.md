# Builds latest OVMF images

Building the latest OVMF images with the correct packages/libraries can be difficult, it is easier to package as an OCI (docker) utility image that can perform the task on your local host.

Utility mounts local 'Build' subdirectory where OVMF images will be placed.

## X86_64

### Prerequisites

[Install Docker](https://fabianlee.org/2023/09/14/docker-installing-docker-ce-on-ubuntu/), and following OS packages on Ubuntu.

```
# required OS packages
sudo apt install -y make git
```

### Build OVMF

```
# required OS packages
sudo apt install -y make git

# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI utility image
make

# use image to build latest OVMF
make docker-build-archs
```

### Testing

[Install KVM](https://fabianlee.org/2018/08/27/kvm-bare-metal-virtualization-on-ubuntu-with-kvm/) first, then run:

```
./test-x86-onx86.sh
```


## MacOSX on Apple Silicon (M1)

### Prerequisites

[Install Brew](https://docs.brew.sh/Installation) first.

To avoid the need for licensing Docker Desktop, install podman instead.

```
brew install podman
podman machine init
podman machine start
```

### Build OVMF

Then run the following commands on MacOSX.

```
# get project code
git clone https://github.com/fabianlee/docker-build-ovmf-packages.git && cd $(basename $_ .git)

# create OCI image
make

# use image to build latest OVMF
make docker-build-archs
```

### Testing

```
./test-arm64-on-arm64.sh
```
