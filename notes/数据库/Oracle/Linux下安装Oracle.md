Oracle19c 下载地址：https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#19c

Oracle 数据库文档地址：https://docs.oracle.com/en/database/oracle/oracle-database/index.html



---

### 1.环境检查

Linux 系统版本：

~~~shell
[root@localhost ~]# cat /etc/centos-release
CentOS Linux release 8.1.1911 (Core)
~~~



安装环境必备条件：

1. 物理内存不少于 2GB

   ~~~shell
   [root@localhost ~]# cat /proc/meminfo | grep MemTotal
   MemTotal:        7976536 kB
   [root@localhost ~]# echo $((7976536/1024/1024))
   7
   ~~~

   物理内存空间为：7GB

2. 硬盘空间不少于 12GB

3. swap 分区空间不少于 2GB

   ~~~shell
   [root@localhost ~]# fdisk -l |grep Disk
   Disk /dev/sda：200 GiB，214748364800 字节，419430400 个扇区
   Disk /dev/mapper/cl-root：50 GiB，53687091200 字节，104857600 个扇区
   Disk /dev/mapper/cl-swap：7.9 GiB，8472494080 字节，16547840 个扇区
   Disk /dev/mapper/cl-home：141.1 GiB，151510843392 字节，295919616 个扇区
   ~~~



---

### 2.用户准备

Oracle 不能使用 root 用户进行安装，需要为其创建特定的用户组及用户。

创建用户组：

1. oinstall：此用户组是 Oracle 推荐创建的 OS 用户组之一，建议在系统第一次安装 Oracle 软件产品之前创建该 oinstall 用户组，理论上该 oinstall 组应当拥有所有的 Oracle 软件产品目录。
2. dba：OSDBA 是我们必须要创建的一种系统 DBA 用户组（dba），若没有该用户组我们将无法安装数据库软件及执行管理数据库的任务。
3. oper：OSOPER 是一种额外可选的用户组（oper），创建该用户组可以满足让系统用户行使某些数据库管理权限（包括 startup 和 shutdown），所以要小心为该用户组添加成员。

~~~shell
[root@localhost ~]# groupadd oinstall
[root@localhost ~]# groupadd dba
[root@localhost ~]# groupadd oper
~~~

在单机环境（single-instance）中 Oracle 软件拥有者用户（常见的 oracle 或者 orauser），应该同时是 oinstall、dba、oper 用户组的成员。同时该用户的主用户组必须是 oinstall。



创建 oracle 用户并更新密码：

~~~shell
[root@localhost ~]# useradd -g oinstall -G dba,oper oracle
[root@localhost ~]# passwd oracle
更改用户 oracle 的密码 。
新的 密码：
无效的密码： 密码少于 8 个字符
重新输入新的 密码：
passwd：所有的身份验证令牌已经成功更新。
~~~

注意：oracle 用户的主用户组必须为 oinstall，另外附加用户组 dba,oper。



---

### 3.前置软件安装

下载 Oracle 前置安装包：https://oss.oracle.com/ol8/SRPMS-updates/

选择 *oracle-database-preinstall-19c-1.0-1.el8.src.rpm* 进行下载，目前只能找到源码包，需要先进行编译。

> 前置安装包的版本必须与操作系统相匹配，否则会安装失败，如 Linux 7 则需要 oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm

将 src.rpm 包拖入 Linux 进行编译安装：

1. 安装 rpm 编译工具

   ~~~shell
   [root@localhost ~]# yum -y install rpm-build
   ~~~

2. 编译源码包：

   ~~~shell
   [root@localhost ~]# rpmbuild --rebuild --clean oracle-database-preinstall-19c-1.0-1.el8.src.rpm
   ~~~

   编译完成后，会在当前目录下生成 rmpbuild 文件夹，rpm 包在 ./rmpbuild/RPMS/x86_64/oracle-database-preinstall-19c-1.0-1.el8.x86_64.rpm

3. 安装 rpm 包：

   ~~~shell
   [root@localhost x86_64]# yum localinstall oracle-database-preinstall-19c-1.0-1.el8.x86_64.rpm
   ~~~

   此时 yum 自动解决依赖并安装 rpm 软件。



---

### 4.安装数据库

使用 yum 命令安装 rpm：

