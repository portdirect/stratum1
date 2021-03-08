#docker build ./imagebuilder -t quay.io/port/stratum1-imagebuilder:latest
#docker push quay.io/port/stratum1-imagebuilder:latest
ARG FROM=debian:bullseye-slim
FROM ${FROM} as base-image
LABEL maintainer="pete@port.direct"

SHELL ["bash", "-exc"]
ARG DEBIAN_FRONTEND=noninteractive

FROM base-image as ubin

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
        git \
        make \
        gcc \
        gcc-aarch64-linux-gnu \
        libc6-dev \
        bison \
        flex \
        build-essential \
        bc

RUN git clone --depth 1 git://git.denx.de/u-boot.git /opt/u-boot

ADD ./assets/u-boot /opt/port/stratum1/u-boot

RUN cat /opt/port/stratum1/u-boot/rpi_4_defconfig >> /opt/u-boot/configs/rpi_4_defconfig ;\
    sed '/"dhcpuboot=usb start; dhcp u-boot.uimg; bootm\\0" \\/a\ \ \ \ \ \ \ \ "silent=1\\0" \\' /opt/u-boot/include/configs/rpi.h

RUN cd /opt/u-boot ;\
    make rpi_4_defconfig ;\
    make CROSS_COMPILE=aarch64-linux-gnu- ;\
    ls -lah /opt/u-boot/u-boot.bin

FROM base-image as writer

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        xz-utils \
        coreutils \
        gdisk \
        parted

RUN curl -sSl -o /opt/ubuntu-server.img.xz https://cdimage.ubuntu.com/releases/20.04.2/release/ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz

COPY --from=ubin /opt/u-boot/u-boot.bin /opt/u-boot/u-boot.bin

ADD ./assets /opt/port/stratum1