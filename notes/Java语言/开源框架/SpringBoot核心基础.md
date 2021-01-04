SpringBoot 官网：[https://spring.io/projects/spring-boot/](https://spring.io/projects/spring-boot/)

Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".



**目录**

1. [SpringBoot 介绍](#1springboot 介绍)

2. SpringBoot 依赖管理

3. SpringBoot Starter

4. SpringBoot AutoConfiguration

   



---

### 1.SpringBoot 介绍

SpringBoot 由 Pivotal 团队在 2013 年开始研发、2014 年 4 月随着 Spring4.0 发布第一个版本，SpringBoot 是一个全新的开源的轻量级框架，它基于设计，不仅继承了 Spring 框架原有的优秀特性，而且还通过简化配置来进一步简化了 Spring 应用的整个搭建和开发过程。另外 SpringBoot 通过集成大量的框架使得依赖包的版本冲突，以及引用的不稳定性等问题得到了很好的解决。

SpringBoot 的特点：

- 独立的 Spring 应用程序。
- 直接嵌入Tomcat，Jetty 或 Undertow（无需部署 WAR 文件）。
- 提供可选择的 Starter 依赖，以简化项目搭建配置。
- 尽可能自动配置 Spring 和第三方代码库。
- 提供可用于生产的功能，例如指标，运行状况检查和外部化配置。
- 完全没有代码生成，也不需要 XML 配置。

Spring Boot 采用约定大于配置的思想，大大的简化了 Spring 应用开发，只需要极小的配置项就能创建一个独立的，产品级别的应用。



在 ***IDEA*** 中，我们可以使用 *Spring Initializer* 快速创建一个 *Spring Boot* 项目。

IDEA 中 SpringBoot 项目目录结构：

![](../../img/Java语言/Snipaste_2020-10-31_01-47-11.png)

- `.mvn`：存放 *maven wrapper* 相关的文件及 jar 包，可删除。
- `src/main/java`：Java 文件存放路径。
  - `XxxApplication.class`：SpringBoot 程序的启动类。

- `src/main/resources`：静态资源文件存放路径。
  - `static`：静态资源目录，如 css/，js/，图片等资源。
  - `templates`：视图模板目录，如 jsp，thymeleaf 等。
  - `application.properties`：SpringBoot 默认生成的配置文件，也可以是 application.yml 等。
- `src/main/test`：测试类的存放目录。
- `.gitignore`：Git 的忽略文件，用来定义过滤文件规则。
- `xxx.iml`：Intellij Idea 的工程配置文件，里面是当前 project 的一些配置信息。
- `HELP.md`：帮助文档，内含 SpringBoot 项目的一些文档链接，可删除。
- `mvnw,mvnw.cmd`：*maven wrapper* 打包脚本，一般情况下用不到，可删除。
- `pom.xml`：maven 项目的依赖配置文件（**P**roject **O**bject **M**odel）。



Spring，SpringBoot 与 SpringCloud：

***Spring***：Spring 是一个从实际开发中抽取出来的框架，因此它完成了大量开发中的通用步骤，留给开发者的仅仅是与特定应用相关的部分，大大的提高了企业用的开发效率。

***SpringBoot***：SpringBoot 是 Spring 框架的扩展，它消除了设置 Spring 应用程序所需的复杂例行配置，帮助我么快速的搭建应用，简化开发过程。

***SpringCloud***：SpringCloud 是一个基于 SpringBoot 实现的微服务解决方案，主要用于微服务架构应用的开发。



---

### 2.SpringBoot 依赖管理

在 SpringBoot 应用中，通过继承 SpringBoot 的提供的父工程来进行依赖管理。

在 `pom.xml` 文件中，声明了一个 ***parent*** 模块，即声明当前项目的父项目：

```xml
<parent>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-parent</artifactId>
   <version>2.3.4.RELEASE</version>
   <relativePath/> <!-- lookup parent from repository -->
</parent>
```

在 `spring-boot-starter-parent` 中，SpringBoot 帮助我们管理一些项目的基础信息：

- 一些公共的项目属性：jdk 版本，字符集等

  ~~~xml
  <properties>
    <java.version>1.8</java.version>
    <resource.delimiter>@</resource.delimiter>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <maven.compiler.target>${java.version}</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
  </properties>
  ~~~

- 项目授权和作者信息：

  ~~~xml
  <licenses>
      ......
  </licenses>
  <developers>
      ......
  </developers>
  ~~~

- 项目构建模块：`<build>...</build>`

  - `<resources>...</resources>` ：声明配置文件位置，在打包时将配置文件打包到 jar 包内。
  - `<pluginManagement>...</pluginManagement>`：声明插件的各个信息，与 `<plugin>...</plugin>` 不同的是，*pluginManagement* 并不是真正的引入了项目插件，仅仅是对插件信息进行管理约束，提供给子项目进行使用，方便进行统一管理，当然，子项目也可以覆盖此信息。



在 `spring-boot-starter-parent` 中，还有一个父项目：

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-dependencies</artifactId>
  <version>2.3.4.RELEASE</version>
</parent>
```

 在 `spring-boot-dependencies` 中，SpringBoot 帮助我们管理应用中的依赖版本：

- `<properties></properties>`：此模块中定义了 SpringBoot 所管理的所有依赖版本。

  ~~~xml
  <properties>
    <activemq.version>5.15.13</activemq.version>
    <antlr2.version>2.7.7</antlr2.version>
    <appengine-sdk.version>1.9.82</appengine-sdk.version>
    <artemis.version>2.12.0</artemis.version>
    <aspectj.version>1.9.6</aspectj.version>
    <assertj.version>3.16.1</assertj.version>
    <atomikos.version>4.0.6</atomikos.version>
      ......
  </properties>  
  ~~~

- `<dependencyManagement>...</dependencyManagement>`：声明各个依赖的信息，与 *pluginManagement* 一样，这里并不会真正的引入依赖，而是对依赖信息进行管理约束，提供给子项目进行使用，方便进行统一管理，一样的，子项目也可以覆盖此信息。

  ~~~xml
  <dependencyManagement>
      <dependencies>
        <dependency>
          <groupId>org.apache.activemq</groupId>
          <artifactId>activemq-amqp</artifactId>
          <version>${activemq.version}</version>
        </dependency>
        <dependency>
          <groupId>org.apache.activemq</groupId>
          <artifactId>activemq-blueprint</artifactId>
          <version>${activemq.version}</version>
        </dependency>
          ...
      </dependencies>
  </dependencyManagement>
  ~~~

有了 SpringBoot 的自动依赖管理，我们导入SpringBoot 所管理的 jar 时，默认不需要填写版本号，当然，如果导入的依赖未在 *spring-boot-dependencies* 进行管理，我们还是需要填写版本号。

> 我们使用 *Spring Initializer* 创建 SpringBoot 项目时，可以直接选择自己所需要的模块，如果后续发现有未引入的依赖，可以在 `spring-boot-dependencies` 中查找相关依赖将其填入 pom.xml 中即可，不需要添加版本信息。



---

### 3.SpringBoot Starter

在 SpringBoot 项目中包含了许许多多的 spring-boot-starter-xxx，我们称之为 SpringBoot 场景启动器，SpringBoot 将所有的功能抽取成一个个的场景启动器，我们只需要在项目中引入这些 *starter*，相关场景的依赖就都会导入进来并且统一由 SpringBoot 帮助我们进行版本管理。

以 `spring-boot-starter-web` 为例，在此 *starter* 的 pom 文件中，SpringBoot 会帮助我们导入 json，tomcat，web，webmvc 等相关依赖，我们无需额外导入其他依赖即可搭建一个基础的 web 应用。

例：spring-boot-starter-web 的 pom.xml 引入的相关依赖：

~~~xml
<dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
      <version>2.3.4.RELEASE</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-json</artifactId>
      <version>2.3.4.RELEASE</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-tomcat</artifactId>
      <version>2.3.4.RELEASE</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>5.2.9.RELEASE</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.2.9.RELEASE</version>
      <scope>compile</scope>
    </dependency>
</dependencies>
~~~



---

### 4.SpringBoot AutoConfiguration

SpringBoot 帮助我们引入相关依赖后，就会进一步帮助我们进行自动配置。



在 SpringBoot 主程序类上，有一个注解 *@SpringBootApplication*，此注解为组合注解，其中包含了 *@EnableAutoConfiguration* 注解，帮助我们引入了自动配置类：

1. *@EnableAutoConfiguration* 向容器中导入了一个 *AutoConfigurationImportSelector* 组件。

2. 在 *AutoConfigurationImportSelector* 组件中，通过 *getAutoConfigurationEntry* 方法，选择出需要加载的自动配置类。

   1. 通过 *getCandidateConfigurations* 获取所有的自动配置类：读取项目所有依赖的 jar 包的 META-INF 目录下的 *spring.factories* 文件，加载一系列的容器组件

      > *spring.factories* 是一个 properties 文件，其中存放的是容器各种组件的全类名，如：
      >
      > ```properties
      > org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
      > org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
      > ......
      > ```

   2. 删除容器不需要的自动配置类：主要是通过 OnBeanCondition，OnClassCondition，OnWebApplicationCondition 进行判断

3. 筛选出容器所需要加载的自动配置类并将 xxxAutoConfiguration 组件加入到容器中，由每一个自动配置类进行自动配置。



以 *EmbeddedWebServerFactoryCustomizerAutoConfiguration* 为例，自动配置类的自动配置流程如下：

1. @ConditionalOnWebApplication：考虑当前应用是否是 Web 应用，如果是 Web 应用，当前自动配置类才会生效。

2. 自动配置类生效时，通过 @EnableConfigurationProperties 注解引入了一个自动配置属性类 ServerProperties.class，帮助我们引入配置属性

   1. 在 ServerProperties 中的注解如下：

      ~~~java
      @ConfigurationProperties(prefix = "server", ignoreUnknownFields = true)
      ~~~

      此注解表明，从配置文件中以 *server* 开头的配置信息与此类中的属性进行绑定，然后进行配置。

   2. 默认情况下，SpringBoot 依赖的 jar 包中包含了 spring-configuration-metadata.json 文件，这些文件中保存了所有的缺省配置项，如：

      ~~~json
      {
      "name": "server.port",
      "type": "java.lang.Integer",
      "description": "Server HTTP port.",
      "sourceType": "org.springframework.boot.autoconfigure.web.ServerProperties",
      "defaultValue": 8080
      }
      ~~~

      所以，如果我们自己没有配置 server.port 则会使用 spring-configuration-metadata.json 文件中的默认值 8080。

3. 在引入配置属性后，自动配置类根据情况通过 @Bean 注解向容器中加入需要用到的各种组件。

   ~~~java
   @Bean
   public TomcatWebServerFactoryCustomizer tomcatWebServerFactoryCustomizer(Environment environment, ServerProperties serverProperties) {
       return new TomcatWebServerFactoryCustomizer(environment, serverProperties);
   }
   ~~~



> 注：使用 @Bean 向容器中添加组件时，如果方法中包含参数，参数的值将会从容器中进行获取（先按类型获取组件，如果有多个值，再按参数名进行匹配）。



SpringBoot 底层 @Conditional 注解：当 @Conditional 指定的条件成立时才给容器中添加组件或者是配置文件里面的所有内容才生效。

@Conditional 衍生注解：

1. @ConditionalOnJava：系统的 java 版本是否符合要求
2. @ConditionalOnBean：容器中存在指定 Bean
3. @ConditionalOnMissingBean：容器中不存在指定 Bean
4. @ConditionalOnExpression：满足 SpEL 表达式指定的规则
5. @ConditionalOnClass：系统中有指定的类
6. @ConditionalOnMissingClass：系统中没有指定的类 
7. @ConditionalOnSingleCandidate：容器中只有一个指定的 Bean，或者这个 Bean 是首选 Bean
8. @ConditionalOnProperty：系统中是否配置了某属性值
9. @ConditionalOnResource：类路径下是否存在指定资源文件
10. @ConditionalOnWebApplication：当前应用是 Web 应用
11. @ConditionalOnNotWebApplication 当前应用不是 Web 应用
12. @ConditionalOnJndi：JNDI 存在指定项



> 在调试 SpringBoot 应用是，可以在配置文件中指定 debug=true 来打印更多信息。



---

### 5.SpringBoot 配置

SpringBoot 使用一个全局的配置文件，配置文件名是固定的：***application.properties***，***application.yml***。

我们可以在配置文件当中修改自动配置的默认值，SpringBoot 启动时就会根据配置文件中的相关信息进行应用配置。

配置文件放在 ***src/main/resources*** 目录或者类路径的 ***config*** 目录下。



> 在 IDEA 中，properties 文件的默认字符集为 GBK，如果配置项有中文则会出现乱码，可以在 Editor --> File Encodings 中更改默认字符集。



*YAML*（**Y**AML **A**in't a **M**arkup **L**anguage / **Y**et **A**nother **M**arkup **L**anguage），YAML 不是一种标记语言，但仍是另外的一种标记语言。

YAML 的语法和其他高级语言类似，并且可以简单表达清单、散列表，标量等数据形态。它使用。空格进行缩进，特别适合用来表达或编辑数据结构、各种配置文件、倾印调试内容、文件大纲等。YAML 的配置文件后缀为 ***.yml***，如：***application.yml*** 。

配置实例：

~~~yaml
server:
 port: 8080
~~~

YAML 的基本语法：

- 使用空格表示层级关系，空格可以多个，但同一层级的元素一定要左对齐。
- 对象键值对使用冒号加空格表示，**key: value**。
- 大小写敏感。
- 使用 **#** 表示注释。

YAML 支持的数据类型：

- 字面量：数字、字符串、布尔和日期键值对，如：***key: value***，默认字符串不需要加双引号（也可以加）并支持转义符；如果给字符串加上单引号，单引号中的特殊字符将会被转义为普通字符数据。

- 对象：对象有两种写法

  - 键值对集合：

    ~~~yaml
    user:
     name: James
     age: 25
    ~~~

  - 行内写法：

    ~~~yaml
    user: {name: James,age: 25}
    ~~~

- 数组：数组同样也有两种写法

  - 写法一：

    ~~~yaml
    pets: 
      - dog
      - cat
      - pig
    ~~~

  - 行内写法：

    ~~~yaml
    pets: [dog,cat,pig]
    ~~~

> YAML 文档块：YAML 支持将一个文档的内容进行切分，文档块之间使用 3 个横线进行切分
>
> ~~~yaml
> server:
>  port: 8081
>   
> ---
> 
> server:
>  port: 8083
> ~~~



SpringBoot 配置文件中值的获取：在 SpringBoot 中，可以通过 *@ConfigurationProperties*，*@Value* 注解获取配置文件中的值。

在开发中，我们可以引入 `spring-boot-configuration-processor`，可以帮助我们处理配置信息，在编写配置文件时给出提示等。

~~~xml
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-configuration-processor</artifactId>
   <optional>true</optional>
</dependency>
~~~



- `@ConfigurationProperties`：标注在类中，将配置文件中的属性值与注入到类的同名属性值中。

  ```java
  @Data
  @Component
  @ConfigurationProperties(prefix = "user")
  public class SysUser {
      private String username;
      private LocalDate birthday;
      private List<String> pets;
  	//将字符串绑定到 LocalDate 属性上
      public void setBirthday(String date){
          this.birthday = LocalDate.parse(date);
      }
  }
  ```

  - 要获取配置文件中的属性值，标注此注解的类必须加入到 SpringBoot 容器中进行管理。
  - 在 *@ConfigurationProperties* 注解中必须指定属性前缀，容器才能识别对应属性。
  - 当 JavaBean 中含有复杂对象属性时，可以改写属性的 set 方法将配置文件中的值绑定到该属性上。

  配置文件：

  ```yaml
  user:
    username: Niko
    birthday: 1920-11-08
    pets:
      - dog
      - cat
  ```

- `@Value`：标注在属性上，将为该属性赋值。

  ```java
  @Data
  @Component
  @ConfigurationProperties(prefix = "user")
  public class SysUser {
      @Value("${user.username}")
      private String username;
      @Value("#{T(java.time.LocalDate).parse('${user.birthday}')}")
      private LocalDate birthday;
      @Value("${user.pets}")
      private List<String> pets;
  }
  ```

  配置文件：

  ```yaml
  user:
    username: Niko
    birthday: 1995-11-08
    pets: dog,cat
  ```

  ***@Value*** 中支持的写法：

  - 字面量（支持运算符）：@Value("hello")，@Value("5+3")，@Value("5 > 3 ? 1 : 0") 等。
  - ${} + 属性值：${user.username}，与配置文件中的属性值绑定。
  - #{} + ***spel*** 表达式：[spel 官网地址](https://docs.spring.io/spring-framework/docs/4.2.x/spring-framework-reference/html/expressions.html)，在 spel 表达式中，我们可以使用容器中的组件，调用其方法，也可以调用静态方法，静态变量，同时也支持运算符，可以获取数组元素 `#{array[0]}`，还可以直接 new 对象进行方法调用 `#{new Xxx().xxx()}`。

  > `@Value` 无法识别 yaml 配置文件中的数组等复杂数据结构，只能将数组写为逗号分割的字符串进行识别，或者使用 *ConfigurationProperties* 进行注入。

 *@ConfigurationProperties* 与 *@Value* 的区别：

| 功能                                         | *@ConfigurationProperties* | *@Value* |
| -------------------------------------------- | -------------------------- | -------- |
| 属性松散绑定（下划线，短横线，驼峰相互转换） | 支持                       | 不支持   |
| spel 表达式                                  | 不支持                     | 支持     |
| JSR303 数据校验                              | 支持                       | 不支持   |
| 复杂数据类型封装                             | 支持                       | 不支持   |



外部配置文件引入：

- `@PropertySource(value = {"classpath:user.properties"})`：将外部的配置文件与当前类进行绑定，然后配合 *@ConfigurationProperties*，*@Value* 进行使用。

  ```java
  @Data
  @Component
  @ConfigurationProperties(prefix = "user")
  @PropertySource(value = {"classpath:user.properties"})
  public class SysUser {
      private String username;
      private LocalDate birthday;
      private List<String> pets;
  
      public void setBirthday(String date){
          this.birthday = LocalDate.parse(date);
      }
  }
  ```

  此时 user 的相关配置写在了单独的 *user.properties* 文件中。

- `@ImportResource(locations = {"classpath:beans.xml"})`：引入 spring 的配置文件（只能是 xml 文件），将此注解标注在配置类上，该配置文件就会生效。

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
      <beans>
          <bean class="com.star.demo.config.SysUser" id="myUser">
              <property name="username" value="star"/>
              <property name="birthday" value="1995-09-20"/>
              <property name="pets" value="dog,cat,pig"/>
          </bean>
      </beans>
  </beans>
  ```

  主配置类：

  ```java
  @SpringBootApplication
  @ImportResource(locations = {"classpath:beans.xml"})
  public class DemoApplication {
  
     public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
     }
  
  }
  ```

  此时，容器中就添加进来了 id 为 myUser 的组件（在 SpringBoot 中，可以直接使用 @Bean 向容器中添加组件）。



配置文件占位符：在 properties 或 yml 配置文件中，我们可以使用 ***${}*** 来做配置文件占位符使用。

- 使用随机数函数：

  ```properties
  user.birthday=1995-11-${random.int(10,30)}
  ```

  还有另外的随机函数，在 IDEA 中会进行提示。

- 使用其他配置项：

  ```properties
  user.username=Niko
  user.description=${user.username} is an excellent programmer
  ```

- 指定默认值：

  ```properties
  user.description=${user.username:James} is an excellent programmer
  ```

  使用当未定义 user.username 的值时，则使用 James 作为此表达式的值。



SpringBoot 多配置文件 Profile：Profile 是 Spring 对不同环境提供不同配置功能的支持，可以通过激活、指定参数等方式快速切换环境。

可以使用多文件（application-xxx.properties）或多文档块（application.yml）的方式实现多环境：

指定方式：

```properties
spring.profiles=prod
```

激活方式：

- 在主配置文件中或者 yml 文件的第一个文档块中进行指定

  ~~~properties
  spring.profiles.active=prod
  ~~~

- 使用命令行参数：

  ~~~shell
  [root@localhost ~]# nohup java -jar demo-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
  ~~~

- 使用 jvm 参数：

  ~~~properties
  –Dspring.profiles.active=prod
  ~~~

  

常用的 SpringBoot 配置文件加载位置（优先级从高到低）：

1. jar:./config/，即运行的 jar 包目录下的 config 文件夹。
2. jar:./，即运行的 jar 包目录。
3. file:./config/，即当前项目根目录下的 config 文件夹。
4. file:./config/*/，即当前项目根目录下的 config/\*/ 文件夹。
5. file:./，即当前项目的根目录。
6. classpath:/config/，即当前项目的 src/main/resources/config/ 文件夹。
7. classpath:/，即当前项目的 src/main/resources/ 文件夹。

以上 5 个位置都可以存放 SpringBoot 配置文件，SpringBoot 在启动时，会从高优先级的配置文件开始读取；如果容器已经加载过某配置项，当再次读取到该配置时，会进行忽略；不同优先级的不同的配置项则会进行互补配置。

> 注：启动项目时我们可以使用命令行 *spring.config.location* 手动添加配置文件加载位置，多个加载位置以逗号隔开，优先级从低到高，手动指定的配置文件与其他配置一起形成互补配置。
>
> ~~~shell
> java -jar demo-0.0.1-SNAPSHOT.jar --spring.config.location=D:/config/
> ~~~

除了内部配置文件，SpringBoot 还可以从外部读取配置文件，SpringBoot 常用的配置加载位置优先级如下：

1. 命令行参数：通过 java -jar 启动时加入的配置信息，此优先级最高。

2. 加载 application 配置文件：

   1. jar 包外部的 application-{profile}.properties 或 application-{profile}.yml 配置文件。
   2. jar 包内部的 application-{profile}.properties 或 application-{profile}.yml 配置文件。
   3. jar 包外部的 application.properties 或 application.yml 配置文件。
   4. jar 包内部的 application.properties 或 application.yml 配置文件。

   > 含 profile 的配置文件优先级总是高于不含 profile 的配置文件；其次，jar 包外部的配置文件优先级总是高于 jar 包内部的配置文件；然后才是按照配置文件加载位置的优先级进行加载。

3. @Configuration 注解类上的 @PropertySource：例如，某配置类从 xxx.properties 中加载了 user.name=xx 到该配置类中，同时 application.properties 中也配置了 user.name=yy 项，则此时起作用的是 application.properties 中的 user.name=yy。

4. 通过 SpringApplication.setDefaultProperties 指定默认属性：

   ```java
   @SpringBootApplication
   public class DemoApplication {
      public static void main(String[] args) {
         SpringApplication application = new SpringApplication(DemoApplication.class);
         application.setDefaultProperties(Collections.singletonMap("server.port", 8889));
         application.run(args);
      }
   }
   ```

完整的 SpringBoot 配置加载优先级可以参考官方文档：[官方文档](https://docs.spring.io/spring-boot/docs/2.3.4.RELEASE/reference/htmlsingle/#boot-features-external-config)



---

### 6.SpringBoot 日志

**日志框架**

目前对于日志系统来说，一般都有一个统一的接口层，然后再给项目中导入具体的日志实现。

目前市面上的日志框架：

- 抽象层：JCL（Jakarta Commons Logging/Apache Commons Logging）、slf4j(Simple Logging Facade for Java)、Jboss-logging...
- 实现层：JUL（java.util.logging）、log4j、log4j2、logback...

在使用，我们一般挑选一个抽象层和一个实现层组成我们的日志框架进行使用：

- 抽象层：~~JCL~~（最后一次更新是在 2014 年，太旧了）、slf4j、~~Jboss-logging~~（一般是一些特定的框架使用，不适用于普通系统）
- ~~JUL~~（功能不够强大）、~~log4j~~（与 slf4j、logback 是同一个作者，但是不如 logback 先进）、~~log4j2~~（Apache 开发的日志框架，功能比较完善，但是与之适配的日志抽象层太少）、logback（与 slf4j 是同一个作者编写，适配性高）

所以，最终 SpringBoot1.x 选用的日志框架是 slf4j + logback，而 SpringBoot2.x 同时保留了 slf4j 和 JCL 两种日志抽象以及 logback 日志实现。



> 在使用日志时，不应该直接调用日志的实现类，而是应该调用日志的抽象层中的方法。



**slf4j 日志**

slf4j 官网：https://www.slf4j.org

slf4j + logback 日志框架的使用：

1. 导入 slf4j 和 logback 的 jar 包（SpringBoot 应用已默认导入）

2. 在代码中引入日志记录器：

   ~~~java
   import org.slf4j.Logger;
   import org.slf4j.LoggerFactory;
   
   public class HelloWorld {
     public static void main(String[] args) {
       Logger logger = LoggerFactory.getLogger(HelloWorld.class);
       logger.info("Hello World");
     }
   }
   ~~~

   我们只需要使用 LoggerFactory 引入日志记录器进行日志记录，最终会由引入的 logback 实现进行日志输出。



**slf4j 日志适配**

问题：假如我的项目中使用到了一些不同的框架如 Spring（使用 commons-logging）、Hibernate（使用 Jboss-logging）等，如何将这些不同的日志框架进行统一，使用 slf4j 进行输出？

针对此种问题，slf4j 提供了一系列的日志替换包：

- 排除项目中的 commons-logging.jar，使用 jcl-over-slf4j.jar，可以将 commons-logging 转换为 slf4j 输出。

- 排除项目中的 log4j.jar，使用 log4j-over-slf4j.jar，可以将 log4j 转换为 slf4j 输出。

- 为项目引入 jul-over-slf4j.jar，可以将 java.util.logging 转换为 slf4j 输出。

将其他日志框架替换为 slf4j 后，我们再引入 slf4j 的实现包如：slf4j-jdk14.jar、（logback-classic.jar + logback-core.jar）、slf4j-log412.jar 等，就可以实现将其他日志框架由 slf4j 统一进行输出。



**SpringBoot 与 slf4j 日志适配**

在 SpringBoot 中，使用 *spring-boot-starter-logging* 作为整个日志框架的基础，引入了 logback-classic，log4j-to-slf4j，jul-to-slf4j 与其他日志框架进行适配。

在 SpringBoot1.x 中，默认排除了 JCL 等其他日志框架，统一使用 slf4j 进行输出，而在 SpringBoot2.x 中，SpringBoot 并未排除 JCL，其内部使用的就是 JCL 进行日志输出，同时还引入了 slf4j，我们在开发中一般选用 slf4j + logback 进行日志输出。

在 SpringBoot 项目中我们如果使用了包含 log4j.jar 的第三方 jar 包，我们只需要对 log4j.jar 进行排除，我们的 SpringBoot 项目便可以自动适配所有的日志并以 logback 进行日志输出。



**SpringBoot 与日志**

日志级别：trace >> debug >> info >> warn >> error

我们可以调整需要输出的日志级别，当设置为某一日志级别后，日志只会打印此级别以及更高级别的日志信息，如：日志级别为 info 时，只会输出 info、warn、error 级别的日志。

SpringBoot 日志级别设置：

~~~properties
# 设置 com.star.demo 包下的日志输出级别为 debug
logging.level.com.star.demo=debug
~~~

其他没有被设置日志输出级别的包将会使用 SpringBoot 默认的日志输出级别 info。

其他日志设置：

1. 日志路径指定：
   1. 指定日志文件名及路径：

      ~~~properties
      logging.file.name=F:/spring.log
      ~~~

   2. 指定日志路径：

      ~~~properties
      logging.file.path=F:/
      ~~~

      logging.file.name 与 logging.file.path 是两个相互冲突的配置，当同时配置时 logging.file.name 生效，使用 logging.file.path 时，SpringBoot 默认以 *spring.log* 作为日志文件名。

2. 日志输出格式设置：

   1. 日志文件输出格式：logging.pattern.file
   2. 控制台日志输出格式：logging.pattern.console

   > 日志输出格式定义：
   >
   > 1. %d 表示日期时间，如：%d{yyyy-MM-dd HH:mm:ss.SSS} 表示将日期按照 {} 内的格式进行输出
   >
   > 2. %t 或 %thread 表示线程名
   >
   > 3. %‐5p 或 %‐5level 日志级别输出，输出占 5 个字符宽度且靠左输出（%5p 表示靠右输出）
   >
   > 4. %-40.40logger{39} 表示 logger 所在类的全类名，名字最长 39 个字符，当全类名达到 40 长度时，按照句点进行分割
   >
   >    如：org.springframework.boot.web.embedded.tomcat.TomcatWebServer >> 输出为 >> o.s.b.w.embedded.tomcat.TomcatWebServer
   >
   > 5. %line 表示日志输出位置（行数）
   >
   > 6. %n 是换行符
   >
   > 7. %msg 或 %m 日志消息，如：%m%n 表示输出日志消息后换行

SpringBoot 默认使用 logback 作为日志输出，配置日志输出的 xml 文件位置：

spring-boot-2.4.1.jar >> org.springframework.boot.logging.logback >> base.xml

在 SpringBoot 中，容器启动时 LoggingApplicationListener 会进行初始化，将我们在配置文件中配置的信息将会封装到 LoggingSystemProperties 一些常量中，如：

~~~java
setSystemProperty(resolver, FILE_LOG_PATTERN, "pattern.file");
~~~

然后 logback 的 base.xml 等日志配置文件就会对其进行引用，如：

~~~xml
<property name="FILE_LOG_CHARSET" value="${FILE_LOG_CHARSET:-default}"/>
~~~



**logback.xml**

当我们需要使用 logback 的更多高级功能时，可以就自己定义 logback.xml 文件：

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="2 minute" debug="false"
        xmlns="http://ch.qos.logback/xml/ns/logback"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://ch.qos.logback/xml/ns/logback
        https://raw.githubusercontent.com/enricopulatzo/logback-XSD/master/src/main/xsd/logback.xsd">

    <!-- 定义日志的根目录 -->
    <property name="LOG_HOME" value="D:/log" />
    <!-- 控制台输出 appender -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <charset>UTF-8</charset>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
        </encoder>
    </appender>
    <!-- 文件输出 appender -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 指定日志文件的名称 -->
        <file>${LOG_HOME}/my.log</file>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/my.%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <maxFileSize>1MB</maxFileSize>
            <maxHistory>30</maxHistory>
            <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
    </appender>

    <logger name="com.star.cache.service" level="DEBUG" additivity="true">
        <!-- 将 com.star.cache.service 包下的日志信息输出到文件，同时打印到控制台 -->
        <appender-ref ref="FILE"/>
    </logger>

    <root level="DEBUG">
        <!-- 所有的日志信息都打印到控制台 -->
        <appender-ref ref="CONSOLE"/>
    </root>
</configuration>
~~~

各种标签及意义：

- configuration：logback 配置文件的根节点

  - scan：当此属性设置为 true 时，配置文件如果发生改变，将会被重新加载，默认为 true。
  - scanPeriod：检测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒；当 scan 为 true 时此属性生效；默认的时间间隔为 1 分钟。
  - debug：此属性设置为 true 时，将打印出 logback 内部日志信息，实时查看 logback 运行状态，默认值为 false。

- property：定义一个属性，可以在配置文件 其他地方进行调用。

- conversionRule：转换规则，将日志信息进行转换，可自定义（SpringBoot 中可使用此标签配置转换器实现控制台彩色输出）

- appender：logback 委派任务将日志事件写入名为 appender 的组件，appender 必须实现 ch.qos.logback.core.Appender。

  常见的 appender：

  1. ConsoleAppender：在控制台进行输出的 appender。
  2. FileAppender：将日志输出到文件的 appender。
  3. RollingFileAppender：FileAppender 的扩展类，提供了切割日志文件的功能。

  appender 内部标签：

  - layout：在 logback 0.9.19 版本之前，我们依赖于一个布局来将事件转换成字符串；在 0.9.19 版本之后，logback 引入了 encoder（编码器） 来进行日志输出。

    ~~~xml
    <layout class="ch.qos.logback.classic.PatternLayout">
        <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
    </layout>
    ~~~

    注：layout 标签需要指定采用的 layout class 的全类名来实例化，缺省值为 ch.qos.logback.classic.PatternLayout。

  - file：指定日志输出的文件名（当日志输出到文件时有效）

  - encoder：编码器，在 0.9.19 版本后引入，负责将事件转换成字节数组，并将字节数组写入 OutputStream

    ~~~xml
    <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
        <charset>utf-8</charset>
        <immediateFlush>true</immediateFlush>
        <outputPatternAsHeader>false</outputPatternAsHeader>
        <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
    </encoder>
    ~~~

    - charset：指定日志的字符集。

    - immediateFlush：当产生日志时是否立即将日志写入到磁盘中，默认为 true。

      > 为 true 时，当产生大量日志时，可能引发性能问题；为 false 时，如果系统突然宕机，可能会丢失部分日志。

    - outputPatternAsHeader：是否在日志顶部插入日志输出的模式，默认为 false。

    - pattern 或 layout 标签：两个标签都可以用来指定日志输出格式。

    注：与 layout 一样，encoder 也需要指定采用的 encoder class 的全类名来实例化，目前为止，有且仅有 ch.qos.logback.classic.encoder.PatternLayoutEncoder 这一个 encoder。

  - filter：如果我们需要在特定的 appender 中只输出特定条件下的日志，此时就需要用到 filter，过滤器有很多种（此处介绍最常用的 2 种）：

    - LevelFilter：精确的匹配日志事件的级别，然后根据 onMatch 和 onMismatch 选择对事件的处理

      ~~~xml
      <filter class="ch.qos.logback.classic.filter.LevelFilter">
          <level>DEBUG</level>
          <onMatch>ACCEPT</onMatch>
          <onMismatch>DENY</onMismatch>
      </filter>
      ~~~

      此时，appender 仅输出 DEBUG 日志。

    - ThresholdFilter：阈值筛选器，将事件过滤到指定的阈值之下，大于等于阈值的事件将会被 match

      ~~~xml
      <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
          <level>DEBUG</level>
          <onMatch>ACCEPT</onMatch>
          <onMismatch>DENY</onMismatch>
      </filter>
      ~~~

      此时，appender 输出 DEBUG、INFO、WARN、ERROR 日志。

  - triggeringPolicy：日志轮转触发策略，此触发器目前只有一个实现类 ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy，且只支持一个参数 maxFileSize，即只支持按文件大小进行滚动，我们用得更多的是 rollingPolicy。

  - rollingPolicy：日志轮转策略，一般我们使用最多的是 ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy，同时按照时间和文件大小进行滚动

    ~~~xml
    <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
        <fileNamePattern>${LOG_FILE}.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
        <cleanHistoryOnStart>false</cleanHistoryOnStart>
        <maxFileSize>10MB</maxFileSize>
        <totalSizeCap>0</totalSizeCap>
        <maxHistory>7</maxHistory>
        <maxIndex>5</maxIndex>
        <minIndex>1</minIndex>
    </rollingPolicy>
    ~~~

    - fileNamePattern：${LOG_FILE}.%d{yyyy-MM-dd}.%i.gz
      - %d{yyyy-MM-dd}：按天进行日志滚动，如果时间精确到小时，则按小时进行滚动。
      - %i：当文件大小超过 maxFileSize 时，按照 i 进行文件滚动，默认从 0 开始。
    - cleanHistoryOnStart：在项目启动时是否删除旧的日志文件，默认为 false。
    - maxFileSize：单个日志文件的最大大小。
    - totalSizeCap：设置所有日志文件的总大小，所有日志文件大小之和超过此值时，将会自动删除旧日志文件，0 表示不限制。
    - maxHistory：日志保存的最长时间，如 n 天（小时）...
    - maxIndex 和 minIndex：设置 %i 的范围，当产生的文件数量超过此范围时，最旧的日志文件将会被删除（一般不进行设置）

    > rollingPolicy 的属性都可以在 application.properties 中进行配置，如：logging.logback.rollingpolicy.max-file-size=10MB

- logger：用来设置某一个包或者具体的某一个类的日志打印级别

  ~~~xml
  <logger name="com.star.cache.service" level="DEBUG" additivity="false">
      <appender-ref ref="STDOUT"/>
  </logger>
  ~~~

  - name：指定具体的包名或类名。
  - level：此包（类）名下的日志打印级别。
  - additivity：是否向上级（root）传递事件信息，默认为 true；如果 root 中也配置了 appender，则此包（类）下的日志将会同时通过 logger 和 root 中的 appender 进行输出；如果不希望日志重复输出，可以设为 false，此时 logger 处理了日志事件后就不会传递给 root。

- root：事实上，root 也是一个 logger 元素，但是它是根 logger，只有一个 level 属性，所有的类都会匹配到 root 进行日志事件处理。

  ~~~xml
  <root level="WARN">
      <appender-ref ref="STDOUT" />
  </root>
  ~~~

  > 同一个 logger 或 root 可以包含多个 appender-ref，此时日志事件将会传递到所有的 appender 进行输出。



**SpringBoot 与日志配置文件**

> SpringBoot 支持自定义日志配置文件：
>
> | Logging System           | Customization                                                |
> | ------------------------ | ------------------------------------------------------------ |
> | Logback                  | logback-spring.xml or logback-spring.groovy or logback.xml or logback.groovy |
> | Log4j2                   | log4j2-spring.xml or log4j2.xml                              |
> | JUL（Java Util Logging） | logging.properties                                           |
>
> 将文件直接放在 /src/main/resources/ 下即可生效。
>
> SpringBoot 官方建议使用 logxxx-spring.xml，logxxx.xml 会直接被日志框架识别，而 logxxx-spring.xml 被 SpringBoot 解析，所以可以使用 profile 等功能：
>
> ~~~xml
> <springProfile name="staging">
>  <!-- configuration to be enabled when the "staging" profile is active -->
> </springProfile>
> 
> <springProfile name="dev | staging">
>  <!-- configuration to be enabled when the "dev" or "staging" profiles are active -->
> </springProfile>
> 
> <springProfile name="!production">
>  <!-- configuration to be enabled when the "production" profile is not active -->
> </springProfile>
> ~~~
>
> 常见的配置示例：
>
> ~~~xml
> <!-- 当启用 dev 环境时，使用此 logger 进行日志输出 -->
> <springProfile name="dev">
>     <logger name="com.star.demo" level="debug"/>
> </springProfile>
> ~~~



---

### 7.SpringBoot Web



















---

### 8.SpringBoot 数据访问