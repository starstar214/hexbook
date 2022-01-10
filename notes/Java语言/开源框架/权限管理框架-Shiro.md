Shiro 官网：https://shiro.apache.org/



---

#### 1.Shiro 介绍

权限管理相关概念：

1. 认证（Authentication）：通过凭据，如用户名/用户ID和密码，验证用户是否为合法用户。
2. 授权（Authorization）：授权发生在系统成功进行认证后，最终会授予访问资源的完全权限；授权决定了用户访问系统的能力以及达到的程度。

> :meat_on_bone: 每次用户在访问系统资源的时候，都要进行授权的检查。

认证中的相关概念：

1. 主体（Subject）：访问系统的用户（也可以是程序等）。
2. 身份信息（Principal）：主体认证身份信息的标识，标识必须具有唯一性；一个主体可以拥有多个身份信息（如：身份证号，用户名，电话号码等），但必须拥有一个主身份（Primary Principal）。
3. 凭证信息（Cridencial）：只有主体自己知道的安全信息，如密码、证书等。

授权中的相关概念：

1. 资源（Resource）：系统提供的功能和服务，如系统菜单、页面、按钮、商品信息等。
2. 权限（Permission）：主体能够使用哪些功能和服务，访问哪些资源。



权限管理的解决方案-基于 URL 进行权限拦截：在 HTTP 请求到达真正的资源之前进行拦截，进行进一步的授权检查。

需要使用的技术：filter、SpringMVC 拦截器

常见的权限管理框架：`Shiro`、`Spring Security`。

由于 Spring Security 的学习门槛较高，而 Shiro 使用简单、较为灵活，所以越来越多的用户选择 Shiro 来搭建系统的权限管理功能。

Shiro 和 Spring Security 的区别：

1. Spring Security 基于 Spring 开发，配合 Spring 更加方便，而 Shiro 需要和 Spring 进行整合开发。
2. Spring Security 对 Oauth、OpenID 也有支持，Shiro 则需要自己手动实现。
3. Spring Security 的权限细粒度更高。
4. Shiro 依赖性低，不需要任何框架和容器，可以独立运行（支持非 Web 项目）；而 Spring Security 依赖 Spring 容器和 Web 环境。



Shiro 框架架构：

1. SecurityManager（安全管理器）：它是 Shiro 的核心，它继承了 Authenticator、Authorizer、SessionManager 接口，主要负责认证、授权和会话管理等功能。
2. Authenticator（认证器）：负责对用户身份进行认证。
3. Authorizer（授权器）：用户在访问资源时对用户的权限进行判断。
4. Realm（领域）：用户的权限数据（一般从配置文件或数据库中进行读取）。
5. SessionManager（会话管理器）：shiro 自己定义了一套会话管理机制，它不依赖于 Web 环境的 session（此特性可以实现单点登录）。
6. SessionDao：对 session 会话操作的一套接口。
7. CacheManager（缓存管理器）：可以将用户权限数据保存在缓存中以提高系统性能。
8. Cryptogrphy（密码管理器）：Shiro 提供的一套加密解密组件。



---

#### 2.Shiro 环境搭建

创建 Maven 项目，添加 shiro 和 junit 依赖：

~~~xml
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-core</artifactId>
    <version>1.8.0</version>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
</dependency>
~~~

> :beach_umbrella: 除此之外还需要引入日志实现，这是因为 shiro 中使用了 slf4j 作为日志抽象层，但是并没有包含日志实现，需要我们手动添加日志实现 jar 包：
>
> ~~~xml
> <dependency>
>     <groupId>ch.qos.logback</groupId>
>     <artifactId>logback-classic</artifactId>
>     <version>1.2.6</version>
> </dependency>
> ~~~
>
> logback 就是 slf4j 的实现，如果加入的是 log4j 等日志实现则还需要加入对应的日志转换包。



