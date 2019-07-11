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

### Routing all client traffic through the VPN

To implement this the directive `redirect-gateway def1` should be set for client. It can be done either for only specific client(s) via client's configuration or for all clients at once via server's configuration. By using this directive the server need to be configured to deal with client traffic. To NAT the VPN client traffic to the Internet:

    # iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

Command assumes that the VPN subnet is *10.8.0.0/24* (taken from the server directive in the OpenVPN server configuration) and that the local ethernet interface is *eth0*. To persist this settings the *iptables-persistent* package can be used.

### Links

 * https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-debian-9
 * https://openvpn.net/community-resources/how-to