~~~shell
[root@localhost ~]# yum localinstall oracle-database-ee-19c-1.0-1.x86_64.rpm
~~~

安装完毕！



创建数据库实例(使用 oracle 用户)：

1. 创建数据存放目录：

   ~~~shell
   [oracle@localhost /]$ cd /opt/oracle
   [oracle@localhost oracle]$ mkdir oradata
   ~~~

2. 修改 *oracledb_ORCLCDB-19c.conf* 文件，位于 /etc/sysconfig/ 文件夹

   ~~~shell
   [oracle@localhost /]$ cd /etc/sysconfig/
   [oracle@localhost sysconfig]$ cp oracledb_ORCLCDB-19c.conf oracledb_ORCLCDB-19c.conf.init
   [oracle@localhost sysconfig]$ vim oracledb_ORCLCDB-19c.conf
   ~~~

   先备份配置文件，再进行修改（此处创建第一个数据库实例，不进行修改）：

   ~~~shell
   #This is a configuration file to setup the Oracle Database. 
   #It is used when running '/etc/init.d/oracledb_ORCLCDB configure'.
   #Please use this file to modify the default listener port and the
   #Oracle data location.
   
   # LISTENER_PORT: Database listener（监听端口）
   LISTENER_PORT=1521
   
   # ORACLE_DATA_LOCATION: Database oradata location（数据存放目录）
   ORACLE_DATA_LOCATION=/opt/oracle/oradata
   
   # EM_EXPRESS_PORT: Oracle EM Express listener（图形化数据库管理工具监听端口）
   EM_EXPRESS_PORT=5500
   ~~~

3. 修改 19c 数据库脚本：

   ~~~shell
   [oracle@localhost /]$ cd /etc/init.d/
   [oracle@localhost init.d]$ cp oracledb_ORCLCDB-19c oracledb_ORCLCDB-19c.init
   [oracle@localhost init.d]$ vim oracledb_ORCLCDB-19c
   ~~~

   可修改如下内容（默认情况下不用修改）：

   ~~~shell
   export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
   
   export ORACLE_VERSION=19c
   export ORACLE_SID=ORCLCDB
   export TEMPLATE_NAME=General_Purpose.dbc
   export CHARSET=AL32UTF8
   export PDB_NAME=ORCLPDB1
   export LISTENER_NAME=LISTENER
   export NUMBER_OF_PDBS=1
   export CREATE_AS_CDB=true
   ~~~

   1. ORACLE_HOME：数据库实例位置，不需要修改（创建多个实例时可设置 dbhome_2）
   2. ORACLE_SID：数据库实例名称（多实例之间不重复）
   3. TEMPLATE_NAME：数据库模板，General_Purpose.dbc（普通数据库）、Data_Warehouse.dbc（数据仓库）
   4. CHARSET：字符集，AL32UTF8 是 UTF-8 的升级版，此处不需要修改。
   5. PDB_NAME：可拔插数据库名字（保持默认，多实例之间不重复）
   6. LISTENER_NAME：监听器，此处需要修改，不要与已存在的监听器相同，建议修改为 "LISTENER_实例名称"
   7. NUMBER_OF_PDBS：可拔插数据库数量，无需修改。
   8. CREATE_AS_CDB：数据库实例作为 CDB 容器，无需修改。

   > 创建多个数据库实例：
   >
   > 1. 修改 /etc/sysconfig/oracledb_ORCLCDB-19c.conf 配置文件名，规则为 oracledb\_${ORACLE_SID-ORACLE}\_${VERSION}.conf
   >
   >    如：实例名为 ORCLABC，版本为 19c，则脚本名称应该为：oracledb_ORCLABC_19c.conf
   >
   > 2. 修改 oracledb_ORCLABC_19c.conf 文件内容
   >
   >    ~~~shell
   >    #LISTENER_PORT: Database listener
   >    LISTENER_PORT=1522  # 设置新的端口 此处需要修改
   >    
   >    #ORACLE_DATA_LOCATION: Database oradata location
   >    ORACLE_DATA_LOCATION=/opt/oracle/oradata # 设置数据库目录 不需要修改
   >    
   >    #EM_EXPRESS_PORT: Oracle EM Express listener
   >    EM_EXPRESS_PORT=5501 # 设置图形化界面端口 此处需要修改
   >    ~~~
   >
   > 3. 创建新的脚本文件，/etc/init.d/oracledb_ORCLABC-19c
   >
   >    ~~~shell
   >    [oracle@localhost init.d]$ cp /etc/init.d/oracledb_ORCLCDB-19c /etc/init.d/oracledb_ORCLABC-19c
   >    ~~~
   >
   > 4. 修改脚本内容：
   >
   >    ~~~shell
   >    export ORACLE_HOME=/opt/oracle/product/19c/dbhome_2
   >    
   >    export ORACLE_VERSION=19c
   >    export ORACLE_SID=ORCLABC
   >    export TEMPLATE_NAME=General_Purpose.dbc
   >    export CHARSET=AL32UTF8
   >    export PDB_NAME=ORCLPDBABC
   >    export LISTENER_NAME=LISTENER-ORCLABC
   >    export NUMBER_OF_PDBS=1
   >    export CREATE_AS_CDB=true
   >    ~~~
   >
   >    修改完毕后，运行脚本进行配置即可。

