:penguin: Linux 系统管理



---

#### 1.系统进程管理

什么是进程？

进程是正在执行的一个程序或命令，每一个进程都是运行的一个实体，都有自己的地址空间，并占用一定的系统资源。

进程管理的作用？

1. 判断服务器健康状况
2. 查看系统所有进程
3. 杀死进程



进程查看命令：

1. 查看系统所有命令：`ps aux/ps -ef`，a:显示前台进程，u:显示用户信息，x:显示后台进程，-e:显示所有进程，f:显示程序间的关系

   ~~~shell
   [root@localhost ~]# ps aux
   USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
   root          1  0.2  0.1 178900 13692 ?        Ss   7月08   0:03 /usr/lib/systemd/systemd --switched-root --system --deserialize 18
   root          2  0.0  0.0      0     0 ?        S    7月08   0:00 [kthreadd]
   root          3  0.0  0.0      0     0 ?        I<   7月08   0:00 [rcu_gp]
   .............................................................................
   root       1386  0.0  0.0  13104  1708 tty1     Ss+  02:47   0:00 /sbin/agetty -o -p -- \u --noclear tty1 linux
   root       2219  0.0  0.0  26756  5032 pts/0    Ss   02:48   0:00 -bash
   root       2244  0.0  0.0  57392  3816 pts/0    R+   02:48   0:00 ps aux
   [root@localhost ~]# ps -ef
   UID         PID   PPID  C STIME TTY          TIME CMD
   root          1      0  0 12:05 ?        00:00:02 /usr/lib/systemd/systemd --switched-root --system --deserialize 17
   root          2      0  0 12:05 ?        00:00:00 [kthreadd]
   root          3      2  0 12:05 ?        00:00:00 [rcu_gp]
   root          4      2  0 12:05 ?        00:00:00 [rcu_par_gp]
   ~~~

   各个参数含义：

   - USER/UID：表示用户是有哪一个用户产生的。
   - PID/PPID：进程 ID/父进程 ID。
   - %CPU：CPU 占用率。
   - %MEM：内存占用率。
   - VSZ/RSS：进程占用虚拟/实际物理内存的大小，单位 KB。
   - TTY：该进程是在哪一个终端当中运行的，tty1-tty7 代表本地控制终端，pts0-pts255 代表远程终端，? 则代表由内核直接产生的进程。
   - STAT：进程状态，常见的状态：R-运行，S-睡眠，T-停止，s-包含子进程，+-位于后台。
   - C：CPU 用于计算执行优先级的因子。
   - START/STIME：进程开始时间
   - TIME：进程占用的 CPU 时间。
   - COMMOND/CMD：运行进程的命令。

2. 查看系统健康状况命令：top [选项]

   - -d：时间，指定 top 命令每隔几秒更新一次
   - P：以 CPU 使用率排序（默认也是）。
   - M：以内存使用率排序。
   - N：以 PID 排序。
   - q：退出 top 命令。
   - ?/h：显示交互模式的帮助。
   
   ~~~shell
   top - 13:21:23 up  1:16,  1 user,  load average: 0.00, 0.00, 0.00
   Tasks: 172 total,   1 running, 171 sleeping,   0 stopped,   0 zombie
   %Cpu(s):  1.6 us,  1.6 sy,  0.0 ni, 96.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
   MiB Mem :   7789.6 total,   6792.8 free,    629.9 used,    366.8 buff/cache
   MiB Swap:   8080.0 total,   8080.0 free,      0.0 used.   7051.9 avail Mem 
   
      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                                                                                                                 
        1 root      20   0  178916  13820   9244 S   0.0   0.2   0:03.04 systemd                                                                                                                                                                   
        2 root      20   0       0      0      0 S   0.0   0.0   0:00.01 kthreadd                                                                                                                                                                  
        3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp                                                                                                                                                                    
        4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_par_gp                                                                                                                                                                
        6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-kblockd  
   ~~~
   
   - top - 当前时间  up 机器运行时间，1 个用户，平均负载：1分钟/5分钟/15分钟 前（小于「内核数」时较小，大于「内核数」时已经超出机器负载
   - Tasks：总共 172 个任务，1 个在执行中，171 个睡眠中，0 个停止的进程，0 个僵尸进程（正在终止并未完全终止）
   - %Cpu(s)：1.6 us（用户进程百分比）,1.6 sy（系统进程百分比）,0.0 ni（改变过优先级的用户进程）,96.9 id（空闲 CPU 比例）, 0.0 wa（等待输入输出的进程）, 0.0 hi（硬中断请求服务比例）, 0.0 si（软中断请求服务比例）, 0.0 st（虚拟 CPU 等待时机 CPU 时间占比）
   - MiB Mem（内存）:   7789.6 total,   6792.8 free,    629.9 used,    366.8 buff/cache
   - MiB Swap（交换分区）:   8080.0 total,   8080.0 free,      0.0 used.   7051.9 avail Mem 
   
