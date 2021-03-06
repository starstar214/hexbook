---
layout:     post
title:      "Linux 下安装 Nginx"
subtitle:   "「软件安装」Nginx"
date:       2020-10-19
author:     "Hex"
header-img: "img/post-bg-os-metro.jpg"
catalog:     true
tags:
    - 软件安装
    - Nginx
---



Nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, nginx served or proxied 25.76% busiest sites in September 2020.



## 安装 Nginx

1. 使用 DNF 包管理器安装Nginx

   ~~~shell
   [root@localhost /]# dnf install nginx
   ~~~

   系统会自动解决相关依赖并安装Nginx。

2. 使用 dnf 安装 nginx 后，系统会将其自动加入 systemctl 进行管理。

   ~~~shell
   [root@localhost /]# systemctl start nginx         启动nginx
   [root@localhost /]# systemctl stop nginx          停止nginx
   [root@localhost /]# systemctl status nginx        查看nginx状态
   ● nginx.service - The nginx HTTP and reverse proxy server
      Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
      Active: inactive (dead)
   
   9月 11 00:20:15 localhost.localdomain systemd[1]: nginx.service: Unit cannot be reloaded because it is inactive.
   9月 11 00:20:58 localhost.localdomain systemd[1]: Starting The nginx HTTP and reverse proxy server...
   9月 11 00:20:58 localhost.localdomain nginx[27331]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
   9月 11 00:20:58 localhost.localdomain nginx[27331]: nginx: configuration file /etc/nginx/nginx.conf test is successful
   9月 11 00:20:59 localhost.localdomain systemd[1]: Started The nginx HTTP and reverse proxy server.
   9月 11 00:30:10 localhost.localdomain systemd[1]: Stopping The nginx HTTP and reverse proxy server...
   9月 11 00:30:10 localhost.localdomain systemd[1]: Stopped The nginx HTTP and reverse proxy server.
   [root@localhost /]# systemctl restart nginx        重启nginx
   [root@localhost /]# systemctl reload nginx         重新加载nginx配置
   [root@localhost /]# systemctl enable nginx         添加nginx开机启动
   Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
   [root@localhost /]# systemctl disable nginx        关闭nginx开机启动
   Removed /etc/systemd/system/multi-user.target.wants/nginx.service.
   ~~~

3. 开放系统防火墙的80端口（Nginx默认已配置监听80端口）

   ```shell
   [root@localhost /]# firewall-cmd --query-port=80/tcp                   查询80端口是否对外开放
   no
   [root@localhost /]# firewall-cmd --add-port=80/tcp --permanent         永久对外开放80端口
   success
   [root@localhost /]# firewall-cmd --reload                              重启防火墙
   success
   ```

4. Nginx启动后，登录网页查看Nginx配置的默认页面

   ```http
   http://192.168.253.128/
   ```

   默认页面如图：

   ![](/hexbook/img/in-post/installation/1564646841313.jpg)

## Nginx 文件目录

使用 `rpm -ql nginx` 即可查询 Nginx 的各个文件目录。

- 安装位置：***/etc/nginx/***，各种配置文件，参数文件都在此目录下。

  ```shell
  [root@localhost nginx]# ls
  conf.d     fastcgi.conf          fastcgi_params          koi-utf  mime.types          nginx.conf          scgi_params          uwsgi_params          win-utf
  default.d  fastcgi.conf.default  fastcgi_params.default  koi-win  mime.types.default  nginx.conf.default  scgi_params.default  uwsgi_params.default
  ```

- web服务器默认目录：***/usr/share/nginx/***，此目录下有一个html目录用来存放网页文件，其中的 index.html 即为 Nginx 配置的默认页面。
- 日志存放路径：***/var/log/nginx/***
- 帮助文档存放路径：***/usr/share/doc/nginx/***