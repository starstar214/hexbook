zookeeper官网：https://zookeeper.apache.org/



**目录**

1. zookeeper 介绍
2. zookeeper 安装





---

#### 1.zookeeper介绍









---

#### 2.zookeeper安装

- 在 [官网](https://zookeeper.apache.org/) 下载 zookeeper 的压缩包 `apache-zookeeper-x.x.x-bin.tar.gz`。

- 将压缩包解压到指定目录：`/usr/local`

  ~~~shell
  [root@localhost local]# pwd
  /usr/local
  [root@localhost local]# tar -zxf apache-zookeeper-3.6.2-bin.tar.gz
  [root@localhost local]# mv apache-zookeeper-3.6.2 zookeeper         #重命名软件目录
  [root@localhost local]# rm -f apache-zookeeper-3.6.2-bin.tar.gz     #删除压缩包
  [root@localhost local]# ls
  zookeeper  bin  etc  include  lib  lib64  libexec  sbin  share  src
  ~~~

  zookeeper各目录：

  - bin 目录：zk 的可执行脚本目录，包括 zk 服务进程，zk 客户端等脚本。
  - conf 目录：配置文件目录，zoo_sample.cfg 为样例配置文件，需要修改为自己的名称，一般为zoo.cfg。log4j.properties 为日志配置文件。
  - lib 目录：zk 依赖的包。
  - docs 目录：存放 zk 相关文档。

- 重命名配置文件 `zoo_sample.cfg` 为 `zoo.cfg`：

  ~~~shell
  [root@localhost local]# cd zookeeper/conf/
  [root@localhost conf]# ls
  configuration.xsl  log4j.properties  zoo_sample.cfg
  [root@localhost conf]# cp zoo_sample.cfg zoo.cfg
  [root@localhost conf]# ls
  configuration.xsl  log4j.properties  zoo.cfg  zoo_sample.cfg
  ~~~

  修改配置文件的配置项： `dataDir=/var/local/zookeeper`。

- zookeeper 基本操作：

  ~~~shell
  [root@localhost bin]# ./zkServer.sh version      #查看 zookeeper 版本
  /usr/bin/java
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Apache ZooKeeper, version 3.6.2- 09/04/2020 12:44 GMT
  
  [root@localhost bin]# ./zkServer.sh start        #启动 zookeeper 
  /usr/bin/java
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Starting zookeeper ... STARTED
  [root@localhost bin]# ./zkServer.sh status       #查看 zookeeper 运行状态
  /usr/bin/java
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Client port found: 2181. Client address: localhost. Client SSL: false.
  Mode: standalone
  [root@localhost bin]# ./zkServer.sh stop         #停止 zookeeper 
  /usr/bin/java
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Stopping zookeeper ... STOPPED
  ~~~

- 使用 zookeeper 客户端连接服务：

  ~~~shell
  [root@localhost bin]# ./zkCli.sh 
  /usr/bin/java
  Connecting to localhost:2181
  
  ......
  
  WATCHER::
  
  WatchedEvent state:SyncConnected type:None path:null
  [zk: localhost:2181(CONNECTED) 0] ls /    #查看 zookeeper 文件系统
  [zookeeper]
  [zk: localhost:2181(CONNECTED) 1] quit    #退除客户端
  
  ......
  
  2020-10-20 23:42:51,491 [myid:] - ERROR [main:ServiceUtils@42] - Exiting JVM with code 1
  [root@localhost bin]# 
  ~~~

  

