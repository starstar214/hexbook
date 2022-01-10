.SpringBoot 官网：[https://spring.io/projects/spring-boot/](https://spring.io/projects/spring-boot/)

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

![](../img/Snipaste_2020-10-31_01-47-11.png)

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



SpringBoot 自定义 Starter：

需要用到的注解：

1. @Configuration：指定配置类
2. @ConditionalOnXxx：在指定条件成立的情况下自动配置类生效 
3. @AutoConfigureAfter：指定自动配置类的顺序 
4. @Bean：给容器中添加组件
5. @ConfigurationPropertie：结合相关 xxxProperties 类来绑定相关的配置 
6. @EnableConfigurationProperties：让 xxxProperties 生效加入到容器中 

此外，还要将需要启动就加载的自动配置类，配置在 META‐INF/spring.factories 中。

启动器设计规约：

1. 通常来说，SpringBoot Starter 启动器应该只用来做依赖导入，它是一空的 jar 包，用来提供辅助性依赖管理，不应该存在任何的 java 代码。
2. 专门来写一个自动配置模块 xxx-starter-autoconfigure 用来向容器当中添加组件，启动器来依赖自动配置模块，使用时直接引入 starter 即可。
3. 另外具体的场景业务代码也放在单独的模块中，由自动配置模块引入。
4. 命名：
   1. 官方启动器：spring-boot-starter-xxx，如：spring-boot-starter-web
   2. 自定义启动器：xxx-spring-boot-starter，如：druid-spring-boot-starter
   3. 官方自动配置类：spring-boot-autoconfigure-xxx，如：spring-boot-autoconfigure-processor
   4. 自定义自动配置类：xxx-spring-boot-autoconfigure，如：mybatis-spring-boot-autoconfigure

自定义 Starter 步骤：

1. 使用`Spring Initializr`添加 demo-spring-boot-autoconfigure 模块，引入需要的业务依赖。

   1. 添加 properties 文件：

      ~~~java
      @Data
      @Component
      @ConfigurationProperties("demo.greet")
      public class GreetProperties {
          private String title;
          private String greeting;
      }
      ~~~

   2. 编写业务代码：

      ~~~java
      @Data
      public class GreetService {
          private GreetProperties properties;
      
          public String greet(String name) {
              String title;
              if ((title = properties.getTitle()) == null) {
                  title = "";
              }
              return properties.getGreeting() + "，" + name + title;
          }
      }
      ~~~

   3. 编写自动配置类将 GreetService 加入到容器中：

      ~~~java
      @Configuration
      @ConditionalOnWebApplication
      @EnableConfigurationProperties(GreetProperties.class)
      public class GreetAutoConfiguration {
          @Autowired
          private GreetProperties greetProperties;
          @Bean
          public GreetService greetService() {
              GreetService service = new GreetService();
              service.setProperties(greetProperties);
              return service;
          }
      }
      ~~~

   4. 在 spring.factories 中添加 GreetAutoConfiguration：

      ~~~properties
      org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
      com.star.demo.autoconfigure.GreetAutoConfiguration
      ~~~

2. 添加 maven 模块 demo-spring-boot-starter 引入 demo-spring-boot-autoconfigure。

3. 在其他项目中引入 demo-spring-boot-starter 并进行 GreetProperties 配置即可使用 GreetService 组件。



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

- trace：极其详细的系统运行信息；默认情况下，既不打印到终端也不输出到文件（请不要在业务代码中使用）

- debug：终端查看、在线调试；该级别日志默认情况下会打印到终端输出，但是不会归档到日志文件；此级别一般用于开发者在程序当前启动窗口上，查看日志流水信息。

- info：报告程序进度和状态信息

  - 程序进度：系统状态、业务状态的变更；业务逻辑的分步骤。
  - 状态信息：客户端请求参数；第三方接口的调用参数和调用结果。

  > 调用其他第三方服务时，所有的出参和入参是必须要记录的（因为你很难追溯第三方模块发生的问题）

- warn：不应该出现但是不影响程序、不影响当前请求正常运行的异常情况

  - 有容错机制的时候出现的错误情况
  - 找不到配置文件，但是系统能自动创建配置文件
  - 某参数即将接近临界值时，如：缓存池占用达到警告线
  - 业务异常的记录，如：当接口抛出业务异常时，应该记录此异常

- error：影响到程序正常运行、影响当前请求正常运行的异常情况；如：打开配置文件失败、第三方接口异常，以及 SQLException 等影响功能使用的异常。

  > 如果进行了抛出异常操作，请不要打印 error 日志，如：
  >
  > ~~~java
  > try{
  >     //......
  > }catch（Exception e）{
  >     String message = "An error occurred when process business";
  >     log.error(message, e);
  >     throw new ServiceException(message, e);
  > }
  > ~~~
  >
  > 请不要像这样记录 error 日志，此时错误日志应该由异常的最终处理方进行记录。

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

**RESTful API**

RESTful API 是目前最流行的 API 设计规范，用于 Web 数据接口的设计。

URL 设计：动词 + 宾语

- 动词：通常就是五种 HTTP 方法，对应 CRUD 操作。
  - GET：读取（Read）
  - POST：新建（Create）
  - PUT：更新（Update）
  - PATCH：更新（Update），通常是部分更新
  - DELETE：删除（Delete）
- 宾语：宾语就是 API 的 URL，是 HTTP 动词作用的对象。它应该是名词，不能是动词。比如，/articles 这个 URL 就是正确的，而 /getAllCars、/createNewCar、/deleteAllRedCars 等 URL 不是名词，所以都是错误的。

> 避免多级 URL：
>
> 在开发中常见的情况：资源需要多级分类，因此很容易写出多级的 URL，比如获取某个作者的某一类文章：GET /authors/12/categories/2
>
> 这种 URL 不利于扩展，语义也不明确，往往要想一会，才能明白含义；更好的做法是，除了第一级，其他级别都用查询字符串表达：GET /authors/12?categories=2
>
> 还有一个例子：查询已发布的文章
>
> 1. GET /articles/published
> 2. GET /articles?published=true
>
> 很明显，published 并不是名词，第二种查询字符串的写法更好。



**HTTP 状态码**

在服务器通讯过程中，客户端的每一次请求，服务器都必须给出回应。回应包括 HTTP 状态码和数据两部分。

HTTP 状态码就是一个三位数，分成五个类别：1xx（相关信息，服务器 API 不需要 1xx 状态码）、2xx（操作成功）、3xx（重定向）、4xx（客户端错误）、5xx（服务器错误）

2xx 状态码表示操作成功：

1. 20x：不同的 HTTP 方法可以返回操作成功的更精确的状态码，如：GET >> 200 OK、POST >> 201 Created、PUT >> 200 OK、PATCH >> 200 OK、DELETE >> 204 No Content（资源已删除，不存在）
2. 202：Accepted，表示服务器已经收到请求，但还未进行处理，会在未来再处理，通常用于异步操作。

在收到 3xx 状态码后，浏览器不会自动跳转，而会让用户自己决定下一步怎么办。下面是一个例子。

1. 302、307：See Other，表示参考另一个 URL，用于 GET 请求。
2. 303：See Other，表示参考另一个 URL，用于 POST、PUT、DELETE 请求。

4xx 状态码表示客户端错误，主要有下面几种

1. 400 Bad Request：服务器不理解客户端的请求，未做任何处理。
2. 401 Unauthorized：用户未提供身份验证凭据，或者没有通过身份验证。
3. 403 Forbidden：用户通过了身份验证，但是不具有访问资源所需的权限。
4. 404 Not Found：所请求的资源不存在，或不可用。
5. 405 Method Not Allowed：用户已经通过身份验证，但是所用的 HTTP 方法不在他的权限之内。
6. 410 Gone：所请求的资源已从这个地址转移，不再可用。
7. 415 Unsupported Media Type：客户端要求的返回格式不支持。比如，API 只能返回 JSON 格式，但是客户端要求返回 XML 格式。
8. 422 Unprocessable Entity：客户端上传的附件无法处理，导致请求失败。
9. 429 Too Many Requests：客户端的请求次数超过限额。

5xx 状态码表示服务端错误。一般来说，API 不会向用户透露服务器的详细信息，所以只要两个状态码就够了：

1. 500 Internal Server Error：客户端请求有效，服务器处理时发生了意外。
2. 503 Service Unavailable：服务器无法处理请求，一般用于网站维护状态。



**统一接口返回格式**

我们在开发中经常会涉及到 server 和 client 的交互，目前比较流行的是基于 json 格式的数据交互，但是 json 只是消息的格式，其中的内容还需要我们自行设计；不管是 HTTP 接口还是 RPC 接口保持返回值格式统一很重要，这将大大降低 client 的开发成本。

返回值 json 的四要素：

1. boolean success ；是否成功。
2. T data ；成功时具体返回值，失败时为 null 。
3. Integer code ；成功时返回 0 ，失败时返回具体错误码。
4. String message ；成功时返回 null ，失败时返回具体错误消息。

在 SpringBoot 中，实现统一 API 格式返回：

1. 定义枚举类：

   ~~~java
   @Getter
   public enum ResultStatus {
   
       SUCCESS(200, "OK"),
       FAIL(500, "服务器异常");
   
       private Integer code;
   
       private String message;
   
       ResultStatus(Integer code, String message) {
           this.code = code;
           this.message = message;
       }
   }
   ~~~

2. 定义返回对象结构：

   ~~~java
   @Data
   public class Result<T> {
       private boolean success;
       private Integer code;
       private String message;
       private T data;
   
       public static <T> Result<T> success(T data){
           Result<T> result = new Result<>();
           result.setSuccess(true);
           result.setCode(ResultStatus.SUCCESS.getCode());
           result.setMessage(ResultStatus.SUCCESS.getMessage());
           result.setData(data);
           return result;
       }
   
       public static Result<Void> failure(ResultStatus status){
           Result<Void> result = new Result<>();
           result.setSuccess(false);
           result.setCode(status.getCode());
           result.setMessage(status.getMessage());
           return result;
       }
   }
   ~~~

3. 使用 AOP 对 Controller 的返回值进行全局处理，不用再每一个方法中进行 Result 包装，只需要定义我们自己想要返回的格式即可

   ~~~java
   @RestControllerAdvice
   public class ResultAdvice implements ResponseBodyAdvice<Object> {
   
       private static final Class<? extends Annotation> TARGET_ANNOTATION = ResponseBody.class;
   
       @Override
       //方法返回 true 时，执行 beforeBodyWrite 方法
       public boolean supports(MethodParameter methodParameter, Class<? extends HttpMessageConverter<?>> aClass) {
           //方法所在类是否标有注解 TARGET_ANNOTATION
           boolean classHasAnnotation = AnnotatedElementUtils.hasAnnotation(methodParameter.getContainingClass(), TARGET_ANNOTATION);
           //方法是否标有注解 TARGET_ANNOTATION
           boolean methodHasAnnotation = methodParameter.hasMethodAnnotation(TARGET_ANNOTATION);
           return classHasAnnotation || methodHasAnnotation;
       }
   
       @Override
       public Object beforeBodyWrite(Object o, MethodParameter methodParameter, MediaType mediaType, Class<? extends HttpMessageConverter<?>> aClass, ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse) {
           //如果返回的对象已经是 Result 对象，则直接返回
           if (o instanceof Result){
               return o;
           }
           //返回由 Result 包装的结果
           return Result.success(o);
       }
   }
   ~~~

   当 supports 返回 true 时，beforeBodyWrite 将会被运行，最终返回由 Result 包装的对象。



**SpringBoot 文件上传**

在 SpringBoot 中通常使用 MultipartFile 来实现文件上传功能：

~~~java
@PostMapping("/upload")
public String upload(@RequestPart("img") MultipartFile photo) throws IOException {
    // do something...
    return "success";
}
~~~



**SpringBoot 错误处理**

SpringBoot 将对错误的处理逻辑封装在 *ErrorMvcAutoConfiguration* 中，向容器中添加了以下组件：

​	DefaultErrorAttributes、BasicErrorController、ErrorPageCustomizer、DefaultErrorViewResolver

错误处理步骤：

1. 一旦系统出现 4xx 或 5xx，就会通过 ErrorPageCustomizer 定制的错误处理来到 /error 请求

2. 来到 /error 请求后，由 BasicErrorController 进行处理（如果是浏览器则返回错误页面，其他客户端返回 json 格式数据）

   ~~~java
   @RequestMapping(produces = MediaType.TEXT_HTML_VALUE)
   public ModelAndView errorHtml(HttpServletRequest request, HttpServletResponse response) {
       HttpStatus status = getStatus(request);
       Map<String, Object> model = Collections
           .unmodifiableMap(getErrorAttributes(request, getErrorAttributeOptions(request, MediaType.TEXT_HTML)));
       response.setStatus(status.value());
       ModelAndView modelAndView = resolveErrorView(request, response, status, model);
       return (modelAndView != null) ? modelAndView : new ModelAndView("error", model);
   }
   
   @RequestMapping
   public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
       HttpStatus status = getStatus(request);
       if (status == HttpStatus.NO_CONTENT) {
           return new ResponseEntity<>(status);
       }
       Map<String, Object> body = getErrorAttributes(request, getErrorAttributeOptions(request, MediaType.ALL));
       return new ResponseEntity<>(body, status);
   }
   ~~~

   在 BasicErrorController 中有 2 个不同的方法，标有同样的 RequestMapping：

   1. 当浏览器发送请求时，在 Request Header 中会带有 Accept:text/html，将会与标有 produces = MediaType.TEXT_HTML_VALUE 相匹配，错误页面
   2. 当其他客户端发送请求时，如果不是优先接收 text/html 返回，将会调用 error 方法返回 json 数据。

   在返回错误响应时，DefaultErrorAttributes 负责封装错误信息，DefaultErrorViewResolver 负责错误视图的解析。