在静态资源路径 resources 目录下创建用户的 Realm 信息（shiro.ini 文件）：

~~~ini
[users]
star=123456,superadmin,admin
niko=123456,public
[roles]
superadmin=user:create,user:update,user:delete,user:view
admin=product:create,product:update,product:delete,product:view
public=product:view
~~~



编写单元测试进行代码测试：

1. 创建安全管理器：

   ~~~java
   private DefaultSecurityManager initSecurityManager() {
       // 构建 shiro 安全管理器
       DefaultSecurityManager securityManager = new DefaultSecurityManager();
       // 创建 ini 格式的 realm
       Realm realm = new IniRealm("classpath:shiro.ini");
       // 设置用户 realm 到安全管理器
       securityManager.setRealm(realm);
       // 将安全管理器设置到运行环境中
       SecurityUtils.setSecurityManager(securityManager);
       return securityManager;
   }
   ~~~

   > :alarm_clock: 在进行认证、授权等操作之前，必须要先在当前线程中初始化安全管理器，否则会抛出错误：
   >
   > org.apache.shiro.UnavailableSecurityManagerException: No SecurityManager accessible to the calling code, either bound to the org.apache.shiro.util.ThreadContext or as a vm static singleton.  This is an invalid application configuration.

2. 模拟主体进行登录：

   ~~~java
   private void authentication() {
       Subject subject = SecurityUtils.getSubject();
       UsernamePasswordToken token = new UsernamePasswordToken("star", "123456");
       subject.login(token);
       System.out.println("是否拥有 superadmin 角色：" + subject.hasRole("superadmin"));
       System.out.println("是否拥有 admin 角色：" + subject.hasRole("admin"));
       System.out.println("是否拥有 public 角色：" + subject.hasRole("public"));
       System.out.println("是否拥有用户创建权限：" + subject.isPermitted("user:create"));
   }
   ~~~

   登入时会先进行账户校验，如果账户错误则抛出`UnknownAccountException`异常，如果密码错误则抛出`IncorrectCredentialsException`异常。



---

#### 3.自定义 Realm

在 Shiro 中，Realm 需要包含认证、授权、权限解析等功能，如果 Shiro 提供的现有 Realm 不能满足需求，我们还可以直接实现`AuthorizingRealm`来自定义 Realm 进行使用。

~~~java
public class MyRealm extends AuthorizingRealm {
    /** 获取授权信息 */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        return null;
    }

    /** 获取身份验证信息 */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        return null;
    }
}
~~~

1. 实现获取身份验证信息:

   ~~~java
   @Override
   protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
       UsernamePasswordToken upToken = (UsernamePasswordToken) token;
       if (!"jack".equals(upToken.getUsername())) {
           throw new UnknownAccountException("用户名不存在");
       }
       char[] password = upToken.getPassword();
       if (!"123456".equals(new String(password))) {
           throw new CredentialsException("密码错误");
       }
       // 传入的 principal 只有一个，则这个 principal 就是 PrimaryPrincipal
       return new SimpleAuthenticationInfo(token.getPrincipal(), token.getCredentials(), super.getName());
   }
   ~~~

   将 IniRealm 替换为 MyRealm 设置到 SecurityManager 中即可实现我们自定义的身份验证逻辑。

2. 实现授权逻辑：

   ~~~java
   @Override
   protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
       String username = principals.getPrimaryPrincipal().toString();
       System.out.println("根据用户名[" + username + "]获取权限...");
       SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
       authorizationInfo.addRole("admin");
       authorizationInfo.addStringPermission("user:create");
       return authorizationInfo;
   }
   ~~~

   

---

#### 4.Shiro 密码加密

散列算法：将任意长度的文本消息变成固定长度的摘要信息消息，算法不可逆。

散列算法常用于对密码进行加密，常用的散列算法有 MD5、SHA。



