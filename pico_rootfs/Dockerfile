ARG UBUNTU_VERSION=22.04.3
FROM scratch AS ubuntu_base
ARG UBUNTU_VERSION
ENV UBUNTU_VERSION=${UBUNTU_VERSION}

ADD ./ubuntu-base-${UBUNTU_VERSION}-base-armhf.tar.gz /

FROM --platform=linux/arm/v7 ubuntu_base
LABEL authors="hiruna"
ARG UBUNTU_VERSION
ENV UBUNTU_VERSION=${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Sydney

ADD ./ubuntu-base-${UBUNTU_VERSION}-base-armhf.tar.gz /

COPY ./apt_packages.txt /tmp/apt_packages.txt

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install $(cat /tmp/apt_packages.txt | tr "\n" " ")

RUN groupadd -g 1000 pico && \
    useradd -m -d /home/pico -s /bin/bash -g 1000 -G sudo -u 1000 -p "$(openssl passwd -1 luckfox)" pico

RUN usermod -a -G sudo pico

COPY ./fstab /etc/fstab

RUN apt clean && rm -rf /tmp/*