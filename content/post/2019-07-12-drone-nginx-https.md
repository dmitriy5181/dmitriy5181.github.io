---
title: "Secure Drone CI with HTTPS-enabled Nginx as reverse proxy"
---

**Prerequisites**

Nginx and Certbot supposed to be installed. If not:

    # apt install nginx python-certbot-nginx

Configure and enable Nginx "server block" (analog of "virtual host" in Apache):

    # vim /etc/nginx/sites-available/example.com
    ...
    # ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

To check Nginx configuration before enabling it, run:

    # nginx -t

**Obtain SSL certificate and reconfigure Nginx**

Just run next command and follow on-screen instruction:

    # certbot --nginx -d example.com

After completing, open *example.com* with the web-browser and check that redirection to HTTPS works.

**Enable reverse proxy for Drone**

Update "location /" directive in */etc/nginx/sites-available/example.com*:

```
location / {
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $http_host;
    
    proxy_pass http://127.0.0.1:8000;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_buffering off;
    
    chunked_transfer_encoding off;
}
```

Restart Nginx and add corresponding port mapping option while starting Drone:

    # docker run ... --publish 127.0.0.1:8000:80 ... drone/drone:1

**Links**

 * https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-debian-9
 * https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-debian-9
 * https://0-8-0.docs.drone.io/setup-with-nginx/