盐（salt）：如果单单使用散列算法对密码进行加密，安全性得不到保障（容易被一些算法所破解），一般在进行加密时，还需要提供一个盐与原始内容一起生成摘要，Shiro 中一般使用 Md5Hash 进行散列：

~~~java
@Test
public void testMD5() {
    // 直接进行散列
    Md5Hash md5 = new Md5Hash("123456");
    System.out.println(md5.toString());
    // 加盐散列
    Md5Hash md5WithSalt = new Md5Hash("123456", "salt");
    System.out.println(md5WithSalt.toString());
    // 加盐散列 3 次
    Md5Hash md5WithSalt5Times = new Md5Hash("123456", "salt", 3);
    System.out.println(md5WithSalt5Times.toString());
}
~~~

得到的结果如下：

~~~shell
e10adc3949ba59abbe56e057f20f883e
f51703256a38e6bab3d9410a070c32ea
d1b129656359e35e95ebd56a63d7b9e0
~~~

在线 MD5 解密网站：https://www.cmd5.com/，使用暴力法进行密码破解并进行存储。

如果将直接散列的密文在网站进行解密，能够很快被破解，即使加简单的 salt，解密网站也存在相关记录；如果使用相对复杂的盐，在网站则不太可能被查到。



> :banana: 在对密码加盐时，最好不要使用简单的用户名作为盐值，否则很容易被破译，可以使用密码、用户名以及其他用户信息的组合作为盐值进行加密。
>
> 常见的密码加密的解决方案为：
>
> 1. 系统使用一个公共盐（最好是比较复杂的如 UUID）。
> 2. 根据用户注册时的必要信息为每一个用户生成一个私有盐。
> 3. 将私有盐保存在数据库中。
> 4. 使用公共盐和私有盐共同进行加密。
>
> ~~~java
> public static Subject login(String username, String password) {
>     // 从数据库中查询出盐值
>     String salt = "";
>     String cipherText = encryptionPass(password, salt);
>     Subject subject = SecurityUtils.getSubject();
>     UsernamePasswordToken token = new UsernamePasswordToken(username, cipherText);
>     subject.login(token);
>     return subject;
> }
> 
> public static String encryptionPass(String password, String salt) {
>     String encryptedSource = new Md5Hash(password, PUBLIC_SALT).toString();
>     // 
>     return new Md5Hash(encryptedSource, salt, 3).toString();
> }
> ~~~



在初始化 SecurityManager 时，还可以设置一个缓存管理器将用户的权限纳入到缓存进行管理。

~~~java
public static void initSecurityManager() {
    // 构建 shiro 安全管理器
    DefaultSecurityManager securityManager = new DefaultSecurityManager();
    // 创建 ini 格式的 realm
    Realm realm = new IniRealm("classpath:shiro.ini");
    // 设置用户 realm 到安全管理器
    securityManager.setRealm(realm);
    // 设置缓存管理器
    CacheManager cacheManager = new MemoryConstrainedCacheManager();
    securityManager.setCacheManager(cacheManager);
    // 将安全管理器设置到运行环境中
    SecurityUtils.setSecurityManager(securityManager);
}
~~~

此时，在每一次检查用户权限时都会从内存当中直接获取。



---

#### 5.系统权限表设计

1. 创建用户表：`sys_user`（oracle）

   ~~~sql
   -- Create table
   create table SYS_USER
   (
     user_id     NUMBER(8) not null,
     username    VARCHAR2(255) not null,
     password    VARCHAR2(255) not null,
     salt        VARCHAR2(255) not null,
     email       VARCHAR2(255),
     mobile      VARCHAR2(255),
     status      NUMBER(1),
     create_time DATE,
     update_time DATE
   )
   tablespace STAR_TEST_DATA
     pctfree 10
     initrans 1
     maxtrans 255
     storage
     (
       initial 64K
       minextents 1
       maxextents unlimited
     );
   -- Add comments to the table 
   comment on table SYS_USER
     is '系统用户表';
   -- Add comments to the columns 
   comment on column SYS_USER.status
     is '0-正常，1-锁定，2-禁用，3-删除';
   -- Create/Recreate indexes 
   create unique index SYS_USER_UNIQUE_KEY on SYS_USER (USER_ID)
     tablespace STAR_TEST_DATA
     pctfree 10
     initrans 2
     maxtrans 255;
   ~~~

