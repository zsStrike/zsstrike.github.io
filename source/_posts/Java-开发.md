---
title: Java 开发
date: 2023-01-01 16:18:47
tags: ["Java"]
---



本文记录 Java 开发过程的相关知识，以备查阅。

<!-- More -->

## 常用类库

Apache Commons：对 JDK 的扩展，包含了很多开源工具，常用包如下：

| 组件                  | 功能说明                                           |
| --------------------- | -------------------------------------------------- |
| Commons BeanUtils     | 针对 Bean 的工具集，使用反射机制实现               |
| Commons Codec         | 编码解码组件，如 DES，SHA1，MD5，Base64 等         |
| Commons Collections   | 集合组件，扩展 Java 标准的 Collections API         |
| Commons Compress      | 压缩解压组件                                       |
| Commons Configuration | 配置管理工具                                       |
| Commons CSV           | 读写 CSV 文件                                      |
| Commons Daemon        | 将普通的 Java 应用转变为系统的后台服务，如 Tomcat  |
| Commons DBCP          | 数据库连接池                                       |
| Commons DBUtils       | 对传统操作数据库的类二次封装                       |
| Commons Digester      | 是 XML 到 Java 对象的映射工具集                    |
| Commons Email         | 邮件操作组件                                       |
| Commons Exec          | 提供一些常用的方法用来执行外部进程                 |
| Commons FileUpload    | 为 Web 应用程序或 Servlet 提供文件上传功能         |
| Commons IO            | 处理 IO 的工具类包                                 |
| Commons Lang3         | 处理 Java 基本对象方法的工具类包                   |
| Commons Logging       | 统一的日志接口，同时兼顾轻量级和不依赖于具体的实现 |
| Commons Math          | 数学和统计计算方法类包                             |
| Commons Net           | 封装了各种网络协议的客户端                         |
| Commons Pool          | 提供了一整套用于实现对象池化的框架                 |
| Commons Primitives    | 对 Java 基本类型的扩展支持                         |
| Commons Validator     | 校验器和校验规则                                   |
| Apache HttpClient     | 提供 HTTP 客户端的相关方法实现                     |

Google Guava：包含了若干被 Google 中的 Java 项目依赖的核心库，相关组件如下：

| 组件              | 功能                                          |
| ----------------- | --------------------------------------------- |
| Basic Utilities   | 让 Java 语言更加舒适，如避免 null，前置条件   |
| Collections       | 对 JDK 集合的扩展，如不可变集合等             |
| Caches            | 本地缓存实现                                  |
| Functional idioms | 函数式编程风格，谨慎使用                      |
| Concurrency       | 并发                                          |
| Strings           | 非常有用的字符串工具                          |
| Primitives        | 扩展 JDK 未提供的原生类型（如int、char）操作  |
| Ranges            | 可比较类型的区间 API，包括连续和离散类型      |
| IO                | 僵化 IO 流和文件的操作，针对 Java 5 和 6 版本 |
| Hash              | 提供比 `Object.hashCode()` 更复杂的散列实现   |
| EventBus          | 发布-订阅模式的组件通信                       |
| Math              | 优化的、充分测试的数学工具类                  |
| Reflection        | Guava 的 Java 反射机制工具类                  |

Hutool：小而全的 Java 工具类库，通过静态方法封装，提供一下组件：

| 模块               | 介绍                                            |
| ------------------ | ----------------------------------------------- |
| hutool-aop         | JDK 动态代理封装，提供非 IOC 下的切面支持       |
| hutool-bloomFilter | 布隆过滤，提供一些 Hash 算法的布隆过滤          |
| hutool-cache       | 简单缓存实现                                    |
| hutool-core        | 核心，包括 Bean 操作、日期、各种 Util 等        |
| hutool-cron        | 定时任务模块，提供类 Crontab 表达式的定时任务   |
| hutool-crypto      | 加密解密模块，提供对称、非对称和摘要算法封装    |
| hutool-db          | JDBC 封装后的数据操作，基于 ActiveRecord 思想   |
| hutool-dfa         | 基于 DFA 模型的多关键字查找                     |
| hutool-extra       | 扩展模块，封装模板引擎、邮件、Servlet、二维码等 |
| hutool-http        | 基于 HttpUrlConnection 的 Http 客户端封装       |
| hutool-log         | 自动识别日志实现的日志门面                      |
| hutool-script      | 脚本执行封装，例如 Javascript                   |
| hutool-setting     | 功能更强大的 Setting 配置文件和 Properties 封装 |
| hutool-system      | 系统参数调用封装（JVM 信息等）                  |
| hutool-json        | JSON 实现                                       |
| hutool-captcha     | 图片验证码实现                                  |
| hutool-poi         | 针对 POI 中 Excel 的封装                        |
| hutool-socket      | 基于 Java 的 NIO 和 AIO 的 Socket 封装          |