3. 查看进程树：pstree

   - -p：显示进程的 PID。
   - -u：显示进程所属账号名称。

   ~~~shell
   [root@localhost ~]# pstree
   systemd─┬─NetworkManager───2*[{NetworkManager}]
           ├─VGAuthService
           ├─agetty
           ├─anacron
           ├─atd
           ├─auditd─┬─sedispatch
           │        └─2*[{auditd}]
           
           ......
           
           ├─tuned───3*[{tuned}]
           └─vmtoolsd───{vmtoolsd}
   ~~~

   

进程终止命令：

1. 进程终止：kill

   - -l：查看可用的进程信号

     ~~~shell
     [root@localhost ~]# kill -l
      1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
      6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
     11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
     ......
     63) SIGRTMAX-1	64) SIGRTMAX	
     ~~~

     可用的进程信号有很多，常用的进程信号如下：

     | 信号代号 | 信号名称 | 说明                                                         |
     | -------- | -------- | ------------------------------------------------------------ |
     | 1        | SIGHUP   | 该信号让进程立即关闭，然后重新读取配置文件之后重启。         |
     | 9        | SIGKILL  | 用来立即结束程序的运行。本信号不能被阻塞、处理和忽略一般用于强制终止进程。 |
     | 15       | SIGTERM  | 正常结束进程的信号，kill 命令的默认信号。有时如果进程已经发生问题，这个信号是无法正常终止进程的，我们才会尝试 SIGKILL 信号，也就是信号 9。 |

   - -[SIG] PID：发送信号量到进程。

     ~~~shell
     [root@localhost ~]# kill -9 22344
     [root@localhost ~]# kill 22344 
     ~~~

2. 进程终止：killall [选项] [信号] 进程名

   - -i：交互式，询问是否要删除进程。
   - -I：忽略进程名大小写。

   ~~~java
   [root@localhost ~]# killall -9 mysqld
   ~~~

   与 kill 命令不同的是，killall 通过进程名来杀死进程。

3. 进程终止：pkill [选项] [信号] 进程名

   - -t 终端号：按照终端号踢出用户

   pkill 命令与 killall 命令极其相似。pkill 的额外功能是：当系统登录用户过多时，权限高的管理员可以选择踢出用户（将用户的连接进程 kill），但是通过 PID 查找用户的登陆终端较麻烦，此时可以选择 pkill 命令按照终端来踢出用户：

   ~~~shell
   [root@localhost ~]# w
    01:08:44 up 50 min,  1 user,  load average: 0.08, 0.02, 0.01
   USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
   root     pts/0    192.168.253.1    00:22    1.00s  0.04s  0.00s w
   [root@localhost ~]# pkill -9 -t pts/0
   Connection closing...Socket close.
   ~~~

   

---

#### 2.工作管理

在 Windows 的图形界面中，我们能很方便地将进程放入后台当中（隐藏图形界面），在 Linux 中，我们同样也能将进程后台运行。

Linux 中让进程后台运行的方式：

1. 在命令后加 & 符号：

   ~~~shell
   [root@localhost ~]# tar -zcf etc.tar.gz /etc &
   [1] 2446
   [root@localhost ~]# tar: 从成员名中删除开头的“/”
   
   [root@localhost ~]# 
   [1]+  已完成               tar -zcf etc.tar.gz /etc
   [root@localhost ~]# 
   ~~~

   放入后台时，按回车可以回到终端界面，此时会由一些提示，但是不影响键入其他命令。