自定义错误处理器：

~~~java
@ResponseBody
@ControllerAdvice
public class MyExceptionHandler {
    @ExceptionHandler(Exception.class)
    public Result<Void> exception(Exception e){
        return Result.failure(ResultStatus.FAIL);
    }
}
~~~

1. 使用 @ControllerAdvice 注解进行标注，表示对 Controller 进行切面处理。
2. 在每一个方法中使用 @ExceptionHandler 表示此方法用来处理何种异常信息。
3. 在同一的异常返回中，可以添加 @ResponseBody 返回 json 数据，也可以返回视图对象。



**JSR303 异常处理**

在开发过程中的接口传参时，往往对接口参数都有一些特殊的限制，我们可以通过 JSR303 注解进行参数校验

1. 引入依赖：spring-boot-starter-validation

   ~~~xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-validation</artifactId>
   </dependency>
   ~~~

2. 在接口的方法参数上或者方法参数对象中标注注解并加入 BindingResult 参数：

   ~~~java
   @GetMapping("/{id}")
   public Employee getEmployee(@PathVariable @Validated @Min(2) int id, BindingResult result){
       return service.getEmployeeById(id);
   }
   ~~~

   1. @Validated - 表示对参数启用校验。
   2. @Min(2) - 参数的校验规则。
   3. BindingResult - 当参数校验不通过时，将会包错误信息绑定到此参数中，在方法中可以对结果进行处理。