Spring 常用工具类：可以考虑使用 Spring-core 中的相关 util 包，具体分为以下几类：

| 分类                 | 实例                                           |
| -------------------- | ---------------------------------------------- |
| 内置的 resource 类型 | UrlResource，ServletContextResource 等         |
| 工具类               | AnnotationUtils，PropertiesLoaderUtils 等      |
| xml 工具             | AbstractXMLReader，DomUtils 等                 |
| 其他工具集           | Assert，CollectionUtils，DigestUtils 等        |
| Web 相关工具集       | CookieGenerator，HtmlUtils，HttpUrlTemplate 等 |



日志类库发展：按照时间顺序，可以分为

+ Log4j：apache 开源项目，使用最为广泛的日志系统
+ JUL（java.util.logging）：sun 官方提供的日志，对标 Log4j，但是性能上存在问题
+ JCL（Jakarta Commons Logging）：apache 开源项目，提供统一的日志功能的接口
+ Logback：Log4j 创始人开发，提供更好的性能，如异步 logger，filter 等特性
+ SLF4J（Simple Logging Facade for Java）：和 JCL 类似，只提供日志的 API 接口
+ Log4j2：和 Log4j1 版本不兼容，设计上模仿了 SLF4J/Logback，性能得到提升

推荐使用日志门面（JCL/SLF4J）+日志系统（JUL/Log4j/Log4j2/Logback）的组合



JSON 库：

+ FastJson：阿里巴巴开发的 JSON 库，性能优秀，但是源码质量低，漏洞较多，不推荐
+ Jackson：社区十分活跃且更新速度很快
+ Gson：谷歌开发的 JSON 库，功能十分全面



Lombok：注解库，常用注解如下：

| 注解                | 说明                                                  |
| ------------------- | ----------------------------------------------------- |
| val                 | 修饰局部变量，相当于定义为 final                      |
| @NotNull            | 自动在方法内对该参数进行是否为空的校验                |
| @Cleanup            | 自动管理资源，自动执行清理工作                        |
| @Getter/@Setter     | 生成对应的 setter 和 getter 方法                      |
| @ToString           | 覆写 toString 方法                                    |
| @EqualsAndHashCode  | 生成 equals 和 hashcode 方法                          |
| @NoArgsConstructor  | 无参构造器                                            |
| @AllArgsConstructor | 全参构造器                                            |
| @Data               | @ToString，@EqualsAndHashCode，@Getter/@Setter        |
| @Value              | 是@Data 的不可变形式，只提供 getter 方法              |
| @SneakyThrows       | 自动抛出受检异常                                      |
| @Synchronized       | 锁对象是私有的属性 $LOCK，而不是 this 或者 class 对象 |
| @Log                | 根据注解生成不同的 log 对象，名称是 log               |
| @Builder            | 生成对象的建造者 builder                              |

Lombok 原理：注解解析方式有运行时解析和编译时解析，运行时解析需要将 @Retention 设置为 Runtime，这样通过反射就能获取到该注解；编译时解析则提供了 Pluggable Annotation Processing API 标准定义，此时 javac 执行过程如下：

![img](Java-开发/dev-package-lombok-2.png)

本质上，Lombok 实现了上述 API，在 javac 生成 AST 后，就能在 AST 中找到对应的注解节点，并且为其增加对应的节点以实现诸如 setter 和 getter 方法等功能

Lombok 优缺点：

+ 优点：减少代码量，更简洁
+ 缺点：对队友不友好，对调试不友好，会破坏封装性，可以考虑 Java14 中的 Record