4. 配置数据库实例（root 用户）：

   ~~~shell
   [root@localhost init.d]# ./oracledb_ORCLCDB-19c configure
   Configuring Oracle Database ORCLCDB.
   准备执行数据库操作
   已完成 8%
   复制数据库文件
   已完成 31%
   正在创建并启动 Oracle 实例
   已完成 32%
   已完成 36%
   已完成 40%
   已完成 43%
   已完成 46%
   正在进行数据库创建
   已完成 51%
   已完成 54%
   正在创建插接式数据库
   已完成 58%
   已完成 77%
   执行配置后操作
   已完成 100%
   数据库创建完成。有关详细信息, 请查看以下位置的日志文件:
    /opt/oracle/cfgtoollogs/dbca/ORCLCDB。
   数据库信息:
   全局数据库名:ORCLCDB
   系统标识符 (SID):ORCLCDB
   有关详细信息, 请参阅日志文件 "/opt/oracle/cfgtoollogs/dbca/ORCLCDB/ORCLCDB.log"。
   
   Database configuration completed successfully. The passwords were auto generated, you must change them by connecting to the database using 'sqlplus / as sysdba' as the oracle user.
   ~~~

   注意：此过程可能会持续若干分钟，请耐心等待。从打印信息中，可以看到相关的日志文件位置。

5. 为 oracle 用户添加环境变量：

   ~~~shell
   [oracle@localhost ~]$ vim .bash_profile
   ~~~

   添加环境变量：

   ~~~shell
   export ORACLE_BASE=/opt/oracle
   export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
   export ORACLE_SID=ORCLCDB
   export PATH=$ORACLE_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin
   ~~~

   注意：用户环境变量修改后需要重新登录。



---

### 5.创建数据库用户

sqlplus 命令的使用：

1. sqlplus / as sysdba：不需要用户名和密码，不需要数据库服务器启动 listener，也不需要数据库服务器处于可用状态；比如我们想要启动数据库就可以用这种方式进入 sqlplus，然后通过 startup 命令来启动数据库。
2. sqlplus username/password：连接本机数据库，不需要数据库服务器的 listener 进程，但是由于需要用户名密码的认证，因此需要数据库服务器处于可用状态才行。
3. sqlplus username/password@orcl：通过网络连接，这是需要数据库服务器的 listener 处于监听状态。
4. sqlplus username/password@//host:port/sid：用 sqlplus 远程连接 oracle 命令(例：sqlplus risenet/123456@//192.168.130.99:1521/risenet)



登录数据库：

