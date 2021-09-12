SpringBoot 官网：[https://spring.io/projects/spring-boot/](https://spring.io/projects/spring-boot/)

Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".



---

#### 1.SpringBoot 与缓存

在开发中，使用缓存的大致步骤：

1. 向电脑申请一块空间作为缓存

2. 为缓存定义你自己的数据结构
3. 向缓存中写数据
4. 从缓存中读数据
5. 不再使用缓存时，清空你锁申请的内存空间

除此之外，还有过期设置，分布式，持久化，事务，加锁等其他细节操作。



***JSR-107*** 规范：为了统一缓存的开发规范，提升系统的可扩展性，Java EE 提出了 JSR-107 缓存规范。

***JCache***：JCache 是用于缓存的 Java API，它提供了一组通用接口和类，可用于将 Java 对象临时存储在内存中，它是 JSR-107 所代表的 Java 缓存标准。

*JCache* 定义了 5 个核心接口，分别是 *CachingProvider*，*CacheManager*，*Cache*，*Entry* 和 *Expiry*：

- ***CachingProvider***：定义了创建、配置、获取、管理和控制多个 *CacheManager*，一个应用可以在运行期访问多个 CachingProvider。

- ***CacheManager***：定义了创建、配置、获取、管理和控制多个唯一命名的 *Cache*，这些 Cache 存在于 CacheManager 的上下文中，一个 CacheManager 仅被

  一个 CachingProvider 所拥有。

- ***Cache***：是一个类似 Map 的数据结构并临时存储以 Key 为索引的值。一个 Cache 仅被一个 CacheManager 所拥有。

- ***Entry***：是一个存储在 Cache 中的 key-value 对。

- ***Expiry***： 每一个存储在 Cache 中的条目有一个定义的有效期，一旦超过这个时间，条目为过期的状态，一旦过期，条目将不可访问、更新和删除，缓存有效期可以通过 *ExpiryPolicy* 设置。



Spring 缓存规范：由于 JSR-107 使用较为复杂，各种缓存技术都实现了不同的缓存 API，Spring 从 3.1 开始定义了 *org.springframework.cache.Cache* 和 

*org.springframework.cache.CacheManager* 接口来统一不同的缓存技术，并支持使用 JCache 注解简化我们开发。

Spring 的 Cache 接口为缓存的组件规范定义，包含了缓存的各种操作集合，在 Cache 接口下 Spring 提供了各种 xxxCache 的实现：如 *RedisCache*，*EhCacheCache*，*ConcurrentMapCache* 等。

每次调用需要缓存功能的方法时，Spring 会检查检查指定参数的指定的目标方法是否已经被调用过，如果有就直接从缓存中获取方法调用后的结果，如果没有就调用方法并缓存结果后返回给用户，下次调用直接从缓存中获取。



Spring 缓存的重要概念与注解：

- ***Cache***：缓存接口，定义缓存操作，实现有：*RedisCache*，*EhCacheCache*，*ConcurrentMapCache* 等。
- ***CacheManager***：缓存管理器，管理各种缓存（*Cache*）组件。
- ***@Cacheable***：主要针对方法配置，能够根据方法的请求参数对其结果进行缓存。
- ***@CacheEvict***：清空缓存。
- ***@CachePut***：保证方法被调用，又希望结果被缓存（用于缓存更新）。
- ***@EnableCaching***：开启基于注解的缓存。
- ***keyGenerator***：缓存数据时 key 生成策略。
- ***serialize***：缓存数据时对 value 的序列化策略。



SpringBoot 中使用缓存：

1. 搭建缓存环境：Web 环境，数据库环境，Redis 环境（也可以使用内存进行缓存）等。

2. 使用 ***@EnableCaching*** 开启基于注解的缓存：

   ~~~java
   @EnableCaching
   @SpringBootApplication
   public class CacheApplication {
   	public static void main(String[] args) {
   		SpringApplication.run(CacheApplication.class, args);
   	}
   }
   ~~~

3. 标注缓存注解。

   

缓存注解 ***@Cacheable***：缓存方法结果，当缓存中有数据时直接从缓存中返回方法结果，否则从数据库获取结果并缓存。

*@Cacheable* 基本属性：

- ***cacheNames/value***：缓存名字，通过制定唯一的缓存名提供给 *CacheManager* 进行管理。

- ***key***：缓存数据使用的 key，默认使用方法参数作为 key，支持 SPEL 表达式，与 *keyGenerator* 二选一。

  支持的 SPEL 表达式用法：

  - *methodName*：当前被调用的方法名，例：`#root.methodName`
  - *method*：当前被调用的方法，例：`#root.method.name`
  - *target*：当前被调用的目标对象，例：`#root.target`
  - *targetClass*：当前被调用的目标对象类，例：`#root.targetClass`
  - *args*：当前被调用的方法的参数列表，例：`#root.args[0]`
  - *caches*：当前方法调用使用的缓存列表，如 `@Cacheable(value={"cache1", "cache2"})）`，可以使用 `#root.caches[0].name` 获取到 “cache1”。
  - *argument*：方法参数的名字，可以直接 #参数名，也可以使用 #p0 或 #a0 的形式，0 代表参数的索引，例：`#id`，`#a0`，`#p0`
  - result：方法执行后的返回值，仅当方法执行之后的判断有效，例：`#result`

- ***keyGenerator***：key 生成器，与 *key* 二选一。

- ***cacheManager***：指定缓存管理器，与 *cacheResolver* 二选一。

- ***cacheResolver***：指定缓存解析器，与 *cacheManager* 二选一。

- ***condition***：对方法的参数进行判断，当 *condition* 指定的条件成立的情况下才缓存，与 *unless* 相反，不可使用 `#result`。

- ***unless***：对方法的执行结果进行判断，*unless* 指定的条件成立时就不会缓存，与 *condition* 相反，可以使用 `#result`。

简单使用：

~~~java
@Cacheable(value = "employee")
public Employee getUserById(int id) {
    return mapper.getUserById(id);
}
~~~



> 注意：被缓存的结果需要指定序列化方式。



SpringBoot 缓存的工作原理：容器启动时，SpringBoot 通过 *CacheAutoConfiguration* 进行自动配置，在未进行其他配置时，默认 *SimpleCacheConfiguration* 配置类生效，缓存数据将会放在内存中。

*CacheAutoConfiguration* 会想容器中注册一个 *ConcurrentMapCacheManager* 缓存管理器，用来获取，创建和储存 *ConcurrentMapCache*，底层使用 `ConcurrentMap<String, Cache>` 来存储数据。

*ConcurrentMapCache* 用来存储具体的缓存数据，底层采用 `ConcurrentMap<Object, Object>` 存储，默认使用 *SimpleKeyGenerator* 来生成 key，value 为方法的返回结果（也可以向容器中加入自定义的 *KeyGenerator*，然后在 *@Cacheable* 注解中指定自定义的 *KeyGenerator* 的 ID 进行使用）。



缓存注解 ***@CachePut***：保证调用方法的同时更新缓存，应用在添加，更新方法上。

缓存注解 ***@CacheEvict***：缓存清除，应用在删除方法上，可以通过 *beforeInvocation* 属性指定缓存清除的时间，为 true 时，在允许目标方法之前就清空缓存，否则在目标方法正确结束后才会清除缓存，发生异常时缓存也不会被清除。

组合缓存注解 ***@Caching***：可同时为方法指定多个 *Cacheable*，*CachePut*，*CacheEvict* 组成复杂的缓存规则。

类缓存注解 ***@CacheConfig***：使用在 Java 类上，指定类下缓存注解的通用属性：*cacheNames*，*keyGenerator*，*cacheManager* 和 *cacheResolver*。



使用 Redis 作为缓存中间件：使用 Redis 作为 SpringBoot 缓存时，*RedisCacheConfiguration* 配置类生效，向容器中注入 ***RedisCacheManager***，使用 ***RedisCache*** 作为缓存组件，通过操作 Redis 来操作缓存数据。

SpringBoot 容器默认创建的 *RedisCacheManager* 在操作 Redis 时默认使用 ***JdkSerializationRedisSerializer*** 进行序列化，如果需要其他序列化方式，需要自定义 *CacheManager*：

```java
@Configuration
public class CacheConfiguration {

    @Value("${spring.cache.redis.time-to-live}")
    private Duration TIME_TO_LIVE;

    @Bean
    public RedisCacheManager redisCacheManager(RedisConnectionFactory factory){
        //字符串序列化器
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        //Jackson 对象序列化器
        Jackson2JsonRedisSerializer<Object> jsonSerializer = new Jackson2JsonRedisSerializer<>(Object.class);
        //Redis Cache 设置
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(TIME_TO_LIVE)
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(stringSerializer))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(jsonSerializer))
                .disableCachingNullValues();
        //创建 RedisCacheManager
        return RedisCacheManager.builder(factory)
                .cacheDefaults(config)
                .build();
    }
}
```

注意：此方法是 2.x 版本的 *CacheManager* 创建方法。

如果加入的 RedisCacheManager 覆盖了元容器中的 redisCacheManager，则缓存注解的 cacheManager 属性可省略，否则需要指定自定义的 CacheManager ID。



> 由于 Spring Cache 的实现原理是基于 AOP 的动态代理实现的，即都在方法调用前后去获取方法的名称、参数、返回值，然后进行缓存。如果是类的内部调用则是直接通过 this 调用而不是代理对象的调用,  所以 AOP 失效，缓存注解失效。
>
> 解决方法：从 ***Spring 4.3*** 开始，可以通过通过注入 self，再通过 self 调用方法即可解决此问题。
>
> ~~~java
> @Slf4j
> @Service
> public class EmployeeService {
> 
>  @Autowired
>  private EmployeeMapper mapper;
>  @Autowired
>  private EmployeeService self;
> 
>  @Cacheable(value = "employee", key = "#id")
>  public Employee getEmployeeById(int id) {
>      return mapper.getEmployeeById(id);
>  }
> 
>  public void demo(int id) {
>      //通过 self 自我调用
>      Employee employee = self.getEmployeeById(id);
>  }
> }
> ~~~



---

#### 2.SpringBoot 与任务

异步任务：SpringBoot 允许使用异步的方法进行方法调用：

1. 在配置类上添加`@EnableAsync`注解。

2. 在方法上添加`@Async`注解。

   ~~~java
   @Async
   @Override
   public void asyncAction() {
       System.out.println("Start async Task...");
       try {
           Thread.sleep(15 * 1000L);
       } catch (InterruptedException e) {
           e.printStackTrace();
       }
       System.out.println("Async Task execute finished!");
   }
   ~~~

   此时，调用此方法时为异步调用。



定时任务：SpringBoot 允许定时任务的设置与执行

1. SpringBoot 的 cron 表达式（共使用 6 个 位置进行表达）：

   | 位置 | 字段意义     | 允许值                           | 允许的特殊符号  |
   | ---- | ------------ | -------------------------------- | --------------- |
   | 1    | 秒           | 0-59                             | , - * /         |
   | 2    | 分           | 0-59                             | , - * /         |
   | 3    | 小时         | 0-23                             | , - * /         |
   | 4    | 月份中的日期 | 1-31                             | , - * ? / L W C |
   | 5    | 月份         | 1-12                             | , - * /         |
   | 6    | 星期         | 0-7 或 SUN-SAT，其中 0、7 是 SUN | , - * ? / L C # |

2. 常用 cron 表达式：

   1. `0 0 * * * *`：每小时整点执行一次。
   2. `0 */30 * * * *`：每半小时执行一次（将在整点和 30 分时进行执行）。
   3. `0 15 10 ? * 6#3`：每月的第三个星期五上午 10:15 触发。
   4. `0 15 10 ? * 6L`：每月的最后一个星期五上午 10:15 触发。
   5. `0 15 10 W * *`：每个工作日上午 10:15 触发。

   > `/` 不会以项目启动为时间起点，例如`*/11 * * * * *`表示在每一分钟的 0、11、22、33、44、55 秒时进行执行。

3. SpringBoot 中使用定时任务：

   1. 在配置类上添加`@EnableScheduling`注解。

   2. 在 SpringBoot 的组件需要定时执行的方法上标注`@Scheduled`注解。

      ~~~java
      @Override
      @Scheduled(cron = "*/7 * * * * *")
      public void cronAction() {
          System.out.println("Cron task executed at " + Instant.now().toString());
      }
      ~~~



---

#### 3.SpringBoot 与邮件

常见的邮件协议：

1. SMTP（Simple Mail Transfer Protocol）：简单邮件传输协议，它是一组用于从源地址到目的地址传输邮件的规范，通过它来控制邮件的中转方式；SMTP 认证要求必须提供账号和密码才能登陆服务器，其设计目的在于避免用户受到垃圾邮件的侵扰。
2. IMAP（Internet Message Access Protocol）：互联网邮件访问协议，IMAP 允许从邮件服务器上获取邮件的信息、下载邮件等。IMAP 与 POP 类似，都是一种邮件获取协议。
3. POP3（Post Office Protocol 3）：邮局协议，POP3 支持客户端远程管理服务器端的邮件。POP3 常用于离线邮件处理，即允许客户端下载服务器邮件，然后服务器上的邮件将会被删除。目前很多 POP3 的邮件服务器只提供下载邮件功能，服务器本身并不删除邮件，这种属于改进版的 POP3 协议。



SpringBoot 的邮件集成：在 SpringBoot 中通过`javaMailSender`和`JavaMailSenderImpl`来实现邮件服务，目前是 Java 后端发送邮件和集成邮件服务的主流工具。我们通过 JavaMailSenderImpl 来发送相对比较简单的邮件，而相对比较复杂的邮件（例如：添加附件等）可以借助 MimeMessageHelper 来构建MimeMessage 进行发送。

1. 邮件发送需要引入依赖：

   ~~~xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-mail</artifactId>
   </dependency>
   ~~~

2. 进行邮件客户端配置：

   ![](D:\GitRepository\HexBook\notes\Java语言\img\Snipaste_2021-09-12_23-11-32.png)

   开通 POP3/SMTP/IMAP/SMTP 服务并生成授权码。

3. 项目中进行配置：

   ~~~properties
   # 用于发送邮件的邮箱
   spring.mail.username=2402477643@qq.com
   # 邮件服务授权码
   spring.mail.password=zckgxidzvhzwdieg
   # 使用 SMTP 发送邮件（此地址在设置中进行查看）
   spring.mail.host=smtp.qq.com
   ~~~

   

发送简单邮件：

~~~java
@SpringBootTest
class SpringBootTaskApplicationTests {
	@Value("${spring.mail.username}")
	private String fromUser;
	@Autowired
	private JavaMailSender mailSender;

	@Test
	void simpleMail() {
		SimpleMailMessage simpleMessage = new SimpleMailMessage();
		simpleMessage.setSubject("开会通知");
		simpleMessage.setText("今天晚上 18:30 在 505 会议室开会，请按时参加。");
		simpleMessage.setTo("hex_1112@163.com");
		simpleMessage.setFrom(fromUser);
		mailSender.send(simpleMessage);
	}
}
~~~

发送复杂邮件：

~~~java
@Test
void mimeMail() throws MessagingException {
    MimeMessage mimeMessage = mailSender.createMimeMessage();
    MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true);
    messageHelper.setSubject("开会通知");
    // 第二个参数表示进行 html 编码
    messageHelper.setText("今天晚上 <span style='font-weight:bold'>18:30</span> 在 <span style='font-weight:bold'>505</span> 会议室开会，请按时参加。" +
                          "<br>会议内容见附件。", true);
    // 添加附件（可以上传文本、图片等附件）
    messageHelper.addAttachment("会议内容.txt", new File("C:\\Users\\star\\Desktop\\会议内容.txt"));
    messageHelper.setTo("hex_1112@163.com");
    messageHelper.setFrom(fromUser);
    mailSender.send(mimeMessage);
}
~~~