3. 此时如果参数错误，返回的数据为：

   ~~~json
   {
       "code": 500,
       "message": "An Errors/BindingResult argument is expected to be declared immediately after the model attribute, the @RequestBody or the @RequestPart arguments to which they apply: public com.star.cache.bean.Employee com.star.cache.controller.EmployeeController.getEmployee(int,org.springframework.validation.BindingResult)",
       "data": null
   }
   ~~~



结合 ExceptionHandler 对参数校验错误的优雅处理：

1. 单个参数校验时：

   1. 在 Controller 上标注 @Validated（单一参数校验时，此注解必须标注在 Controller 上），类上面标注此注解后，方法参数前面可以省略

      ~~~java
      @Validated
      @RestController
      @RequestMapping("/employee")
      public class EmployeeController {
          //......
      }
      ~~~

   2. 在参数上添加校验逻辑：

      ~~~java
      @PatchMapping("/{id}")
      public Employee updateLoginName(@PathVariable @Min(value = 2, message = "id 至少大于等于 2") int id, @NotBlank(message = "登录名不能为空") String loginName){
          return service.updateLoginName(id, loginName);
      }
      ~~~

   3. 当参数不满足校验逻辑时，将会抛出 *ConstraintViolationException*，我们需要在 ExceptionHandler 对此错误进行处理：

      ~~~java
      @ExceptionHandler(ConstraintViolationException.class)
          public Result<Void> singleParamError(ConstraintViolationException e){
              Set<ConstraintViolation<?>> violationSet = e.getConstraintViolations();
              //将参数校验结果通过 ; 进行拼接
              String message = violationSet.stream().map(ConstraintViolation::getMessage).collect(Collectors.joining(";"));
              return Result.failure(message);
          }
      ~~~

   4. 返回结果示例：

      ~~~json
      {
          "code": 500,
          "message": "登录名不能为空;id 至少大于等于 2",
          "data": null
      }
      ~~~

