Kafka 官网：http://kafka.apache.org/

Kafka 中文文档：https://kafka.apachecn.org/



---

#### 1.Kafka 介绍及安装

> :alembic: Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.
>
> Apache Kafka 是一个开源的<u>分布式流处理平台</u>，被数千家公司用于高性能数据管道、流分析、数据集成和关键任务应用程序。

Kafka 所具有的主要功能：

1. 发布&订阅：类似于一个消息系统，读写流式的数据。

   Kafka 很好地替代了传统的 message broker（消息代理）。

   与大多数消息系统相比，Kafka 拥有更好的吞吐量、内置分区、具有复制和容错的功能，这使它成为一个非常理想的大型消息处理应用。

2. 流处理：编写可扩展的流处理应用程序，用于实时事件响应的场景。

3. 存储：安全的将流式的数据存储在一个分布式，有副本备份，容错的集群。

 

> :o: 由于 Kafka 是基于 Scala 和 Java 开发，运行时需依赖 JDK 环境，除此之外，还要结合 Zookeeper 进行使用。

1. 安装 Zookeeper：见[分布式服务协调中间件-ZooKeeper](../分布式服务中间件/分布式服务协调中间件-ZooKeeper.md)

2. 在官网找到下载地址将压缩包下载到压缩包`/usr/local`目录下，由于 Kafka 运行需要 Scala 环境，所以我们要下载带 Scala 的压缩包`kafka_xxx-xxx.tgz`（第一个 xxx 代表 Scala 的版本）。

   ~~~shell
   [root@localhost local]# wget https://dlcdn.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz
   --2021-08-25 23:21:12--  https://dlcdn.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz
   正在解析主机 dlcdn.apache.org (dlcdn.apache.org)... 151.101.2.132, 2a04:4e42::644
   正在连接 dlcdn.apache.org (dlcdn.apache.org)|151.101.2.132|:443... 已连接。
   已发出 HTTP 请求，正在等待回应... 200 OK
   长度：71403603 (68M) [application/x-gzip]
   正在保存至: “kafka_2.13-2.8.0.tgz.1”
   
   kafka_2.13-2.8.0.tgz.1                                       100%[===========================================================================================================================================>]  68.10M  3.35MB/s  用时 63s     
   
   2021-08-25 23:22:17 (1.09 MB/s) - 已保存 “kafka_2.13-2.8.0.tgz.1” [71403603/71403603])
   
   [root@localhost local]# ls
   bin  etc  games  include  kafka_2.13-2.8.0.tgz  lib  lib64  libexec  sbin  share  src  zookeeper
   ~~~

3. 解压安装包：

   ~~~shell
   [root@localhost local]# tar -zxf kafka_2.13-2.8.0.tgz 
   [root@localhost local]# ls
   bin  etc  games  include  kafka_2.13-2.8.0  kafka_2.13-2.8.0.tgz  lib  lib64  libexec  sbin  share  src  zookeeper
   [root@localhost local]# rm kafka_2.13-2.8.0.tgz 
   rm：是否删除普通文件 'kafka_2.13-2.8.0.tgz'？y
   [root@localhost local]# mv kafka_2.13-2.8.0 kafka
   [root@localhost local]# ls
   bin  etc  games  include  kafka  lib  lib64  libexec  sbin  share  src  zookeeper
   ~~~



Kafka 各目录说明：

1. `bin` 目录：kafka 的可执行脚本目录，包括 kafka 服务进程，kafka 客户端等脚本。
2. `config` 目录：配置文件目录，server.properties 为服务配置文件。
3. `libs` 目录：kafka 依赖的包。
4. `site-docs` 目录：存放 kafka 相关文档。

Kafka 配置文件：配置文件是位于 config 目录下 server.properties 文件，需要修改几项配置

1. 配置 listeners 监听： 

   ~~~properties
   listeners=PLAINTEXT://localhost:9092
   advertised.listeners=PLAINTEXT://localhost:9092
   ~~~

   如果这里配置的 localhost 后续命令中则使用 localhost，如果这里配置具体 IP，后面命令则使用具体的 IP 地址。

2. 配置日志路径： `log.dirs=/var/log/kafka`。

Kafka 基本操作：

1. 启动 Kafka（启动前需要确认 Zookeeper 先启动）：

   ~~~shell
   [root@localhost bin]# pwd
   /usr/local/kafka/bin
   [root@localhost bin]# ./kafka-server-start.sh ../config/server.properties &
   
   ......
   
   [2021-08-25 23:40:07,010] INFO [KafkaServer id=0] started (kafka.server.KafkaServer)
   [2021-08-25 23:40:07,071] INFO [broker-0-to-controller-send-thread]: Recorded new controller, from now on will use broker 192.168.253.136:9092 (id: 0 rack: null) (kafka.server.BrokerToControllerRequestThread)
   ~~~

   此方式为非后台运行，如果需要后台运行，则使用：`bin/kafka-server-start.sh -daemon config/server.properties`

2. 停止 Kafka：`./kafka-server-stop.sh` 



>:closed_lock_with_key: Kafka 基本概念：
>
>1. Topic（主题）：消息主题，一个消息主题包含多个 Partitions。
>2. Partitions（分区）：消息的实际存储单位。
>3. Producer（生产者）：消息生产者。
>4. Consumer（消费者）：消息消费者。



Kafka 主题 Topic 操作：

1. 创建主题 topic：

   ~~~shell
   [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic news --partitions 2 --replication-factor 1
   ~~~

   - `--zookeeper localhost:2181`：指定 zookeeper 地址。

   - `--create --topic news`：创建名称为 news 的主题。
   - `--partitions 2`：指定主题的分区数。
   - `--replication-factor 1`：每个分区的副本个数。

2. 查看所有主题：

   ~~~shell
   [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --list
   news
   ~~~

3. 查看主题详情：

   ~~~shell
   [root@localhost kafka]# bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic news
   Topic: news	TopicId: AXYK2TQCSoiT8wc6d7odgw	PartitionCount: 2	ReplicationFactor: 1	Configs: 
   	Topic: news	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
   	Topic: news	Partition: 1	Leader: 0	Replicas: 0	Isr: 0
   ~~~

4. 创建消费者监听主题 news：

   ~~~shell
   [root@localhost kafka]# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic news
   ~~~

   - `--bootstrap-server localhost:9092`：指定连接的 Kafka 集群地址。
   - `--topic news`：指定监听的主题。

   执行此命令后，shell 界面阻塞等待生产者发布消息。

5. 在开启一个 ssh 连接生产消息：

   ~~~shell
   [root@localhost kafka]# bin/kafka-console-producer.sh --broker-list localhost:9092 --topic news
   >Hello Kafka    #输入发布的消息
   ~~~

   - `--broker-list localhost:9092`：指定连接的 Kafka 集群地址。
   - `--topic news`：指定发布的主题。

   发布消息后，监听此主题的消费者就会收到消息。

   >  :green_salad: 上面的监听命令只会接受到开启监听段之后生产者所生产的消息，如果需要接收历史消息，需要额外添加参数：
   >
   > ~~~shell
   > [root@localhost kafka]# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic news --from-beginning
   > xixixi
   > Hello Kafka
   > ~~~
   >
   > 生产者所生产的消息都将会被监听端所接收（顺序不一定）。



---

#### 2.Kafka API-客户端操作



