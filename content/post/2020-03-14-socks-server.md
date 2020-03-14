---
title: "Setup and use SOCKS server"
---

In some cases it might be useful to run own SOCKS server. Dante (see `danted(8)`) which implements server
as well as client part might be a possible choice.

**Server**

Install package:

```
$ sudo apt install dante-server
```

Configuration file is installed at `/etc/danted.conf`, possible values are:

```
logoutput: syslog

internal: <interface> port = 1080
external: <interface>

socksmethod: none
clientmethod: none

user.privileged: proxy
user.unprivileged: nobody
user.libwrap: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
```

Server can be controlled with `systemctl`.

**Client**

While Dante has client part also, Firefox can directly use SOCKS server. Network Proxy configuration
can be set in Preferences.
