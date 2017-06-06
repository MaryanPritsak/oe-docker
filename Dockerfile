FROM ubuntu:16.10

RUN apt-get update && apt-get install -y \
        gawk \
        wget \
        git-core \
        diffstat \
        unzip \
        texinfo \
        gcc-multilib \
        build-essential \
        chrpath \
        socat \
        libsdl1.2-dev \
        xterm \
        locales \
        cpio \
        python \
        python \
        iputils-ping


# Locale
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Add user
ARG user
ARG uid
ARG guid
ENV USER $user
RUN groupadd -f -r -g $guid g$user
RUN useradd $user -l -u $uid -g $guid -d /var/$user -m -s /bin/bash

# Set workung directory to poky
ARG poky_dir
WORKDIR $poky_dir

USER $user
