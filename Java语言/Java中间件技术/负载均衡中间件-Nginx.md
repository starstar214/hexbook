安装 Nginx：[CentOS 8 下安装 Nginx](../../软件安装手册/中间件安装/CentOS8下安装Nginx.md)

Nginx 官网：https://www.nginx.com/

Nginx 官方文档：https://www.nginx.cn/doc/



**目录**

1. [Nginx 介绍及基本使用](#1Nginx介绍及基本使用)

2. [Nginx 配置](#2Nginx配置)

3. [Nginx 日志](#3Nginx日志)

   

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

#### 2.Nginx配置

















---

#### 3.Nginx日志