2. 角色表：`sys_role`（oracle）

   ~~~sql
   -- Create table
   create table SYS_ROLE
   (
     role_id     NUMBER(8) not null,
     role_name   VARCHAR2(255) not null,
     remark      VARCHAR2(255),
     create_time DATE,
     update_time DATE
   )
   tablespace STAR_TEST_DATA
     pctfree 10
     initrans 1
     maxtrans 255
     storage
     (
       initial 64K
       minextents 1
       maxextents unlimited
     );
   -- Add comments to the table 
   comment on table SYS_ROLE
     is '角色表';
   -- Create/Recreate indexes 
   create unique index SYS_ROLE_UNIQUE_KEY on SYS_ROLE (ROLE_ID)
     tablespace STAR_TEST_DATA
     pctfree 10
     initrans 2
     maxtrans 255;
   ~~~

3. 资源表：`sys_resource`（oracle）

   1. 系统资源有`目录`、`菜单`、`按钮`，需要使用一个 type 来进行区分。
   2. 系统中菜单资源含有页面链接，使用 url 表示。
   3. 系统中的菜单资源往往包含菜单 logo，使用字段 icon 表示。
   4. 系统资源的层级关系使用节点 ID 和父节点 ID 进行表示（resource_id、parent_id）。

   ~~~sql
   -- Create table
   create table SYS_RESOURCE
   (
     resource_id     NUMBER(8) not null,
     parent_id       NUMBER(8) not null,
     resource_type   NUMBER(1) not null,
     resource_name   VARCHAR2(255) not null,
     icon            VARCHAR2(255),
     url             VARCHAR2(255),
     permission_name VARCHAR2(255),
     resource_order  VARCHAR2(255),
     create_time     DATE,
     update_time     DATE
   )
   tablespace STAR_TEST_DATA
     pctfree 10
     initrans 1
     maxtrans 255
     storage
     (
       initial 64K
       minextents 1
       maxextents unlimited
     );
   -- Add comments to the table 
   comment on table SYS_RESOURCE
     is '系统资源表';
   -- Add comments to the columns 
   comment on column SYS_RESOURCE.resource_id
     is '资源 ID';
   comment on column SYS_RESOURCE.parent_id
     is '父节点 ID，一级资源的 ID 设为 0';
   comment on column SYS_RESOURCE.resource_type
     is '0-目录，1-菜单，2-按钮';
   comment on column SYS_RESOURCE.permission_name
     is '权限名称';
   comment on column SYS_RESOURCE.resource_order
     is '排序字段';
   -- Create/Recreate indexes 
   create unique index SYS_RESOURCE_UNIQUE_KEY on SYS_RESOURCE (RESOURCE_ID)
     tablespace STAR_TEST_DATA
     pctfree 10
     initrans 2
     maxtrans 255;
   ~~~

4. 用户与角色关系表：`sys_user_role`（oracle）

   ~~~sql
   -- Create table
   create table SYS_USER_ROLE
   (
     id      NUMBER(8) not null,
     user_id NUMBER(8) not null,
     role_id NUMBER(8) not null
   )
   tablespace STAR_TEST_DATA
     pctfree 10
     initrans 1
     maxtrans 255
     storage
     (
       initial 64K
       minextents 1
       maxextents unlimited
     );
   -- Add comments to the table 
   comment on table SYS_USER_ROLE
     is '用户角色表';
   -- Create/Recreate indexes 
   create unique index USER_ROLE_UNIQUE_KEY on SYS_USER_ROLE (USER_ID, ROLE_ID)
     tablespace STAR_TEST_DATA
     pctfree 10
     initrans 2
     maxtrans 255;
   ~~~

   其中 USER_ID 和 ROLE_ID 应当为联合主键。

