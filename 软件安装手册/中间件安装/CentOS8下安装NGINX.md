#### DNF安装NGINX

1. 安装NGINX

   ```shell
   [root@localhost /]# dnf install nginx -y
   ```

   系统会自动解决相关依赖并安装NGINX。

2. NGINX基本命令

   ```shell
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
   ```

3.  开放系统防火墙的80端口（NGINX默认已配置监听80端口）

   ```shell
   [root@localhost /]# firewall-cmd --query-port=80/tcp                   查询80端口是否对外开放
   no
   [root@localhost /]# firewall-cmd --add-port=80/tcp --permanent         永久对外开放80端口
   success
   [root@localhost /]# firewall-cmd --reload                              重启防火墙
   success
   ```

4. NGINX启动后，登录网页查看NGINX配置的默认页面

   ```http
   http://192.168.253.128/
   ```

   默认页面如图：

   ![](../软件安装手册/Image/Snipaste_2020-09-11_00-45-37.png)

5. DNF安装NGINX后各个文件目录位置

   - 安装位置：***/etc/nginx/***，各种配置文件，参数文件都在此目录下。

     ```shell
     [root@localhost nginx]# ls
     conf.d     fastcgi.conf          fastcgi_params          koi-utf  mime.types          nginx.conf          scgi_params          uwsgi_params          win-utf
     default.d  fastcgi.conf.default  fastcgi_params.default  koi-win  mime.types.default  nginx.conf.default  scgi_params.default  uwsgi_params.default
     ```

   - web服务器默认目录：***/usr/share/nginx/***，此目录下有一个html目录用来存放网页文件，其中的 index.html 即为 NGINX 配置的默认页面。
   - 日志存放路径：***/var/log/nginx/***
   - 帮助文档存放路径：***/usr/share/doc/nginx/***