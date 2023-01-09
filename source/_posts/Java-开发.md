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









