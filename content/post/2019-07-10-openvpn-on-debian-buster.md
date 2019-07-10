---
title: "Setup OpenVPN on Debian 'buster'"
---

### Prerequisites

First, install needed package:

    # apt install openvpn

### Easy-RSA

Create certificates directory:

    $ make-cadir myca

From inside that directory initiate the public key infrastructure (PKI):

    $ ./easyrsa init-pki

Create new certificate authority (CA):

    $ ./easyrsa build-ca nopass

Generate a keypair and certificate request for the **server**:

    $ ./easyrsa gen-req <server-name> nopass

Then sign the request:

    $ ./easyrsa sign-req server <server-name>

Generate a keypair and certificate request for the **client**:

    $ ./easyrsa gen-req <client-name> nopass

Then sign the request:

    $ ./easyrsa sign-req client <client-name>

### OpenVPN

The `/usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz` and `/usr/share/doc/openvpn/examples/sample-config-files/client.conf` can be used as starting point to create server and client configuration files respectively. Parameters are mostly self-explanatory.

Generate an HMAC signature:

    $ openvpn --genkey --secret ta.key

Create a strong Diffie-Hellman key:

    $ openssl dhparam -out dh2048.pem 2048


### Server

Uncomment next line in the `/etc/sysctl.conf`:

    net.ipv4.ip_forward=1

and apply changes:

    # sysctl -p

Put `ca.crt`, `dh2048.pem`, `ta.key` and `<server-name>.{conf,crt,key}` files into the directory `/etc/openvpn/server`.

Start service:

    # systemctl start openvpn-server@<server-name>

### Client

Put `ca.crt`, `ta.key` and `<client-name>.{conf,crt,key}` files into the directory `/etc/openvpn/client`.

Start service:

    # systemctl start openvpn-client@<client-name>

### Links

 * https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-debian-9