MapStruct：解决业务代码中很多 JavaBean 之间的相互转化，比如 PO/DTO/VO 相互转化，主要通过 @Mapper 和 @Mapping 实现转换。和 Lombok 相似，其同样也是编译时解析，通过 setter 和 getter 实现对象转换过程，相较于反射，其性能较高



Java 开发中的各种 Object：

| 名称 | 使用范围                                           | 解释说明                                                     |
| ---- | -------------------------------------------------- | ------------------------------------------------------------ |
| BO   | 用于 Service，Manager，Business 等业务相关类的命名 | Business Object，业务处理对象，主要作用是把业务逻辑封装成一个对象。 |
| DTO  | 经过加工后的 PO 对象，其内部属性可能增加或减少     | Data Transfer Object，数据传输对象，主要用于远程调用等需要大量传输数据的地方，例如，可以将一个或多个 PO 类的部分或全部属性封装为 DTO 进行传输 |
| DAO  | 用于对数据库进行读写操作的类进行命名               | Data Access Object，数据访问对象，主要用来封装对数据库的访问，通过 DAO 可以将 POJO 持久化为 PO，也可以利用 PO 封装出 VO 和 DTO |
| PO   | Bean，Entity 等类的命名                            | Persistant Object，持久化对象，数据库表中的数据在 Java 对象中的映射状态，可以简单的理解为一个 PO 对象即为数据库表中的一条记录 |
| POJO | POJO 是 DO/DTO/BO/VO 的统称                        | Plain Ordinary Java Object，简单 Java 对象，它是一个简单的普通 Java 对象，禁止将类命名为 XxxxPOJO |
| VO   | 通常是视图控制层和模板引擎之间传递的数据对象       | Value Object，值对象，主要用于视图层，视图控制器将视图层所需的属性封装成一个对象，然后用一个 VO 对象在视图控制器和视图之间进行数据传输。 |



## 代码质量

单元测试：主要使用 JUnit 库进行，目前主要有两个版本，对应的注解如下：

| JUnit4       | JUnit5             | 注释                                                         |
| ------------ | ------------------ | ------------------------------------------------------------ |
| @Test        | @Test              | 表示该方法是一个测试方法，JUnit5 中不支持参数                |
| @BeforeClass | @BeforeAll         | 表示使用了该注解的方法应该在当前类中所有测试方法之前执行（只执行一次），并且它必须是 static 方法 |
| @AfterClass  | @AfterAll          | 表示使用了该注解的方法应该在当前类中所有测试方法之后执行（只执行一次），并且它必须是 static 方法 |
| @Before      | @BeforeEach        | 表示使用了该注解的方法应该在当前类中每一个测试方法之前执行   |
| @After       | @AfterEach         | 表示使用了该注解的方法应该在当前类中每一个测试方法之后执行   |
| @Ignore      | @Disabled          | 用于禁用一个测试类或测试方法                                 |
| @Category    | @Tag               | 用于声明过滤测试的  tag标签，该注解可以用在方法或类上        |
| @Runwith     | @Runwith           | 用于参数化测试，测试集（suit）测试等                         |
| Assert       | Assert             | 断言测试                                                     |
|              | @RepeatedTest      | 定义重试测试                                                 |
|              | @ParameterizedTest | 参数化测试                                                   |



Mockito：Java 中的 mock 框架，用于在测试时 mock 被依赖或者测试的对象，常用在真实对象很难获取或某些行为很难触发的场景中，主要使用方法通过 mock 来生成一个对象，然后使用 when 和 thenReturn 方法进行打桩，以控制对象的行为

| 注解     | 说明                                                  |
| -------- | ----------------------------------------------------- |
| @Mock    | 对 mock 方法的替代，配合 MockitoJUnitRunner 使用      |
| @Spy     | 对 spy 方法的替代，调用方法时默认走真实方法           |
| 参数匹配 | 如 anyInt()，anyList() 等                             |
| 静态方法 | mockito 默认不能 mock 静态方法，可通过 PowerMock 实现 |



统一命名风格：

