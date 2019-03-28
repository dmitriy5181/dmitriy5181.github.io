---
title: "Update upstream version for a Debian package"
---

Article describes how to use more recent upstream version of Unison on Debian "stable".

First, create directory for the workspace and change to it. Now obtain source package for the current version:

    $ apt-get --download-only source unison

To be able to do this, make sure that Apt sources list includes **deb-src** archive type. See */etc/apt/sources.list*.

Workspace should contain next files now (*X.Y.Z* is the version number):

    unison_X.Y.Z-1.dsc
    unison_X.Y.Z.orig.tar.gz
    unison_X.Y.Z-1.debian.tar.xz

Download archive with the latest upstream version and rename it to follow same pattern (*unison_X.Y.Z.orig.tar.gz*).

Unarchive upstream version and change to its directory. From that directory unarchive there also *unison_X.Y.Z-1.debian.tar.xz*. After this the workspace structure should look as follows (*A.B.C* here corresponds to the new upstream version):

    ├── unison-A.B.C
    │   ├── debian
    │   ├── doc
    │   ├── Dockerfile
    │   ├── icons
    │   ├── LICENSE
    │   ├── Makefile
    │   ├── README.md
    │   ├── src
    │   ├── tests
    │   └── unicode_utils
    ├── unison_X.Y.Z-1.debian.tar.xz
    ├── unison_X.Y.Z-1.dsc
    ├── unison_X.Y.Z.orig.tar.gz
    └── unison_A.B.C.orig.tar.gz

From inside *unison-A.B.C* first build and install a package which will depends on all build-dependencies:

    # mk-build-deps --install --remove

Now build deb-package for the new upstream Unison version:

    $ dpkg-buildpackage --no-sign --build=binary

It is highly possible that first build attempt will not succeed. Most likely some files inside *debian* directory should be adapted first.

After successful build, just created deb-package can be found in the root of workspace and can be installed in a normal way with the help of *apt* or *dpkg* commands.