#!/bin/bash
#docker run -it --rm --privileged -v /dev/:/dev/ quay.io/port/stratum1-imagebuilder:latest
sdcard="/dev/sdc"
#xzcat --verbose /opt/ubuntu-server.img.xz | dd bs=4M of=${sdcard}
mount "${sdcard}2" /mnt
mkdir -p /mnt/boot/firmware
mount "${sdcard}1" /mnt/boot/firmware/
cp -frv /opt/port/stratum1/cloud-init/* /mnt/
cp -vf /opt/u-boot/u-boot.bin /mnt/boot/firmware/uboot_rpi_4.bin
umount /mnt/boot/firmware /mnt
