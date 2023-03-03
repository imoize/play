# Docker baseimage-alpine
[![GitHub](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub&logo=github)](https://github.com/imoize "view the source for all of our repositories.")
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub%20Package&logo=github)](https://github.com/imoize/test/packages)
[![Docker Pulls](https://img.shields.io/docker/pulls/sestnact/qloapps.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/imoize/test)

## Custom image based on alpine with s6-overlay 

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose `recommended`

```yaml
version: "3.7"
services:
  alpine:
    image: ghcr.io/imoize/test:latest
    container_name: alpine
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Jakarta
```

```bash
cd /path/to/app/data
```

| Parameter | Function |
| :----: | --- |
| `-p 443` | WebUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /data` | Your personal data. |




