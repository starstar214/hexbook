安装 Nginx：[CentOS 8 下安装 Nginx](../../软件安装手册/中间件安装/CentOS8下安装Nginx.md)

Nginx 官网：https://www.nginx.com/

Nginx 官方文档：http://nginx.org/en/docs/



**目录**

1. [Nginx 介绍及基本使用](#1nginx介绍及基本使用)

2. [Nginx 基本配置](#2nginx基本配置)

3. [Nginx 日志](#3nginx日志)

   

---

#### 1.Nginx介绍及基本使用

***Nginx***：*Nginx* 是一个高性能的 *HTTP* 和反向代理 web 服务器，同时也提供了 ***IMAP***/***POP3***/***SMTP*** 邮件服务。相对于同类 web 服务器如 *Tomcat*，*Apache*，*Jetty*等，Nginx 的高并发处理能力强、擅长处理静态请求、反向代理和均衡负载，所以经常用来做静态内容服务和代理服务器。

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


在使用 DNF 软件包管理器安装 Nginx 后，官方的二进制命令文件的位置在 */usr/sbin/nginx*，我们可以通过命令行参数和控制信号运行脚本文件使 Nginx 作出不同的行为（也可以使用 systemctl 命令管理 Nginx 服务）。

*Nginx* 常用命令行参数：

- -?，-h：显示帮助。

- -c filename：为 Nginx 指定一个配置文件来代替缺省的配置文件。

- -t：不运行 Nginx，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件。

- -v，-V：查看 Nginx 的版本（以及编译器版本和配置参数）。

- -s signal：向主进程发送信号，quit（正常停止），stop（强制停止），reload（重新加载），reopen（重新打开日志文件，日志切割时使用）。

  ~~~shell
  [root@localhost ~]# nginx -s reload
  ~~~

*Nginx* 主要控制信号：

- *TERM*, *INT*：快速停止服务，不建议。
- *QUIT*：优雅地关闭服务。
- *HUP*：配置重载，使用新配置启动新 worker 进程，正常关闭旧的 worker 进程。
- *USR1*：重新打开日志文件（日志切割时使用）。
- *USR2*：平滑的升级二进制脚本文件。
- *WINCH*：优雅地关闭 worker 进程。

*Nginx* 控制信号使用方法：使用 ***kill*** 命令向 Nginx 主进程发送控制信号。

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

#### 2.Nginx基本配置

*Nginx* 主配置文件：*/etc/nginx/nginx.conf*

全局段配置：配置一些全局参数。

~~~nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;
events {
    worker_connections 1024;
}
~~~

- ***user***：后面可以跟用户（及用户组），定义 Nginx 运行的用户和用户组，当 Nginx 主线程启动后会使用此处配置的用户启动 worker 进程。

  ~~~shell
  user nginx xxx;    # 以 xxx 用户组，nginx 用户的身份启动 work 线程
  ~~~

- ***worker_processes***：工作进程的数量，一般设置为机器的核心数量（CPU数*每个CPU的核心数），当设置为 *auto* 时，nginx 会根据核心数生成对应数量的 worker 进程。

- ***error_log***：错误日志的存放路径，可以同时定义日志级别（debug<info<notice<warn<error<crit<alert<emerg），默认为 ***crit***。

  ~~~shell
  error_log /var/log/nginx/error.log error;   #指定日志及日志级别
  ~~~

- ***pid***：nginx 启动后进程 pid 文件的存放位置。

- ***events***：配置 nginx 工作进程的连接属性

  - *worker_connections*：一个 worker 进程同一时间允许的最大连接数。



http 服务段配置：配置 http 协议的相关参数。

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

- ***log_format***：定义日志格式，并标记名称（***main***），后续在其他日志配置项中可以使用。
- ***access_log***：指定日志文件的位置及格式（*main*，未指定时默认为 *combined*），也可以同时指定一些相关参数如：日志缓存区大小，刷新时间等。

- ***sendfile***：是否使用 *sendfile* 系统来传输文件（on/off），*sendfile* 可实现零拷贝文件传输。
- ***tcp_nopush***：在使用 sendfile 的时候开启才有效，可以提高网络传输 bits 时的效率。
- ***tcp_nodelay***：在长连接中需要开启此选项，即使是很小的数据包也不会做延迟发送。
- ***keepalive_timeout*** ：一个请求完成之后保持连接的时间（防止过度频繁的创建连接）。
- ***types_hash_max_size***：Nginx 使用散列表来存储 *MIME type* 与文件扩展名，此值设置了每个散列桶占用的内存大小，值越大，占用内存越大，匹配效率越高，使用默认值即可。
- ***include***：nginx 支持将其他位置的配置文件引入到主配置文件中，这样即使配置复杂主配置文件也不会显得十分臃肿。
- ***server***：配置具体的虚拟主机，一个 http 中可以配置多个虚拟主机。

> 除上诉配置外，http 配置段还可以配置负载均衡，gzip，编码等。



虚拟主机配置段（包含在 http 之内）：配置代理服务的虚拟主机的各项参数。

~~~nginx
server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;
        include /etc/nginx/default.d/*.conf;
        location / {
        }
        error_page 404 /404.html;
            location = /40x.html {
        }
        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
~~~

- ***listen***：定义要监听的端口。
  
  - `listen 80;`：监听所有的 ipv4 地址的 80 端口。
  - `listen [::]:80;`：监听所有的 ipv6 地址的 80 端口。
  - `listen 192.168.1.6:80;`：只监听 192.168.1.6 的 ipv4 地址下的 80 端口。
  - `listen [fe80::919c:9a57:127f:5a8a]:80;`：只监听 *fe80::919c:9a57:127f:5a8a* 的 ipv6 地址下的 80 端口。
  - *default_server*：将此 server 定义为默认的 server（一个 http 块中可以配置多个 server 模块），当请求的域名未匹配到任何 server_name 时，nginx 将会使用 default_server 来处理请求，如果均未配置 default_server，使用第一个 server 进行请求处理。
  
- ***server_name***：定义域名，可以定义多个，使用空格隔开，也可以使用正则表达式。配置 server_name 后，就可以在浏览器中直接输入域名进行访问而不需要输入 ip 地址（ _ 为官方随意指定的一个无效域名，无任何意义）。

- ***root***：定义根目录，nginx 会根据该目录进行文件映射，例如：nginx 配置 `root /usr/share/nginx/html;`，用户访问 /project/xxx.html 时，nginx 则会返回 /usr/share/nginx/html/project/xxx.html 文件。

- ***include***：将其他配置文件包含进来。

- ***location***：指定路径匹配规则，/ 为匹配任何路径。

- ***error_page***：定义发生错误的时候需要显示一个的定义的 uri。

  ~~~nginx
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
  }
  ~~~

  当发生 500，502，503，504 错误时转到 /50x.html，使用 `location = /50x.html` 匹配该路径然后再 location 块中作具体配置。

> server 中还可以配置 index（缺省为 nginx 根目录下的 index.html），代理服务响应时间，缓存等多种参数。



---

#### 3.Nginx日志

*Nginx* 允许针对不同的 server 配置不同的 Log，在 server 段中的日志配置会覆盖 http 段的日志配置。

- 配置日志格式：

  ~~~nginx
  log_format  mylog  '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';
  ~~~

  Nginx 日志的部分格式配置项：

  <table><tbody><tr><td width="234">参数</td><td width="434">说明</td><td width="506">示例</td></tr><tr><td width="234" >$remote_addr</td><td width="434" >客户端地址</td><td width="507" >211.28.65.253</td></tr><tr style="height:15.25pf"><td width="234">$remote_user</td><td width="434">客户端用户名称</td><td width="508">–</td></tr><tr style="height:15.25pf"><td width="234" >$time_local</td><td width="434" >访问时间和时区</td><td width="509" >18/Jul/2012:17:00:01&nbsp;+0800</td></tr><tr style="height:15.25pf"><td width="234">$request</td><td width="434">请求的URI和HTTP协议</td><td width="510">“GET&nbsp;/article-10000.html&nbsp;HTTP/1.1”</td></tr><tr style="height:15.25pf"><td width="234" >$http_host</td><td width="434" >请求地址，即浏览器中你输入的地址（IP或域名）</td><td width="511" >www.it300.com/192.168.100.100</td></tr><tr style="height:15.25pf"><td width="234">$status</td><td width="434">HTTP请求状态</td><td width="512">200</td></tr><tr style="height:15.25pf"><td width="234" >$upstream_status</td><td width="434" >upstream状态</td><td width="513" >200</td></tr><tr style="height:15.25pf"><td width="234" >$body_bytes_sent</td><td width="434">发送给客户端文件内容大小</td><td width="514">1547</td></tr><tr style="height:15.25pf"><td width="234" >$http_referer</td><td width="434" >url跳转来源</td><td width="515"><a href="https://www.baidu.com/" title="" style="color: rgb(66, 133, 244);">https://www.baidu.com/</a></td></tr><tr style="height:15.25pf"><td width="234">$http_user_agent</td><td width="434">用户终端浏览器等信息</td><td width="516">"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36"</td></tr><tr><td width="234" >$ssl_protocol</td><td width="434" >SSL协议版本</td><td width="517" >TLSv1</td></tr><tr><td>$ssl_cipher</td><td width="434">交换数据中的算法</td><td width="518">RC4-SHA</td></tr><tr style="height:15.25pf"><td width="234" >$upstream_addr</td><td width="434" >后台upstream的地址，即真正提供服务的主机地址</td><td width="519" >10.10.10.100:80</td></tr><tr><td width="234" >$request_time</td><td width="434">整个请求的总时间</td><td width="520">0.205</td></tr><tr style="height:15.25pf"><td width="234">$upstream_response_time</td><td width="434">请求过程中，upstream响应时间</td><td width="521">0.002</td></tr><tr style="height:15.25pf"><td width="234">$http_x_forwarded_for</td><td width="434">当客户使用代理服务器时的真正IP地址</td><td width="520" >211.28.65.253</td></tr></tbody></table>



