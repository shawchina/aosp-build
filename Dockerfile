# This dockerfile uses the ubuntu image
# VERSION 0 - EDITION 1
# Author:  Yen-Chin, Lee <yenchin@weintek.com>
# Command format: Instruction [arguments / command] ..

FROM ubuntu:16.04
MAINTAINER Shawn.Xiao, shawchina@163.com

ENV DEBIAN_FRONTEND noninteractive

ADD sources.list /etc/apt/sources.list
# Yocto's depends (plus sudo)
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install AOSP dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get --quiet --yes update && \
	apt-get -y install git-core gnupg flex bison gperf build-essential \
      	zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
      	lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
      	libgl1-mesa-dev libxml2-utils xsltproc unzip python bc openjdk-8-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm -rf /var/cache/*




# Set the default shell to bash instead of dash
RUN echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash

# Set the locale, else yocto will complain
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# default workdir is /yocto
WORKDIR /aosp

# Add entry point, we use entrypoint.sh to mapping host user to
# container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
