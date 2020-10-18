#### DNF 安装 Kafka

1）安装 jdk 环境：

- 查看 jdk 安装包：

  ~~~shell
  [root@localhost redis]# dnf search java-1.8
  上次元数据过期检查：0:21:30 前，执行于 2020年10月18日 星期日 03时04分09秒。
  ====================================================== 名称 匹配：java-1.8 ====================================================
  java-1.8.0-openjdk.x86_64 : OpenJDK Runtime Environment 8
  java-1.8.0-openjdk-src.x86_64 : OpenJDK Source Bundle 8
  java-1.8.0-openjdk-demo.x86_64 : OpenJDK Demos 8
  java-1.8.0-openjdk-devel.x86_64 : OpenJDK Development Environment 8
  java-1.8.0-openjdk-javadoc.noarch : OpenJDK 8 API documentation
  java-1.8.0-openjdk-headless.x86_64 : OpenJDK Headless Runtime Environment 8
  java-1.8.0-openjdk-javadoc-zip.noarch : OpenJDK 8 API documentation compressed in single archive
  java-1.8.0-openjdk-accessibility.x86_64 : OpenJDK 8 accessibility connector
  ~~~

  在 Linux 中需要安装 `openjdk.x86_64`（运行时环境） 与 `openjdk-devel.x86_64`（开发工具包）。

- 安装 jdk：

  ~~~shell
  [root@localhost redis]# dnf install java-1.8.0-openjdk.x86_64
  
  ......
  
  完毕！
  [root@localhost redis]# dnf install java-1.8.0-openjdk-devel.x86_64
  
  ......
  
  完毕！
  [root@localhost redis]# java -version
  openjdk version "1.8.0_265"
  OpenJDK Runtime Environment (build 1.8.0_265-b01)
  OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode)
  ~~~



2）安装 ***ZooKeeper***：CentOS8 下安装 ZooKeeper

