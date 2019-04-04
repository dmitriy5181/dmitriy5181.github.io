---
title: "Minimal deb-packaging workflow"
---

Article describes basic steps to create and build minimal *deb-package*.

First, install required packages:

    # apt install build-essential debhelper dh-make devscripts

Create skeleton for the *deb-package*. As a result the *debian* directory with the minimal set of required file will be created:

    $ DEBEMAIL=test@example.com DEBFULLNAME=Test dh_make --native --single --packagename test_1.0.0 --yes
    $ find debian -not -name debian -not -name control -not -name copyright -not -name changelog -not -name rules -not -name compat -not -path \*source\* -delete

To build binary package (`-b` option) without signing the *.changes* file (`-uc` option). Created deb-package will be in one directory up:

    $ dpkg-buildpackage -uc -b

After making some changes, to bump package version run `dch` with option `-U` to increment version and update the *debian/changelog* file properly:

    $ dch -U "some message"

Useful links:

 * The Debconf Programmer's Tutorial, Debconf should be used whenever your package needs to output something to the user, or ask a question, http://www.fifi.org/doc/debconf-doc/tutorial.html
 * Debian Policy Manual, technical requirements that each package must satisfy, https://www.debian.org/doc/debian-policy/
 * Maintainer script flowcharts, https://www.debian.org/doc/debian-policy/ap-flowcharts.html
 * Debian New Maintainers' Guide, https://www.debian.org/doc/manuals/maint-guide/index.en.html
 * Debian Packaging For The Modern Developer, https://github.com/phusion/debian-packaging-for-the-modern-developer
​