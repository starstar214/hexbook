zookeeper官网：https://zookeeper.apache.org/



---

#### 1.zookeeper 介绍及安装





zookeeper 安装：

1. 在官网找到下载链接。

2. 将压缩包下载到指定目录：`/usr/local`。

   ~~~shell
   [root@localhost local]# wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0-bin.tar.gz
   --2021-08-25 21:59:22--  https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0-bin.tar.gz
   正在解析主机 mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)... 101.6.15.130, 2402:f000:1:400::2
   正在连接 mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)|101.6.15.130|:443... 已连接。
   已发出 HTTP 请求，正在等待回应... 200 OK
   长度：12387614 (12M) [application/octet-stream]
   正在保存至: “apache-zookeeper-3.7.0-bin.tar.gz”
   
   apache-zookeeper-3.7.0-bin.tar.gz                            100%[===========================================================================================================================================>]  11.81M  20.2MB/s  用时 0.6s    
   
   2021-08-25 21:59:23 (20.2 MB/s) - 已保存 “apache-zookeeper-3.7.0-bin.tar.gz” [12387614/12387614])
   
   [root@localhost local]# ls
   apache-zookeeper-3.7.0-bin.tar.gz  bin  etc  games  include  lib  lib64  libexec  sbin  share  src
   ~~~

3. 解压下载的压缩包即可：

   ~~~shell
   [root@localhost local]# tar -zxf apache-zookeeper-3.7.0-bin.tar.gz 
   [root@localhost local]# ls
   apache-zookeeper-3.7.0-bin  apache-zookeeper-3.7.0-bin.tar.gz  bin  etc  games  include  lib  lib64  libexec  sbin  share  src
   [root@localhost local]# mv apache-zookeeper-3.7.0-bin zookeeper # 重命名软件目录      
   [root@localhost local]# rm apache-zookeeper-3.7.0-bin.tar.gz    # 删除安装包
   rm：是否删除普通文件 'apache-zookeeper-3.7.0-bin.tar.gz'？y
   [root@localhost local]# ls
   bin  etc  games  include  lib  lib64  libexec  sbin  share  src  zookeeper
   ~~~

解压后的文件夹即为 zookeeper 整个安装目录。



Zookeeper 各目录说明：

- bin 目录：zk 的可执行脚本目录，包括 zk 服务进程，zk 客户端等脚本。
- conf 目录：配置文件目录，zoo_sample.cfg 为样例配置文件，需要修改为自己的名称，一般为zoo.cfg。log4j.properties 为日志配置文件。
- lib 目录：zk 依赖的包。
- docs 目录：存放 zk 相关文档。
- logs 目录：存放 zk 运行的日志信息。

- zoo_sample.cfg 配置文件：官方给出的配置文件样例，如果需要其生效需要将名字改为 zoo.cfg。

  ~~~shell
  [root@localhost conf]# pwd
  /usr/local/zookeeper/conf
  [root@localhost conf]# cp zoo_sample.cfg zoo.cfg 
  [root@localhost conf]# ls
  configuration.xsl  log4j.properties  zoo.cfg  zoo_sample.cfg
  ~~~
  
修改配置文件的配置项： `dataDir=/var/lib/zookeeper`。



Zookeeper 基本操作：

1. 查看 Zookeeper 版本：

   ~~~shell
   [root@localhost bin]# ./zkServer.sh version
   /usr/bin/java
   ZooKeeper JMX enabled by default
   Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
   Apache ZooKeeper, version 3.7.0 2021-03-17 09:46 UTC
   ~~~

2. 启动 Zookeeper 服务：

   ~~~shell
   [root@localhost bin]# ./zkServer.sh start
   /usr/bin/java
   ZooKeeper JMX enabled by default
   Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
   Starting zookeeper ... STARTED
   ~~~

3. 查看 Zookeeper 运行状态：

   ~~~shell
   [root@localhost bin]# ./zkServer.sh status
   /usr/bin/java
   ZooKeeper JMX enabled by default
   Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
   Client port found: 2181. Client address: localhost. Client SSL: false.
   Mode: standalone
   ~~~

4. 使用 Zookeeper 客户端连接服务：

   ~~~shell
   [root@localhost bin]# ./zkCli.sh 
   /usr/bin/java
   Connecting to localhost:2181
   
   ......
   
   WATCHER::
   
   WatchedEvent state:SyncConnected type:None path:null
   [zk: localhost:2181(CONNECTED) 0] ls /    #查看 zookeeper 文件系统
   [zookeeper]
   [zk: localhost:2181(CONNECTED) 1] quit    #退出客户端
   
   ......
   
   WatchedEvent state:Closed type:None path:null
   2021-08-25 23:11:41,841 [myid:] - INFO  [main:ZooKeeper@1232] - Session: 0x100005947080000 closed
   2021-08-25 23:11:41,841 [myid:] - INFO  [main-EventThread:ClientCnxn$EventThread@570] - EventThread shut down for session: 0x100005947080000
   2021-08-25 23:11:41,843 [myid:] - ERROR [main:ServiceUtils@42] - Exiting JVM with code 1
   [root@localhost bin]# 
   ~~~

5. 停止 Zookeeper 服务：

   ~~~shell
   [root@localhost bin]# ./zkServer.sh stop
   /usr/bin/java
   ZooKeeper JMX enabled by default
   Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
   Stopping zookeeper ... STOPPED
   ~~~

   



