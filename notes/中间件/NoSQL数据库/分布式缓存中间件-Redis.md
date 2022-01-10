安装 Redis：[CentOS 8 下安装 Redis](../../软件安装手册/中间件安装/CentOS8下安装Redis.md)

Redis 官网：https://redis.io/

Redis 文档：http://www.redis.cn/，https://www.redis.net.cn/

 

**目录**

1. [NoSQL 与 Redis](#1nosql与redis)
2. [Redis 安装](#2redis安装)
3. [Redis 基础知识与命令](#3redis基础知识与命令)
4. [Redis 五大数据类型](#4redis五大数据类型)
5. [Redis 特殊数据类型](#5redis特殊数据类型)
6. [Redis 事务及 WATCH 锁](#6redis事务及watch锁)
7. [使用 Jedis 操作 Redis](#7使用jedis操作redis)
8. [SpringBoot 整合 Redis](#8springboot整合redis)
9. [使用 Redis 实现分布式锁](#9使用redis实现分布式锁)
10. [Redis 配置文件](#10redis配置文件)
11. [持久化之 RDB 与 AOF](#11持久化之rdb与aof)
12. [Redis 发布订阅](#12redis发布订阅)
13. [Redis 主从与哨兵](#13redis主从与哨兵)
14. [Redis 集群模式](#14redis集群模式)

 

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

#### 2.Redis安装

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



---

#### 3.Redis基础知识与命令

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



---

#### 4.Redis五大数据类型

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
   
   

---

#### 5.Redis特殊数据类型

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

 

---

#### 6.Redis事务及WATCH锁

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



---

#### 7.使用Jedis操作Redis

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



---

#### 8.SpringBoot整合Redis

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



---

#### 9.使用Redis实现分布式锁

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
  
  > 注：此种方式实现的简单分布式锁还存在相当一部分的问题如机器断电、网络传输过慢引起的 BUG 不能避免。



---

#### 10.Redisson分布式锁框架

在实际应用中，我们应该使用 ***Redisson*** 分布式锁！

引入依赖：

~~~xml
<dependency>
    <groupId>org.redisson</groupId>
    <artifactId>redisson</artifactId>
    <version>3.16.7</version>
</dependency>
~~~

*Redisson* 适应集群模式或单机模式，效率高，更安全，可以实现分布式锁更多的相关功能（可重入锁、自动延期等）。

Redisson 文档地址：https://github.com/redisson/redisson/wiki/%E7%9B%AE%E5%BD%95

使用代码配置 Redisson：

~~~java
@Configuration
public class MyRedissonConfiguration {
    @Bean(destroyMethod="shutdown")
    public RedissonClient redisson() {
        Config config = new Config();
        config.useSingleServer().setAddress("redis://192.168.253.136:6379");
        return Redisson.create(config);
    }
}
~~~

使用示例：

~~~java
private ProductCategoryEntity getRootTree() {
    RLock myLock = redisson.getLock("MY_LOCK");
    myLock.lock();
    try {
        // 执行业务代码
    }finally {
        myLock.unlock();
    }
    return root;
}
~~~

Redisson 内部提供了一个监控锁的看门狗，它的作用是在 Redisson 实例被关闭前，不断的延长锁的有效期。如果在执行业务代码的过程中程序闪断，未执行解锁代码，看门狗也不会给锁进行续期，在过一段时间后，锁自动失效，也不会造成程序死锁（默认 30 秒，可配置）。

此外，也可以加指定失效时间的锁，如果指定了失效时间，将不会有自动续期。

读写锁：允许同时有多个读锁和一个写锁处于加锁状态。

1. 读 + 读：相当于无锁状态。
2. 读 + 写：写操作等待读操作完成后进行。
3. 写 + 写：后者写操作等待前者写操作完成后进行。
4. 写 + 读：后者读操作等待前者写操作完成后进行。



除此之外，Redisson 还提供了公平锁、联锁、红锁、闭锁（CountDownLatch）、信号量（Semaphore）的实现。

> 信号量（Semaphore）可以实现分布式系统的限流工作。

---

#### 11.Redis配置文件

默认安装的 Redis 的配置文件位于 ***/etc/redis.conf*** ：[Example](../data/redis.conf)。

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

- ***SNAPSHOTTING***：RDB 快照参数设置，详情见第 10 章节：[持久化之 RDB 与 AOF](#10持久化之rdb与aof)。

- ***REPLICATION***：主从复制相关配置，详情见第 12 章节：[Redis 主从与哨兵](#12redis主从与哨兵)

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

- ***APPEND ONLY MODE***：AOF相关配置，详情见第 10 章节：[持久化之 RDB 与 AOF](#10持久化之rdb与aof)。

- ***LUA SCRIPTING***：Lua 脚本的相关配置，允许 Lua 脚本执行的的最大好毫秒数

    ~~~bash
    lua-time-limit 5000
    ~~~

    设置为 0 或负值时，Lua 脚本可以无警告的无限执行。

- ***REDIS CLUSTER***：Redis 集群配置，详情见第 13 章节：[Redis 集群模式](#13redis集群模式)

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



---

#### 12.持久化之RDB与AOF

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



---

#### 13.Redis发布订阅

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

   

---

#### 14.Redis主从与哨兵

Redis 主从复制：将一台 Redis 服务器的数据，复制到其他的 Redis 服务器。前者称为主节点-master，后者称为从节点-slave，数据的复制是单向的，只能由主节点到从节点，master 以写为主，slave 以读为主。

> 在生产中，80% 的情况下都是在进行读操作，主从复制，读写分离将读操作分散在从节点，主节点用来执行写操作，能够有效地减缓服务器的压力。

Redis 主从复制的主要作用：

- 数据冗余：主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。
- 故障恢复：当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复。
- 负载均衡：在主从复制的基础上，配合读写分离，由主节点提供写服务，从节点提供读服务，分担了服务器负载，大大的提高了 Redis 服务器的并发量。
- 高可用：除了上述作用以外，主从复制是 Redis 哨兵和集群的基础，因此可以说主从复制是 Redis 高可用性的基础。

> 注意：在 Redis 中，一个主节点可以有多个从节点，但是一个从节点只能有一个主节点。



Redis 主从集群搭建：Redis 集群至少需要 3 个节点（哨兵模式要求从机不唯一），在搭建环境时只需要配置从库，主库无需做任何更改。

查看 Redis 服务主从信息命令：`info replication`

~~~shell
127.0.0.1:6379> info replication
# Replication
role:master                                                  #当前服务的主从角色
connected_slaves:0                                           #连接的从机个数
master_replid:a043b79f0182f9bc8ae15f73918a467115012f16
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0
~~~

- 复制 *redis.conf* 并做相应修改：复制两份配置文件，修改为 8380 和 6381 端口。

  ~~~bash
  #修改服务启动端口
  port 6380
  #修改服务启动的 pid 文件
  pidfile /root/temp/redis/run/redis_6380.pid
  #修改日志文件位置
  logfile /root/temp/redis/log/redis_6380.log
  #修改 RDB 文件存储位置及名称
  dbfilename dump_6380.rdb
  dir /root/temp/redis/lib/
  #修改 AOF 文件存储名称
  appendfilename "appendonly_6380.aof"
  ~~~

  另一个配置文件修改为 6381 端口后，通过不同的配置文件启动 3 个 Redis 服务。

  ~~~shell
  [root@localhost config]# ps -ef|grep redis
  root       2895      1  0 00:15 ?        00:00:00 redis-server 0.0.0.0:6379
  root       3658      1  0 00:15 ?        00:00:00 redis-server 0.0.0.0:6380
  root       3663      1  1 00:15 ?        00:00:00 redis-server 0.0.0.0:6381
  root       3668   2065  0 00:15 pts/0    00:00:00 grep --color=auto redis
  ~~~

- 登入 6380 和 6381 客户端，执行 ***slaveof*** 命令：

  ~~~shell
  127.0.0.1:6380> SLAVEOF 127.0.0.1 6379
  OK
  ~~~

  ~~~shell
  127.0.0.1:6381> SLAVEOF 127.0.0.1 6379
  OK
  ~~~

  此时主机的信息如下：

  ~~~shell
  127.0.0.1:6379> info replication
  # Replication
  role:master
  connected_slaves:2
  slave0:ip=127.0.0.1,port=6380,state=online,offset=42,lag=1
  slave1:ip=127.0.0.1,port=6381,state=online,offset=42,lag=1
  master_replid:180ed9378bdcfc3cccaef497c8eca72c62ab260e
  master_replid2:0000000000000000000000000000000000000000
  master_repl_offset:42
  second_repl_offset:-1
  repl_backlog_active:1
  repl_backlog_size:1048576
  repl_backlog_first_byte_offset:1
  repl_backlog_histlen:42
  ~~~

  6380 从机的信息如下：

  ~~~shell
  # Replication
  role:slave
  master_host:127.0.0.1
  master_port:6379
  master_link_status:up
  master_last_io_seconds_ago:2
  master_sync_in_progress:0
  slave_repl_offset:252
  slave_priority:100
  slave_read_only:1
  connected_slaves:0
  master_replid:180ed9378bdcfc3cccaef497c8eca72c62ab260e
  master_replid2:0000000000000000000000000000000000000000
  master_repl_offset:252
  second_repl_offset:-1
  repl_backlog_active:1
  repl_backlog_size:1048576
  repl_backlog_first_byte_offset:1
  repl_backlog_histlen:252
  ~~~

  至此，一个基础的 Redis "一主二从" 集群架构搭建完成。

> 除 "一主二从" 模式，Redis 还可以使用 "层层链路" 模式进行集群，即 6379 作为主机，6380 和 6381 作为从机，6380 仍然从 6379 复制数据，但 6381 从 6380 复制数据（此时 6380 仍然是从节点）。



Redis 主从搭建注意要点：

- 通过命令行可以使从机跟随主机，但是此种方式是暂时的，服务重启后关系消失，如果需要永久生效，需要在配置文件中配置主从信息：

  ~~~bash
  relicaof 127.0.0.1 6379
  masterauth 950920          #如果主机需要密码，则从机需要配置此项
  ~~~

- 默认状态下，从机是只读状态：

  ~~~shell
  127.0.0.1:6381> set k v
  (error) READONLY You can't write against a read only replica.
  ~~~

  可以修改配置文件使从机可写。

  ~~~bash
  replica-read-only no
  ~~~

  注意：写入从机的键值信息不会同步到其他机器。

- 当主机挂掉时，从机依旧连接到主机，但是没有写操作，如果主机回来了，从机依旧可以获取到主机上写的信息。
- 当从机挂掉时，只要重新将从机连接到主机，就会从新获取主机上的全部数据集。
- 使用 `slaveof no one` 命令可以使从服务器关闭复制功能，原来复制所得的数据集不会丢失。

> 如果主机断开了连接，我们需要使用 `slaveof no one` 让自己变成主机，其他的节点连接到最新主节点（手动），使 Redis 正常的对外提供服务。使用哨兵模式可以自动完成此过程。



主从切换技术：当主服务器宕机后，需要手动把一台从服务器切换为主服务器，这就需要人工干预，费事费力，还会造成一段时间内服务不可用。Redis 从 2.8 开始正式提供了 ***sentinel***（哨兵） 模式来解决这个问题，***sentinel*** 能够后台监控主机是否故障，如果故障了根据投票数自动将从库转换为主库。

哨兵模式（ ***sentinel*** ）：哨兵模式是一种特殊的模式，它是一个独立运行的进程，通过发送命令，等待 Redis 服务器响应，从而监控运行的多个 Redis 实例，同时 Redis 也提供了哨兵相关的命令。

Redis 哨兵的作用：

1. 通过发送命令，让 Redis 服务器返回其运行状态，包括主服务器和从服务器。
2. 当哨兵监测到 master 宕机，会自动将 slave 切换成 master，然后通知其他的从服务器，让它们切换主机。

然而一个哨兵进程对 Redis 服务器进行监控，也有可能会出现问题，因此，我们可以使用多个哨兵进行监控，各个哨兵之间还会相互进行监控，这样就形成了多哨兵模式。

哨兵集群的工作原理：

1. 假设主服务器宕机，哨兵1先检测到这个结果，系统并不会马上进行 ***failover***（故障转移） 过程，仅仅是哨兵1主观的认为主服务器不可用，这个现象称为主观下线。
2. 当后面的哨兵也检测到主服务器不可用，并且数量达到一定值时，主服务器会被标记为客观下线，然后进行故障转移工作。



***redis-sentinel.conf*** 配置文件：[Example](../data/redis-sentinel.conf)

- 网络配置：默认情况下，sentinel 无法通过不同于 localhost 的网络接口进行访问，当 sentinel 与 Redis 集群不在同一台机器上时，sentinel 与 Redis 集群将会出现通信问题，此时需要手动配置一下两个选项之一：

  ~~~bash
  bind 127.0.0.1 192.168.1.1 192.168.1.2       #将 Redis 集群的地址绑定到 sentinel 上
  protected-mode no                            #解除 sentinel 的保护模式
  ~~~

- *sentinel* 基本配置：

  ~~~bash
  # 此哨兵实例的运行端口
  port 26379
  # 是否以守护进程的方式运行，以守护进程方式运行时 Redis 会创建一个 pid 文件(选择 yes 以允许 sentinel 后台运行)
  daemonize yes 
  # 以守护进程运行时创建的 pid 文件位置
  pidfile "/var/run/redis-sentinel.pid"
  # sentinel 运行的日志文件位置
  logfile "/var/log/redis/sentinel.log"
  # sentinel 的工作目录，将工作目录设置为 /tmp 将不会干扰系统的其他工作
  dir "/tmp"
  ~~~

- *sentinel* 监听配置：

  - 配置监听：`sentinel monitor <master-name> <ip> <redis-port> <quorum>`

    ~~~bash
    sentinel monitor mymaster 127.0.0.1 6379 2
    ~~~

    *mymaster*：为主机取一个别名，后续的配置可以使用此别名。

    *quorum*：配置一个数量，当达到该数量的哨兵认为主机 "主观下线" 时，才标记主机为 "客观下线"。

    > 在故障转移时，必须在哨兵之间选出一个 leader 执行故障转移操作，此 leader 必须获得大多数 sentinel 的投票，因此在少数情况下无法执行故障转移。
    >
    > 例如：当哨兵集群的数量为 2 时，此时主机和其中一个 sentinel 挂掉，则此 sentinel 获取不到足够数量的投票，无法执行故障转移。
    >
    > [5 的大多数 = 3，4 的大多数 = 3，3 的大多数 = 2，2 的大多数 = 2；所以当挂掉一个 sentinel 后剩下的 sentinel 无法获得大多数哨兵的投票]

    注意：从库能够被自动发现，sentinel 无需配置从库信息，而在进行故障转移后，sentinel 会自动修改配置文件内容。

  - 主机密码配置：`sentinel auth-pass <master-name> <password>`

    ~~~bash
    sentinel auth-pass mymaster 950920
    ~~~

    注意：如果要使用密码和哨兵集群，主机和从机的密码需设置成一致的，也可以部分设置密码，部分不设置密码，但是设置密码的那部分必须保持一致。

  - 主观下线参数：`sentinel down-after-milliseconds <master-name> <milliseconds>`

    ~~~bash
    sentinel down-after-milliseconds mymaster 30000
    ~~~

    当主机在 30000 毫秒内都没有对 sentinel 作出响应（或者 sentinel 在 30000 毫秒内都无法 ping 通主机），该 sentinel 标记主机为主观下线。

    此配置项缺省配置为 30 秒。

- *sentinel* 故障转移配置：

  - 故障转移中的主从复制参数：`sentinel parallel-syncs <master-name> <numreplicas>`

    ~~~bash
    sentinel parallel-syncs mymaster 1
    ~~~

    在故障转移中，最多可以有多少个 slave 同时对新的 master 进行同步，进行同步的 slave 因为主从复制将无法提供查询服务。此值设置的越小，故障转移所花费的时间越长；此值设置的越大，故障转移期间能够提供查询服务的从机数量越少。

  - 故障转移超时时间：`sentinel failover-timeout <master-name> <milliseconds>`

    ~~~bash
    sentinel failover-timeout mymaster 180000
    ~~~

    此配置项以多种方式使用：

    1. 当第一次故障转移失败后，重新启动故障转移所需要的的时间，即同哨兵同主机两次故障转移的间隔时间。
    2. 如果一个从机根据 sentinel 配置从错误的主机复制数据（此时 sentinel 配置未更新），至少需要此配置的时间，sentinel 才能发现错误并进行纠正，可以理解为 sentinel 隔一段时间才会去检查从机的主机配置。
    3. 取消一个正在进行中的故障转移所需要的时间（至少过去该时间才进行新一轮的故障转移操作）。
    4. 故障转移进行时，在等待所有从库复制新主机数据集时，如果花费时间超过了此配置，主从复制将由 sentinel 重新配置，不再受 `sentinel parallel-syncs` 限制。

    此配置项缺省配置为 3 分钟。

- 脚本执行配置：Redis sentinel 支持通知脚本和重新配置脚本，在发生故障转移时，可以触发通知和重新配置客户端。

  ~~~bash
  sentinel notification-script mymaster /var/redis/notify.sh            #通知脚本
  sentinel client-reconfig-script mymaster /var/redis/reconfig.sh       #重新配置脚本
  #不允许使用 SENTINEL SET 命令更改 notification-script 和 client-reconfig-script 配置
  sentinel deny-scripts-reconfig yes
  ~~~

- 命令重命名：一般来说，Sentinel 在运行过程中会对 Redis 执行相应命令，如：***CONFIG***、***SLAVEOF*** 等，如果 Redis 服务器已经对这些危险命令进行了重命名，则需要在 Sentinel 配置文件中指明。

  ~~~bash
  #指明 Redis 服务器 CONFIG 命令的别名
  SENTINEL rename-command mymaster CONFIG GUESSME
  #此配置项可以在运行过程中进行更改，下面为将 CONFIG 命令恢复原名的方式
  SENTINEL rename-command mymaster CONFIG CONFIG
  ~~~

  

> Redis 集群&哨兵集群工作流程：
>
> 1. 当哨兵与主机建立连接后，sentinel 定时执行以下操作：
>
>    1）每 10s 向主数据库和从数据库发送 INFO 命令获取数据库实例的相关信息。
>
>    2）每 1s 向 master、slave 以及其他哨兵节点发送 PING 命令监测各个服务的运行情况。
>
>    3）每 2s 向 master 和 slave 的 *sentiel:hello* 频道发送自己的信息来宣布自己的存在，该过程也是实现哨兵之间自动发现的基础。
>
>    这三个操作贯穿了哨兵的整个生命周期，是哨兵实现原理的核心。
>
> 2. 当一个哨兵检测到一个实例（master/slave）距离最后一次有效回复 PING 超过 `down-after-milliseconds` 设定的时间后，该哨兵将其标记为主观下线，同时该 sentinel 还会发送命令询问其他 sentinel 节点是否也认为该数据库库主观下线，当达到配置的 *quorum* 数量后，该实例会被标记为客观下线，如果是主机，则进行下一步的故障转移（***failover***）。
>
> 3. 哨兵之间使用 ***Raft*** 算法进行选举，选举出的 leader 进行下一步的故障转移操作。
>
> 4. leader 哨兵从从机中根据规则选出一个并向其发送 `slaveof no one` 命令使其成为新的主机，然后再向其他从库发送 `slaveof` 命令将配置升级到最新的主库。
>
> 5. 当哨兵成功的对 master 进行了 failover 后，它将会把关于 master 的最新配置通过广播形式通知到其它 sentinel。
>
> 6. 如果主机再次恢复，sentinel 检测到原来主机恢复时，会将原来的主机配置为新主机的从机。



哨兵集群搭建：

1. 复制并修改修改 ***redis-sentinel.conf*** 文件：

   ~~~bash
   #端口
   port 26380
   #设置后台运行
   daemonize yes
   #pid 目录
   pidfile "/root/temp/redis/sentinel/run/redis-sentinel-26380.pid"
   #日志目录
   logfile "/root/temp/redis/sentinel/log/sentinel-26380.log"
   #监听主机
   sentinel monitor mymaster 127.0.0.1 6379 2
   ~~~

   将端口分别改为 26379，26380，26381。

2. 使用 `redis-sentinel redis-sentinel-26379.conf` 运行 3 个哨兵实例。

3. 当主机挂掉时，哨兵会进行故障转移，并记录日志信息：

   ~~~verilog
   2652:X 14 Oct 2020 00:14:25.029 # +sdown master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.092 # +odown master mymaster 127.0.0.1 6379 #quorum 3/2
   2652:X 14 Oct 2020 00:14:25.092 # +new-epoch 1
   2652:X 14 Oct 2020 00:14:25.092 # +try-failover master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.092 # +vote-for-leader aa52892a8ae198a1ca73538e0a0cc14850d5a621 1
   2652:X 14 Oct 2020 00:14:25.094 # c87a6b286e1a51d618fc48a4b1c4fbca9a3d202e voted for aa52892a8ae198a1ca73538e0a0cc14850d5a621 1
   2652:X 14 Oct 2020 00:14:25.094 # 590ee2b5dd9b78f79993e1304c1cb64eada8be8e voted for aa52892a8ae198a1ca73538e0a0cc14850d5a621 1
   2652:X 14 Oct 2020 00:14:25.148 # +elected-leader master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.148 # +failover-state-select-slave master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.249 # +selected-slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.249 * +failover-state-send-slaveof-noone slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:25.321 * +failover-state-wait-promotion slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:26.101 # +promoted-slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:26.101 # +failover-state-reconf-slaves master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:26.191 * +slave-reconf-sent slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:27.106 * +slave-reconf-inprog slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:27.106 * +slave-reconf-done slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:27.169 # -odown master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:27.169 # +failover-end master mymaster 127.0.0.1 6379
   2652:X 14 Oct 2020 00:14:27.169 # +switch-master mymaster 127.0.0.1 6379 127.0.0.1 6381
   2652:X 14 Oct 2020 00:14:27.169 * +slave slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6381
   2652:X 14 Oct 2020 00:14:27.169 * +slave slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6381
   2652:X 14 Oct 2020 00:14:57.172 # +sdown slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6381
   
   ~~~

   

***sentinel*** 常用命令：通过 redis-cli 可以与 redis-sentinel 进行通信，通过 `redis-cli -p 26379` 命令进入到交互界面

进入 Redis Sentinel 客户端：

~~~shell
[root@localhost ~]# redis-cli -p 26379
127.0.0.1:26379> 
~~~

SENTINEL 常用命令：

- info [section]：返回该 sentinel [某 section] 的信息，section 可以是 Server，Clients，CPU，Stats，Sentinel。

  ~~~bash
  127.0.0.1:26379> info CPU
  # CPU
  used_cpu_sys:3.790803
  used_cpu_user:1.019102
  used_cpu_sys_children:0.000000
  used_cpu_user_children:0.000000
  ~~~

- 查看主机信息：

  ~~~bash
  127.0.0.1:26379> sentinel masters             #查看 sentinel 监视的所有主机信息
  ......
  127.0.0.1:26379> sentinel master mymaster     #查看 sentinel 监视的指定主机信息
  ......
  ~~~

- 查看指定主机的从机信息：`sentinel slaves mymaster`。

- 查看指定主机的哨兵信息：`sentinel sentinels mymaster`。

- 查看指定主机的 IP 及端口：

  ~~~bash
  127.0.0.1:26379> sentinel get-master-addr-by-name mymaster
  1) "127.0.0.1"
  2) "6381"
  ~~~

- sentinel **reset** \<pattern\>：重置匹配 pattern 的所有主服务器（正则），重置操作将会清除主服务器目前的所有状态，包括正在执行中的故障转移，并移除目前已经发现和关联主服务器的所有从服务器和 sentinel，然后再重新发现这个集群的状态。

- sentinel **failover** \<master name\> ： 强制进行故障转移。

- sentinel **moniotr** \<name\> \<ip\> \<port\> \<quorum\>：以命令行的方式添加监视的主机（相当于配置文件中的那一行）。

- sentinel **remove** \<name\>：不再对名称为 name 的 master 进行监视。

- sentinel **set** \<mastername> [\<option> \<value>]：修改监视的主机的相关配置

  ~~~bash
  127.0.0.1:26379> sentinel set mymaster down-after-milliseconds 60000
  OK
  ~~~



SpringBoot 与 Redis 集成 *application.properties* 配置文件：

- Redis 相关配置：

  ~~~properties
  #集群地址，以逗号分隔
  spring.redis.cluster.nodes=192.168.253.128:6379,192.168.253.128:6380,192.168.253.128:6381
  # Redis 响应超时时间
  spring.redis.timeout=60000
  ~~~

- Lettuce 连接池相关配置：

  ~~~properties
  #连接池中允许的最大空闲连接数，使用负数表示无限制，默认值 8，当最大空闲连接数和最大连接数都未达到上限时，客户端发出请求时 Lettuce 将会创建新连接
  spring.redis.lettuce.pool.max-idle=16
  #连接池中允许的最小空闲连接数，超过此值的连接在驱逐线程运行时将会被回收，默认值 0
  spring.redis.lettuce.pool.min-idle=8
  #连接池最大连接数，使用负数表示无限制，默认值 8 
  spring.redis.lettuce.pool.max-active=32
  #当连接池的连接耗尽时，线程最大等待时间(毫秒单位)，超过此时间后将会抛出错误，默认 -1(不限制)
  spring.redis.lettuce.pool.max-wait=-1
  #每隔一段时间运行驱逐线程，回收连接池中的空闲连接(毫秒单位)，不配置此项默认不进行回收
  spring.redis.lettuce.pool.time-between-eviction-runs=600000
  ~~~
  
  最简单的配置：为设置密码的情况下，仅配置 `spring.redis.cluster.nodes` 这一项即可。
  
- 配置 ***redisTemplate*** 然后使用。





---

#### 15.Redis集群模式

通过主从复制与哨兵模式，能够有效的分担单台 Redis 服务器的负载，并基本实现 Redis 服务器的高可用，但是此种方式多个服务器存储同一份数据，大大的浪费了服务器资源，当服务器内存使用达到上限时，无法进行横向扩展（无法通过新增服务器扩大内存空间），纵向扩展（在线扩容）也会变得及其复杂（需要扩展多台服务器内存容量，并且涉及到主从切换相关操作），单个节点的性能压力问题仍然没有解决。

从 Redis 3.0 开始，官方提供了 ***Cluster*** 集群模式，实现了 Redis 的分布式存储，即每台 Redis 节点上存储不同的内容。

***Cluster*** 集群模式：

Redis 集群是一个提供在多个 Redis 节点间共享数据的程序集，Redis 集群并不支持处理多个 keys 的命令，因为这需要在不同的节点间移动数据，从而达不到像单机 Redis 那样的性能，在高负载的情况下可能会导致不可预料的错误。

Redis 集群通过分区来提供一定程度的可用性，在实际环境中当某个节点宕机或者不可达的情况下继续处理命令。

Redis 集群的优点：

- 无中心化架构，自动分割数据到不同的节点上。
- 可扩展性：可线性扩展到 1000 多个节点，节点可动态添加或删除。
- 高可用性：整个集群的部分节点失败或者不可达的情况下能够继续处理命令。

Redis 集群的缺点：

- 数据通过异步复制，Redis 并不能保证数据的强一致性，这意味这在实际中集群在特定的条件下可能会丢失写操作。
- 不支持 Key 批量操作，并且当多个 Key 分布于不同的节点上时无法使用事务功能。



Redis 集群的数据分片：

Redis 集群引入了哈希槽的概念，集群中共有 ***16384*** 个哈希槽，每个 Key 通过 *CRC16* 校验后对 16384 取模来决定放置哪个槽，集群的每个节点负责一部分哈希槽。

Redis 集群的主从复制模型：

为了使在部分节点失败或者大部分节点无法通信的情况下集群仍然可用，所以集群使用了主从复制模型，每个节点都会有 1 个复制品。

假设集群中有 A、B、C 三个主节点，并且添加 A1、B1、C1 作为主节点的从节点，当 B 节点挂掉后，从节点 B1 转移成主节点，此时的集群仍然可用，当然如果 B 和 B1 同时挂掉，集群不可用。

Redis 集群规范：http://www.redis.cn/topics/cluster-spec.html



Redis 集群搭建：此例中搭建三注三从的最基本集群架构。

1）启动 6 个 Redis 集群服务：

- 创建集群测试的目录：

  ~~~shell
  [root@localhost redis]# mkdir cluster_test
  [root@localhost redis]# cd cluster_test/
  [root@localhost cluster_test]# mkdir 7000 7001 7002 7003 7004 7005
  [root@localhost cluster_test]# 
  ~~~

- 修改配置文件：

  ~~~shell
  port 7000
  pidfile /root/temp/redis/cluster_test/7000/redis_7000.pid
  logfile /root/temp/redis/cluster_test/7000/redis_7000.log
  dir /root/temp/redis/cluster_test/7000/
  #开启集群功能
  cluster-enabled yes
  #指定集群配置文件，此文件不需要人工修改，由集群自动创建
  cluster-config-file nodes-7000.conf
  #如果主机在 15s 内无响应则认为主机已经宕机进行主从切换
  cluster-node-timeout 15000
  ~~~

  > Cluster 其他配置项（默认配置即可）：
  >
  > ~~~shell
  > #主从复制有效因子，用来判断从机的副本数据是否太旧，并决定是否进行故障转移
  > cluster-replica-validity-factor 10
  > #副本迁移屏障：新的主机至少有 1 个副本数据库时才允许故障转移
  > cluster-migration-barrier 1
  > #集群是否必须覆盖所有Hash槽才对外提供服务
  > #设为 no 时，部分节点宕机不影响其他节点对其所覆盖的Hash槽提供服务。
  > #设为 yse 时，只要有一个节点宕机且无法进行故障转移时整个节点都会不可用
  > cluster-require-full-coverage yes
  > #不允许集群故障转移，设置为yes时，可防止副本在主服务器发生故障时尝试对其主服务器进行故障转移。
  > cluster-replica-no-failover no
  > ~~~

- 修改完配置文件后，直接启动 6 个 Redis 服务:

  ~~~shell
  [root@localhost 7000]# ps -ef|grep redis
  root       2355      1  0 00:55 ?        00:00:00 redis-server 0.0.0.0:7000 [cluster]
  root       2366      1  0 00:56 ?        00:00:00 redis-server 0.0.0.0:7001 [cluster]
  root       2375      1  0 00:56 ?        00:00:00 redis-server 0.0.0.0:7002 [cluster]
  root       2384      1  0 00:56 ?        00:00:00 redis-server 0.0.0.0:7003 [cluster]
  root       2393      1  0 00:56 ?        00:00:00 redis-server 0.0.0.0:7004 [cluster]
  root       2402      1  1 00:56 ?        00:00:00 redis-server 0.0.0.0:7005 [cluster]
  root       2407   2206  0 00:56 pts/0    00:00:00 grep --color=auto redis
  ~~~

2）通过工具启动集群：在 Redis 5.x 版本以下，我们需要使用 ***redis-trib.rb*** 脚本操作 Redis 集群，此脚本由  Ruby 语言编写，放在 Redis 源码包中，可以帮我们快速的创建出 Redis 集群。如果没有此脚本也可以到 GitHub 上进行下载然后放至虚拟机目录下进行执行，GitHub 下载地址：https://github.com/beebol/redis-trib.rb；而在 Redis 5.0 版本以上，我们可以直接使用 ***redis-cli*** 创建 Redis 集群。

- 使用 *redis-trib.rb* 创建 Redis 集群：

  1. 安装此脚本运行需要的 Ruby 语言环境：

     ~~~shell
     [root@localhost cluster_test]# dnf install ruby
     ......
     完毕！
     [root@localhost cluster_test]# ruby -v
     ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-linux]
     ~~~

  2. 安装 gem 的 Redis 插件：

     ~~~shell
     [root@localhost cluster_test]# gem install redis
     Fetching: redis-4.2.2.gem (100%)
     Successfully installed redis-4.2.2
     1 gem installed
     ~~~

  3. 使用 ***redis-trib.rb*** 脚本启动集群：

     ~~~shell
     [root@localhost cluster_test]# ./redis-trib.rb create --replicas 1 192.168.253.128:7000 192.168.253.128:7001 192.168.253.128:7002 192.168.253.128:7003 192.168.253.128:7004 192.168.253.128:7005
     >>> Creating cluster
     >>> Performing hash slots allocation on 6 nodes...
     
     ......
     
     Can I set the above configuration? (type 'yes' to accept): yes     #输入yes允许程序修改 node.conf 文件
     >>> Nodes configuration updated
     >>> Assign a different config epoch to each node
     >>> Sending CLUSTER MEET messages to join the cluster
     
     ......
     
     [OK] All 16384 slots covered.
     ~~~

     Redis 集群搭建完毕！

     > 注意：使用 `./redis-trib.rb help` 命令即可查看脚本帮助。

- 使用 *redis-cli* 创建 Redis 集群：

  ~~~shell
  [root@localhost cluster_test]# redis-cli --cluster create 192.168.253.128:7000 192.168.253.128:7001 192.168.253.128:7002 192.168.253.128:7003 192.168.253.128:7004 192.168.253.128:7005 --cluster-replicas 1
  >>> Performing hash slots allocation on 6 nodes...
  Master[0] -> Slots 0 - 5460
  Master[1] -> Slots 5461 - 10922
  Master[2] -> Slots 10923 - 16383
  
  ......
  
  Can I set the above configuration? (type 'yes' to accept): yes  #输入yes允许程序修改 node.conf 文件
  
  ......
  
  [OK] All 16384 slots covered.
  ~~~

  Redis 集群搭建完毕！

3）Redis 集群常用操作：

- 可以通过 `redis-cli` 连接任意一个集群服务器进行交互：

  - cluster info：查看集群信息。
  - cluster nodes：查看集群所有节点。
  - cluster meet \<ip> \<port>：向集群中添加新成员。
  - cluster forget \<node_id> ：从集群中移除成员。

  ~~~shell
  [root@localhost 7000]# redis-cli -p 7000
  127.0.0.1:7000> cluster info
  cluster_state:ok
  cluster_slots_assigned:16384
  cluster_slots_ok:16384
  cluster_slots_pfail:0
  cluster_slots_fail:0
  cluster_known_nodes:6
  
  ......
  ~~~

  哈希槽相关操作：

  - cluster addslots \<slot> [slot ...] ：将一个或多个槽（ slot）指派（ assign）给当前节点。

  - cluster delslots \<slot> [slot ...] ：移除一个或多个槽对当前节点的指派。

  - cluster flushslots ：移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。

  - cluster setslot \<slot> node <node_id> ：将槽 slot 指派给 node_id 指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽，然后再进行指派。

  - cluster setslot \<slot> migrating <node_id> ：将本节点的槽 slot 迁移到 node_id 指定的节点中。

  - cluster setslot \<slot> importing <node_id> ：从 node_id 指定的节点中导入槽 slot 到本节点。

  - cluster setslot \<slot> stable ：取消对槽 slot 的导入（import）或者迁移（migrate）。

> 关闭 Redis 集群时，直接关闭 Redis 服务即可，尽量不要使用 kill -9 直接杀掉进程，而是使用 redis-cli 客户端 shutdown 进程。
>
> 再次启动 Redis 集群时，只需要启动各个 Redis 服务即可，不需要再次执行 `--cluster create` 命令。
>
> 如果需要重新创建集群节点，需要删除 node.conf、dump.rdb 和 appendonly.aof 文件，否则将会出现如下报错：
>
> `[ERR] Node 192.168.253.128:7000 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.`

4）Redis 集群请求重定向：

- 在集群模式下，Redis 在接收到键任何命令时会先计算该键所在的槽，如果该键所在的槽位于当前节点，则直接执行命令，如果该键位于其它节点，则返回重定向信息。比如 key 这个键在槽 866 上，而槽 866 位于 2 节点上，假设在 1 节点上执行 `get key` 信息：

  ~~~shell
  127.0.0.1:7000> get key
  (error) MOVED 12539 127.0.0.1:7002
  ~~~

  此时可以通过命令定位主机：

  ~~~shell
  127.0.0.1:7000> cluster keyslot key                    #查看 key 键所在槽位
  (integer) 12539
  127.0.0.1:7000> cluster nodes                          #查看槽位分布以定位到主机
  3747b8a73cd3be4a1e1765422a5dd74f7817ded7 127.0.0.1:7005@17005 slave 1b170934f6008822d7175df6c64c374b64fb66b9 0 1602926566000 6 connected
  74185e84f82f3e9e47d31cdc06b1728126a56a4f 127.0.0.1:7001@17001 master - 0 1602926566733 2 connected 5461-10922
  1b170934f6008822d7175df6c64c374b64fb66b9 127.0.0.1:7002@17002 master - 0 1602926565000 3 connected 10923-16383
  127d1ac3e6e03ae1bf3d9f5daddbf95082751758 127.0.0.1:7000@17000 myself,master - 0 1602926567000 1 connected 0-5460
  96e49a1187b1ad82a417767a5f2faa03e1488360 127.0.0.1:7003@17003 slave 127d1ac3e6e03ae1bf3d9f5daddbf95082751758 0 1602926567740 4 connected
  584f701fc28fe635b3190abcf7878be75476a213 127.0.0.1:7004@17004 slave 74185e84f82f3e9e47d31cdc06b1728126a56a4f 0 1602926566000 5 connected
  ~~~

  此外，还可以使用 -c 选项使客户端自动重定向：

  ~~~shell
  [root@localhost cluster_test]# redis-cli -c -p 7000
  127.0.0.1:7000> set key value
  -> Redirected to slot [12539] located at 127.0.0.1:7002
  OK
  ~~~

5）SpringBoot 与 Redis 集群整合：  

- ***application.properties*** 配置文件：

  ~~~properties
  #集群地址
  spring.redis.cluster.nodes=192.168.253.128:7000,192.168.253.128:7001,192.168.253.128:7002,192.168.253.128:7003,192.168.253.128:7004,192.168.253.128:7005
  #请求最大重定向次数
  spring.redis.cluster.max-redirects=3
  # lettuce 开启集群信息刷新功能，当故障转移后及时感知，追踪最新的主机信息
  spring.redis.lettuce.cluster.refresh.adaptive=true
  #集群信息刷新间隔时间(毫秒数)
  spring.redis.lettuce.cluster.refresh.period=600000
  ~~~

- 报错解决：`java.net.ConnectException: Connection refused: no further information`

  ~~~verilog
  Unable to connect to [127.0.0.1:7000]: Connection refused: no further information: /127.0.0.1:7000
  Unable to connect to [127.0.0.1:7002]: Connection refused: no further information: /127.0.0.1:7002
  Unable to connect to [127.0.0.1:7005]: Connection refused: no further information: /127.0.0.1:7005
  Unable to connect to [127.0.0.1:7003]: Connection refused: no further information: /127.0.0.1:7003
  Unable to connect to [127.0.0.1:7004]: Connection refused: no further information: /127.0.0.1:7004
  Unable to connect to [127.0.0.1:7001]: Connection refused: no further information: /127.0.0.1:7001
  ~~~

  这是由于在创建 Redis 集群时，使用了 `127.0.0.1` 地址，注意：在创建集群时，只能使用机器的真实 IP 地址，否则 *Lettuce* 无法连接到 Redis 集群。

- 配置好 RedisTemplate 后便可以正常使用。