2. 使用 ctrl + z 暂停进程：

   ~~~shell
   [root@localhost ~]# top
   top - 01:49:15 up  1:30,  1 user,  load average: 0.02, 0.02, 0.00
   Tasks: 168 total,   1 running, 167 sleeping,   0 stopped,   0 zombie
   %Cpu(s):  0.0 us,  1.5 sy,  0.0 ni, 98.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
   MiB Mem :   7789.6 total,   6771.8 free,    636.3 used,    381.5 buff/cache
   MiB Swap:   8080.0 total,   8080.0 free,      0.0 used.   7045.6 avail Mem 
   
      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                                                                                                                   
        1 root      20   0  178916  13896   9304 S   0.0   0.2   0:02.78 systemd                                                                                                                                                                   
        2 root      20   0       0      0      0 S   0.0   0.0   0:00.02 kthreadd                                                                                                                                                                           
        ......                                                                                                                                                         
      118 root     -51   0       0      0      0 S   0.0   0.0   0:00.00 irq/27-pciehp                                                                                                                                                             
      119 root     -51   0       0      0      0 S   0.0   0.0   0:00.00 irq/28-pciehp                                                                                                                                                             
   [1]+  已停止               top
   [root@localhost ~]# 
   ~~~

   

查看系统工作命令：

1. 查看后台工作：jobs [选项]

   - -l：查看详细信息（PID）

   ~~~shell
   [root@localhost ~]# jobs -l
   [1]+  2461 停止 (信号)         top
   ~~~

   1 代表第一个放入后台的工作，+ 代表最后一个（- 是倒数第二个，其他的无符号）。

2. 恢复后台工作到前台执行：fg %工作号

   工作号可以省略，此时恢复最后一个工作（+ 标记的工作）。

3. 把后台暂停的工作恢复到后台执行：bg %工作号

   注意：恢复到后台执行的工作不能与前台有所交互，否则不能恢复，如 top 命令（只能在前台运行）。



---

#### 3.系统资源查看

1. 监控系统资源：vmstat [刷新延时 刷新次数]

   ~~~shell
   [root@localhost ~]# vmstat 1 3
   procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
    2  0      0 6993336   3268 336816    0    0  1766   125  738  721  5 12 68 16  0
    0  0      0 6993148   3268 336856    0    0    64  7824  582  730  0  1 99  0  0
    0  0      0 6993148   3268 336856    0    0     0     4  303  506  0  0 100  0  0
   ~~~

   每隔 1 秒刷新一次，一共刷新 3 次。