---

#### 4.SpingBoot 与监控

通过引入 spring-boot-starter-actuator，可以使用 SpringBoot 为我们提供的准生产环境下的应用监控和管理功能。我们可以通过 HTTP、JMX、SSH 协议来进行操作，自动得到审计、健康及指标信息等。

引入 SpringBoot 监控模块：

~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
~~~

此时启动项目后，访问`http://127.0.0.1:8080/actuator`即可看到 actuator 默认所暴露的监控端点:

~~~json
{
	"_links": {
		"self": {
			"href": "http://127.0.0.1:8080/actuator",
			"templated": false
		},
		"health-path": {
			"href": "http://127.0.0.1:8080/actuator/health/{*path}",
			"templated": true
		},
		"health": {
			"href": "http://127.0.0.1:8080/actuator/health",
			"templated": false
		}
	}
}
~~~



SpringBoot actuator 常见的监控和管理端点：

| 端点名称    | 作用                                 |
| ----------- | ------------------------------------ |
| autoconfig  | 所有自动配置信息                     |
| auditevents | 审计事件                             |
| beans       | 所有 Bean 的信息                     |
| configprops | 所有配置属性                         |
| dump        | 线程状态信息                         |
| env         | 当前环境信息                         |
| health      | 应用健康状况                         |
| info        | 当前应用信息                         |
| metrics     | 应用的各项指标                       |
| mappings    | 应用 @RequestMapping 映射路径        |
| shutdown    | 关闭当前应用（需要进行配置才能开启） |
| trace       | 追踪信息（最新的 http 请求）         |

