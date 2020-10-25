---
title: "Redis 基础"
subtitle: "「中间件」Redis 的基本使用"
layout: post
author: "Hex"
date:  2020-10-25
header-img: "img/post-bg-curl.jpg"
catalog:    true
tags:
  - Redis
  - 中间件
  - NoSQL
---



Redis 官网：[https://redis.io/](https://redis.io/)

Redis 文档：[http://www.redis.cn/](http://www.redis.cn/)，[https://www.redis.net.c](https://www.redis.net.c)



## NoSQL 与 Redis

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
  
  

## Redis 安装及使用

*Redis*（**Re**mote **Di**ctionary **S**erver )，即远程字典服务；Redis 使用 ANSI C 语言编写，支持网络，可基于内存亦可持久化的日志型、Key-Value数据库，

并提供多种语言的API。 

 

Redis 常见应用场景：

- 内存存储、持久化（RDB、AOF）。
- 高速缓存。
- 存储用户 *session*，实现集群模式下的 session 会话管理。
- 消息发布订阅系统。
- 定时器、排行榜、计数器、浏览量等。
- 实现分布式锁。

 

Redis 的安装：

1. 查询 Redis 版本

   ```shell
   [root@localhost ~]# dnf list redis
   ```

2. 安装 Redis

   ~~~shell
   [root@localhost ~]# dnf install redis
   ~~~

3. 查看 Redis 相关文件位置

   ~~~shell
   [root@localhost ~]# rpm -ql redis
   ~~~

   - 配置文件位置：*/etc* 下，***redis-sentinel.conf*** 文件以及 ***redis.conf*** 文件。
   - 运行脚本位置：*/usr/bin/* 下，***redis-benchmark***（自带的Redis性能测试工具），***redis-check-aof***，***redis-check-rdb***，***redis-cli***，***redis-sentinel***（哨兵启动脚本），***redis-server***。
   - 默认日志目录：*/var/log/redis/*，默认为此目录下的 ***redis.log*** 文件。

4. Redis 基本命令

   ```shell
   [root@localhost ~]# redis-server /ect/redis.conf           启动Redis，非后台启动，退出命令行后服务停止
   [root@localhost ~]# redis-server /ect/redis.conf &         后台启动Redis
   [root@localhost redis]# redis-cli     进入Redis客户端,默认连接localhost的6379端口
   127.0.0.1:6379> ping
   PONG
   127.0.0.1:6379> exit
   [root@localhost redis]# redis-cli shutdown    关闭Redis服务
   2836:M 14 Sep 2020 01:04:13.294 # User requested shutdown...
   2836:M 14 Sep 2020 01:04:13.294 * Saving the final RDB snapshot before exiting.
   2836:M 14 Sep 2020 01:04:13.295 * DB saved on disk
   2836:M 14 Sep 2020 01:04:13.296 # Redis is now ready to exit, bye bye...
   [1]+  已完成               redis-server  (工作目录: /var/lib)
   (当前工作目录：/var/log/redis)
   ```

   > 启动 Redis 时需要添加 & 符号使 Redis 后台运行，也可以修改配置文件 daemonize 为 yes 以守护进程的方式启动。
   >
   > 启动时须指定配置文件，否则 Redis 会使用默认配置（非默认配置文件），某些配置项会不同于默认配置文件。



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

 

> 由于 Redis 是基于内存操作，CPU 不是 Redis 的性能瓶颈，所以 Redis 被设计为单线程的。Redis 的瓶颈是机器的内存和网络带宽。
>
>  Redis 为什么这么快？
>
> Redis 的数据都是放在内存中的，绝大部分都是内存操作，使用单线程避免了不必要的 CPU 上下文切换，并且使用了非阻塞IO以保证其性能。

 

Redis Key 基本命令：

~~~mysql
127.0.0.1:6379> ping                    #测试连接
PONG
127.0.0.1:6379> set name niko           #设置字符串键值对
OK
127.0.0.1:6379> keys *                  #查看所有键
1) "name"
127.0.0.1:6379> get name                #获取 name 键对应的值
"niko"
127.0.0.1:6379> EXISTS name             #查看是否存在 name 键
(integer) 1
127.0.0.1:6379> move name 1             #将 name 键值对移动到 1 号数据库
(integer) 1
127.0.0.1:6379> get name
(nil)
127.0.0.1:6379> select 1
OK
127.0.0.1:6379[1]> get name
"niko"
127.0.0.1:6379[1]> EXPIRE name 10       #将 name 键值对设置为 10s 后过期
(integer) 1
127.0.0.1:6379[1]> ttl name             #查看 name 键值对的剩余时间(s)
(integer) 4
127.0.0.1:6379> type name               #查看 name 键对应值的类型
string
127.0.0.1:6379> DEL key_name            #删除指定 key
(integer) 1
~~~



使用客户端配置服务器：`config set xxx xxx`

~~~shell
127.0.0.1:6379> config set requirepass "950920"    #直接配置密码
OK
127.0.0.1:6379> auth 950920            			   #验证密码
OK
~~~

 除密码外，通过 ***config*** 命令可以配置 *redis.conf* 中的任意配置。



## Redis 五大数据类型

1. 字符串类型

   String 是 Redis 最基本的类型，可以存储整型、浮点型和字符串数据。String 类型是二进制安全的，可以包含任何数据，如 jpg 图片或者序列化对象。String 类型是 Redis 最基本的数据类型，String 类型的值最大能存储 ***512MB***。

   字符串数据相关命令：

   ~~~mysql
   127.0.0.1:6379> get name
   "niko"
   127.0.0.1:6379> APPEND name oo       #字符串追加拼接，如果当前 key 不存在，则相当于 set key
   (integer) 6
   127.0.0.1:6379> get name
   "nikooo"
   127.0.0.1:6379> set time 2020-09-09T00:44:31.857
   OK
   127.0.0.1:6379> GETRANGE time 0 3    #获取字符串部分范围的内容
   "2020"
   127.0.0.1:6379> GETRANGE time 0 -1   #获取字符串全部内容(结束位置输入 -1 表示全部)
   "2020-09-09T00:44:31.857"
   127.0.0.1:6379> SETRANGE time 2 21   #从第 2 位置开始替换字符串 
   (integer) 23
   127.0.0.1:6379> get time
   "2021-09-09T00:44:31.857"
   
   ~~~

   整型数据相关命令：

   ~~~mysql
   127.0.0.1:6379> set views 0          #设置整型数据
   OK
   127.0.0.1:6379> INCR views           #views 自增 1
   (integer) 1
   127.0.0.1:6379> get views
   "1"
   127.0.0.1:6379> DECR views           #views 自减 1
   (integer) 0
   127.0.0.1:6379> DECR views
   (integer) -1
   127.0.0.1:6379> get views             
   "-1"
   127.0.0.1:6379> INCRBY views 10      #views 自增 10
   (integer) 9
   127.0.0.1:6379> DECRBY views 5       #views 自减 5
   (integer) 4
   ~~~

   其他命令：

   ~~~mysql
   127.0.0.1:6379> setex gender 20 male   #设置值同时设置过期时间
   OK
   127.0.0.1:6379> get gender
   "male"
   127.0.0.1:6379> ttl gender
   (integer) 10
   127.0.0.1:6379> SETNX name star         #如果不存在 name 键值对才设置值(仅 set 时会覆盖原值)，创建失败返回 0
   (integer) 0
   127.0.0.1:6379> get name
   "nikooo"
   127.0.0.1:6379> mset age 25 mail tiny.star@qq.com addr ChengDu        #批量设置值
   OK
   127.0.0.1:6379> get mail
   "tiny.star@qq.com"
   127.0.0.1:6379> mget age addr               #批量获取值
   1) "25"
   2) "ChengDu"
   127.0.0.1:6379> MSETNX height 184cm age 24  #批量设置不存在的键值(原子操作，有一个值设置不成功则全部失败)
   (integer) 0
   127.0.0.1:6379> get height
   (nil)
   127.0.0.1:6379> get user:1:name   
   "niko"
   127.0.0.1:6379> getset user:1:name star      #先 get 再 set(可以用来更新值的原子操作)
   "niko"
   127.0.0.1:6379> get user:1:name
   "star"
   ~~~
   
    

> Redis 设置对象的方式：
>
> 1. 使用 json 字符串储存对象
>
>    ~~~mysql
>    127.0.0.1:6379> set user:1 {name:niko,age:25,gender:male}
>    OK
>    127.0.0.1:6379> get "user:1"
>    "{name:niko,age:25,gender:male}"
>    ~~~
>
> 2. 设计 key 的值使用 mset 来储存对象
>
>    ~~~mysql
>    127.0.0.1:6379> mset user:1:name niko user:1:age 25 user:1:gender male
>    OK
>    127.0.0.1:6379> mget user:1:age user:1:gender
>    1) "25"
>    2) "male"
>    ~~~

 

2. List 类型数据

   在 Redis 中，我们可以使用 List 数据结构实现栈，队列等，List 的本质是一个链表结构。

   *List* 常用命令：

   ~~~shell
   127.0.0.1:6379> LPUSH list one                #向 list 中从左边放入一个值
   (integer) 1
   127.0.0.1:6379> LPUSH list three four         #向 list 中从左边依次放入 three、four 两个值
   (integer) 4
   127.0.0.1:6379> LRANGE list 0 -1              #查看 list 的所有值
   1) "four"
   2) "three"
   3) "two"
   4) "one"
   127.0.0.1:6379> LRANGE list 0 1               #查看 list 的前两个值(从左边开始)
   1) "four"
   2) "three"
   127.0.0.1:6379> RPUSH list zero               #向 list 中从右边放入一个值
   (integer) 5
   127.0.0.1:6379> LPOP list                     #移除 list 最左边的元素
   "four"
   127.0.0.1:6379> RPOP list                     #移除 list 最右边的元素
   "zero"
   127.0.0.1:6379> LINDEX list 1                 #通过下表获取 list 的某一个值
   "two"
   127.0.0.1:6379> LLEN list                     #返回 list 的长度
   (integer) 3
   127.0.0.1:6379> LREM list 1 three             #从 list 中移除 1 个 three
   (integer) 1
   127.0.0.1:6379> ltrim list 0 1                #截取 list 中 0-1 下标的数据
   OK
   127.0.0.1:6379> RPOPLPUSH list queue          #将 list 最右边的元素取出放在 queue 的左边
   "three"
   127.0.0.1:6379> LSET list 0 two               #将 list 的 0 号下标的元素更改为 two
   OK
   127.0.0.1:6379> LRANGE list 0 -1
   1) "two"
   2) "one"
   3) "two"
   4) "three"
   127.0.0.1:6379> LINSERT list BEFORE two zero  #在 list 中 two 这个元素的前面插入 zero(只会插入到最左边的第一个指定元素前)
   (integer) 5
   127.0.0.1:6379> LRANGE list 0 -1
   1) "zero"
   2) "two"
   3) "one"
   4) "two"
   5) "three"
   ~~~

 


3. Set 类型数据

   Redis 的 Set 类似于 List，Set 中的值无序不重复。

   *Set* 常用命令：

   ~~~shell
   127.0.0.1:6379> sadd students Jack Nacy        #从左边向 Set 中依次放入 Jack、Nacy 两个值
   (integer) 2
   127.0.0.1:6379> SMEMBERS students              #查看 Set 的所有值
   1) "Nacy"
   2) "Jack"
   127.0.0.1:6379> SISMEMBER students James       #判断 James 是否在 Set 中
   (integer) 0
   127.0.0.1:6379> SCARD students                 #查看 Set 的元素个数
   (integer) 2
   127.0.0.1:6379> SREM students Jack             #移除 Set 中的指定元素
   (integer) 1
   127.0.0.1:6379> SRANDMEMBER students           #从 Set 中随机抽取一个成员
   "Rose"
   127.0.0.1:6379> SRANDMEMBER students 2         #从 Set 中随机抽取两个成员
   1) "James"
   2) "Jack"
   127.0.0.1:6379> spop students                  #从 Set 中随机删除一个成员并返回该成员的值
   "Rose"
   127.0.0.1:6379> SMOVE students teachers Lucky  #从 Set 中随机移动一个成员到另一个 Set
   (integer) 1
   127.0.0.1:6379> SDIFF students teachers        #求两个或多个 Set 的差集
   1) "James"
   2) "Tom"
   3) "LiMei"
   4) "Jack"
   5) "Nacy"
   127.0.0.1:6379> SINTER students teachers       #求两个或多个 Set 的交集
   1) "Lucy"
   2) "Niko"
   127.0.0.1:6379> SUNION students teachers       #求两个或多个 Set 的并集
    1) "Tom"
    2) "Lucy"
    3) "Niko"
    4) "Nacy"
    5) "LiMei"
   ~~~

    

4. Hash 类型数据

   Redis 中的 Hash 类似于 Java 中的 Map 结构，存放的 key - value 键值对（value 为字符串或数字）。

   *Hash* 常用命令：

   ~~~shell
   127.0.0.1:6379> hset user name Niko            #设置一个 Hash 数据的键值对 name - Niko
   (integer) 1
   127.0.0.1:6379> HSETNX user age 25             #当 Hash 中不存在键时设置一个键值对
   (integer) 1
   127.0.0.1:6379> hget user name                 #获取 user 中 name 键对应的值
   "Niko"
   127.0.0.1:6379> hmset user age 25 gender male  #同时设置多个键值对
   OK
   127.0.0.1:6379> hmget user age gender
   1) "25"
   2) "male"
   127.0.0.1:6379> hgetall user
   1) "name"
   2) "Niko"
   3) "age"
   4) "25"
   127.0.0.1:6379> hdel user age gender           #删除 Hash 中指定键值对
   (integer) 2
   127.0.0.1:6379> hlen user                      #查看 Hash 中的键值对个数
   (integer) 1
   127.0.0.1:6379> HEXISTS user name              #判断 Hash 中指定键是否存在
   (integer) 1
   127.0.0.1:6379> HKEYS user                     #查看 Hash 中所有的键
   1) "name"
   127.0.0.1:6379> HVALS user                     #查看 Hash 中所有的值
   1) "Niko"
   127.0.0.1:6379> HINCRBY user age 1             #将 Hash 中某个键的值加上一个值(如果不存在该键则会创建)
   (integer) 1
   
   ~~~

   Hash 适合用来存储简单对象。



5. Zset 数据类型

   在 Set 的基础上增加了一个分值，可以根据分值进行排序，所以 Zset 也可以看成一个有序不重复集合（分值可以重复，元素不能重复）。

   *Zset* 常用命令：

   ~~~shell
   127.0.0.1:6379> ZADD numbers 1 one 2 two        #向 Zset 中加入元素 [分值 元素]
   (integer) 2
   127.0.0.1:6379> ZADD numbers 5 five 3 three
   (integer) 2
   127.0.0.1:6379> ZRANGE numbers 0 -1             #按下标获取 Zset 中的元素(加入 Zset 中的元素会按照分值进行排序)
   1) "one"
   2) "two"
   3) "three"
   4) "five"
   127.0.0.1:6379> ZREVRANGE numbers 0 1           #翻转 Zset 后获取其中指定范围的元素
   1) "five"
   2) "two"
   127.0.0.1:6379> ZRANGEBYSCORE numbers 0 2       #获取 Zset 中分数在 0-2 之间的元素
   1) "one"                                        
   2) "two"                                        #ZRANGEBYSCORE key min max [WITHSCORES] [limit offset count]
   127.0.0.1:6379> ZRANGEBYSCORE numbers 0 3 withscores limit 2 1
   1) "three"                                      #获取 Zset 中分数在 0-3 之间的元素同时展示分数，偏移值为 2 ，只展示一个元素
   2) "3"
   127.0.0.1:6379> ZRANGEBYSCORE numbers -inf +inf #获取 Zset 中分数在 负无穷(-inf)-正无穷(+inf) 之间的元素
   1) "one"
   2) "two"
   3) "three"
   4) "five"
   127.0.0.1:6379> ZREM numbers three              #移除 Zset 中的指定元素
   (integer) 1
   127.0.0.1:6379> ZCARD numbers                   #查看 Zset 中元素个数
   (integer) 3
   127.0.0.1:6379> zcount numbers 0 3              #查看 Zset 中分数在 0-3 之间的元素个数
   (integer) 2
   127.0.0.1:6379> ZINCRBY numbers 2 two           #给元素 “two” 的分数加 2
   "4"
   127.0.0.1:6379> ZPOPMAX numbers 1               #移除 Zset 中分数最大的 1 个元素
   1) "five"
   2) "5"
   127.0.0.1:6379> ZPOPMIN numbers 1               #移除 Zset 中分数最小的 1 个元素
   1) "one"
   2) "1" 
   127.0.0.1:6379> ZRANK numbers ten               #查看元素 “ten” 的排名(从 0 开始)
   (integer) 1
   ~~~
   
   应用：排行榜，成绩表等统计类功能实现。
   
   

## Redis 特殊数据类型

地理位置 ***Geospatial***：*Geospatial* 是 Redis 3.2 版本推出的一个新功能，用来记录地理位置的名称和经纬度，可以用来推算两地之间的距离，方圆距离内的地理信息等，其数据结构为一种特殊 Zset，值存储地理名，score 存储经度和纬度信息。

*Geospatial* 命令：

- ***geoadd*** key longtitude  latitude member [longtitude  latitude member]：向地理位置组中添加地理位置。

  ~~~shell
  127.0.0.1:6379> GEOADD china:city 121.472644 31.231706 ShangHai 116.405285 39.904989 BeiJing
  (integer) 2
  ~~~

  有效的经度：-180 到 180 度。

  有效的纬度：-85.05112878 到 85.05112878 度。

- ***geopos*** key member [key member]：查看地理位置组某一个（多个）地理位置的经纬度。

  ~~~shell
  127.0.0.1:6379> GEOPOS china:city BeiJing
  1) 1) "116.40528291463851929"
     2) "39.9049884229125027"
  ~~~

- ***geodist*** key member1 member2：查看两个地理位置之间的直线距离（返回 *m* 单位）。

  ~~~shell
  127.0.0.1:6379> GEODIST china:city BeiJing ShangHai
  "1067597.9668"
  ~~~

- ***georadius*** key longtitude  latitude radius m|km|ft|mi：查找某一经纬度某距离内的地理位置成员。

  ~~~shell
  127.0.0.1:6379> georadius china:city 116 39 2000 km count 3 desc
  1) "ShenZhen"
  2) "ChengDu"
  3) "ChongQing"
  ~~~

- ***georadiusbymember*** key member radius m|km|ft|mi：查找某地理位置周围某距离内的地理位置成员。

  ~~~shell
  127.0.0.1:6379> GEORADIUSBYMEMBER china:city ChengDu 500 km
  1) "ChongQing"
  2) "ChengDu"
  ~~~

> 获取半径距离内的成员时，Redis 还支持一些选项实现不同的功能：
>
> - *WITHCOORD*：同时返回经纬度。
> - *WITHDIST*：同时显示与目标位置之间的直线距离。
> - *WITHHASH*：同时返回地理位置的 hash 值。
> - *COUNT count*：只返回前 n 条数据。
> - *ASC|DESC*：按距离的远近进行排序。
> - *STORE key*：将查询结果保存为 Zset，位置信息作为 score，地理名称作为 member。
> - *STOREDIST key*：将查询结果保存为 Zset，距离作为 score，地理名称作为 member。

- 由于*Geospatial* 的底层实现为 Zset，所以我们可以使用 Zset 的相关命令对 Geospatial 进行处理（移除元素，查看元素等）。

  ~~~shell
  127.0.0.1:6379> ZRANGE china:city 0 -1
  1) "WuLuMuQi"
  2) "ChongQing"
  3) "ChengDu"
  4) "ShenZhen"
  5) "HangZhou"
  6) "ShangHai"
  7) "BeiJing"
  127.0.0.1:6379> zrem china:city HangZhou
  (integer) 1
  ~~~

 

数据结构 ***Hyperloglog***：在 Redis 2.8.9 版本添加，用来做基数统计的算法，HyperLogLog 的优点是：在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定并且是很小的（接受一定误差 0.81%），在 2 的 64 次方的数据量下统计基数只需要 ***12KB*** 的内存。

基数：数据集 {1,3,5,7,5,7,8,9}， 那么这个数据集的基数集为 {1,3,5,7,8,9}，数据集的基数(不重复元素个数)为 6 个。

*Hyperloglog* 常用命令：

- ***pfadd*** key element [element ...]：向 *Hyperloglog* 加入元素。

  ~~~shell
  127.0.0.1:6379> pfadd word a b c d e f g
  (integer) 1
  
  ~~~

- ***pfcount*** key [key ...]：查看一个或多个数据集的基数 *Hyperloglog* 。

  ~~~shell
  127.0.0.1:6379> pfcount word vowel
  (integer) 10
  ~~~

- ***pfmerge*** destkey sourcekey [sourcekey ...]：将多个 *Hyperloglog* 数据集合并到 destkey 中。

  ~~~shell
  127.0.0.1:6379> PFMERGE word vowel
  OK
  ~~~

    

位图 ***Bitmap***：Redis 2.2.0 版本引入此数据类型，其数据结构类似于 hash，但是其 value 只能是 0 或 1，在数据量很大时，使用 *Bitmap* 存储只有两个状态的信息时可以极大的节省储存空间。

*Bitmap* 常用命令：

- ***setbit*** key offset value：向 Bitmap 中某个位置设置值。

  ~~~shell
  127.0.0.1:6379> SETbit bit 0 0
  (integer) 0
  ~~~

- ***getbit*** key offset：获取 Bitmap 中某个位置的值。

  ~~~shell
  127.0.0.1:6379> getbit bit 7
  (integer) 1
  ~~~

- ***bitcount*** key [start end]：获取 Bitmap 中的所有状态为 1 的数量。

  ~~~shell
  127.0.0.1:6379> BITCOUNT bit
  (integer) 2
  ~~~

  > 注意：*BITCOUNT* 直接加范围进行统计的结果不准确，如果需要加范围统计，setbit 时的 offset 要乘以 8 。
  >
  > ~~~shell
  > 127.0.0.1:6379> setbit byte 0 1
  > (integer) 0
  > 127.0.0.1:6379> setbit byte 8 1
  > (integer) 0
  > 127.0.0.1:6379> setbit byte 16 0
  > (integer) 0
  > 127.0.0.1:6379> BITCOUNT byte 0 1
  > (integer) 2
  > ~~~
  >
  > 即：`bitcount byte 0 2`  == `bitcount 0*8 2*8` == `bitcount 0 16`

 

## Redis事务

Redis 事务的本质是一组命令的集合。事务支持一次执行多个命令，一个事务中所有命令都会被序列化。在事务执行过程，会按照顺序串行化执行队列中的命令，其他客户端提交的命令请求不会插入到事务执行命令序列中。

Redis 事务没有隔离级别的概念，批量操作在发送 *exec* 命令前被放入队列缓存，并不会被实际执行；Redis 事务也不保证原子性：Redis 的单条命令是原子性执行的，但事务不保证原子性，且没有回滚，事务中任意命令执行失败，其余的命令仍会被执行。



Redis 事务执行的 3 个阶段：

1. 开始事务：***multi***

   ~~~shell
   127.0.0.1:6379> MULTI
   OK
   ~~~

2. 命令入队：......

   ~~~shell
   127.0.0.1:6379> set k1 v1
   QUEUED
   127.0.0.1:6379> set k2 v2
   QUEUED
   127.0.0.1:6379> get k2
   QUEUED
   ~~~

3. 执行事务：***exec***

   ~~~shell
   127.0.0.1:6379> exec
   1) OK
   2) OK
   3) "v2"
   ~~~

   也可以输入 ***discard*** 取消事务。



事务异常：

- 当输入的命令语法错误时，所有事务中的命令均不会执行。

  ~~~shell
  127.0.0.1:6379> multi
  OK
  127.0.0.1:6379> set k1 v1
  QUEUED
  127.0.0.1:6379> set k10 v10
  QUEUED
  127.0.0.1:6379> gget kk
  (error) ERR unknown command `gget`, with args beginning with: `kk`, 
  127.0.0.1:6379> exec
  (error) EXECABORT Transaction discarded because of previous errors.
  127.0.0.1:6379> get k10
  (nil)
  ~~~

- 当输入的命令语法正确，但是执行过程中发生错误时，不会影响其他命令的执行。

  ~~~shell
  127.0.0.1:6379> multi
  OK
  127.0.0.1:6379> set k1 v1
  QUEUED
  127.0.0.1:6379> incr k1
  QUEUED
  127.0.0.1:6379> set k2 v2
  QUEUED
  127.0.0.1:6379> exec
  1) OK
  2) (error) ERR value is not an integer or out of range
  3) OK
  127.0.0.1:6379> get k2
  "v2"
  ~~~



Redis 可以使用 ***watch***（乐观锁） 监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断（回滚）。

~~~shell
127.0.0.1:6379> watch money
OK
127.0.0.1:6379> multi 
OK
127.0.0.1:6379> decrby money 20            #在 watch 之后，事务 exec 之前使用另一个客户端改变 money 的值
QUEUED
127.0.0.1:6379> incrby cost 20
QUEUED
127.0.0.1:6379> exec                   
(nil)                                      #事务执行不成功
127.0.0.1:6379> get cost
"0"
~~~

在实际使用过程中，当被 watch 监视的事务执行失败时，我们可以使用 ***unwacth*** 解除监视后再次（获取新值）进行监视、执行事务。

> 使用 Redis 的 multi 和 watch 可以实现 ***CAS*** 操作。



## Redis 配置文件

redis.conf 默认单位介绍：单位大小写不敏感。

~~~shell
# 1k => 1000 bytes
# 1kb => 1024 bytes
# 1m => 1000000 bytes
# 1mb => 1024*1024 bytes
# 1g => 1000000000 bytes
# 1gb => 1024*1024*1024 bytes
#
# units are case insensitive so 1GB 1Gb 1gB are all the same.
~~~

- ***INCLUDES***：引入外部配置文件。

   ~~~shell
   # include /path/to/local.conf
   # include /path/to/other.conf
   ~~~

- ***MODULES***：加载一些 *so* 文件用以扩展 Redis 的功能。

   ~~~shell
   # loadmodule /path/to/my_module.so
   # loadmodule /path/to/other_module.so
   ~~~

- ***NETWORK***：网络模块，配置连接 Redis 服务的相关参数。

   - 网络地址绑定：绑定一个或多个 IP 地址，使 Redis 服务只监听来自目标 IP 的连接请求。

     ~~~shell
     # Examples:
     bind 192.168.1.100 10.0.0.1
     bind 127.0.0.1 ::1
     ~~~

     不使用 bind 配置或 `bind 0.0.0.0` 时，Redis 会监听来自所有地址的连接请求（公网条件下不建议）。

   - 保护模式：启用保护模式后，只有主机能够连接到 Redis 服务。

     ~~~shell
     protected-mode no
     ~~~

   - Redis 启动端口：

     ~~~shell
     port 6379
     ~~~

   - tcp 连接的队列大小，当请求量巨大时，允许最大 511 个 tcp 请求在队列中等待响应。

     ~~~shell
     tcp-backlog 511
     ~~~

   - 客户端连接超时：当客户端空闲 n 秒后，主动断开与客户端的连接。

     ~~~shell
     timeout 0
     ~~~

     设置为 0 时，表示不启动连接超时功能。

   - 每 300 秒向客户端发送 ACK 信息以保持连接活跃。

     ~~~shell
     tcp-keepalive 300
     ~~~

- ***GENERAL***：一些通用配置项。

   - 守护进程模式：修改为 yes 允许 Redis 服务后台运行。

     ~~~shell
     daemonize yes
     ~~~

   - 是否通过 *upstart* 和 *systemd* 管理 Redis 服务，保持默认的 no 即可。

     ~~~shell
     supervised no
     ~~~

   - Redis 服务启动后的 *pid* 文件：

     ~~~shell
     pidfile /var/run/redis_6379.pid
     ~~~

   - 日志信息：Redis 服务的日志级别和日志地址

     ~~~bash
     loglevel notice      
     logfile /var/log/redis/redis.log
     ~~~

   - 数据库个数：默认为 16 个数据库。

     ~~~bash
     databases 16
     ~~~

   - 启动时是否打印 logo：

     ~~~bash
     always-show-logo yes
     ~~~

- ***SNAPSHOTTING***：RDB 快照参数设置，详情见第 10 章节。

- ***REPLICATION***：主从复制相关配置，详情见 Redis 高级：[Redis 高级使用](#12redis主从与哨兵)

- ***SECURITY***：安全相关配置。

   - 设置密码：

     ~~~bash
     requirepass 950920
     ~~~

     除了配置文件，也可以在命令行设置密码，将密码注释或者设置为 "" 即为取消密码。

   - 禁用或重命名危险命令（***flushdb***，***flushall***，***config***，***shutdown*** 等）

     ~~~bash
     rename-command FLUSHALL ""                       #禁用 FLUSHALL 命令
     rename-command CONFIG FRaqbC8wSA1XvpFVjCRGry     #将 CONFIG 命令重命名为其他名字，保证不会轻易执行
     ~~~

- ***CLIENTS***：客户端限制参数配置，同一时间允许最多 n 个客户端进行连接。

   ~~~bash
   maxclients 10000
   ~~~

- ***MEMORY MANAGEMENT***：内存管理相关配置。

   - 最大使用内存：一般不做配置，有默认使用大小。

     ~~~bash
     maxmemory <bytes>
     ~~~

   - 内存达到最大时采取的策略：

     ~~~bash
      maxmemory-policy noeviction         #默认策略
     ~~~

     Redis 清除 Key 的算法：

     - *LRU*：Least Recently Used，最近最少使用算法。
     - *LFU*：Least Frequently Used，最近最不常使用算法。
     - *TTL*：Time To Live，最少存活时间算法。

     此配置项的策略共有 8 种：

     - *volatile-lru*：从设置了过期时间的 key 中通过 LRU 算法移除一个 key。

     - *allkeys-lru*：从所有 key 中通过 LRU 算法移除一个 key。

     - *volatile-lfu*：从设置了过期时间的 key 中通过 LFU 算法移除一个 key。

     - *allkeys-lfu*： 从所有 key 中通过 LFU 算法移除一个 key。

     - *volatile-random*：从设置了过期时间的 key 当中移除一个随机的 key。

     - *allkeys-random*：随机从所有 key 当中移除 key。

     - *volatile-ttl*：从设置了过期时间的 key 当中移除最快要过期的那个 key。

     - *noeviction*：不做任何操作，直接返回错误。

   - LRU 算法的样本数量设置：Redis 的 LRU 算法为近似算法，增大样本数量可提高精确度但是会凶耗更多的 CPU，保持默认 5 个样本数量即可。

     ~~~bash
     maxmemory-samples 5      #样本数量
     ~~~

   - 是否忽略从库的内存配置：

     ~~~bash
     replica-ignore-maxmemory yes
     ~~~

     当使用主从配置时，Redis 默认会忽略从库的 maxmemory 相关配置，但是如果从库是可写的并且你希望从库有一些不同的内存设置，可更改此选项。

- ***LAZY FREEING***：

    ~~~bash
    lazyfree-lazy-eviction no
    lazyfree-lazy-expire no
    lazyfree-lazy-server-del no
    replica-lazy-flush no
    ~~~

- ***APPEND ONLY MODE***：AOF相关配置，详情见第 10 章节：[持久化之 RDB 与 AOF](#持久化之 rdb 与 aof)。

- ***LUA SCRIPTING***：Lua 脚本的相关配置，允许 Lua 脚本执行的的最大好毫秒数

    ~~~bash
    lua-time-limit 5000
    ~~~

    设置为 0 或负值时，Lua 脚本可以无警告的无限执行。

- ***REDIS CLUSTER***：Redis 集群配置，详情见 Redis 高级：[Redis 集群模式](#13redis集群模式)

14. ***CLUSTER DOCKER/NAT support***：当 Redis cluster 服务经过 NAT 限制或端口被转发时（如 Docker 容器），需要配置集群的节点位置，否则 Redis cluster 地址不能被主机发现。

15. ***SLOW LOG***：Redis 慢日志功能相关配置，在 Redis 中可以将超过指定执行时间的查询命令记录下来，此模块对此功能的参数进行控制。

    ~~~bash
    slowlog-log-slower-than 10000   #将超过 10000 微秒(10毫秒)的查询记录下来
    slowlog-max-len 128             #允许做多记录 128 个命令(当纪录达到 128 时，记录新命令时会删除最老的一个命令)
    								# slowlog-max-len设置为负数时该功能禁用，设置为 0 时可以无限制的记录慢日志
    ~~~

    Redis 慢日志相关命令：

    ~~~shell
    127.0.0.1:6379> SLOWLOG len       #获取慢日志记录的个数
    (integer) 2
    127.0.0.1:6379> SLOWLOG get       #获取所有慢日志记录
    1) 1) (integer) 14                #1)慢日志 ID
       2) (integer) 1309448221        #2)命令执行的 UNIX 时间戳
       3) (integer) 15                #3)命令执行的微秒数
       4) 1) "ping"                   #4)组成命令参数的数组
    2) 1) (integer) 13
       2) (integer) 1309448128
       3) (integer) 30
       4) 1) "slowlog"
           2) "get"
           3) "100"
    127.0.0.1:6379> SLOWLOG get 1      #获取最近的 1 条慢日志记录
    1) 1) (integer) 14
       2) (integer) 1309448221
       3) (integer) 15
       4) 1) "ping"
    127.0.0.1:6379> SLOWLOG RESET      #重置(清空)慢日志记录，不可恢复
    ~~~

- ***LATENCY MONITOR***：Redis 2.1.83 版本引入的延迟监视系统，此系统会在运行时对不同的操作进行采样，以收集与 Redis 实例的潜在延迟源相关的数据，还可以画出延时图，给出诊断建议等。默认情况下，延迟监视是禁用的（如果没有延迟问题，一般来说此功能用不到），并且此功能在收集数据会对性能产生影响（尽管影响很小）。

    延迟监视相关命令：`latency arg ...options...`

- ***EVENT NOTIFICATION***：事件通知，Redis 提供了事件监听，可以对事件作相关配置，每当事件（如：键失效，键被删除等）发生时，都会向客户端发送通知。在 SpringBoot 中，也对 Redis 的事件监听功能做了集成，通过继承 *org.springframework.data.redis.listener* 包下的相关 Listener（如：***KeyExpirationEventMessageListener***--键过期监听器），实现其 *onMessage* 方法即可在事件发生时触发我们想要的回调。

- ***ADVANCED CONFIG***：高级配置，与数据压缩，发布订阅，LFU 算法因子相关的一些复杂配置项。

- ***ACTIVE DEFRAGMENTATION***：内存碎片整理，Redis 在 4.0 版本加入此功能，对 Redis 运行过程中产生的内存碎片进行整理以节约内存空间，此功能默认禁用且处于实验性阶段，如果没有发生碎片问题（Redis 服务内存占用量高但实际占用内存的数据量不大）则不要轻易开启此功能。



## 持久化之 RDB 与 AOF

RDB：**R**edis **D**ata**B**ase，在指定的时间间隔内将内存中的数据集以快照的形式保存在磁盘上，是默认的持久化方式，默认的文件名为 ***dump.rdb***，恢复时将快照文件放入到配置文件中 dir 配置的目录下，Redis 就会自动读取文件当中的数据到内存中。

Redis 提供了 3 种方式进行 RDB 存储：

- ***save*** 命令：该命令会阻塞当前 Redis 服务器，执行 save 命令期间，Redis 不能处理其他命令，直到 RDB 过程完成为止。
- ***bgsave*** 命令：Redis 主进程 fork 出一个子进程来进行持久化，子进程会拥有父进程所有的内存数据，主进程不进行任何 I/O 操作，阻塞只发生在 fork 阶段（时间很短）。
- 自动触发：在配置文件中进行配置 `save 900 1` 等，在达到相应条件时自动触发 *bgsave* 命令。

RDB 存储的优点：

- RDB 文件紧凑，全量备份，非常适合用于进行备份和灾难恢复。
- 生成 RDB 文件的时候，Redis 主进程不需要进行任何 I/O 操作，不会阻塞 Redis 其他命令的执行。
- RDB 在恢复大数据集时的速度比 AOF 的恢复速度要快。

RDB 存储的缺点：

- 当数据量较大时，RDB 的执行成本较高，fork 出的子进程也需要占用大量的内存空间。
- RDB 在一定间隔时间做一次存储，可能会丢失丢失最后一次快照后的所有修改。

*redis.conf* 中 RDB 相关配置：

- RDB 储存刷新条件：

  ~~~bash
  save 900 1        #每 900 秒保存一次(如果有 1 个键发生改变)
  save 300 10       #每 300 秒保存一次(如果有 10 个键发生改变)
  save 60 10000     #每 60 秒保存一次(如果有 10000 个键发生改变)
  ~~~

  如果需要禁用 RDB，使用 `save ""` 或直接注释所有 `save <seconds> <changes>` 即可。

- RDB 其他配置：

  ~~~bash
  #持久化如果出错，Redis 是否还需要继续工作
  stop-writes-on-bgsave-error yes
  #是否将 RDB 文件压缩存储
  rdbcompression yes
  #保存 RDB 文件的时候，进行错误的检查校验
  rdbchecksum yes
  #RDB快照文件名
  dbfilename dump.rdb  
  #快照文件存储路径
  dir /var/lib/redis/    
  ~~~

    

AOF：**A**ppend **O**nly **F**ile，将每一个收到的写命令都通过 write 函数追加到文件中，相当于日志记录，Redis 默认不启用 AOF。恢复时会去读取日志文件，将每一个写命令重新执行一次。AOF 方式就是文件的无限追加，文件会随着时间越来越大，所以 Redis 提供了 Rewrite 功能重写 AOF 文件。

AOF 存储的优点：

- AOF 执行的频率较高，可以更好的保护数据不丢失，且 AOF 文件写入性能非常高，文件不易破损。

- AOF 日志文件的可读性较高（内容为 Redis 命令），非常适合做灾难性的误删除的紧急恢复。比如：使用 *flushall* 命令清空了所有数据，只要后台 rewrite 还没有发生，可以将最后一条 flushall 命令删除，重新读取 AOF 文件即可恢复所有数据。

AOF 存储的缺点：

- 当数据量较大时，AOF 恢复数据所需要的的时间较长。
- 当 AOF 开启时，会消耗一定的性能，Redis 的 QPS 会降低（影响较小）。

*redis.conf* 中 RDB 相关配置：

- 开启 AOF 功能：

  ~~~bash
  appendonly yes                          #开启 aof，no 为关闭
  appendfilename "appendonly.aof"         #aof 存储的文件名
  ~~~

  注意：*appendonly.aof*  文件的存储路径与 *dump.rdb* 一致，由 `dir` 参数进行配置。

- AOF 执行策略：

  ~~~bash
  # appendfsync always
  appendfsync everysec
  # appendfsync no
  ~~~

  - ***always***：每次发生数据变更会被立即记录到磁盘，性能影响较大，但数据完整性会比较好。
  - ***everysec***：每秒钟进行一次追加操作，最多会丢失一秒钟的数据，官方建议采取此策略。
  - ***no***：从不，即禁用 aof 功能。

- AOF Rewrite 配置：

  ~~~bash
  #当后台在重写 aof 文件时，会占用大量的磁盘 I/O，此时是否阻塞 aof 操作。
  #no：阻塞 aof 操作直到磁盘空闲，此方式不会丢失任何数据，但是需要忍受命令阻塞。
  #yes：aof 操作不会被阻塞而是将追加结果暂时写到缓存中，待磁盘不阻塞时再写入文件(如果发生故障，最多可能丢失 30 秒的数据)
  no-appendfsync-on-rewrite no
  #当 aof 文件增长比例达到 100% 时(即为上次重写后的 2 倍)才再次进行重写
  auto-aof-rewrite-percentage 100
  #当 aof 文件达到 64mb 时才进行重写(初次启动有效，后续重写依赖增长比例)
  auto-aof-rewrite-min-size 64mb
  #从 aof 恢复数据时，是否忽略最后一条可能存在问题的指令(比如指令执行到一半时崩溃)，yes-进行忽略，no-不忽略，可能会启动失败
  aof-load-truncated yes
  #是否开启 aof-rdb 混合模式
  aof-use-rdb-preamble yes
  ~~~

  混合模式 ***aof-use-rdb-preamble***：Redis 4.0 开始增加了此混合模式，Redis 在重启时通常是加载 AOF 文件，但加载速度较慢，开启此模式后，AOF 在重写时将会直接以 RDB 形式写入内存中的数据：

  1. 子进程会把内存中的数据以 RDB 的方式写入 AOF 中。
  2. 把重写缓冲区中的增量命令以 AOF 方式写入到文件。
  3. 使用新的 AOF 文件覆盖旧的 AOF 文件，新的AOF文件中，一部分数据为 RDB格式，一部分为 AOF 格式（重写过程中的增量数据）。

  混合模式既能快速备份又能避免大量数据丢失，但是会降低 AOF 文件的可读性。



> Redis 提供了持久化文件的校验功能，如果 appendonly.aof 有损坏还可以进行修复。
>
> ~~~shell
> [root@localhost bin]# redis-check-rdb /var/lib/redis/dump.rdb               校验 rdb 文件(rdb 文件不能修复)
> [root@localhost bin]# redis-check-aof /var/lib/redis/appendonly.aof         校验 aof 文件
> [root@localhost bin]# redis-check-aof --fix /var/lib/redis/appendonly.aof   修复 aof 文件
> ~~~



Redis 支持 RDB 和 AOF 同时开启时，两者都会讲数据进行持久存储，但是在启动时，Redis 会优先从 AOF 文件中恢复数据。

> 如果 Redis 只用作缓存，可以不使用 Redis 持久化。

RDB 和 AOF 使用建议：

- 将 RDB 方式用作后备用途，只在 slave 上持久化 RDB 文件，并且只保留 `save 900 1` 这条规则。
- 同时启用 AOF 或使用主从复制：   
  - 启用 AOF ：在最坏情况下也只会丢失不超过 1 秒的数据，恢复时也只需要直接加载 AOF 文件。代价一是带来了持续的 I/O，二是 AOF 文件重写时造成的阻塞几乎是不可避免的，所以只要硬盘许可，应该尽量减少重写频率，生产中可以将 AOF 重写的基础大小设置到 ***5G*** 以上，日志增长比例阈值也可以做相应修改
  - 使用主从复制而不启用 AOF：此方式能够省掉一大笔 I/O 消耗，同时减少了 AOF 文件重写时带来的系统波动。代价是如果 Master/Slave 同时倒掉，会丢失十几分钟的数据，恢复数据时需要比较 Master/Slave 中的 RDB 文件，载入较新的那个（微博采用的是此方式）。



## Redis 发布订阅

Redis 发布订阅（pub/sub）是一种消息通信模式：发布者（pub）发送消息，订阅者（sub）接收消息，每一个 Redis 客户端可以订阅任意数量的频道。订阅者订阅一个或多个频道，发布者发送消息到频道，每个该频道的订阅者都会接收到该消息。



发布/订阅相关命令：

- ***SUBCRIBE channel [channel...]***：订阅一个或多个给定的频道。
- ***UNSUBCRIBE channel [channel...]***：退订一个或多个给定的频道。
- ***PUBLISH channel message***：发布消息到频道。
- ***PSUBSCRIBE pattern [pattern ...]***：订阅一个或多个符合给定模式（正则匹配）的频道。
- ***PUNSUBSCRIBE pattern [pattern ...]***：退订一个或多个符合给定模式（正则匹配）的频道。
- ***PUBSUB \<subcommand\> [argument [argument...]]***：发布订阅系统相关命令。
  - *PUBSUB channels*：查看系统所有的活跃频道。

> 在 shell 的 redis-cli 命令行下，订阅频道后将会一直阻塞在订阅界面等待接收频道发送的消息，所以无法执行退订命令，但是在 Java 代码中可以异步的接收频道消息，同时可以使用退订功能。



测试使用：

- 客户端订阅频道：

  ~~~shell
  [root@localhost ~]# redis-cli --raw
  127.0.0.1:6379> SUBSCRIBE china.news.sport china.news.entertainment
  subscribe
  china.news.sport
  1
  subscribe
  china.news.entertainment
  2
  
  ~~~

  订阅频道后，客户端将会阻塞在此界面等待接收频道消息。

- 发布消息到频道：

  ~~~shell
  [root@localhost ~]# redis-cli --raw
  127.0.0.1:6379> PUBLISH china.news.entertainment "迪丽热巴摩登写真曝光，复古冷艳风美得让人沉醉"
  1
  127.0.0.1:6379> PUBLISH china.news.sport "詹姆斯罕见发怒！夹胳膊爆头！前队友输球输人！"
  1
  ~~~

- 订阅者接收到消息：

  ~~~shell
  [root@localhost ~]# redis-cli --raw
  127.0.0.1:6379> SUBSCRIBE china.news.sport china.news.entertainment
  subscribe
  china.news.sport
  1
  subscribe
  china.news.entertainment
  2
  message
  china.news.entertainment
  迪丽热巴摩登写真曝光，复古冷艳风美得让人沉醉
  message
  china.news.sport
  詹姆斯罕见发怒！夹胳膊爆头！前队友输球输人！
  ~~~

- 查看发布/订阅系统所有的活跃频道：

  ~~~shell
  127.0.0.1:6379> pubsub channels
  china.news.entertainment
  china.news.sport
  ~~~

   

## Jedis 的使用

Jedis 是 Redis 官方推荐的 Java 连接开发工具，使用 Java 来操作 Redis，Redis 所有命令都可以通过 Jedis 执行。

导入依赖：

~~~xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.1.0</version>
</dependency>
~~~

注意：使用非本机的其他客户端连接 Redis 时，需要先进行检查：

1. Redis 服务端机器的防火墙是否开放了 6379 端口。
2. redis.conf 配置文件中的 `bind 127.0.0.1` 是否注释掉或者修改为 `bind 0.0.0.0`（允许所有主机连接到 Redis）
3. *protected-mode* 修改为 no，即非保护模式运行，允许非本机的客户端连接 Redis。

Jedis 连接测试：

~~~java
public class PingDemo {
    public static void main(String[] args) {
        //连接 Redis
        Jedis jedis = new Jedis("192.168.253.128",6379);
        String response = jedis.ping();
        System.out.println(response);
        jedis.close();
    }
}
~~~

Jedis 实现事务实例：

~~~java
public class TransactionDemo {
    public static void main(String[] args) {
        Jedis jedis = new Jedis("192.168.253.128",6379);
        jedis.set("money","100");
        jedis.set("debt","20");
        jedis.watch("money","debt");
        int balance = Integer.parseInt(jedis.get("money"));
        int debt = Integer.parseInt(jedis.get("debt"));
        try {
            if (balance < debt){
                jedis.unwatch();
                System.out.println("余额不足!");
            }else {
                Thread.sleep(15000L);
                Transaction multi = jedis.multi();
                multi.decrBy("money",debt);
                multi.decrBy("debt",debt);
                List<Object> exec = multi.exec();
                if (exec == null){
                    int newBalance = Integer.parseInt(jedis.get("money"));
                    int newDebt = Integer.parseInt(jedis.get("money"));
                    System.out.println("执行失败，余额或欠款已发生变化，余额为：" + newBalance + "欠款为" + newDebt);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            jedis.close();
        }
    }
}
~~~

在实际开发中，为配合多线程一般我们使用 ***JedisPool***：

~~~java
JedisPool jedisPool = new JedisPool("192.168.253.128", 6379);
Jedis jedis = jedisPool.getResource();
jedis.set("demo","demo");
//归还连接至连接池
jedis.close();
~~~

*JedisPool* 的默认配置：

~~~java
public class JedisPoolConfig extends GenericObjectPoolConfig {
    public JedisPoolConfig() {
        this.setTestWhileIdle(true);
        this.setMinEvictableIdleTimeMillis(60000L);
        this.setTimeBetweenEvictionRunsMillis(30000L);
        this.setNumTestsPerEvictionRun(-1);
    }
}
~~~

我们也可以 `new JedisPoolConfig();` 自定义配置设置到 *JedisPool* 中，在开发中，我们需要使用单例模式保证 *JedisPool* 只会产生一个。



## SpringBoot 整合 Redis

新建 *SpringBoot* 项目，选择 

- ***Spring Boot DevTools***：支持 SpringBoot 项目热部署。
- ***Lombok***：通过注解方式生成 Java 实体类结构。
- ***Spring Configuration Processor***：Spring 默认使用 yml 配置，此注解是项目支持传统的 xml 或 properties 配置（与配置文件相关的几个注解依赖）。
- ***Spring Web***：标记项目为 web 项目并加入 mvc 依赖。
- ***Spring Data Redis（Access + Driver）***：加入 Redis 相关依赖。

这 5 个模块。



> 在 ***SpringBoot 2.x*** 之后，连接 Redis 服务器不再使用 Jedis 框架，而是采用了 ***Lettuce*** 框架！
>
> *Jedis*：采用的是直连，使用 Jedis Pool 用来支撑高并发情况下的连接请求，类似于 BIO 的模式。
>
> *Lettuce*：使用 netty 连接 Redis 服务，连接实例可以在多个线程当中进行共享，性能极高，类似于 NIO 的模式。



编写配置文件 ***application.properties***：

~~~properties
#应用程序端口
server.port=8080
#配置 Redis
spring.redis.host=192.168.253.128
spring.redis.port=6379
#热部署生效
spring.devtools.restart.enabled=true
#设置重启的目录
spring.devtools.restart.additional-paths=src/main/java
~~~



> 在 IDEA 中修改项目后，按下 ***Ctrl + F9*** 可以使项目重新编译，触发 SpringBoot 热部署自动重启。



SpringBoot 的 Redis 自动配置类 ***RedisAutoConfiguration***：

~~~java
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass(RedisOperations.class)
@EnableConfigurationProperties(RedisProperties.class)
@Import({ LettuceConnectionConfiguration.class, JedisConnectionConfiguration.class })
public class RedisAutoConfiguration {
	@Bean
	@ConditionalOnMissingBean(name = "redisTemplate")
	public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory)
			throws UnknownHostException {
		RedisTemplate<Object, Object> template = new RedisTemplate<>();
		template.setConnectionFactory(redisConnectionFactory);
		return template;
	}
	@Bean
	@ConditionalOnMissingBean
	public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory)
			throws UnknownHostException {
		StringRedisTemplate template = new StringRedisTemplate();
		template.setConnectionFactory(redisConnectionFactory);
		return template;
	}
}
~~~

SpringBoot 为我们提供了 2 个用来操作 Redis 的模板类：

- ***redisTemplate***：可以用来操作 Redis 的所有命令，默认没有过多配置（对象序列化等），我们可以自定义 *redisTemplate* 覆盖掉 SpringBoot 提供的模板类。

  使用方法：

  - *redisTemplate.opsForXxx()*：操作 xxx 类型的数据，如：`opsForValue` 操作字符串，`opsForHash` 操作 hash 类型数据。
  - *redisTemplate.getConnectionFactory().getConnection()*：获取 Redis 连接对象，直接使用连接执行命令。
  - *redisTemplate.execute()*：直接传入 Redis 命令通过 Redis 连接对象执行。
  - *redisTemplate.xxx()*：直接执行一些常用的命令，如事务相关操作 *watch*，*multi*，*exec*，*discard* 等，元素操作 *type*，*delete*，*move*，*expire* 等。

- ***stringRedisTemplate***：由于String 类型最常使用，所以提供了此模板专门用来操作 Redis 字符串。

测试 *redisTemplate*：

~~~java
@SpringBootTest
class RedisBootApplicationTests {
	@Autowired
	private RedisTemplate<String,String> redisTemplate;
	@Test
	void contextLoads() {
		redisTemplate.opsForValue().set("myName","地球人");
		System.out.println(redisTemplate.opsForValue().get("myName"));
	}
}
~~~

在 SpringBoot 默认的 RedisTemplate 中，默认使用 ***JdkSerializationRedisSerializer*** 进行序列化：

```java
if (defaultSerializer == null) {
    defaultSerializer = new JdkSerializationRedisSerializer(
        classLoader != null ? classLoader : this.getClass().getClassLoader());
}
```

在不进行特殊配置时，直接在 Redis 客户端查看 *Lettuce* 储存的对象类型的键值时会出现乱码，我们可以自定义 *RedisTemplate* 使用 *json* 来实现序列化。

自定义 ***RedisTemplate***：

~~~java
@Configuration
public class RedisConfiguration {
    @Bean
    public RedisTemplate<String,Object> redisTemplate(RedisConnectionFactory factory){
        //在开发中，一般使用字符串作为键
        RedisTemplate<String,Object> template = new RedisTemplate<>();
        //字符串序列化器
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);
        //Redis对象序列化器
        Jackson2JsonRedisSerializer<Object> jsonSerializer = new Jackson2JsonRedisSerializer<>(Object.class);
        template.setValueSerializer(jsonSerializer);
        template.setHashValueSerializer(jsonSerializer);
        template.setConnectionFactory(factory);
        //应用设置
        template.afterPropertiesSet();
        return template;
    }
}
~~~

SpringBoot 内置了几种序列化器，直接将适合的序列化器设置到 *redisTemplate* 即可。



> 使用 Java 设值中文内容时，如果直接使用客户端查询会出现中文乱码，此时可以加启动参数以查看正常的中文显示：
>
> ~~~shell
> [root@localhost ~]# redis-cli --raw
> 27.0.0.1:6379> get myName
> "地球人啊"
> ~~~



设置 SpringBoot 项目启动检查 Redis 连接：

~~~java
@Slf4j
@Component
public class RedisCheck implements ApplicationListener<ApplicationStartedEvent> {
    @Autowired
    private RedisTemplate redisTemplate;
    @Value("${spring.redis.host}")
    private String redisHost;
    @Value("${spring.redis.port}")
    private int port;
    @Override
    public void onApplicationEvent(ApplicationStartedEvent applicationStartedEvent) {
        //测试Redis连接，连接不成功时，此方法抛出异常，容器中止启动
        String result = (String) redisTemplate.execute(RedisConnection::ping);
        log.info(result);
        log.info("Redis连接成功，主机地址："+ redisHost + "，端口号：" + port);
    }
}
~~~



## Redis 实现分布式锁

为了防止分布式系统中的多个进程之间相互干扰，我们需要一种分布式协调技术来对这些进程进行调度，而这个分布式协调技术的核心就是分布式锁。

分布式锁应该具备的条件：

1. 互斥性：在分布式系统环境下，在同一时间只有一个客户端能持有锁。
2. 高可用：只要大部分的 Redis 节点正常运行，客户端就可以加锁和解锁。
3. 防死锁：即使有一个客户端在持有锁的期间崩溃而没有主动解锁，也能保证后续其他客户端能加锁。
4. 非阻塞：没有获取到锁时将直接返回获取锁失败。
5. 解锁必须是解除自己加上的锁。

实现简单的分布式锁：

- 定义 Redis 锁：

  ~~~java
  @Slf4j
  @Component
  public class RedisLock {
      @Autowired
      private RedisTemplate<String,Object> redisTemplate;
  
      public boolean tryLock(String key, String value, int seconds){
          //如果能够设值成功，则获取锁成功，否则直接返回 false
          return Optional.ofNullable(redisTemplate.opsForValue()
          	.setIfAbsent(key, value, seconds, TimeUnit.SECONDS)).orElse(false);
      }
  
      public void unLock(String key,String value){
          try {
              String str = (String) redisTemplate.opsForValue().get(key);
              //如果存在值且值为加锁时候的值，才进行解锁
              if (!StringUtils.isEmpty(str) && str.equals(value)){
                  redisTemplate.delete(key);
              }
          }catch (Exception e){
              log.error("Redis分布式锁解锁异常：{}",e.getMessage());
          }
      }
  }
  ~~~

- 业务代码：

  ~~~java
  @Service
  public class DemoService {
      private static final String LOCK_ID = "LOCK_01";
      @Autowired
      private RedisLock redisLock;
      public boolean spike(){
          //生成UUID，保证后续解锁时只解锁自己的锁
          String uuid = UUID.randomUUID().toString();
          try {
              boolean result = redisLock.tryLock(LOCK_ID, uuid, 5);
              if (result){
                  //拿到锁后，模拟中间处理过程
                  Thread.sleep(3000L);
                  return true;
              }else {
                  return false;
              }
          }catch (Exception e){
              e.printStackTrace();
          }finally {
              //总是进行解锁操作
              redisLock.unLock(LOCK_ID,uuid);
          }
          return false;
      }
  }
  ~~~

  多个不同客户端上的线程同时调用 spike 方法时，能够保证同一时间只有一个客户端持有锁。



在 SpringBoot 中，推荐我们使用 ***Redisson*** 分布式锁！

引入依赖：

~~~xml
<dependency>
    <groupId>org.redisson</groupId>
    <artifactId>redisson-spring-boot-starter</artifactId>
</dependency>
~~~

*Redisson* 适应集群模式或单机模式，效率高，更安全，可以实现分布式锁更多的相关功能（可重入锁、自动延期等）。