2. 使用 Java Bean 封装对象时，的参数校验

   1. 需要在 Java Bean 中添加校验逻辑即可

      ~~~java
      @Data
      public class Employee implements Serializable{
          private int id;
          @NotBlank(message = "登录名不能为空")
          private String loginName;
          //0-女，1-男
          private byte gender;
          @Email(message = "邮箱格式输入错误")
          private String email;
          private int deptId;
      }
      ~~~

   2. 在方法的参数中添加 @Validated 注解（使用对象接收参数时，@Validated 必须添加在方法参数前）

      ~~~java
      @PostMapping
      public Integer addEmployee(@RequestBody @Validated Employee employee){
          return service.addEmployee(employee).getId();
      }
      ~~~

   3. 当参数不满足校验逻辑时，将会抛出 *BindException*，我们需要在 ExceptionHandler 对此错误进行处理：

      ~~~java
      @ExceptionHandler(BindException.class)
      public Result<Void> paramError(BindException e){
          BindingResult bindingResult = e.getBindingResult();
          String message = bindingResult.getFieldErrors().stream().map(FieldError::getDefaultMessage).collect(Collectors.joining(";"));
          return Result.failure(message);
      }
      ~~~

   4. 返回结果示例：

      ~~~java
      {
          "code": 500,
          "message": "登录名不能为空;邮箱格式输入错误",
          "data": null
      }
      ~~~



**嵌入式 Servlet 容器**

SpringBoot 默认使用 Tomcat 作为嵌入式的 Servlet 容器，如果需要修改 server 相关配置，则在 application.properties 中修改以 server 开头的属性即可

~~~properties
# 通用 server 配置
server.port=8080
# tomcat 配置
server.tomcat.uri-encoding=UTF-8
# jetty 配置
server.jetty.uri-encoding=UTF-8
# undertow 配置
server.undertow.uri-encoding=UTF-8
~~~

除此之外，还可以像容器中添加 *EmbeddedServletContainerCustomizer* 组件自定义 server 的属性。



在 SpringBoot 中，除了 Tomcat 外，还支持 Jetty 和 Undertow：

