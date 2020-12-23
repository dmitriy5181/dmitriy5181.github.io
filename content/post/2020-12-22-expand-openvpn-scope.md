---
title: "Expand the scope of the VPN"
---

Suppose a client machine connects to the VPN and at the same time to the local LAN. 
In this case such client can act as a gateway for the LAN and VPN clients will be able to reach LAN machines
through it. Next image illustrates the situation.

![](/lan-gateway.png)

To achieve connectivity between VPN and LAN clients following adjustments are needed.

**OpenVPN server**

Tell the OpenVPN server that the 192.168.178.0/24 subnet should be routed to a LAN gateway.
For this the LAN gateway configuration should contain (can be set through the *ccd* directory):

    iroute 192.168.178.0 255.255.255.0

Then set in the main server configuration file:

    route 192.168.178.0 255.255.255.0

Also, to allow network traffic between LAN and VPN clients ask OpenVPN server to advertise LAN subnet
to VPN clients by adding to the server configuration:

    client-to-client
    push "route 192.168.178.0 255.255.255.0"

**LAN gateway**

Enable IP forwarding (to make it persistent add *"net.ipv4.ip_forward=1"* to the */etc/sysctl.conf*):

    # sysctl -w net.ipv4.ip_forward=1

Set the iptables rule (*iptables-persistent* package can be used to make it persistent):

    # iptables -t nat -A POSTROUTING -j MASQUERADE

**References**

 - https://openvpn.net/community-resources/how-to/#scope
