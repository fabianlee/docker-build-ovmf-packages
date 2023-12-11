FROM ubuntu:jammy-20231128

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV WORKSPACE=/home/ubuntu/tianocore
ENV PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms:$WORKSPACE/edk2-non-osi

# accept override of value from --build-args
ARG EDK2_GIT_TAG=
ENV EDK2_GIT_TAG=$EDK2_GIT_TAG

WORKDIR ${WORKSPACE}

# https://github.com/tianocore/edk2-platforms
# python needed for making BaseTools
# cross-compiler support for gcc: aarch64 and arm
RUN apt update \
  && apt install -q -y -o Dpkg::Options::="--force-confnew" ca-certificates curl build-essential gcc git uuid-dev iasl nasm python3-dev python-is-python3 gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi

# source files
RUN mkdir -p ${WORKSPACE}; cd ${WORKSPACE} && \
  [ -n "${EDK2_GIT_TAG}" ] && git clone --depth 1 --branch ${EDK2_GIT_TAG} https://github.com/tianocore/edk2.git || git clone --depth 1 https://github.com/tianocore/edk2.git && \
  cd edk2 && \
  git submodule update --init --depth 1 && cd .. && \
  git clone --depth 1 https://github.com/tianocore/edk2-platforms.git && cd edk2-platforms && \
  git submodule update --init --depth 1 && cd .. && \
  git clone --depth 1 https://github.com/tianocore/edk2-non-osi.git && \
  git clone --depth 1 https://git.linaro.org/uefi/uefi-tools.git
#  && rm -rf /var/lib/apt/lists/* \
#  && update-ca-certificates

# python needed for making BaseTools
#RUN apt install -q -y -o Dpkg::Options::="--force-confnew" python3-dev python-is-python3

# cross-compiler support for gcc
#RUN apt install -q -y -o Dpkg::Options::="--force-confnew" gcc-aarch64-linux-gnu

RUN cd edk2 && \
  . ./edksetup.sh && \
  make -C BaseTools/

# https://www.garyhawkins.me.uk/custom-logo-on-uefi-boot-screen/
# custom logo for OVMF
COPY custom-logo.bmp edk2/MdeModulePkg/Logo/Logo.bmp
#RUN echo ${PACKAGES_PATH} && \
#  uefi-tools/edk2-build.sh juno

# show tag being used
RUN cd edk2 && git branch && git tag

# start
#CMD [ "bash" ]