- Tomcat：成熟稳定的一款 Web 容器，过了多年的市场考验，应用也相当广泛，如果不涉及高并发，可以使用 Tomcat 容器。
- Jetty：基于 NIO 实现，轻量级，很好的支持长连接，性能与 Tomcat 相近，支持 JSP，易于扩展。
- Undertow：基于 NIO 实现，并发性能高，但不支持 JSP。

替换其他的嵌入式 Web 容器：

1. 排除 spring-boot-starter-tomcat：

   ~~~xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-web</artifactId>
       <exclusions>
           <exclusion>
               <artifactId>spring-boot-starter-tomcat</artifactId>
               <groupId>org.springframework.boot</groupId>
           </exclusion>
       </exclusions>
   </dependency>
   ~~~

2. 加入其他容器的依赖（以 Untertow 为例）：

   ~~~xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-undertow</artifactId>
   </dependency>
   ~~~

3. 此时 SpringBoot 应用将以 Untertow 作为 Web 容器。



---

### 8.SpringBoot 数据访问

**SpringBoot 与 JDBC**

SpringBoot2.x 默认使用 com.zaxxer.hikari.HikariDataSource 数据源。

配置数据源通用信息：

~~~properties
# 数据源相关配置
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://192.168.253.128:3306/mybatis?serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=TinyStar0920
~~~

数据源的相关配置在 DataSourceProperties 中进行绑定。

具体数据源的配置（如：hikari）通过 spring.datasource.hikari.xxx 进行配置：

~~~properties
spring.datasource.hikari.connection-test-query=select 1 from dual
spring.datasource.hikari.idle-timeout=60000
~~~

> 在 SpringBoot 的 DataSourceInitializer 中，在数据源初始化完成后，会帮助我们运行 sql 脚本
>
> 默认的脚本位置检查规则：classpath\*:schema-all.sql、classpath\*:schema.sql
>
> 也可以在配置文件中手动指定位置：
>
> ~~~properties
> spring.datasource.schema=classpath*:employee.sql,classpath*:department.sql
> ~~~

在 *JdbcTemplateAutoConfiguration* 中 SpringBoot 默认还帮我们自动注入了 JdbcTemplate 和 NamedParameterJdbcTemplate 组件，我们可以直接进行使用：

~~~java
@SpringBootTest
class CacheApplicationTests {
    
	@Autowired
	JdbcTemplate jdbcTemplate;
    
	@Test
	void contextLoads() {
		System.out.println(jdbcTemplate.queryForList("select * from employee").get(0));
	}
}
~~~



**整合 Druid 数据源**

Druid 的 GitHub 地址：https://github.com/alibaba/druid/tree/master/druid-spring-boot-starter/

SpringBoot 集成 Druid：

1. 添加 POM 依赖：

   ~~~xml
   <dependency>
       <groupId>com.alibaba</groupId>
       <artifactId>druid-spring-boot-starter</artifactId>
       <version>1.1.17</version>
   </dependency>
   ~~~

   注：如果是 SpringBoot2.x 版本，druid-spring-boot-starter 的版本必须为 1.1.10+

2. 数据源相关配置：

   ~~~properties
   # 数据源基本信息相关配置
   spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
   spring.datasource.url=jdbc:mysql://192.168.253.128:3306/mybatis?serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=TinyStar0920
   # Druid 连接池相关配置
   spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
   ~~~

   此时，数据源就已经变为了 Druid 数据源。
   
3. 数据源的其他配置可以省略，详情信息可以参考：https://github.com/alibaba/druid/wiki



**配置 Druid 监控**

要开启 Druid 监控，需要向容器中加入一个 servlet 组件和一个 filter 组件：

创建 DruidConfig 配置类，加上 @Configuration 注解。

配置 servlet：

~~~java
/**
* 配置 Druid 管理台的 Servlet
* @return 管理台 Servlet
*/
@Bean
public ServletRegistrationBean<StatViewServlet> statViewServlet(){
    ServletRegistrationBean<StatViewServlet> servlet = new ServletRegistrationBean<>(new StatViewServlet(), "/druid/*");
    servlet.addInitParameter("loginUsername", "star");
    servlet.addInitParameter("loginPassword", "123456");
    return servlet;
}
~~~

配置 filter：

~~~java
/**
* 配置 Druid 的 Web 监控 Filter
* @return Web 监控 Filter
*/
@Bean
public FilterRegistrationBean<StatViewFilter> statViewFilter(){
    FilterRegistrationBean<StatViewFilter> filter = new FilterRegistrationBean<>();
    filter.setFilter(new StatViewFilter());
    //拦截所有请求
    filter.setUrlPatterns(Collections.singleton("/*"));
    //放行下列请求，交由 StatViewServlet 进行处理
    filter.addInitParameter("exclusions", "*.js,*.css,/druid/*");
    return filter;
}
~~~



**结合 MyBatis 配置多数据源**

1. 搭建项目：创建 SpringBoot 项目，引入需要的项目依赖（不同数据库时需要引入不同的数据库 Driver）。

