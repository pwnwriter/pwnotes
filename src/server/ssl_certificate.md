## Installing an SSL Certificate on a Domain Using Certbot manually

### 1. Install Certbot

If Certbot is not already installed, you can install it using the following commands:

**For Debian/Ubuntu:**

```sh
sudo apt update
sudo apt install certbot
```

### 2. Obtain the SSL Certificate

```export DOMAIN=<your domain>```

```bash
certbot certonly --manual -d *.$DOMAIN -d $DOMAIN --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --register-unsafely-without-email --rsa-key-size 4096

```

### 3. Certbot will provide instructions on how to create a DNS TXT record to verify your domain ownership. The output will look something like this:

```bash
Please deploy a DNS TXT record under the name
_acme-challenge.example.com with the following value:

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

Before continuing, verify the record is deployed.
```
After creating the DNS TXT record, wait for the changes to propagate. This can
take a few minutes. You can verify the DNS record by using a tool like
[`DNSChecker`][dnschecker]to ensure it has been properly set.

### 4. Setup ssl 
Your new SSL certificates will be stored in the /etc/letsencrypt/live/$DOMAIN/ directory. You will find the following files:

```bash
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}

```


[dnschecker]:https://dnschecker.org