配置监控和管理端点开启与关闭：

~~~properties
# 第一种方式控制 info 端点的开启
management.endpoint.info.enabled=true
# 第二种方式控制 info 端点的开启
management.endpoints.web.exposure.include=health,info
# 排除 shutdown 端点（关闭此端点）
management.endpoints.web.exposure.exclude=shutdown
# 定制 info 信息
info.author=Hex
# 在配置文件中进行单独配置才能生效（可以使用 Post 请求远程停止应用）
management.endpoint.shutdown.enabled=true
~~~



SpringBoot 健康检查：SpringBoot 的健康检查通过在容器中注入 HealthIndicator 组件来进行健康检查，常见的实现如：`RedisHealthIndicator`、`ElasticsearchRestHealthIndicator` 等。

> 默认情况下，SpringBoot 只展示健康状况的简略信息，如果需要展示详细信息需要配置：
>
> ~~~properties
> management.endpoint.health.show-details=always
> ~~~

在开发过程中，如果我们有自定义组件需要进行健康检查，我们可以实现 HealthIndicator 来定制我们自己的健康检查：

~~~java
@Component
public class ApplicationHealthIndicator implements HealthIndicator {
    @Override
    public Health health() {
        // 根据逻辑返回对应结果
        return Health.up().withDetail("status", "没得毛病").build();
    }
}
~~~

注意：健康检查的 Indicator 必须命名为 xxxHealthIndicator。

此时访问健康端点结果：

~~~json
{
	"status": "UP",
	"components": {
		"application": {
			"status": "UP",
			"details": {
				"status": "没得毛病"
			}
		},
		"diskSpace": {
			"status": "UP",
			"details": {
				"total": 536870907904,
				"free": 302631677952,
				"threshold": 10485760,
				"exists": true
			}
		},
		"mail": {
			"status": "UP",
			"details": {
				"location": "smtp.qq.com:-1"
			}
		},
		"ping": {
			"status": "UP"
		}
	}
}
~~~