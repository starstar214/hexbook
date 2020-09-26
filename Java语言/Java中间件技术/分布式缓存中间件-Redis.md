安装 Redis：[CentOS 8 下安装 Redis](../../软件安装手册/中间件安装/CentOS8下安装Redis.md)

Redis 官网：https://redis.io/

Redis 文档：http://www.redis.cn/，https://www.redis.net.cn/



**目录**

1. [NoSQL 与 Redis](#1nosql与redis)
2. [Redis 基础知识与命令](#2redis基础知识与命令)
3. [Redis 数据结构](#3redis数据结构)



---

#### 1.NoSQL与Redis

什么是 NoSQL？

***NoSQL***（Not Only SQL），指的是非关系型的数据库，NoSQL 用于超大规模数据的存储，这些类型的数据存储不需要固定的模式，无需多余操作就可以横向扩展。

为什么要用 NoSQL？

在 90 年代，一个基本的网站访问量一般不会太大，单个数据库完全足够！而随着 Web2.0 网站的快速发展，传统的关系型数据库架构遭遇到了几个挑战：

1. 高并发读写：数据库并发负载非常高，往往达到每秒上万次的读写请求。

2. 高容量存储和高效存储：通常需要在后台数据库中存储海量数据，并且进行高效的查询。

3. 高扩展性和高可用性：随着系统的用户量和访问量与日俱增，需要数据库能够很方便的进行扩展、维护。

随着大数据时代的来临，我们可以很容易的访问和抓取数据，用户的个人信息，社交网络，地理位置，用户生成的数据和用户操作日志已经成倍的增加，此时传统型关系型数据库已经达到了其扩展瓶颈：

1. 无法应对每秒上万次的读写请求，硬盘IO此时也将变为性能瓶颈。

2. 表中存储记录数量有限，横向可扩展能力有限，纵向数据可承受能力也是有限的，面对海量数据，势必涉及到分库分表，难以维护大数据查询SQL效率极低，数据量到达一定程度时，查询时间会呈指数级别增长。

3. 难以横向扩展，无法简单地通过增加硬件、服务节点来提高系统性能，对于需要24小时不间断提供服务的网站来说，数据库升级、扩展将是一件十分麻烦的事，往往需要停机维护，数据迁移，如果网站使用服务器集群，还需要考虑主从一致性、集群扩展性等一系列问题。

NoSQL 数据库的优点：

1. 海量数据下，读写性能优异。

2. 数据模型灵活。

3. 数据间无关系，易于扩展。



NoSQL 数据库分类：

- 键值数据库：使用键值对储存数据。

  - 内存键值数据库：把数据保存在内存中，如 Memcached 和 ***Redis***。
  - 持久化键值数据库：把数据保存在磁盘中，如 BerkeleyDB、Voldmort 和 Riak。

  应用场景：

  1. 内容缓存，主要用于处理大量数据的高访问负载系统。
  2. 储存用户信息，比如会话、配置文件、参数、购物车等,这些信息一般都和 ID（键）挂钩。

- 列式数据库：以列簇式存储，将同一列数据存在一起，可以将其看作是一个每行列数可变的数据表。常见的数据库产品有：Cassandra、***HBase***、Riak。

  应用场景：分布式文件系统。

- 文档数据库：key - value 结构，value 是结构化数据如 json 等。常见的数据库产品有：***MongoDB***、CouchDB。

  应用场景：Web应用，主要用来处理文档信息如日志，大文本等。

- 图形数据库：使用灵活的图形模型存储数据（不是存图片，是存关系的数据库）。常见的数据库产品有：Neo4j，InfoGrid。

  应用场景：社交网络，推荐系统等，专注于构建关系图谱。



---

#### 2.Redis基础知识与命令

*Redis*（**Re**mote **Di**ctionary **S**erver )，即远程字典服务；Redis 使用 ANSI C 语言编写，支持网络，可基于内存亦可持久化的日志型、Key-Value数据库，

并提供多种语言的API。 



Redis 常见应用场景：

- 内存存储、持久化（RDB、AOF）。
- 高速缓存。
- 存储用户 *session*，实现集群模式下的 session 会话管理。
- 消息发布订阅系统。
- 定时器、排行榜、计数器、浏览量等。
- 实现分布式锁。



Redis 安装：[CentOS 8 下安装 Redis](../../软件安装手册/中间件安装/CentOS8下安装Redis.md)



Redis 服务相关命令：

- 启动 Redis 服务：

  - 直接输入 `redis-server`：此时 Redis 服务会以非后台的方式运行，退出命令行后服务停止， 并且由于没有指定配置文件，Redis 会将 当前目录视为工作目录，RDB 文件将会放置在当前目录下。

  - 输入 `redis-server /etc/redis.conf & `：服务以后台的方式运行，并且指定 etc 下的 redis.conf 为配置文件。
  - 输入 `redis-server /etc/redis.conf --daemonize yes`：指定配置文件启动 Redis 服务，同时修改配置项 daemonize 为 yes 以后台运行 Redis 服务。除此之外，redis-server 启动时可以同时指定任意配置项，指定的配置项将会覆盖配置文件中的内容。
  - 修改配置文件 `daemonize  yes`，然后以 `redis-server /etc/redis.conf` 启动。

- 使用 redis-cli 客户端连接 Redis 服务：

  - `redis-cli`：连接 Redis 服务器，默认连接的地址为 ***127.0.0.1***，连接端口为 ***6379***。

  - `redis-cli -h 192.168.253.128 -p 6380`：指定 IP 和端口连接 Redis 服务。

    ~~~shell
    [root@localhost ~]# redis-cli
    127.0.0.1:6379> 
    ~~~

    执行 `redis-cli` 命令后会进入交互界面，在交互界面可以执行 redis-cli 内部命令，使用 *quit/exit* 退出交互界面。

  - 也可以不进入交互界面执行相关内部命令：

    ~~~shell
    [root@localhost ~]# redis-cli set key value
    OK
    ~~~

- 关闭 Redis 服务：
  - `redis-cli shutdown`：关闭 Redis 服务，也可以指定 ***-h*** 和 ***-p***。

> ***redis-cli*** 命令的参数和选项非常多，可以使用 `redis-cli --help` 进行查看。



***redis-benchmark*** 性能测试：*redis-benchmark* 是官方自带的性能测试工具。

使用示例：

~~~shell
[root@localhost ~]# redis-benchmark
~~~

直接使用 redis-benchmark 即可进行压力测试，默认以 50 并发数发起 100,000 次请求（get、set、lpush......）

> redis-benchmark 可以使用选项对性能测试的各种参数进行调整，详细选项可以通过 `redis-benchmark --help` 进行查询。



Redis 数据库：Redis 默认共有 16 个数据库，默认使用第 0 个数据库，在一个数据库中设置的值不能在另一个数据库中进行使用。

- 切换数据库：	

  ~~~shell
  [root@localhost ~]# redis-cli
  127.0.0.1:6379> select 2
  OK
  ~~~

- 清空数据库：

  ~~~shell
  127.0.0.1:6379> DBSIZE                #查看当前数据库的 key 的数量
  (integer) 5
  127.0.0.1:6379[2]> FLUSHDB            #清空当前数据库
  OK
  127.0.0.1:6379[2]> FLUSHALL           #清空所有数据库
  OK
  127.0.0.1:6379> DBSIZE
  (integer) 0
  ~~~



> 由于 Redis 是很快的，而且是基于内存操作，CPU 不是 Redis 的性能瓶颈，所以 Redis 被设计为单线程的。Redis 的瓶颈是机器的内存和网络带宽。
>
>  Redis 为什么这么快？
>
> Redis 的数据都是放在内存中的，绝大部分都是内存操作，使用单线程避免了不必要的 CPU 上下文切换，并且使用了非阻塞IO以保证其性能。





---

#### 3.Redis数据结构







