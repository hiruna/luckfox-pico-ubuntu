#!/bin/bash

#
# SPDX-FileCopyrightText: © 2025 Hiruna Wijesinghe <hiruna.kawinda@gmail.com>
# SPDX-License-Identifier: GPL-2.0-only
#

UBUNTU_VERSION=22.04.3

UBUNTU_BASE_TAR_FILENAME="ubuntu-base-${UBUNTU_VERSION}-base-armhf.tar.gz"

if [[ ! -f ${UBUNTU_BASE_TAR_FILENAME} ]]; then
  echo "Downloading ${UBUNTU_BASE_TAR_FILENAME}..."
  wget https://cdimage.ubuntu.com/ubuntu-base/releases/${UBUNTU_VERSION}/release/${UBUNTU_BASE_TAR_FILENAME} \
    -O ${UBUNTU_BASE_TAR_FILENAME}
fi

docker build --platform linux/arm/v7 -t ubuntu_base:${UBUNTU_VERSION} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} .