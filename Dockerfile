FROM ubuntu:14.04

MAINTAINER Greg Taylor "greg.taylor@reddit.com"

# Install java8
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 \
    lib32gcc1 lib32ncurses5 lib32z1 python curl unzip

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz \
    --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar xzf android-sdk.tgz && rm -f android-sdk.tgz && \
    chown -R root.root android-sdk-linux

# Install Android NDK
RUN cd /opt && wget --output-document=android-ndk.zip \
    --quiet http://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip && \
    unzip -q android-ndk.zip && rm -f android-ndk.zip

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_NDK_HOME /opt/android-ndk-r12b
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter \
     platform-tools,android-23,android-24,build-tools-23.0.3,sys-img-armeabi-v7a-google_apis-23,extra-android-m2repository,extra-google-m2repository"]

RUN which adb
RUN which android

# Create emulator
RUN echo "no" | android create avd \
                --force \
                --device "Nexus 5" \
                --name nexus5_23 \
                --target android-23 \
                --abi google_apis/armeabi-v7a \
                --skin WVGA800 \
                --sdcard 512M

# Cleaning
RUN apt-get clean

# Create workspace
RUN mkdir -p /drone/src/github.com/reddit/

# Start up the emulator
RUN ["/bin/bash", "-c", "SHELL=/bin/bash emulator -avd nexus5_23 -no-skin -no-audio -no-window & /opt/tools/android-wait-for-emulator.sh"]

