安装 Redis：[CentOS 8 下安装 Redis](../../软件安装手册/中间件安装/CentOS8下安装Redis.md)

Redis 官网：https://redis.io/

Redis 文档：http://www.redis.cn/，https://www.redis.net.cn/

 

**目录**

1. [NoSQL 与 Redis](#1nosql与redis)
2. [Redis 基础知识与命令](#2redis基础知识与命令)
3. [Redis 五大数据类型](#3redis五大数据类型)
4. [Redis 特殊数据类型](#4redis特殊数据类型)
5. [Redis 事务及 WATCH 锁](#5redis事务及watch锁)
6. [使用 Jedis 操作 Redis](#6使用jedis操作redis)
7. [SpringBoot 整合 Redis](#7springboot整合redis)

 

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
~~~

 

---

#### 3.Redis五大数据类型

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

#### 4.Redis特殊数据类型

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

#### 5.Redis事务及WATCH锁

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

#### 6.使用Jedis操作Redis

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

我们也可以 `new JedisPoolConfig();` 自定义配置设置到 *JedisPool* 中。



---

#### 7.SpringBoot整合Redis

新建 *SpringBoot* 项目，选择 

- ***Spring Boot DevTools***：支持 SpringBoot 项目热部署。
- ***Lombok***：通过注解方式生成 Java 实体类。
- ***Spring Configuration Processor***：Spring 默认使用 yml 配置，此注解是项目支持传统的 xml 或 properties 配置（与配置文件相关的几个注解依赖）。
- ***Spring Web***：标记项目为 web 项目并加入 mvc 依赖。
- ***Spring Data Redis（Access + Driver）***：加入 Redis 相关依赖。

这 5 个模块。



> 在 ***SpringBoot 2.x*** 之后，连接 Redis 服务器不在使用 Jedis 框架，而是采用了 ***Lettuce*** 框架！
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

#### 使用Redis实现分布式锁