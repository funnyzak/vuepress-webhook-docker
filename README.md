# Vuepress Webhook Docker

Pull your vuepress project Git code into a data volume and trigger automatic packaging via Webhook.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/vuepress-webhook.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/vuepress-webhook/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/vuepress-webhook.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/vuepress-webhook/)

This image is based on Alpine Linux image, which is a 163MB image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/vuepress-webhook.svg)](http://microbadger.com/images/funnyzak/vuepress-webhook "Get your own image badge on microbadger.com")

[Docker hub image: funnyzak/vuepress-webhook](https://hub.docker.com/r/funnyzak/vuepress-webhook)

Docker Pull Command: `docker pull funnyzak/vuepress-webhook`

Webhook Url: [http://hostname:9000/hooks/vuepress-webhook](#)

---

## Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

- **USE_HOOK** : The web hook is enabled as long as this is present.
- **GIT_REPO** : URL to the repository containing your source code
- **GIT_BRANCH** : Select a specific branch (optional)
- **GIT_EMAIL** : Set your email for code pushing (required for git to work)
- **GIT_NAME** : Set your name for code pushing (required for git to work)

## Volume Configuration

- **/app/code** : vuepress output dir.
- **/app/output** : source code dir. Will automatically pull the code.
- **/root/.ssh** :  If it is a private repository, please set ssh key

### ssh-keygen

`ssh-keygen -t rsa -b 4096 -C "youremail@gmail.com" -N "" -f ./id_rsa`

---

## Docker-Compose

 ```docker
version: '3'
services:
  vuepress:
    image: funnyzak/vuepress-webhook
    privileged: true
    container_name: vuepress
    working_dir: /app/code
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - USE_HOOK=1
      - GIT_REPO=git@github.com:username/repo_name.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
    restart: on-failure
    # 映射端口
    ports:
      - 9000:9000 # webhook port
    volumes:
      - ./output:/app/output
      - ./code:/app/code
      - ./ssh:/root/.ssh

 ```

---

## Nginx

 ```nginx
server {
    listen       80;
    server_name  yourdomain.com;

    underscores_in_headers on;
    ssl off;

    location / {
        root   /mnt/app/vuepress/output;
        index  index.html index.htm;
    }

    location /webhook {
        proxy_set_header Host $host;
        proxy_set_header X-Real-Ip $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_pass http://127.0.0.1:9000/hooks/vuepress-webhook;
    }

    error_page  404   /404.html;
}

 ```

Please configure according to the actual deployment path and port.
