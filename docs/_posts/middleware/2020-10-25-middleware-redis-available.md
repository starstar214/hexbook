---
title: "Redis 高可用"
subtitle: "「Redis」哨兵与集群"
layout: post
author: "Hex"
date:  2020-10-25 18:00:00
header-img: "img/post-bg-universe.jpg"
catalog:    true
tags:
  - Redis
  - 中间件
  - NoSQL
---



Redis 高可用常见的两种方式：

- 主从复制（Replication-Sentinel 模式）
- Redis集群（Redis-Cluster 模式）



## Redis 主从复制

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



## Redis 哨兵模式

主从切换技术：当主服务器宕机后，需要手动把一台从服务器切换为主服务器，这就需要人工干预，费事费力，还会造成一段时间内服务不可用。Redis 从 2.8 开始正式提供了 ***sentinel***（哨兵） 模式来解决这个问题，***sentinel*** 能够后台监控主机是否故障，如果故障了根据投票数自动将从库转换为主库。

哨兵模式（ ***sentinel*** ）：哨兵模式是一种特殊的模式，它是一个独立运行的进程，通过发送命令，等待 Redis 服务器响应，从而监控运行的多个 Redis 实例，同时 Redis 也提供了哨兵相关的命令。

Redis 哨兵的作用：

1. 通过发送命令，让 Redis 服务器返回其运行状态，包括主服务器和从服务器。
2. 当哨兵监测到 master 宕机，会自动将 slave 切换成 master，然后通知其他的从服务器，让它们切换主机。

然而一个哨兵进程对 Redis 服务器进行监控，也有可能会出现问题，因此，我们可以使用多个哨兵进行监控，各个哨兵之间还会相互进行监控，这样就形成了多哨兵模式。

哨兵集群的工作原理：

1. 假设主服务器宕机，哨兵1先检测到这个结果，系统并不会马上进行 ***failover***（故障转移） 过程，仅仅是哨兵1主观的认为主服务器不可用，这个现象称为主观下线。
2. 当后面的哨兵也检测到主服务器不可用，并且数量达到一定值时，主服务器会被标记为客观下线，然后进行故障转移工作。



***redis-sentinel.conf*** 配置文件：

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



## Redis 集群模式

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

- 配置 ***RedisTemplate*** 后便可以正常使用。