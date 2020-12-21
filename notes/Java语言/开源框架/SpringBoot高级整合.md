SpringBoot 官网：[https://spring.io/projects/spring-boot/](https://spring.io/projects/spring-boot/)

Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".



**目录**

1. [SpringBoot 与缓存](#1springboot 与缓存)





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
>     @Autowired
>     private EmployeeMapper mapper;
>     @Autowired
>     private EmployeeService self;
> 
>     @Cacheable(value = "employee", key = "#id")
>     public Employee getEmployeeById(int id) {
>         return mapper.getEmployeeById(id);
>     }
> 
>     public void demo(int id) {
>         //通过 self 自我调用
>         Employee employee = self.getEmployeeById(id);
>     }
> }
> ~~~