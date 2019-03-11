---
title: "How to setup reliable ssh tunnel"
---

Used tools are autossh and systemd user unit. Might be useful for Raspberry Pi in combination with http://serveo.net

Install autossh:

```
% sudo apt install autossh
```

Create ssh tunnel configuration in the `~/.ssh/config`:

```
Host example
    HostName example.net
    RemoteForward 22 localhost:22
    ServerAliveInterval 30
    ServerAliveCountMax 3
    ExitOnForwardFailure yes
```

Before going any further, run next command to authenticate host and update `~/.ssh/known_hosts`:

```
% ssh example
```

Create systemd template unit file `~/.config/systemd/user/autossh-tunnel@.service`:

```
[Unit]
Description=AutoSSH to '%I'
After=network.target

[Service]
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -M 0 -N %I
ExecStop=/bin/kill $MAINPID

[Install]
WantedBy=default.target
```

Reload configuration and start service:

```
% systemctl --user daemon-reload
% systemctl --user start autossh-tunnel@example
```

Enable autostart for the service:

```
% systemctl --user enable autossh-tunnel@example
```

Allow (optionally) to run services without session been opened:

```
% sudo loginctl enable-linger username
```