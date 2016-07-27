# Docker Android build environment

This repo contains Dockerfiles for building Android within Docker. We used [appunite/docker](https://github.com/appunite/docker) as our starting point (thanks, appunite!).

# Image: Android 24.4.1 + Java 8

This docker is to build Android Gradle project with Java 8.

Contains:

* Android SDK: r24.4.1
* Build tools: 23.0.3
* Android API: 23
* Support maven repository
* Google maven repository
* Arm emulator: v23
* Platform tools
* Created emulator image named: "Nexus 5"

## Build image

```bash
make build
```

## Push build version to repository

```bash
make push
```

## Usage
Change directory to your project directory, than run:

```bash
docker run --rm -it --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm reddit/android:java8-r24-4-1  /bin/sh -c "./gradlew build"
```
