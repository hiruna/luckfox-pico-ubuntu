#!/bin/bash

#
# SPDX-FileCopyrightText: © 2025 Hiruna Wijesinghe <hiruna.kawinda@gmail.com>
# SPDX-License-Identifier: GPL-2.0-only
#

UBUNTU_VERSION=22.04.3

docker build --platform linux/arm/v7 -t pico_rootfs_ubuntu:${UBUNTU_VERSION} \
 --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} .

