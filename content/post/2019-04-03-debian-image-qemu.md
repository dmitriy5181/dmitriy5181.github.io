---
title: "Debian image for QEMU"
---

How to create and run Debian image with QEMU. Might be useful for testing.

Create the hard disk image of 'qcow2' format (`-f` option) with specified *filename* and 4 gigabytes size:

    $ qemu-img create -f qcow2 debian-base.qcow 4G

Download installation *.iso* from the https://www.debian.org/distrib/. Boot the image with previously created image as hard disk 0 (`-hda` option), 512 megabytes of RAM (`-m` option), downloaded *.iso* as CD-ROM (`-cdrom` option) and with the first CD-ROM as boot drive (`-b` option):

    $ qemu-system-x86_64 -hda debian-base.qcow -m 512 -cdrom debian-9.8.0-amd64-netinst.iso -boot d

After the installation is done, the system can be booted with (append next options to enable ssh forwarding: *-net nic -net user,hostfwd=tcp::2222-:22*):

    $ qemu-system-x86_64 -hda debian-base.qcow -m 512

Taking a snapshot of 'qcow2' format (`-f` option) using specified file as *base image* (`-b` option):

    $ qemu-img create -f qcow2 -b debian-base.qcow debian-base-snapshot-01.qcow

Run from the snapshot:

    $ qemu-system-x86_64 -hda debian-base-snapshot-01.qcow -m 512
​
To avoid changing the hard drive image during run add `-snapshot` option and changes will be written to temporary files leaving disk image unaffected.

Useful links:

 * https://wiki.debian.org/QEMU
 * https://dustymabe.com/2015/01/11/qemu-img-backing-files-a-poor-mans-snapshotrollback/