2. 编写项目配置：

   ~~~properties
   # 服务端口
   server.port=8080
   ~~~

3. MySQL 数据源连接相关信息

   ~~~properties
   spring.datasource.mysql.driver-class-name=com.mysql.cj.jdbc.Driver
   spring.datasource.mysql.url=jdbc:mysql://192.168.253.128:3306/common?serverTimezone=UTC
   spring.datasource.mysql.username=root
   spring.datasource.mysql.password=TinyStar0920
   ~~~

4. Oracle 数据源连接相关信息

   ~~~properties
   spring.datasource.oracle.driver-class-name=oracle.jdbc.OracleDriver
   spring.datasource.oracle.url=jdbc:oracle:thin:@192.168.253.128:1521:ORCLCDB
   spring.datasource.oracle.username=C##STAR
   spring.datasource.oracle.password=123456
   ~~~

5. Druid 相关配置

   ~~~properties
   spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
   spring.datasource.druid.initial-size=5
   ~~~

6. 配置 Druid 监控

   ~~~properties
   spring.datasource.druid.filter.commons-log.connection-logger-name=stat,wall,log4j
   spring.datasource.druid.stat-view-servlet.enabled=true
   ~~~

7. 日志相关配置

   ~~~properties
   logging.level.com.star.md=debug
   ~~~

8. 添加作用在 mapper 上的注解用来使用不同的数据源：

   ~~~java
   @Documented
   @Repository
   @Target({ElementType.TYPE})
   @Retention(RetentionPolicy.RUNTIME)
   public @interface MysqlRepository {
       @AliasFor(annotation = Repository.class)
       String value() default "";
   }
   ~~~

   同理，添加 OracleRepository 注解。

9. 使用 MysqlProperties 封装 Mysql 配置属性：

   ~~~java
   @Data
   @Component
   @ConfigurationProperties(prefix = "spring.datasource.mysql")
   public class MysqlProperties {
       private String url;
       private String username;
       private String password;
       private String driverClassName;
   }
   ~~~

   同理，使用 OracleProperties 封装 Oracle 配置属性。

10. 配置 DataSource，SessionFactory，SessionTemplate 组件：

    ~~~java
    @Data
       @Configuration
       @MapperScan(basePackages = "com.star.md.dao", annotationClass = MysqlRepository.class,
               sqlSessionFactoryRef = "mysqlSessionFactory", sqlSessionTemplateRef = "mysqlSessionTemplate")
       @MapperScan(basePackages = "com.star.md.dao", annotationClass = OracleRepository.class,
               sqlSessionFactoryRef = "oracleSessionFactory", sqlSessionTemplateRef = "oracleSessionTemplate")
       public class DataSourceConfig {
       
           @Bean
           @Primary
           public DataSource mysqlDataSource(MysqlProperties properties) {
               DruidDataSource mysqlDataSource = DruidDataSourceBuilder.create().build();
               mysqlDataSource.setDriverClassName(properties.getDriverClassName());
               mysqlDataSource.setUrl(properties.getUrl());
               mysqlDataSource.setUsername(properties.getUsername());
               mysqlDataSource.setPassword(properties.getPassword());
               return mysqlDataSource;
           }
           
           @Bean
           public SqlSessionFactory mysqlSessionFactory(@Qualifier("mysqlDataSource") DataSource dataSource) throws Exception {
               final SqlSessionFactoryBean mysqlSessionFactoryBean = new SqlSessionFactoryBean();
               //配置数据源
               mysqlSessionFactoryBean.setDataSource(dataSource);
               //配置 mysql mapper 文件位置
               mysqlSessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver()
                       .getResources("classpath:/mapper/mysql/*Mapper.xml"));
               SqlSessionFactory sessionFactory = mysqlSessionFactoryBean.getObject();
               assert sessionFactory != null;
               sessionFactory.getConfiguration().setMapUnderscoreToCamelCase(true);
               return sessionFactory;
           }
       
           @Bean
           public SqlSessionTemplate mysqlSessionTemplate(@Qualifier("mysqlSessionFactory") SqlSessionFactory sessionFactory) {
               return new SqlSessionTemplate(sessionFactory);
           }
       
           @Bean
           public DataSource oracleDataSource(OracleProperties properties) {
               DruidDataSource oracleDataSource = DruidDataSourceBuilder.create().build();
               oracleDataSource.setDriverClassName(properties.getDriverClassName());
               oracleDataSource.setUrl(properties.getUrl());
               oracleDataSource.setUsername(properties.getUsername());
               oracleDataSource.setPassword(properties.getPassword());
               return oracleDataSource;
           }
       
           @Bean
           public SqlSessionFactory oracleSessionFactory(@Qualifier("oracleDataSource") DataSource dataSource) throws Exception {
               final SqlSessionFactoryBean oracleSessionFactoryBean = new SqlSessionFactoryBean();
               //配置数据源
               oracleSessionFactoryBean.setDataSource(dataSource);
               //配置 oracle mapper 位置
               oracleSessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver()
                       .getResources("classpath:/mapper/oracle/*Mapper.xml"));
               SqlSessionFactory sessionFactory = oracleSessionFactoryBean.getObject();
               assert sessionFactory != null;
               org.apache.ibatis.session.Configuration sessionConfiguration = sessionFactory.getConfiguration();
               sessionConfiguration.setMapUnderscoreToCamelCase(true);
               return sessionFactory;
           }
       
           @Bean
           public SqlSessionTemplate oracleSessionTemplate(@Qualifier("oracleSessionFactory") SqlSessionFactory sessionFactory) {
               return new SqlSessionTemplate(sessionFactory);
           }
       }
    ~~~

    1. 向容器中添加了 2 个数据源， 2 个 SqlSessionFactory，2 个 SqlSessionTemplate。
    2. 使用 **@MapperScan** 标注了要扫描的 mapper 组件，由于容器中存在多个 SqlSessionFactory 和多个 SqlSessionTemplate 组件，所以还要额外为扫描到的 mapper 指定要使用的 SqlSessionFactory 和 SqlSessionTemplate。



