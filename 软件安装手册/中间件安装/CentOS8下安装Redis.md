#### DNF安装Redis

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
   [root@localhost ~]# redis-server              启动Redis，非后台启动，退出命令行后服务停止
   [root@localhost ~]# redis-server &            后台启动启动Redis
   [root@localhost redis]# redis-cli             进入Redis客户端
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

   

