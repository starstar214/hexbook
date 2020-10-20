Kafka 官网：http://kafka.apache.org/



**目录**

1. [初识 Kafka](#1初识kafka)
2. [Kafak 安装及使用](#2kafka安装及使用)



---

#### 1.初识Kafka









---

####  2.Kafka安装及使用

Kafka 安装：

1）安装 jdk 环境：

- 查看 jdk 安装包：

  ~~~shell
  [root@localhost redis]# dnf search java-1.8
  上次元数据过期检查：0:21:30 前，执行于 2020年10月18日 星期日 03时04分09秒。
  ====================================================== 名称 匹配：java-1.8 ====================================================
  java-1.8.0-openjdk.x86_64 : OpenJDK Runtime Environment 8
  java-1.8.0-openjdk-src.x86_64 : OpenJDK Source Bundle 8
  java-1.8.0-openjdk-demo.x86_64 : OpenJDK Demos 8
  java-1.8.0-openjdk-devel.x86_64 : OpenJDK Development Environment 8
  java-1.8.0-openjdk-javadoc.noarch : OpenJDK 8 API documentation
  java-1.8.0-openjdk-headless.x86_64 : OpenJDK Headless Runtime Environment 8
  java-1.8.0-openjdk-javadoc-zip.noarch : OpenJDK 8 API documentation compressed in single archive
  java-1.8.0-openjdk-accessibility.x86_64 : OpenJDK 8 accessibility connector
  ~~~

  在 Linux 中需要安装 `openjdk.x86_64`（运行时环境） 与 `openjdk-devel.x86_64`（开发工具包）。

- 安装 jdk：

  ~~~shell
  [root@localhost redis]# dnf install java-1.8.0-openjdk.x86_64
  
  ......
  
  完毕！
  [root@localhost redis]# dnf install java-1.8.0-openjdk-devel.x86_64
  
  ......
  
  完毕！
  [root@localhost redis]# java -version
  openjdk version "1.8.0_265"
  OpenJDK Runtime Environment (build 1.8.0_265-b01)
  OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode)
  ~~~



2）安装 ***ZooKeeper***：Zookeeper 是安装 Kafka 集群的必要组件，Kafka 通过 Zookeeper 来实施元数据信息的管理，包括集群、主题、分区等内容。Zookeeper 安装见 [分布式服务协调中间件-ZooKeeper](../分布式服务中间件/分布式服务协调中间件-ZooKeeper.md)

3）安装 ***Kafka***：在官网进行压缩包的下载，由于 Kafka 需要 Scala 环境，所以我们下载 `kafka_2.13-2.6.0.tgz` ，此包中包含 *Scala 2.13* 环境。

- 解压安装包：

  ~~~shell
  [root@localhost local]# tar -zxf kafka_2.13-2.6.0.tgz 
  [root@localhost local]# ls
  bin  etc  include  kafka_2.13-2.6.0  kafka_2.13-2.6.0.tgz  lib  lib64  libexec  sbin  share  src  zookeeper
  [root@localhost local]# rm kafka_2.13-2.6.0.tgz 
  rm：是否删除普通文件 'kafka_2.13-2.6.0.tgz'？y
  [root@localhost local]# mv kafka_2.13-2.6.0 kafka
  [root@localhost local]# ls
  bin  etc  include  kafka  lib  lib64  libexec  sbin  share  src  zookeeper
  [root@localhost local]# 
  ~~~

- kafka 解压后各目录：

  - `bin` 目录：kafka 的可执行脚本目录，包括 kafka 服务进程，kafka 客户端等脚本。
  - `conf` 目录：配置文件目录，server.properties 为服务配置文件。
  - `libs` 目录：kafka 依赖的包。
  - `site-docs` 目录：存放 kafka 相关文档。

- 修改 conf 目录下 server.properties 配置文件的日志路径： `log.dirs=/var/log/kafka`。

- 确认 *zookeeper* 启动后，启动 *Kafka*：

  ~~~shell
  [root@localhost kafka]# bin/kafka-server-start.sh config/server.properties
  
  ......
  
  [2020-10-21 00:06:08,586] INFO [KafkaServer id=0] started (kafka.server.KafkaServer)
  ~~~

  此方式为非后台运行，如果需要后台运行，则使用：`bin/kafka-server-start.sh -daemon config/server.properties`



Kafka 基本使用：

- 创建主题 topic：

  ~~~shell
  [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic news --partitions 2 --replication-factor 1
  ~~~

  - `--zookeeper localhost:2181`：指定 zookeeper 地址。
  - `--create --topic news`：创建名称为 news 的主题。
  - `--partitions 2`：指定主题的分区数。
  - `--replication-factor 1`：每个分区的副本个数。

- 查看所有主题：

  ~~~shell
  [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --list
  news
  ~~~

- 查看主题详情：

  ~~~shell
  [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic news
  Topic: news	PartitionCount: 2	ReplicationFactor: 1	Configs: 
  	Topic: news	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
  	Topic: news	Partition: 1	Leader: 0	Replicas: 0	Isr: 0
  ~~~

- 创建消费者监听主题：

  ~~~shell
  [root@localhost kafka]# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic news
  ~~~

  - `--bootstrap-server localhost:9092`：指定连接的 Kafka 集群地址。
  - `--topic news`：指定监听的主题。

  执行此命令后，shell 界面阻塞等待生产者发布消息。

- 生产消息：

  ~~~shell
  [root@localhost kafka]# bin/kafka-console-producer.sh --broker-list localhost:9092 --topic news
  >Hello Kafka    #输入发布的消息
  ~~~

  - `--broker-list localhost:9092`：指定连接的 Kafka 集群地址。
  - `--topic news`：指定发布的主题。

  发布消息后，监听此主题的消费者就会收到消息。