5. 角色与资源关系表：`sys_user_role`（oracle）

   ~~~sql
   -- Create table
   create table SYS_ROLE_RESOURCE
   (
     id          NUMBER(8) not null,
     role_id     NUMBER(8) not null,
     resource_id NUMBER(8) not null
   )
   tablespace STAR_TEST_DATA
     pctfree 10
     initrans 1
     maxtrans 255
     storage
     (
       initial 64K
       minextents 1
       maxextents unlimited
     );
   -- Create/Recreate indexes 
   create unique index ROLE_RESOURCE_UNIQUE_KEY on SYS_ROLE_RESOURCE (ROLE_ID, RESOURCE_ID)
     tablespace STAR_TEST_DATA
     pctfree 10
     initrans 2
     maxtrans 255;
   ~~~

   其中 ROLE_ID 和 RESOURCE_ID 应当为联合主键。



---

#### 6.集成 SpringBoot

环境搭建：

2. 创建 SpringBoot 项目，选择需要的 starter，同时引入`shiro-spring-boot-starter` 

   ~~~xml
   <dependency>
       <groupId>org.apache.shiro</groupId>
       <artifactId>shiro-spring-boot-starter</artifactId>
       <version>1.8.0</version>
   </dependency>
   ~~~

3. 创建权限表对应的实体类，并且创建操作用户、角色、资源等功能接口和实现。


环境配置：

1. 创建自定义 Realm：

   ```java
   public class UserRealm extends AuthorizingRealm {
   
       @Override
       protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
           return null;
       }
   
       @Override
       protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
           return null;
       }
   }
   ```

2. 向容器中加入相关组件：

   ~~~java
   @Bean
   public UserRealm userRealm() {
       return new UserRealm();
   }
   
   @Bean
   public DefaultWebSecurityManager defaultWebSecurityManager(UserRealm realm) {
       DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
       // 设置 realm
       securityManager.setRealm(realm);
       return securityManager;
   }
   
   @Bean
   
   public ShiroFilterFactoryBean shiroFilterFactoryBean(DefaultWebSecurityManager securityManager) {
       ShiroFilterFactoryBean factoryBean = new ShiroFilterFactoryBean();
       factoryBean.setSecurityManager(securityManager);
       // 配置过滤规则
       Map<String, String> authMap = new HashMap<>();
       // 可以匿名访问 login 这一个 url
       authMap.put("/login", "anon");
       // 访问任何资源都需要认证和授权
       authMap.put("/**", "authc");
       factoryBean.setFilterChainDefinitionMap(authMap);
       // 设置未登录时跳转的 url，由此 url 向前端返回未登录的提示
       factoryBean.setLoginUrl("/unauth");
       return factoryBean;
   }
   ~~~

   shiro 中常用的内置过滤器：

   | Filter名称        | 类路径                                                       | 功能                                                         |
   | ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
   | anon              | org.apache.shiro.web.filter.authc.AnonymousFilter            | 指定的 url 可以匿名访问                                      |
   | authc             | org.apache.shiro.web.filter.authc.FormAuthenticationFilter   | 指定的 url 需要 form 表单登录，默认从请求中获取 username、password、rememberMe 等参数进行登录，如果登录不了则会跳转到 loginUrl |
   | authcBasic        | org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter | 指定的 url 需要 basic 登录                                   |
   | logout            | org.apache.shiro.web.filter.authc.LogoutFilter               | 登出过滤器，指定 url 实现登出功能                            |
   | noSessionCreation | org.apache.shiro.web.filter.session.NoSessionCreationFilter  | 禁止创建会话                                                 |
   | perms             | org.apache.shiro.web.filter.authz.PermissionsAuthorizationFilter | 需要指定权限才能访问                                         |
   | port              | org.apache.shiro.web.filter.authz.PortFilter                 | 需要指定端口才能访问                                         |
   | roles             | org.apache.shiro.web.filter.authz.RolesAuthorizationFilter   | 需要指定角色才能访问                                         |
   | ssl               | org.apache.shiro.web.filter.authz.SslFilter                  | 需要 https 才能访问                                          |
   | user              | org.apache.shiro.web.filter.authc.UserFilter                 | 需要"记住我"的用户才能访问                                   |