2. 查看开机时内核检测信息：dmesg

   ~~~shell
   [root@localhost ~]# dmesg | grep CPU
   [    0.000000] smpboot: Allowing 128 CPUs, 124 hotplug CPUs
   [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:128 nr_cpu_ids:128 nr_node_ids:1
   [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=128, Nodes=1
   [    0.001000] rcu: 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=128.
   [    0.055833] MDS: Mitigation: Clear CPU buffers
   [    0.064106] smpboot: CPU0: Intel(R) Core(TM) i5-7500 CPU @ 3.40GHz (family: 0x6, model: 0x9e, stepping: 0x9)
   [    0.064915] core: CPUID marked event: 'cpu cycles' unavailable
   [    0.064915] core: CPUID marked event: 'instructions' unavailable
   [    0.064916] core: CPUID marked event: 'bus cycles' unavailable
   [    0.064916] core: CPUID marked event: 'cache references' unavailable
   [    0.064917] core: CPUID marked event: 'cache misses' unavailable
   [    0.064918] core: CPUID marked event: 'branch instructions' unavailable
   [    0.064918] core: CPUID marked event: 'branch misses' unavailable
   [    0.065876] NMI watchdog: Perf event create on CPU 0 failed with -2
   [    0.081778] smp: Bringing up secondary CPUs ...
   [    0.082769] .... node  #0, CPUs:          #1
   [    0.087106] smp: Brought up 1 node, 4 CPUs
   ~~~

   由于开机自检信息非常多，一般通过 | 来筛选需要查看的信息。

3. 查看内存使用状态：free [选项]

   - -b/-k/-m/-g：切换内存显示的单位。

   ~~~shell
   [root@localhost ~]# free -m
                 total        used        free      shared  buff/cache   available
   Mem:           7789         625        6832           8         331        7056
   Swap:          8079           0        8079
   ~~~

4. 查看 CPU 信息：cat /proc/cpuinfo

   - /proc 是内存文件系统，一旦断电内容就会消失。
   - /proc/cpuinfo 中存放的是每次开机时 CPU 的自检信息。

5. 查看系统的启动时间和平均负载（top/w 命令的第一行）：uptime

   ~~~shell
   [root@localhost ~]# uptime
    00:01:09 up  2:45,  1 user,  load average: 0.00, 0.00, 0.00
   ~~~

6. 查看系统与内核相关信息：uname [选项]

   - -a：查看系统所有相关信息。
   - -r：查看内核版本。
   - -s：查看内核名称。

   ~~~shell
   [root@localhost ~]# uname -a
   Linux localhost.localdomain 4.18.0-147.el8.x86_64 #1 SMP Wed Dec 4 21:51:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
   [root@localhost ~]# uname -r
   4.18.0-147.el8.x86_64
   [root@localhost ~]# uname -s
   Linux
   ~~~

7. 判断当前系统位数：file /bin/ls

   ~~~shell
   [root@localhost ~]# file /bin/ls
   /bin/ls: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=937708964f0f7e3673465d7749d6cf6a2601dea2, stripped, too many notes (256)
   ~~~

   file 命令用于辨识文件类型。

   通过 file 命令查看系统命令类型可顺带显示系统位数。

8. 查询当前 Linux 系统的发行版本：lsb_release -a

   ~~~shell
   [root@localhost ~]# lsb_release -a
   LSB Version:	:core-4.1-amd64:core-4.1-noarch:cxx-4.1-amd64:cxx-4.1-noarch:desktop-4.1-amd64:desktop-4.1-noarch:languages-4.1-amd64:languages-4.1-noarch:printing-4.1-amd64:printing-4.1-noarch
   Distributor ID:	CentOS
   Description:	CentOS Linux release 8.1.1911 (Core) 
   Release:	8.1.1911
   Codename:	Core
   ~~~

   如果系统为安装此命令，则使用 `yum install -y redhat-lsb` 命令进行安装。

9. 列出进程打开或使用的文件信息：lsof [选项]

   - -c 字符串：列出以字符串开头的进程所使用的文件信息。
   - -u 用户名：列出某个用户进程打开的文件信息。
   - -p pid：列出某个 PID 打开的文件信息。

   ~~~shell
   [root@localhost ~]# lsof -p 2179
   COMMAND  PID USER   FD   TYPE             DEVICE SIZE/OFF      NODE NAME
   bash    2179 root  cwd    DIR              253,0     4096 100663425 /root
   bash    2179 root  rtd    DIR              253,0      224       128 /
   bash    2179 root  txt    REG              253,0  1219248      1484 /usr/bin/bash
   bash    2179 root  mem    REG              253,0  2801698  67769192 /usr/lib/locale/zh_CN.utf8/LC_COLLATE
   bash    2179 root  mem    REG              253,0    76872  33555712 /usr/lib64/libnss_files-2.28.so
   bash    2179 root  DEL    REG              253,0             708673 /var/lib/sss/mc/passwd
   bash    2179 root  mem    REG              253,0    62600  34231059 /usr/lib64/libnss_sss.so.2
   bash    2179 root  mem    REG              253,0  3154704  33555700 /usr/lib64/libc-2.28.so
   ......
   ~~~

   

---

#### 4.系统定时任务

crond 服务管理与访问控制：

- 启动命令：service crond start
- 设置开机自启：chkconfig crond on

一般来说，crond 服务默认就是自启动的。

~~~shell
[root@localhost ~]# systemctl list-unit-files | grep crond
crond.service                                    enabled 
[root@localhost ~]# ps -ef | grep crond
root       1397      1  0 7月23 ?       00:00:00 /usr/sbin/crond -n
root      32807   2179  0 01:49 pts/0    00:00:00 grep --color=auto crond
~~~



定时任务设置：crontab [选项]

- -e：编辑定时任务。
- -l：查询定时任务。
- -r：删除当前用户的所有的定时任务。

定时任务格式：* * * * * command

- 第一个 *：一个小时当中的第几分钟（0-59）。
- 第二个 *：一天当中的第几个小时（0-23）。
- 第三个 *：一个月的第几天（1-31）。
- 第四个 *：一年当中的第几个月（1-12）。
- 第五个 *：一周当中的星期几（0-7,0 和 7 都代表星期天）。
- command：需要执行的任务或脚本。

特殊符号：

- *：代表任意时间。
- ,：代表不连续的时间，如 1,3,8,9 。
- -：代表连续的时间范围，如 10-15 。
- */n：代表隔多久执行一次，如：\*/10 * * * * 代表每 10 分钟执行一次。

~~~shell
*/1 * * * * echo 'Hello Linux!' >> /tmp/test
~~~

每分钟向 tmp 下的 test 文件中写入 `Hello Linux!`。