~~~shell
[oracle@localhost ~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Wed Jan 13 03:05:11 2021
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> 
~~~

> 登录 sqlplus 后，可能出现乱码，需要在 ~/.bash_profile 中引入环境变量：export NLS_LANG=AMERICAN_AMERICA.AL32UTF8



创建数据库用户：

~~~sql
SQL> create user C##STAR IDENTIFIED BY 123456;
~~~

> 注意：从 Oracle 12c 之后，增加了 CDB 和 PDB 的概念，数据库引入的多组用户环境（Multitenant Environment）中，允许一个数据库容器（CDB）承载多个可插拔数据库（PDB）;
>
> 此外，数据库用户名必须以 C## 开头。

创建表空间：

~~~sql
SQL> create tablespace STAR_TEST_DATA datafile '/opt/oracle/oradata/ORCLCDB/star_test.dbf' size 5120M;
~~~

重新启动数据库：

~~~sql
SQL> shutdown immediate;
SQL> startup;
~~~

为用户分配默认表空间：

~~~sql
SQL> alter user C##STAR default tablespace STAR_TEST_DATA;

User altered.
~~~



给用户授予权限：

1. 登录数据库权限：

   ~~~sql
   SQL> grant create session to C##STAR;
   
   Grant succeeded.
   ~~~

2. 授予用户操作表空间的权限：普通用户不需要

   ~~~sql
   SQL> grant unlimited tablespace to C##STAR;
   SQL> grant create tablespace to C##STAR;             
   SQL> grant alter tablespace to C##STAR;
   SQL> grant drop tablespace to C##STAR;
   SQL> grant manage tablespace to C##STAR;
   ~~~

3. 授予用户操作表的权限（包含有 create index 权限、alter table、drop table 权限）：

   ~~~sql
   SQL> grant create table to C##STAR;
   
   Grant succeeded.
   ~~~

4. 授予用户操作视图的权限（包含有 alter view、drop view权限）:

   ~~~sql
   SQL> grant create view to C##STAR;
   
   Grant succeeded.
   ~~~

5. 授予用户操作触发器的权限（包含有 alter trigger、drop trigger 权限）：

   ~~~sql
   SQL> grant create trigger to C##STAR;
   
   Grant succeeded.
   ~~~

6. 授予用户操作存储过程的权限（包含有 alter procedure、drop procedure、function、package 权限）：

   ~~~sql
   SQL> grant create procedure to C##STAR;
   
   Grant succeeded.
   ~~~

7. 授予用户操作序列的权限（包含有创建、修改、删除以及选择序列）：

   ~~~sql
   SQL> grant create sequence to C##STAR;
   
   Grant succeeded.
   ~~~

8. 授予用户回滚权限：

   ~~~sql
   SQL> grant create rollback segment to C##STAR;
   SQL> grant alter rollback segment to C##STAR;
   SQL> grant drop rollback segment to C##STAR;
   ~~~



---

### 6.远程登录数据库

修改防火墙：

~~~shell
[root@localhost ORCLCDB]# firewall-cmd --add-port=1521/tcp --permanent
success
[root@localhost ORCLCDB]# firewall-cmd --reload
success
~~~



使用 Navicat Premium 进行连接：

连接方式选择 Basic，输入 IP、端口、用户名、密码即可连接成功。

进入数据库后点击用户名，即可查看当前用户的表空间以及其下的数据表。



---

### 7.添加 Oracle 为系统服务

找到文件`/etc/oratab`，修改文件内容：

~~~properties
ORCLCDB:/opt/oracle/product/19c/dbhome_1:Y
~~~

将最后的 N 修改为 Y。

在`/etc/init.d`目录下编写启动脚本`oracle`

~~~shell
#!/bin/sh
# chkconfig: 2345 20 80
# description: Oracle dbstart / dbshut
# 以上两行为 chkconfig 所需
ORA_HOME=/opt/oracle/product/19c/dbhome_1
ORA_OWNER=oracle
LOG_FILE=/var/log/oracle/oracle.log
echo  "==================================================================================="
date +"### %T %a %D: Run Oracle... "
if [ ! -f ${ORA_HOME}/bin/dbstart ] || [ ! -f ${ORA_HOME}/bin/dbshut ]; then
    echo "Error: Missing the script file ${ORA_HOME}/bin/dbstart or ${ORA_HOME}/bin/dbshut!"
    echo "==================================================================================="
    exit
fi
start(){
        echo "### Startup Database..."
        su - ${ORA_OWNER} -c "${ORA_HOME}/bin/dbstart ${ORA_HOME}"
        echo "### Done."
}
stop(){
        echo "### Shutdown Database..."
        su - ${ORA_OWNER} -c "${ORA_HOME}/bin/dbshut ${ORA_HOME}"
        echo "### Done."
}
case "$1" in
        "start")
                start
                ;;
        "stop")
                stop
                ;;
        "restart")
                stop
                start
                ;;
esac

date +"### %T %a %D: Finished."
echo "==================================================================================="
echo ""
~~~

编写完成后即可使用此脚本进行服务启停。





