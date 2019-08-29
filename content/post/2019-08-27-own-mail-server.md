---
title: "Setup own outgoing mail server"
---

Ability to have own outgoing mail server might be handy in some situation. For example to send automated notifications. And Postfix as a mail server is a popular option.

Although default Postfix configuration will work in general case, _Gmail_ and most likely other free mail services will not pass through such mail. For reliable mail delivery just only pure Postfix is not enough. Few other component should be in place also. Those components will be described first.

Next steps were done on Debian 10 _"buster"_ assuming `example.com` as a server's domain name.

__SASL authentication__

Install needed packages:

```
# apt install libsasl2-2 sasl2-bin
```

There are multiple possibilities to configure SASL authentication and this guide describes usage of SASL Authentication Daemon in combination with _sasldb_. Create an entry for the user and set password:

```
# saslpasswd2 -c -u example.com username
```

Create a file `/etc/postfix/sasl/smtpd.conf`:

```
pwcheck_method: saslauthd
mech_list: PLAIN LOGIN
```

Adjust `/etc/default/saslauthd` to contain following:

```
START=yes
MECHANISMS="sasldb"
OPTIONS="-c -m /var/spool/postfix/var/run/saslauthd"
```

Create required subdirectories in Postfix chroot:

```
# dpkg-statoverride --add root sasl 710 /var/spool/postfix/var/run/saslauthd
```

Restart SASL Authentication Daemon:

```
# systemctl restart saslauthd
```

Add Postfix to the _"sasl"_ group so that it can communicate with SASL Authentication Daemon:

```
# adduser postfix sasl
```

__Sender Policy Framework (SPF)__

Add a TXT record for a domain `example.com` with the next content:

```
v=spf1 a ~all
```

__DomainKeys Identified Mail (DKIM)__

Install needed packages:

```
# apt install opendkim opendkim-tools
```

Generate the pair of public/private keys:

```
# opendkim-genkey -D /etc/dkimkeys/ -d example.com -s default
```

Create directory to hold a unix socket for OpenDKIM under the Postfix chroot location:

```
# dpkg-statoverride --add opendkim opendkim 710 /var/spool/postfix/var/run/opendkim
```

Adjust OpenDKIM configuration in `/etc/opendkim.conf`:

```
Domain          example.com
KeyFile         /etc/dkimkeys/default.private
Selector        default

Socket          local:/var/spool/postfix/var/run/opendkim/opendkim.sock
```

Restart OpenDKIM and make sure it works:

```
# systemctl restart opendkim
```

Add a TXT record for a subdomain `default._domainkey.example.com` with the content taken from the `/etc/dkimkeys/default.txt`:

```
v=DKIM1; h=sha256; k=rsa; p=MIIB...
```

Add Postfix to the _"opendkim"_ group so that it can communicate with OpenDKIM:

```
# adduser postfix opendkim
```

__Domain-based Message Authentication, Reporting and Conformance (DMARC)__

After SPF and DKIM are configured, add a TXT record for a subdomain `_dmarc.example.com` with the next content:

```
v=DMARC1; p=none
```

__Reverse DNS lookup__

rDNS is relaying on a PTR record and to set it up for a DigitalOcean droplet set droplet's name same to the domain name (_example.com_).

__TLS certificates__

It is better to use proper certificates instead of self-signed which are provided by the _ssl-cert_ package. It can be easily done with the help of Let's Encrypt and `certbot`.

__Postfix__

Install needed packages:

```
# apt install mailutils postfix
```

Since Postfix will be used as a message submission agent (MSA) only a mail transfer agent (MTA) service can be turned off. As a result incoming mail will be disabled. To achieve this open Postfix master process configuration file _/etc/postfix/master.cf_, comment out line for the "smtp" service and uncomment the "submission" service:

```
#smtp      inet  n       -       y       -       -       smtpd
submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_tls_auth_only=yes
```

With this configuration the MTA-functionality on port 25 will be disabled and the MSA on port 587 enabled.

Next, adjust Postfix configuration parameters in _/etc/postfix/main.cf_:

```
# Important for rDNS
mydomain = example.com
myhostname = example.com

# OpenDKIM
milter_default_action = accept
milter_protocol = 6
smtpd_milters = unix:/var/run/opendkim/opendkim.sock
non_smtpd_milters = unix:/var/run/opendkim/opendkim.sock

# TLS certificates
smtpd_tls_cert_file=/etc/letsencrypt/live/example.com/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/example.com/privkey.pem

# Good to have
smtp_tls_security_level = may
```

Restart Postfix after updating its configuration:

```
# systemctl restart postfix
```

__Test tools__

Locally, a test mail can be send as:

```
echo "This is the body of the email" | mail -s "This is the subject line" your@email.address
```

Remotely, Swaks (Swiss Army Knife SMTP) can be used for the testing, for example:

```
$ swaks --to example@gmail.com --from test@example.com>" --server example.com --auth-user username@example.com --auth-password pa$$word --tls "Some message"

```

__References__

 - [How To Install and Configure Postfix as a Send-Only SMTP Server on Debian 10](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-debian-10)
 - [Debian 9 Mail Server, Part I: Postfix and Dovecot](https://scaron.info/blog/debian-mail-postfix-dovecot.html)
 - [Debian 9 Mail Server, Part II: SPF and DKIM](https://scaron.info/blog/debian-mail-spf-dkim.html)
 - https://wiki.debian.org/opendkim
 - https://wiki.debian.org/PostfixAndSASL
 - http://www.postfix.org/SASL_README.html
 - http://www.postfix.org/postconf.5.html