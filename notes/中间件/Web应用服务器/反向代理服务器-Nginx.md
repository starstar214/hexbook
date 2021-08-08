Nginx 官网：https://www.nginx.com/

Nginx 官方文档：http://nginx.org/en/docs/



**目录**

1. [Nginx 介绍及基本使用](#1nginx介绍及基本使用)

2. [Nginx 基本配置](#2nginx基本配置)

3. [Nginx 日志](#3nginx日志)

   

---

#### 1.Nginx 介绍及基本使用

Nginx：*Nginx* 是一个高性能的 *HTTP* 和反向代理 web 服务器，同时也提供了 IMAP/POP3/SMTP 邮件服务。相对于同类 web 服务器如 *Tomcat*，*Apache*，*Jetty*等，Nginx 的高并发处理能力强、擅长处理静态请求、反向代理和均衡负载，所以经常用来做静态内容服务和代理服务器。

*Nginx* 的特点：

- 跨平台：Nginx 可以在大多数 Unix like OS 编译运行，而且也有Windows的移植版本。
- 高并发处理能力强：通信机制采用 epoll 模型，非阻塞 IO，支持高并发连接，且在处理大并发的请求时内存消耗非常小。
- master/worker 结构：一个master进程，生成一个或多个worker进程
- 成本低廉：Nginx为开源软件，可以免费使用。
- 可以节省带宽：Nginx 支持 GZIP 压缩，可以添加浏览器本地缓存的 Header 头。
- 稳定性高：用于反向代理时，宕机的概率微乎其微。



正向代理和反向代理：

- 正向代理：正向代理类似一个跳板机，代理访问外部资源；客户端发出请求到代理服务器，由代理服务器向原始服务器发出请求接收到响应，然后再由代理服务器将响应返回给客户端；此时代理服务器代理客户端进行资源访问，服务端不知道实际发起请求的客户端。
- 反向代理：代理服务器来接受连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给请求连接的客户端；此时代理服务器代理服务端进行请求响应，客户端不知道实际提供服务的服务端。

<div align="center">
	<img src='Image/1350514-20190313105516378-237949533.png' style='max-width:600px'></img>
</div>


---

#### 2.Nginx 安装

1. 安装Nginx

   ```shell
   [root@localhost /]# dnf install nginx -y
   ```

   系统会自动解决相关依赖并安装Nginx。

2. Nginx基本命令

   使用 dnf 安装 nginx 后，系统会将其自动加入 systemctl 进行管理。

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

   <p align='center'> <img src='Image/Snipaste_2020-09-11_00-45-37.jpg' title='Nginx默认页面' style='max-width:600px'></img> </p>

5. DNF 安装 Nginx 后各个文件目录位置

   - 安装位置：/etc/nginx/，各种配置文件，参数文件都在此目录下。

     ```shell
     [root@localhost nginx]# ls
     conf.d     fastcgi.conf          fastcgi_params          koi-utf  mime.types          nginx.conf          scgi_params          uwsgi_params          win-utf
     default.d  fastcgi.conf.default  fastcgi_params.default  koi-win  mime.types.default  nginx.conf.default  scgi_params.default  uwsgi_params.default
     ```

   - web服务器默认目录：/usr/share/nginx/，此目录下有一个html目录用来存放网页文件，其中的 index.html 即为 Nginx 配置的默认页面。

   - 日志存放路径：/var/log/nginx/

   - 帮助文档存放路径：/usr/share/doc/nginx/



在使用 DNF 软件包管理器安装 Nginx 后，官方的二进制命令文件的位置在 /usr/sbin/nginx，我们可以通过命令行参数和控制信号运行脚本文件使 Nginx 作出不同的行为（也可以使用 systemctl 命令管理 Nginx 服务）。

*Nginx* 常用命令行参数：

- -?，-h：显示帮助。

- -c filename：启动时为 Nginx 指定一个配置文件来代替缺省的配置文件。

- -t：不运行 Nginx，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件。

- -v，-V：查看 Nginx 的版本（以及编译器版本和配置参数）。

- -s signal：向主进程发送信号，quit（正常停止），stop（强制停止），reload（重新加载），reopen（重新打开日志文件，日志切割时使用）。

  ~~~shell
  [root@localhost ~]# nginx -c /etc/nginx/nginx.conf    #启动 nginx 服务 
  [root@localhost ~]# nginx -s reload                   #重新加载 nginx 服务
  ~~~

*Nginx* 主要控制信号：

- *TERM*, *INT*：快速停止服务，不建议。
- *QUIT*：优雅地关闭服务。
- *HUP*：配置重载，使用新配置启动新 worker 进程，正常关闭旧的 worker 进程。
- *USR1*：重新打开日志文件（日志切割时使用）。
- *USR2*：平滑的升级二进制脚本文件。
- *WINCH*：优雅地关闭 worker 进程。

*Nginx* 控制信号使用方法：使用 kill 命令向 Nginx 主进程发送控制信号。

1. 获取 Nginx 的主进程 ID：

   ~~~shell
   [root@localhost nginx]# ps -ef|grep nginx
   root       2257      1  0 01:52 ?        00:00:00 nginx: master process /usr/sbin/nginx
   nginx      2265   2257  0 01:53 ?        00:00:00 nginx: worker process
   nginx      2266   2257  0 01:53 ?        00:00:00 nginx: worker process
   nginx      2267   2257  0 01:53 ?        00:00:00 nginx: worker process
   nginx      2268   2257  0 01:53 ?        00:00:00 nginx: worker process
   root       2348   2181  0 02:05 pts/0    00:00:00 grep --color=auto nginx
   [root@localhost nginx]# cat /run/nginx.pid 
   2257
   ~~~

- 使用 kill 命令发送控制信号：

  ~~~shell
  [root@localhost nginx]# kill -HUP 2257
  [root@localhost nginx]# kill -QUIT $(cat /run/nginx.pid)
  [root@localhost nginx]# ps -ef|grep nginx
  root       2373   2181  0 02:08 pts/0    00:00:00 grep --color=auto nginx
  ~~~



---

#### 3.Nginx 主配置文件

Nginx 主配置文件位于 /etc/nginx/nginx.conf，可以被分为 3 部分：

1. 全局块：从配置文件开始到 events 块之间的内容，用来设置一些会影响 Nginx 服务器整体运行的配置指令，主要包括运行 Nginx 的用户（组），允许生成的 worker process 数，进程 PID 的存放路径、日志存放路径和类型、配置文件引入等。
2. events 块：主要配置 Nginx 服务器与用户的网络连接，常见的如：是否允许同时接受多个网络连接、选用哪种事件驱动模型来处理连接请求、每个 work process 可以同时支持的最大连接数等。
3. http 块：http 块中又包含了 2 个部分，http 全局块和 server 部分
   1. http 全局块：包括了文件引入、MIME-TYPE 定义、日志定义、连接超时时间等。
   2. server 块：配置一个虚拟主机（应用服务），每个 http 块可以包含多个 server 块，每一个 server 块都是一个独立的应用服务。



:first_quarter_moon: 全局块配置：

~~~nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

~~~

- user：后面可以跟用户（及用户组），定义 Nginx 运行的用户和用户组，当 Nginx 主线程启动后会使用此处配置的用户启动 worker 进程。

  ~~~shell
  user nginx xxx;    # 以 xxx 用户组，nginx 用户的身份启动 work 线程
  ~~~

- worker_processes：工作进程的数量，一般设置为机器的核心数量（CPU 数 * 每个 CPU 的核心数），当设置为 auto 时，nginx 会根据核心数生成对应数量的 worker 进程。

- error_log：错误日志的存放路径，可以同时定义日志级别（debug<info<notice<warn<error<crit<alert<emerg），默认为 crit。

  ~~~shell
  error_log /var/log/nginx/error.log error;   #指定日志及日志级别
  ~~~

- pid：nginx 启动后进程 pid 文件的存放位置。

- include：引入的配置文件路径位置。



:last_quarter_moon: events 块配置：

~~~nginx
events {
    worker_connections 1024;
}
~~~

- worker_connections：一个 worker 进程同一时间允许的最大连接数。



:derelict_house: http 全局块配置：

~~~nginx
http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    include /etc/nginx/conf.d/*.conf;
        
    server {
        ......
    }
}
~~~

- log_format：定义日志格式，并标记名称（main），后续在其他日志配置项中可以使用。
- access_log：指定日志文件的位置及格式（*main*，未指定时默认为 *combined*），也可以同时指定一些相关参数如：日志缓存区大小，刷新时间等。
- sendfile：是否使用 *sendfile* 系统来传输文件（on/off），*sendfile* 可实现零拷贝文件传输。
- tcp_nopush：在使用 sendfile 的时候开启才有效，可以提高网络传输 bits 时的效率。
- tcp_nodelay：在长连接中需要开启此选项，即使是很小的数据包也不会做延迟发送。
- keepalive_timeout ：一个请求完成之后保持连接的时间（防止过度频繁的创建连接）。
- types_hash_max_size：Nginx 使用散列表来存储 *MIME type* 与文件扩展名，此值设置了每个散列桶占用的内存大小，值越大，占用内存越大，匹配效率越高，使用默认值即可。
- include：nginx 支持将其他位置的配置文件引入到主配置文件中，这样即使配置复杂主配置文件也不会显得十分臃肿。

除上诉配置外，http 配置段还可以配置负载均衡，gzip，编码等。



> :biking_woman: <u>在 server 块中我们配置具体的虚拟主机，也是在开发中需要我们配置的主要部分</u>。



---

#### 4.Nginx 反向代理配置

<u>一般来说，每部署一个服务，都在 /etc/nginx/conf.d 目录下新增一个 xxxx.conf 配置 server 信息，每个服务的文件互不干扰</u>。

在 /etc/nginx/conf.d 目录下新建 demo.conf 文件，文件内容如下：

~~~nginx
server {
        listen       80 default_server;
        listen       [::]:80 default_server;
    	server_name  _;
        root         /usr/share/nginx/html;
        include /etc/nginx/default.d/*.conf;
        location / {
        	proxy_pass http://127.0.0.1:8080;
        	index index.html;
        }
        error_page 404 /404.html;
            location = /40x.html {
        }
        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
~~~

- listen：定义要监听的端口
  
  - `listen 80;`：监听所有的 ipv4 地址的 80 端口。
  - `listen [::]:80;`：监听所有的 ipv6 地址的 80 端口。
  - `listen 192.168.1.6:80;`：只监听 192.168.1.6 的 ipv4 地址下的 80 端口。
  - `listen [fe80::919c:9a57:127f:5a8a]:80;`：只监听 *fe80::919c:9a57:127f:5a8a* 的 ipv6 地址下的 80 端口。
  - *default_server*：将此 server 定义为默认的 server（一个 http 块中可以配置多个 server 模块），当请求的域名未匹配到任何 server_name 时，nginx 将会使用 default_server 来处理请求，如果均未配置 default_server，使用第一个 server 进行请求处理。
  
- server_name：定义域名，可以定义多个，使用空格隔开，也可以使用正则表达式。配置 server_name 后，相当于本机的 hosts 文件（ _ 为官方随意指定的一个无效域名，无任何意义）。

- root：定义根目录，nginx 会根据该目录进行文件映射，例如：nginx 配置 `root /usr/share/nginx/html;`，用户访问 /project/xxx.html 时，nginx 则会返回 /usr/share/nginx/html/project/xxx.html 文件。

- include：将其他配置文件包含进来。

- location：指定路径匹配规则，/ 为匹配任何路径。

- error_page：定义发生错误的时候需要显示一个的定义的 uri。

  ~~~nginx
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
  }
  ~~~

  当发生 500，502，503，504 错误时转到 /50x.html，使用 `location = /50x.html` 匹配该路径然后再 location 块中作具体配置。

> server 中还可以配置 index（缺省为 nginx 根目录下的 index.html），代理服务响应时间，缓存等多种参数。



在 location 区域中，配置了用于反向代理的路径跳转：

~~~nginx
location / {
    proxy_pass http://127.0.0.1:8080;
    index index.html;
}
~~~

当用户访问 http://192.168.253.133:80 时（Nginx 服务器 IP），将被代理到服务器上的 8080 端口下进行访问。

> 如果对不同的路径有多种代理方式，可以配置多个 location 进行代理。



location 匹配规则： `location [=|~|~*|^~] /uri/ { … }`

1. 什么都不带时，表示以 xxx 开头的 uri，如：`location /demo {...}`
2. `=`：开头表示精确匹配（会忽略 get 请求的参数），例： `location = /demo {...}`
3. `~`：开启 uri 包含的正则匹配（区分大小写），例：`location ~ /list/[0-9] {...}`
4. `^~`：用于不包含正则表达式的 uri 前，相当于以 xxx 开头，例：`location ^~ /xxx {...}`
5. `~` 开头表示区分大小写的正则匹配           以xx结尾
6. `~*`：开启 uri 包含的正则匹配（不区分大小写）。
7. `!~` 和 `!~*`：分别表示区分大小写的不匹配和不区分大小写的不匹配的正则。
8. `/`：通用匹配，任何请求都会匹配到。



---

#### 5.Nginx 负载均衡配置

Nginx 支持对多态服务器进行负载均衡，还自带了多种负载均衡策略。



负载均衡的配置方法：

1. 配置 upstream（配置位置为 http 配置段内）：

   ~~~nginx
   upstream myserver {
       server 192.168.253.132:8080;
       server 192.168.253.132:8081;
   }
   ~~~

2. 将 server 段的 server_name 配置为本机 IP。

3. 配置反向代理的代理内容：

   ~~~nginx
   proxy_pass http://myserver;
   ~~~

   

Nginx 负载均衡策略：

1. 轮询：默认的负载均衡策略，每个请求按时间的先后顺序分配到不同的后端服务器上。

   配置方法就是上例中的配置。

2. 权重：指定轮询几率的负载均衡方式，默认情况下的权重是 1，权重越高，访问到的几率越大。

   ~~~nginx
   upstream myserver {
       server 192.168.253.132:8080 weight=5;
       server 192.168.253.132:8081 weight=10;
   }
   ~~~

3. 根据客户端 IP 进行 Hash 然后分配，每一个客户端只能访问到其中某一台服务器上，可以解决 session 存储的问题。

   ~~~nginx
   upstream myserver {
       ip_hash;
       server 192.168.253.132:8080;
       server 192.168.253.132:8081;
   }
   ~~~

4. fair：按照后端服务器的响应时间来分配权重，响应时间短的进行优先分配

   ~~~nginx
   upstream myserver {
       server 192.168.253.132:8080;
       server 192.168.253.132:8081;
       fair;
   }
   ~~~

5. 最少连接策略：把请求转发给连接数较少的后端服务器。

   ~~~nginx
   upstream myserver {
       least_conn;
       server 192.168.253.132:8080;
       server 192.168.253.132:8081;
   }
   ~~~

6. 根据 url 的 Hash 值来进行分配，同一个 url 一般定向到同一个后端服务器，一般配合本地缓存进行使用。

   ~~~nginx
   upstream myserver {
       hash $request_uri;
       server 192.168.253.132:8080;
       server 192.168.253.132:8081;
   }
   ~~~

   

---

#### 6.Nginx 动静分离

动静分离就是指将动态请求和静态请求分离开来，使用 Nginx 来处理静态页面，而数据内容（动态请求）代理到后端服务器进行完成。

Nginx 通过不同的 location 映射来进行动静分离功能的实现。



配置文件内容：

~~~nginx
location /data/ {
    proxy_pass http://127.0.0.1:8080;
}

location / {
    root /usr/share/nginx/html;
    index index.html;
}
~~~

Nginx 从上到下进行匹配，如果 url 已 data 开头，则进入后端服务器进行处理，否则继续向下匹配代理到本机的静态资源。



---

#### 7.Nginx 高可用

在实际的生产环境中，如果使用一个 Nginx 来代理所有的访问请求，一旦 Nginx 出现故障，那么整个应用将处于不可访问的状态。

一般情况下，我们搭建一个 Nginx 集群并结合 Keepalived 实现 Nginx 的高可用。



Keepalived：它是 Linux 下的一个轻量级的高可用解决方案，用来监控集群系统中各个服务节点的状态。如果某个服务节点出现异常，将被 Keepalived 检测到，并将出现故障的服务节点从集群系统中剔除，而在故障节点恢复正常后，Keepalived 又可以自动将此服务节点重新加入服务器集群中。

安装 Keepalived：

~~~shell
[root@localhost nginx]# dnf install Keepalived
~~~

安装后的配置文件位置：/etc/keepalived



修改 Keepalived 的配置文件：

1. Nginx 服务器 Keepalived 配置：

   ~~~nginx
   ! Configuration File for keepalived
     
   global_defs {
      notification_email {
        acassen@firewall.loc
        failover@firewall.loc
        sysadmin@firewall.loc
      }
      notification_email_from Alexandre.Cassen@firewall.loc
      smtp_connect_timeout 30
      router_id LVS_DEVEL  # 路由 ID，需要在 hosts 文件中配置 127.0.0.1 LVS_DEVEL
      vrrp_skip_check_adv_addr
      vrrp_strict
      vrrp_garp_interval 0
      vrrp_gna_interval 0
   }
   
   vrrp_instance VI_1 {
       state MASTER   # 备机配置为 BACKUP
       interface ens32
       virtual_router_id 51 # 路由 ID，主备机的值应该相等
       priority 100  # 权重，主机应大于备机
       advert_int 1  # 检查的时间间隔，默认为 1 秒
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       virtual_ipaddress {
           192.168.253.88  # 虚拟 IP 地址
       }
   }
   ~~~
   
   修改 hosts 文件添加：`127.0.0.1 LVS_DEVEL`。
   
   备 Nginx 服务器 Keepalived 配置与主机基本保持一致。
   
启动 keepalived：`systemctl start keepalived.service`
   
2. 配置 Nginx 配置文件 demo.conf:

   ~~~nginx
   server {
       listen 7000;
       root /usr/share/nginx/html;
       location / {
           proxy_pass http://192.168.253.128:8080;
       }
   }
   ~~~

   重新加载 Nginx 配置文件。

3. 需要关闭 SELinux，否则可能会对 Keepalived 有影响。

确定防火墙开启了对应端口后，即可进行测试。



---

#### 8.Nginx 原理

Nginx 默认采用多进程工作方式，Nginx 启动后，会运行一个 master 进程和多个 worker 进程。

master 充当整个进程组与用户的交互接口，同时对进程进行监护，管理 worker 进程来实现重启服务、平滑升级、更换日志文件、配置文件实时生效等功能。worker 用来处理基本的网络事件，worker 之间是平等的，他们共同竞争来处理来自客户端的请求。

![](Image/1183448-20180210145226654-1347579045.png)

使用 master-worker 机制的好处：

1. 可以使用 nginx –s reload 进行热部署（不会一次性地停掉所有 worker）。
2. 每个 woker 都是独立的进程，不需要加锁，节省了很多开销，如果有其中的一个 woker 出现问题也不会影响到其他 worker，不会造成服务中断。



Nginx 多进程事件模型：异步非阻塞

虽然 Nginx 采用多 worker 的方式来处理请求，每个 worker 里面只有一个主线程，但是 Nginx 采用了异步非阻塞（EPOLL）的方式来处理请求，也就是说，Nginx 是可以同时处理成千上万个请求的。一个 worker 进程可以同时处理的请求数只受限于内存大小，而且在架构设计上，不同的 worker 进程之间处理并发请求时几乎没有同步锁的限制，worker 进程通常不会进入睡眠状态，因此，<u>当 Nginx 上的进程数与 CPU 核心数相等时，进程间切换的代价是最小的</u>。