+ 包命名：通常采用顶级域名作为前缀，随后紧跟功能模块名称
+ 类命名：建议使用驼峰命名，首字母大写
+ 接口命名：也是用驼峰命名法，通常使用形容词或者动词来描述接口行为
+ 抽象类：通常以 Abstract/Base 作为前缀
+ 异常类：需要使用 Exception 后缀
+ 方法名：驼峰命名，首字母小写，通常使用动词 + 名词组合
+ 变量名称：驼峰命名，首字母小写
+ 常量名称：全大写，使用 `_` 进行分割
+ 枚举命名：枚举类采用驼峰命名，定义的值按照常量命名
+ 接口实现类：按照 Impl 作为后缀
+ 测试类和测试方法：测试类通常使用 Test 后缀，测试方法通常使用 test 开头
+ 泛型：
  + E 表示 Element，通常用在集合中
  + T 表示 Type(类型)，通常指代类
  + K 表示 Key(键)，V 表示 Value (值)，通常用于 Map  中
  + N 表示 Number，通常用于表示数值类型
  + ？表示不确定的 Java 类型
  + X 用于表示异常
  + U，S 表示任意的类型



## 开发安全

OWASP：关注 Web 应用程序安全的项目，大约每三年更新一次"十大安全隐患列表"，总结了 Web 应用程序最可能、最常见的十大隐患，还包括消除这些隐患的建议



注入攻击：将不受信任的数据作为命令或查询的一部分发送到解析器，达到访问非授权信息的作用，包括诸如 SQL 注入，XPath 注入，命令注入，CRLF 注入，Host 头注入等。



CSRF（Cross-Site Request Forgery）：当用户成功进行身份验证后，浏览器就能得到一个标识其身份的 cookie，主要用户不关闭浏览器或者退出登录，以后访问网站都能带上这个 cookie。攻击者可以诱导用户点击第三方网站图片按钮，从而实现向原网站发送伪造请求的目的。需要注意以下几个点：

+ 攻击者并不能获取到 Cookie，只是借助受害者浏览器来为伪造请求自动增加 cookie
+ 通常 POST/PUT/DELETE 请求需要保护，GET 请求一般不会保护

CSRF 防御思路：

+ 验证 HTTP Referer 字段，该字段记录了 HTTP 请求的来源地址
+ 在请求地址中添加 token 并验证，在服务器端通过 Session 保存 csrf_token 进行比对
+ 在 HTTP 头中自定义属性并验证



XSS（Cross-Site Scripting）：攻击者向 Web 页面中插入恶意 Script 代码，当用户浏览时，Web 页面中的 Script 就能执行，达到攻击的目的

XSS 攻击类型：

+ 反射型：需要用户主动去访问带攻击的连接，网站随后将恶意文本包含在响应页面中
+ 存储型：利用后端不对数据做校验存储恶意代码，其他用户访问时达到攻击的目的
+ DOM 型：是放射型的变种，只不过攻击者会将攻击代码植入到页面中

XSS 防御：

+ escapeHTML：前后端使用对应的库来对 html 代码进行转义
+ 过滤和校验



DDoS（Distributed Denial of Service）：攻击者控制成千上万的机器来对目标机器进行攻击，以达到实现目标机器不能向外提供服务的目的。攻击者通常采用欺骗和伪装的策略来进行网络攻击，使网站服务器充斥大量要求回复的信息，消耗网络带宽或系统资源，导致网络或系统不胜负荷以至于瘫痪而停止提供正常的网络服务

攻击分类：

| 攻击分类   | 洪水攻击                                                     | 慢速攻击                                                     |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 网络层攻击 | ICMP/IGMP 洪水攻击                                           | /                                                            |
| 传输层攻击 | UDP 洪水攻击   <br />SYN 洪水攻击   <br />TCP 连接洪水攻击   <br />PSH+ACK 洪水攻击   <br />ACK 反射攻击   <br />RST 洪水攻击   <br />SSL洪水攻击 | Sockstress 攻击  <br />THC SSL Dos 攻击<br />SSL 洪水攻击    |
| 应用层攻击 | DNS QUERY 洪水攻击  <br />DNS NXDOMAIN 洪水攻击  <br />DNS 放大攻击  <br />HTTP 洪水攻击  <br />SNMP 放大攻击  <br />NTP 放大攻击 | Slowloris 攻击  <br />慢速 POST 请求攻击  <br />数据处理过程攻击 |







