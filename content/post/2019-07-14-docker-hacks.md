---
title: "Docker hacks"
---

**Rename docker volume**

Unfortunately Docker does not directly support volume rename operation. But same result can be achieved
by copying data from the one volume to the other (assuming *source* and *destination* already exist):

```
$ docker run --rm -it -v <source>:/from -v <destination>:/to alpine ash -c "cd /from ; cp -av . /to"
```

Also through the SSH:

```
$ ssh <host> 'docker run --rm -v <source>:/from alpine ash -c "tar cf - -C /from ."' | docker run --rm -i -v <destination>:/to alpine ash -c "tar xpf - -C /to"
```

Late *source* can be removed.

**Host user in Docker container**

With bind mount, a directory on *host* machine is mounted into a container. And files in that folder
created by process from the container will have owner name and group set to that process's name and group
(such as *root*).

Which is inconvenient since host user will not be able to change such files. To avoid this issue user
with the *UID* and *GID* same to host user should exist inside container. Next commands in Dockerfile
will do that:

```
ARG UID
ARG GID

RUN addgroup --gid $GID host-group
RUN adduser --disabled-password --gecos "" --uid $UID --gid $GID host-user
```

Corresponding values should be provided during build:

    $ docker build --build-arg UID=$UID --build-arg GID=$GID .

User with the name *host-user* will exist inside container. And any files created by this user will look
exactly the same like created by local user.

**Alternative BASEIMAGE**

Might be useful to build images for more then one CPU architecture with the same Dockerfile. Next commands
will allow to specify base image during build:

```
ARG BASEIMAGE=debian:stretch-slim

FROM $BASEIMAGE
```

By default, build will use *amd64* architecture. And to build image for *armhf* (Raspberry Pi):

```
$ docker build --build-arg BASEIMAGE=resin/rpi-raspbian:stretch .
```