编写自定义 Realm 实现从数据库读取用户信息和权限信息：

```java
@Slf4j
public class UserRealm extends AuthorizingRealm {

    @Autowired
    private UserService userService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        UserDTO user = (UserDTO) principals.getPrimaryPrincipal();
        // 从数据库获取权限信息（以 : 分割的形式）
        Set<String> permissions = authService.getPermissionsByUser(user.getUserId());
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        authorizationInfo.setStringPermissions(permissions);
        // 从数据库获取角色信息
        Set<String> roles = authService.getRolesByUser(user.getUserId());
        authorizationInfo.setRoles(roles);
        return authorizationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        UsernamePasswordToken upToken = (UsernamePasswordToken) token;
        String username = upToken.getUsername();
        UserDTO user = userService.getUserByAccount(username);
        if (user == null) {
            throw new CustomAuthException(ResultEnum.ACCOUNT_NOT_EXIST);
        }
        String encryptedPass = MD5Kit.encrypt(new String(upToken.getPassword()), user.getSalt());
        if (ObjectUtil.notEqual(encryptedPass, user.getPassword())) {
            throw new CustomAuthException(ResultEnum.INCORRECT_PASSWORD);
        }
        if (user.getStatus() == UserStatusEnum.LOCKED.getStatus()) {
            throw new CustomAuthException(ResultEnum.ACCOUNT_LOCKED);
        }
        if (user.getStatus() == UserStatusEnum.FORBIDDEN.getStatus()) {
            throw new CustomAuthException(ResultEnum.ACCOUNT_FORBIDDEN);
        }
        // 认证成功
        log.debug("用户[{}]登陆成功...", username);
        // 直接封装 user 作为凭证，在授权步骤中可直接获取
        return new SimpleAuthenticationInfo(user, upToken.getCredentials(), getName());
    }
}
```



编写登陆代码：

1. 编写 controller：

   ~~~java
   @Autowired
   private AuthService service;
   
   @PostMapping("/login")
   public Result<UserInfoBO> doLogin(@RequestBody LoginReq req) {
       // 成功返回用户信息
       return Result.success(service.doLogin(req));
   }
   ~~~

2. 编写登陆逻辑：

   ~~~java
   @Override
   public UserInfoBO doLogin(LoginReq req) {
       Subject subject = SecurityUtils.getSubject();
       UsernamePasswordToken token = new UsernamePasswordToken(req.getAccountName(), req.getPassword());
       subject.login(token);
       // 登陆成功后向前端返回用户和权限信息
       UserInfoBO infoBO = new UserInfoBO();
       UserDTO userDTO = userService.getUserByAccount(req.getAccountName());
       infoBO.setUser(userDTO);
       // 返回资源树
       List<ResourceDTO> resource = resourceMapper.getResourceByUser(userDTO.getUserId());
       ResourceTreeNode tree = getResourceTree(resource);
       infoBO.setResourceTree(tree);
       return infoBO;
   }
   ~~~

登陆成功后向前端返回用户信息和权限信息。



为接口添加权限标签：

~~~java
@PostMapping
@RequiresPermissions("SYSTEM:USER:INFO:ADD")
public Result<Integer> addUser(@RequestBody UserDTO user) {
    int userId = service.addUser(user);
    return Result.success(userId);
}
~~~

