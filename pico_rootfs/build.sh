#!/bin/bash -e

#
# SPDX-FileCopyrightText: © 2025 Hiruna Wijesinghe <hiruna.kawinda@gmail.com>
# SPDX-License-Identifier: GPL-2.0-only
#

function split_tar() {
    local tar_dir="$1"
    local tar_filename="$2"
    local split_size="50M"
    local num_files="$(du -sh "$folder_path" | awk '{print $1/50}')"

    if [[ ! -d ${tar_dir} ]]; then
      echo "directory ${tar_dir} does not exist!"
      exit 1
    fi
    if [[ ! -f "${tar_dir}/${tar_filename}" ]]; then
      echo "file ${tar_dir}/${tar_filename} does not exist!"
      exit 1
    fi
    cwd=$(pwd)
    cd "${tar_dir}"

    echo "Calculating md5 for each split package..."
    md5sum "./${tar_filename}" > "./${tar_filename}.md5"

    echo "Splitting folder $folder_path into $num_files packages of size $split_size..."
    split -b "$split_size" -d -a 1 "./${tar_filename}" "./${tar_filename}.split."

    echo "Split and md5 calculation completed."

    cd "${cwd}"
}

UBUNTU_VERSION=22.04.3
UBUNTU_BASE_TAR_FILENAME="ubuntu-base-${UBUNTU_VERSION}-base-armhf.tar.gz"
PICO_ROOTFS_IMAGE_TAG="pico_rootfs_ubuntu:${UBUNTU_VERSION}"
OUTPUT_DIR="./output/$(date '+%Y-%m-%d_%H%M%S')"
OUTPUT_TAR_FILENAME="luckfox-ubuntu-${UBUNTU_VERSION}.tar"

if [[ ! -f ${OUTPUT_DIR} ]]; then
  mkdir -p "${OUTPUT_DIR}"
fi

TEMP_ROOTFS_DIR=$(mktemp -d --suffix pico_rootfs -p "${OUTPUT_DIR}/")

if [[ ! -f ${UBUNTU_BASE_TAR_FILENAME} ]]; then
  echo "Downloading ${UBUNTU_BASE_TAR_FILENAME}..."
  wget https://cdimage.ubuntu.com/ubuntu-base/releases/${UBUNTU_VERSION}/release/${UBUNTU_BASE_TAR_FILENAME} \
    -O ${UBUNTU_BASE_TAR_FILENAME}
fi

docker buildx build --platform linux/arm/v7 -t ${PICO_ROOTFS_IMAGE_TAG} \
  --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} . --output "type=tar,dest=${OUTPUT_DIR}/${OUTPUT_TAR_FILENAME}"

echo "Compressing ${OUTPUT_DIR}/${OUTPUT_TAR_FILENAME} into ${OUTPUT_DIR}/${OUTPUT_TAR_FILENAME}.gz"
gzip "${OUTPUT_DIR}/${OUTPUT_TAR_FILENAME}"

rm -rf ${TEMP_ROOTFS_DIR}

# split_tar "${OUTPUT_DIR}" "${OUTPUT_TAR_GZ_FILENAME}"