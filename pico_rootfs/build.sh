#!/bin/bash

#
# SPDX-FileCopyrightText: © 2025 Hiruna Wijesinghe <hiruna.kawinda@gmail.com>
# SPDX-License-Identifier: GPL-2.0-only
#

UBUNTU_VERSION=22.04.3
UBUNTU_BASE_TAR_FILENAME="ubuntu-base-${UBUNTU_VERSION}-base-armhf.tar.gz"
PICO_ROOTFS_IMAGE_TAG="pico_rootfs_ubuntu:${UBUNTU_VERSION}"
OUTPUT_DIR="./output"
OUTPUT_TAR_GZ_FILENAME="luckfox-ubuntu-${UBUNTU_VERSION}.tar.gz"
TEMP_ROOTFS_DIR=$(mktemp -d --suffix pico_rootfs -p output/)

if [[ ! -f ${UBUNTU_BASE_TAR_FILENAME} ]]; then
  echo "Downloading ${UBUNTU_BASE_TAR_FILENAME}..."
  wget https://cdimage.ubuntu.com/ubuntu-base/releases/${UBUNTU_VERSION}/release/${UBUNTU_BASE_TAR_FILENAME} \
    -O ${UBUNTU_BASE_TAR_FILENAME}
fi

docker buildx build --platform linux/arm/v7 -t ${PICO_ROOTFS_IMAGE_TAG} \
  --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} . --output ${TEMP_ROOTFS_DIR}

tar cvzf "${OUTPUT_DIR}/${OUTPUT_TAR_GZ_FILENAME}" ${TEMP_ROOTFS_DIR}

rm -rf ${TEMP_ROOTFS_DIR}