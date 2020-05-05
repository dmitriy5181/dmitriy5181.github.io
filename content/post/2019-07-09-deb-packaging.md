---
title: "The simplest possible Debian packaging"
---

**Package**

Basic skeleton for the Debian-package can be build with the help of `debmake`. As a result the *debian* directory with the minimal set of required files will be created:

    $ DEBEMAIL=test@example.com DEBFULLNAME=Test debmake --native --package test --upstreamversion 1.0.0 --revision 1
    $ find debian -type f -not -name control -not -name copyright -not -name changelog -not -name rules -not -name compat -not -name format -delete

To build binary package (`-b`) without signing the *.changes* file (`-uc`):

    $ dpkg-buildpackage -uc -b

Created *deb-package* will be in one directory up.

**Repository**

Managing the Debian packages repository can be done with the `reprepro`. Assuming repository will be located under the directory */srv/packages*, create simple text file in it: */srv/packages/conf/distributions*. With the content:

```
Codename: stretch
Architectures: amd64
Components: main
```

After this, a binary package can be added into the repository with the next command:

    # reprepro --basedir /srv/packages includedeb stretch /path/to/package_1.0.0_all.deb

To be able to use this repository locally, create file */etc/apt/sources.list.d/local.list* with the next content:

    deb [trusted=yes] file:///srv/packages stretch main

More information about APT data sources, including recognized URI types can be found in `sources.list(5)`.

**Useful links**

 * Guide for Debian Maintainers, https://www.debian.org/doc/manuals/debmake-doc/index.en.html
 * Debian New Maintainers' Guide, https://www.debian.org/doc/manuals/maint-guide/index.en.html
 * Debian Policy Manual, technical requirements that each package must satisfy, https://www.debian.org/doc/debian-policy/
   * Maintainer script flowcharts, https://www.debian.org/doc/debian-policy/ap-flowcharts.html
