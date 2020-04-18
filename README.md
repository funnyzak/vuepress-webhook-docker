# Vuepress Webhook Docker

Pull your vuepress project Git code into a data volume and trigger automatic packaging via Webhook.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/vuepress-webhook.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/vuepress-webhook/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/vuepress-webhook.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/vuepress-webhook/)

This image is based on Alpine Linux image, which is a 163MB image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/vuepress-webhook.svg)](http://microbadger.com/images/funnyzak/vuepress-webhook "Get your own image badge on microbadger.com")

[Docker hub image: funnyzak/vuepress-webhook](https://hub.docker.com/r/funnyzak/vuepress-webhook)

Docker Pull Command: `docker pull funnyzak/vuepress-webhook`

Visit Url: [http://hostname:80/](#)

Webhook Url: [http://hostname:80/hooks/git-webhook](#)

---

## Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

* **USE_HOOK** : The web hook is enabled as long as this is present.
* **GIT_REPO** : URL to the repository containing your source code
* **GIT_BRANCH** : Select a specific branch (optional)
* **GIT_EMAIL** : Set your email for code pushing (required for git to work)
* **GIT_NAME** : Set your name for code pushing (required for git to work)
* **WEBHOOK_LIST** : Optional. Notify link array that send notifications when pull code, each link is separated by **|**
* **HOOK_NAME** : Optional. When setting **WEBHOOK_LIST**, it is best to set a HOOK name

---

## Volume Configuration

* **/app/target** :  builded code files will move to this folder.
* **/app/code** : source code dir. Will automatically pull the code.
* **/root/.ssh** :  If it is a private repository, please set ssh key

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
      - WEBHOOK_LIST=http://link1.com/hook|http://link2.com/hook
      - HOOK_NAME=vuepress_app
    restart: on-failure
    ports:
      - 80:80
    volumes:
      - ./target:/app/target
      - ./code:/app/code
      - ./ssh:/root/.ssh

 ```

---

Please configure according to the actual deployment path and port.
