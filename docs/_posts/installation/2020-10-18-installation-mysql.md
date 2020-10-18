---
layout:     post
title:      "Linux 下安装 MySQL"
subtitle:   "「软件安装」MySQL"
date:       2020-10-18
author:     "Hex"
header-img: "img/post-bg-computer.jpg"
catalog: false
tags:
    - 软件安装
    - 数据库
    - MySQL
---



MySQL Database Service is a fully managed database service to deploy cloud-native applications using the world’s most popular open source database. It is 100% developed, managed and supported by the MySQL Team.



***DNF***：DNF代表 Dandified YUM 是基于 RPM 的 Linux 发行版的软件包管理器。用于在 Fedora / RHEL / CentOS 操作系统中安装，更新和删除软件包。 它是CentOS8 的默认软件包管理器。 DNF 是 YUM 的下一代版本，功能强大且具有健壮的特征，使维护软件包组变得更加容易，并且能够自动解决依赖性问题。



> 安装前请先确保 Linux 系统与外网畅通且安装有 DNF 软件包管理器！



MySQL安装：

1. 安装MySQL

   ```shell
   [root@localhost ~]# dnf install @mysql
   ```

   根据提示输入 y 进行安装。

2. 启动MySQL服务

   ```shell
   [root@localhost ~]# systemctl start mysqld
   ```

3. 设置MySQL开机自启

   ```shell
   [root@localhost ~]# systemctl enable mysqld
   ```

4. 查看MySQL运行状态

   ```shell
   [root@localhost ~]# systemctl status mysqld
   ```

   

MySQL配置：

1. 运行 ***mysql_secure_installation*** 脚本，执行一些与安全性相关的操作并设置 MySQL Root 密码

   ```shell
   [root@localhost ~]# mysql_secure_installation
   
   Securing the MySQL server deployment.
   
   Connecting to MySQL using a blank password.
   
   VALIDATE PASSWORD COMPONENT can be used to test passwords
   and improve security. It checks the strength of password
   and allows the users to set only those passwords which are
   secure enough. Would you like to setup VALIDATE PASSWORD component?
   
   Press y|Y for Yes, any other key for No: y        #输入 y 进入配置
   
   There are three levels of password validation policy:
   
   LOW    Length >= 8
   MEDIUM Length >= 8, numeric, mixed case, and special characters
   STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file
   
   Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 0  #选择 0-LOW 密码强度
   Please set the password for root here.
   
   New password:               #输入密码
   
   Re-enter new password:      #确认密码
   
   Estimated strength of the password: 50 
   Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
   By default, a MySQL installation has an anonymous user,
   allowing anyone to log into MySQL without having to have
   a user account created for them. This is intended only for
   testing, and to make the installation go a bit smoother.
   You should remove them before moving into a production
   environment.
   
   Remove anonymous users? (Press y|Y for Yes, any other key for No) : y      # 移除匿名用户
   Success.
   
   
   Normally, root should only be allowed to connect from
   'localhost'. This ensures that someone cannot guess at
   the root password from the network.
   
   Disallow root login remotely? (Press y|Y for Yes, any other key for No) : n   #不禁止 root 用户的远程登陆
   
    ... skipping.
   By default, MySQL comes with a database named 'test' that
   anyone can access. This is also intended only for testing,
   and should be removed before moving into a production
   environment.
   
   
   Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y   #移除 test 数据库
    - Dropping test database...
   Success.
   
    - Removing privileges on test database...
   Success.
   
   Reloading the privilege tables will ensure that all changes
   made so far will take effect immediately.
   
   Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y    #重新载入权限表
   Success.
   
   All done! 
   ```

2. 配置远程登陆

   > 在安全配置中 ***Disallow root login remotely?*** 需要选 n 才能配置远程登陆！

   登陆MySQL的 shell 客户端：

   ```shell
   [root@localhost ~]# mysql -uroot -p
   Enter password:                             #输入密码
   Welcome to the MySQL monitor.  Commands end with ; or \g.
   Your MySQL connection id is 10
   Server version: 8.0.17 Source distribution
   
   Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.
   
   Oracle is a registered trademark of Oracle Corporation and/or its
   affiliates. Other names may be trademarks of their respective
   owners.
   
   Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
   
   mysql> use mysql              #切换到 mysql 数据库
   Reading table information for completion of table and column names
   You can turn off this feature to get a quicker startup with -A
   
   Database changed
   ```

   修改 root 用户的 host 字段为 '%'，表示接受 root 用户所有IP地址的登录请求：

   ```shell
   mysql> update user set host='%' where user='root';
   Query OK, 1 row affected (0.00 sec)
   Rows matched: 1  Changed: 1  Warnings: 0
   
   mysql> flush privileges;     #刷新权限表
   Query OK, 0 rows affected (0.00 sec)
   ```

   

系统网络配置：

1. 开启系统防火墙的 3306 端口：

   ```shell
   [root@localhost ~]# firewall-cmd --add-port=3306/tcp --permanent
   success
   ```

2. 重启防火墙，应用修改

   ```shell
   [root@localhost ~]# firewall-cmd --reload
   success
   ```
   