---

### 9.SpringBoot 原理

SpringBoot 启动流程：

1. 创建 SpringApplication 对象：

   ```java
   public SpringApplication(ResourceLoader resourceLoader, Class<?>... primarySources) {
       this.resourceLoader = resourceLoader;
       Assert.notNull(primarySources, "PrimarySources must not be null");
       this.primarySources = new LinkedHashSet<>(Arrays.asList(primarySources));
       // 判断当前 SpringApplication 的类型（是否为 Web 应用程序）
       this.webApplicationType = WebApplicationType.deduceFromClasspath();
       // 从 jar 的类路径下查找 META‐INF/spring.factories 文件读取文件中的 Initializers
       this.bootstrapRegistryInitializers = getBootstrapRegistryInitializersFromSpringFactories();
       // 通过读取到的 Initializers 初始化所有的 ApplicationContextInitializer 并保存
       setInitializers((Collection) getSpringFactoriesInstances(ApplicationContextInitializer.class));
       // 通过读取到的 Initializers 初始化所有的 ApplicationListener 并保存
       setListeners((Collection) getSpringFactoriesInstances(ApplicationListener.class));
       // 从多个配置类中找到有 main 方法的主配置类
       this.mainApplicationClass = deduceMainApplicationClass();
   }
   ```

   在创建 SpringApplication 对象的过程中初始化 Initializers、Listeners 等组件。

2. 执行 run 方法：

   ~~~java
   public ConfigurableApplicationContext run(String... args) {
       // 创建计时器
       StopWatch stopWatch = new StopWatch();
       // 计时器启动
       stopWatch.start();
       DefaultBootstrapContext bootstrapContext = createBootstrapContext();
       ConfigurableApplicationContext context = null;
       configureHeadlessProperty();
       // 获取 META‐INF/spring.factories 下所有的 SpringApplicationRunListeners
       SpringApplicationRunListeners listeners = getRunListeners(args);
       // 回调所有的获取到的 SpringApplicationRunListener 的 starting 方法
       listeners.starting(bootstrapContext, this.mainApplicationClass);
       try {
           // 封装命令行参数
           ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
           // 准备环境、回调 listeners 的 environmentPrepared 方法
           ConfigurableEnvironment environment = prepareEnvironment(listeners, bootstrapContext, applicationArguments);
           configureIgnoreBeanInfo(environment);
           // 打印 Banner 信息
           Banner printedBanner = printBanner(environment);
           // 创建 ApplicationContext
           context = createApplicationContext();
           context.setApplicationStartup(this.applicationStartup);
           /**
            * 准备 ApplicationContext 上下文环境
            * 1.设置环境、对 ApplicationContext 进行后置处理（postProcessApplicationContext）
            * 2.回调之前保存的所有的 ApplicationContextInitializer 的 initialize 方法（applyInitializers）
            * 3.回调 listeners 的 contextPrepared 方法
            * 4.创建 boot 环境所需要的特殊的 singleton beans
            * 5.回调 listeners 的 contextLoaded 方法
            */ 
           prepareContext(bootstrapContext, context, environment, listeners, applicationArguments, printedBanner);
           // 刷新容器、创建 BeanFactory、如果是 Web 应用还会创建内嵌的 Server 容器（createWebServer）
           refreshContext(context);
           afterRefresh(context, applicationArguments);
           // 计时器结束
           stopWatch.stop();
           if (this.logStartupInfo) {
               new StartupInfoLogger(this.mainApplicationClass).logStarted(getApplicationLog(), stopWatch);
           }
           // 回调 listeners 的 started 方法
           listeners.started(context);
           // 从 ioc 容器中获取所有的 ApplicationRunner 和 CommandLineRunner 进行回调
           callRunners(context, applicationArguments);
       }catch (Throwable ex) {
           handleRunFailure(context, ex, listeners);
           throw new IllegalStateException(ex);
       }
   
       try {
           // 回调 listeners 的 running 方法
           listeners.running(context);
       }catch (Throwable ex) {
           handleRunFailure(context, ex, null);
           throw new IllegalStateException(ex);
       }
       return context;
   }
   ~~~

   

在 SpringBoot 主程序中，在一些步骤调用了 Initializer、Listener、Runner 的回调方法，我们也可以利用 SpringBoot 的事件监听机制在容器启动过程中来执行我们自定义的业务逻辑：

1. **ApplicationContextInitializer**：监听 ApplicationContext 的初始化动作。

   自定义 ApplicationContextInitializer：

   ~~~java
   public class MyApplicationContextInitializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {
       @Override
       public void initialize(ConfigurableApplicationContext applicationContext) {
           System.out.println("MyApplicationContextInitializer...initialize");
       }
   }
   ~~~

2. **SpringApplicationRunListener**：监听 SpringApplication 的启动过程。

   自定义 SpringApplicationRunListener：

   ~~~java
   public class MySpringApplicationRunListener implements SpringApplicationRunListener {
   
       // 添加必要的构造器
       public MySpringApplicationRunListener(SpringApplication application, String[] args) {
           super();
       }
   
       @Override
       public void starting(ConfigurableBootstrapContext bootstrapContext){
           System.out.println("MySpringApplicationRunListener...starting...");
       }
   
       @Override
       public void environmentPrepared(ConfigurableBootstrapContext bootstrapContext, ConfigurableEnvironment environment) {
           System.out.println("MySpringApplicationRunListener...environmentPrepared...");
       }
   
       @Override
       public void contextPrepared(ConfigurableApplicationContext context) {
           System.out.println("MySpringApplicationRunListener...contextPrepared...");
       }
   
       @Override
       public void contextLoaded(ConfigurableApplicationContext context) {
           System.out.println("MySpringApplicationRunListener...contextLoaded...");
       }
   
       @Override
       public void started(ConfigurableApplicationContext context) {
           System.out.println("MySpringApplicationRunListener...started...");
       }
   
       @Override
       public void running(ConfigurableApplicationContext context) {
           System.out.println("MySpringApplicationRunListener...running...");
       }
   }
   ~~~

:zap: 注意：ApplicationContextInitializer 和 SpringApplicationRunListener 两种组件需要加入到 spring.factories 中才能生效：

在当前项目的 resources 目录下新建 META-INF/spring.factories 文件，加入内容：

~~~properties
org.springframework.context.ApplicationContextInitializer=\
  com.star.demo.listener.MyApplicationContextInitializer
org.springframework.boot.SpringApplicationRunListener=\
  com.star.demo.listener.MySpringApplicationRunListener
~~~

3. 自定义 ApplicationRunner：

   ~~~java
   @Component
   public class MyApplicationRunner implements ApplicationRunner {
       @Override
       public void run(ApplicationArguments args) throws Exception {
           System.out.println("MyApplicationRunner...run");
       }
   }
   ~~~

4. 自定义 CommandLineRunner：

   ~~~java
   @Component
   public class MyCommandLineRunner implements CommandLineRunner {
       @Override
       public void run(String... args) throws Exception {
           System.out.println("MyCommandLineRunner...run");
       }
   }
   ~~~

启动容器后，它们的执行顺序如下：

~~~tex
MySpringApplicationRunListener...starting...
MySpringApplicationRunListener...environmentPrepared...
MyApplicationContextInitializer...initialize
MySpringApplicationRunListener...contextPrepared...
MySpringApplicationRunListener...contextLoaded...
MySpringApplicationRunListener...started...
MyApplicationRunner...run
MyCommandLineRunner...run
MySpringApplicationRunListener...running...
~~~



> :alarm_clock: 除此之外，Spring 还提供了大量的 Listener 实现和大量的 Event 实现，帮助我们更好的介入到应用的各个活动之中。
>
> 例如，通过 ApplicationReadyEvent 介入到程序启动之后，同时也可以实现自定义的事件监控机制。

实现自定义事件监听：

1. 定义事件：

   ~~~java
   public class MyApplicationEvent extends ApplicationEvent {
       public MyApplicationEvent(Object source) {
           super(source);
       }
   }
   ~~~

2. 定义监听器：

   ~~~java
   @Component
   public class MyApplicationEventListener implements ApplicationListener<MyApplicationEvent> {
       @Override
       public void onApplicationEvent(MyApplicationEvent event) {
           System.out.println("监听到事件:" + event.getTimestamp());
       }
   }
   ~~~

3. 使用 context 发布事件：

   ~~~java
   @Autowired
   private ApplicationContext context;
   
   @Test
   void myEventListener() {
       context.publishEvent(new MyApplicationEvent(new Object()));
   }
   ~~~

   