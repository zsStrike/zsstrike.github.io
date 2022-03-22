---
title: 《Java》备忘录
date: 2022-03-21 19:19:56
tags: ["Java"]
---

本文用于记录 Java 相关知识，以备查阅。

<!-- More -->



## 01 面向对象

面向对象的三大特征：

+ 封装：通过访问修饰符实现，优点是减少耦合，提高软件的可重用性
+ 继承：通过 extends 实现，表示 is-a 的关系
+ 多态：编译时多态指的是方法的重载，运行时多态指的是对象引用所指向的具体类型在运行期间才确定，运行时多态通过继承，重写，向上转型实现



## 02 基础知识

数据类型：8 种基本类型，对应 8 种包装类型，通过 `xxxValue` 和 `valueOf` 自动拆箱和装箱

缓存池：

+ 基本类型：除了 long，float 和 double，其它类型都有一字节的缓存池
+ String：字面量创建会先从常量池获取，没有的话再创建，new 创建不会加入常量池

String：被声明为 final，内部存储的 value 数组也被声明为 final，同时内部没有改变 value 指向的方法，因此保证了 String 类不可变，不可变的好处：

+ 可以缓存 hash 值
+ String Pool 的需要，如果可变将没有意义
+ 安全性和线程安全

String，StringBuilder，StringBuffer：

+ String 不可变，StringBuilder 和 StringBuffer 可变
+ String 和 StringBuffer 是线程安全的，StringBuilder 不是线程安全的

String.intern：可以保证相同内容的字符串变量引用同一的内存对象，其首先将字符串对象放到字符串常量池中，然后返回这个对象引用

参数传递：Java 中的参数是以值传递的形式传入方法中的，而不是引用传递

float 和 double：浮点数字面量默认是 double 类型，需要加后缀 `f` 将其表示为 float 类型

隐式类型转换：整型数字面量是 int 类型，使用复合运算符如 `+=` ，会自动类型转换

switch：从 Java 7 开始，支持 String 对象（对应的 hashcode ），但是其仍旧不支持 long

访问权限：

+ 类可见：其它类可以用这个类创建实例对象
+ 成员可见：其它类可以用这个类的实例对象访问到该成员

| 访问权限  | 本类 | 本包的类 | 子类 | 非子类的外包类 |
| --------- | ---- | -------- | ---- | -------------- |
| public    | 是   | 是       | 是   | 是             |
| protected | 是   | 是       | 是   | 否             |
| default   | 是   | 是       | 否   | 否             |
| private   | 是   | 否       | 否   | 否             |

抽象类和接口：

+ 抽象类：一般会包含抽象方法，抽象方法一定位于抽象类中，不能被实例化
+ 接口：是抽象类的延伸，在 Java 8 开始，引入了默认方法
+ 比较：
  + 抽象类提供了 is-a 的关系，而接口提供了 like-a 关系
  + 一个类只能继承一个抽象类，但是可以实现多个接口
  + 接口的字段只能是 static 和 final ，成员（字段和方法）只能是 public

super：

+ 访问父类的构造函数，需要放到子类构造函数第一行
+ 访问父类的成员

重写和重载：

+ 重写：存在于继承体系中，为了满足里式替换原则，需要满足
  + 参数列表和父类相同
  + 子类方法的访问权限必须大于等于父类方法
  + 子类方法的返回类型必须是父类方法返回类型或为其子类型
+ 重载：存在于同一个类中，指方法名相同，但是参数类型，个数，顺序至少有一个不同，应该注意的是，返回值不同，其它都相同不算是重载

Object 通用方法：getClass，hashCode，equals，clone，toString，notify，notifyAll，wait，finalize

equals 方法实现：

+ 检查是否为同一个对象的引用，如果是直接返回 true
+ 检查是否是同一个类型，如果不是，直接返回 false
+ 将 Object 对象进行转型
+ 判断每个关键域是否相等

hashCode：用于返回对象的哈希值，通常将每个字段看作是 R 进制中的某一位，R 一般取 31

clone：是 Object 类的 protected 方法，并不是 public，如果想要重写该方法，还需要实现 Cloneable 空接口。分为浅拷贝和深拷贝两种方式，可以使用更加安全的拷贝构造函数来拷贝一个对象

final：

+ 修饰数据时，表示数据是常量，对于引用类型，只是使其引用不变
+ 修饰方法时，表示方法不能被重写，private 方法隐式地指定为 final
+ 修饰类时，表示类不可被继承

static：

+ 静态变量：类变量，所有实例共享静态变量
+ 静态方法：在类加载的时候就存在了，不能是抽象方法，不能包含 this 和 super
+ 静态语句块：类初始化时运行一次
+ 静态内部类：非静态内部类依赖于外部类的实例，而静态内部类不需要
+ 静态导包：不用指定类名就可以使用方法，但是可读性降低
+ 初始化顺序：静态变量和静态语句块优先于实例变量和普通语句块，静态变量和静态语句块的初始化顺序取决于它们在代码中的顺序。在存在继承的情况下：
  + 父类(静态变量、静态语句块)
  + 子类(静态变量、静态语句块)
  + 父类(实例变量、普通语句块)
  + 父类(构造函数)
  + 子类(实例变量、普通语句块)
  + 子类(构造函数)

Java 7 版本新特性：

1. Strings in Switch Statement
2. Type Inference for Generic Instance Creation
3. Multiple Exception Handling
4. Support for Dynamic Languages
5. Try with Resources
6. Java nio Package
7. Binary Literals, Underscore in literals
8. Diamond Syntax

Java 8 版本新特性：

1. Lambda Expressions
2. Pipelines and Streams
3. Date and Time API
4. Default Methods
5. Type Annotations
6. Nashhorn JavaScript Engine
7. Concurrent Accumulators
8. Parallel operations
9. PermGen Error Removed

Java 和 C++ 区别：

+ Java 是纯粹的面向对象语言，C++ 既支持面向对象也支持面向过程
+ Java 通过虚拟机从而实现跨平台特性，但是 C++ 依赖于特定的平台
+ Java 没有指针，它的引用可以理解为安全指针，而 C++ 具有和 C 一样的指针
+ Java 支持自动垃圾回收，而 C++ 需要手动回收
+ Java 不支持多重继承，只能通过实现多个接口来达到相同目的，而 C++ 支持多重继承
+ Java 不支持操作符重载，而 C++ 可以
+ Java 的 goto 是保留字，但是不可用，C++ 可以使用 goto
+ Java 不支持条件编译，C++ 通过 #ifdef #ifndef 等预处理命令从而实现条件编译



## 03 泛型机制

引入泛型的意义：

+ 适用于多种数据类型执行相同的代码
+ 使用泛型可以提供编译前的检查，不需要强制类型转换，更加安全

泛型的使用：

+ 泛型类
+ 泛型接口
+ 泛型方法：相比泛型类，其更加灵活，在使用不同的参数的时候，不需要再次实例化一个对象

泛型的上下限：为类型参数增加限制

+ 上限：`<T extends Number>`，注意，extends 后面可以是接口，表示实现了接口的类型
+ 下限：`<T super String>`，表示 T 是 String 或者 String 的父类（Object）
+ 无限制通配符：`<T>` 或者 `<?>`
+ 多个限制：`<T extends A & B >`  或者 `<T extends A , B >`，通常一个类和多个接口

类型擦除：Java 中实现泛型的方式是在编译阶段进行类型擦除，即

+ 将所有泛型表示都替换为具体的类型
+ 为了保证类型安全，必要时插入强制类型转换
+ 自动产生桥接方法保证擦除后的代码具有泛型的多态性

证明类型擦除：

+ 原始类型相同：如`ArrayList<String>` 和 `ArrayList<Integer>` 的 getClass 返回值相同

+ 通过反射可以添加其他类型的元素：

  `strList.getClass().getMethod("add", Object.class).invoke(list, "asd")`

原始类型：指擦除了泛型信息，最后在字节码中的类型变量的真正类型

泛型的编译期检查：Java 编译期会先检查代码中泛型的类型，然后再进行类型擦除，之后进行编译

+ 类型检查就是针对引用的，谁是一个引用，用这个引用调用泛型方法，就会对这个引用调用的方法进行类型检测，而无关它真正引用的对象

+ 参数化类型不考虑继承关系，下面的引用传递不被允许：

  ```java
  // 编译错误，ClassCastException  
  ArrayList<String> list1 = new ArrayList<Object>(); 
  //编译错误，违背使用泛型的初衷
  ArrayList<Object> list2 = new ArrayList<String>(); 
  ```

泛型的多态实现：类型擦除会造成多态的冲突，JVM 采用桥接方法解决该问题

```java
class DateInter extends Pair<Date> {  

    @Override  
    public void setValue(Date value) {  
        super.setValue(value);  
    }  
    @Override  
    public Date getValue() {  
        return super.getValue();  
    }  
		// 编译器添加的桥接方法
  	public void setValue(Object value) {
      	setValue((Date)value);
    }
  	// 编译期添加的桥接方法
  	public Object getValue() {
      	return getValue();
    }
}

```

另外，子类中桥接方法`Object getValue()`和`Date getValue()`是同时存在的，虚拟机可以通过返回值和参数类型来区别，但是在编写程序的时候，Java 编译期不允许我们这样做。

基本类型不能作为泛型类型：无限制泛型擦除后将变为 Obejct，而 Obejct 不能存储 int 等基本类型

泛型类型不能实例化：本质上由于类型擦除造成的，如果确实需要实例化泛型，可以使用反射

泛型数组：采用通配符的方式初始化泛型数组（存在警告），因为对于通配符的方式最后取出数据是要做显式类型转换的，符合预期逻辑。更加优雅的方式是使用反射：`Array.newInstance`

泛型类中的静态方法和静态变量：不可以使用泛型类所声明的泛型类型参数，因为静态变量和静态方法不需要使用对象来调用，从而类型参数不确定，但是可以使用泛型静态方法

获取泛型的参数类型：通过反射 `java.lang.reflect.Type` 获取



## 04 注解机制

注解分类：

+ Java 自带的标准注解：`@Override`，`@Deprecated`，`@SupressWarning`
+ 元注解：用于定义注解的注解
+ 自定义注解：根据自己需求定义注解

自带的标准注解：

- `@Override`：表示当前的方法定义将覆盖父类中的方法
- `@Deprecated`：表示代码被弃用，如果使用了被 @Deprecated 注解的代码则编译器将发出警告
- `@SuppressWarnings`：表示关闭编译器警告信息

元注解：描述注解的注解

+ `@Target`：描述注解的使用范围，取值范围在 ElementType 枚举类中
+ `@Retention`：描述注解保留的时间范围，取值范围在 RetentionPolicy 中，共三种
+ `@Documented`：描述在使用 javadoc 工具为类生成帮助文档时是否要保留其注解信息
+ `@Inherited`：被它修饰的注解将具有继承性，被该注解修饰的父类，其子类自动具有该注解
+ `@Repeatable`：允许在同一申明类型(类，属性，或方法)的多次使用同一个注解
+ `@Native`：修饰成员变量，则表示这个变量可以被本地代码引用，常常被代码生成工具使用

注解和反射：通过反射下的 AnnotatedElement 接口可以获取注解，要求该注解范围是 RUNTIME 的

注解不支持继承：尽管在内部实现中，注解被翻译成 interface，但是并不能使用 extends 来继承某个 @interface，另外，在注解编译后，编译器会自动将其继承到 Annotation 接口

注解使用场景：

+ 配置化到注解化：框架的演进
+ 继承实现到注解实现：junit3 到 Junit4
+ 自定义注解和 AOP：通过切面实现解耦



## 05 异常机制

异常结构层次：

![java-basic-exception-1](《Java》备忘录/java-basic-exception-1-16488760948223.png)

+ 可查异常：编译器要求必须处理的异常，包括非运行时异常
+ 不可查异常：编译器不强制要求处理的异常，包括运行时异常和错误

异常关键字：try，catch，fainally，throw，throws

异常的声明（throws）：在方法末尾添加该语句即可，添加异常的规则

+ 如果是不可查异常，那么可以不使用 throws 来声明，因为在运行时会被系统抛出
+ 必须声明任何方法可抛出的的可查异常
+ 重写方法声明的异常必须是被重写方法声明的异常或者其子类

异常的抛出（throw）：有时在 catch 中抛出一个异常，目的是为了改变异常的类型

异常自定义：通过继承异常类实现，可以实现带有详细描述信息的构造函数用于调试

异常的捕获：

+ try-catch：同一个 catch 可以捕获多种不同的异常，使用 `|` 分割
+ try-catch-finally：不管有没有出现异常，finally 中的语句块始终会被执行，通常 finnaly 里面不要包含 return 语句
+ try-finally：保证资源使用后被关闭
+ try-with-resource：自动释放资源，需要资源实现了 AutoClaseable 接口的类

异常实践：

+ 只针对不正常的情况才使用异常，如可以通过判断规避掉 NullPointorException
+ 使用 finally 或者 try-with-resources 关闭资源
+ 尽量使用标准的异常，基于语义的基础
+ 对异常进行文档说明
+ 优先捕获最具体的异常
+ 不要捕获 Throwable 类，因为其会捕获 Error（如 OOM）
+ 不要忽略异常，至少记录异常的信息
+ 不要记录并抛出异常，可能导致多个地方输出同一个异常信息
+ 包装异常时不要抛弃原始的异常，否则失去了原始的堆栈信息
+ 不要使用异常控制程序的流程
+ 不要在 finally 块中使用 return，会覆盖 try 块中的返回点

JVM 处理异常的机制：编译器通过编译后，会生成对应的异常表，异常表每项表示为（from，to，target，type），表示在 [from, to] 代码段中可能发生异常，如果发生 type 类异常，就跳转到 target 对应的代码段。在发生异常的时候，JVM 查找异常表，跳转到对应的 target 地方

异常耗时：建立一个异常对象，大概是一个普通 Object 对象的 20 倍，而抛出，接收一个异常，所花费时间大约是建立异常对象的 4 倍



## 06 反射机制

反射机制：在运行时，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性。

Class 类：Class 类也是一个类，其实例用于表示运行时的类（class & enum）或接口（interface & annotation），数组和基本类型同样也被映射为 Class 对象的一个类

+ 手动编写的类编译后会产生 Class 对象，其被保存在同名 .class 文件中
+ 每个类在内存中只有一个对应的 Class 对象来描述其信息，采用单例模式
+ Class 类只存在似有构造函数，因此对应的 Class 对象只能通过 JVM 加载和创建

Class 类对象的获取：

+ 根据类名：类名.class
+ 根据对象：对象.getClass()
+ 根据全限定类名：Class.forName(全限定类名)

Constructor 类：表示 Class 对象所表示类的构造方法，相关方法如下：

+ getConstructor(Class<?>... parameterTypes)：返回具有 public 访问权限的构造函数对象
+ getDeclaredConstructor(Class<?>... parameterTypes)：返回所有（包括 private）构造函数对象
+ newInstance()：调用无参构造器创建新的实例
+ newInstance(Object... initargs)

Field 类：提供有关类或接口单个字段的信息，以及对它的动态访问权限

+ getField：获取指定的名称，且具有 public 修饰的字段，包括继承字段
+ getDeclaredField：获取指定的字段（包括 private），不包括继承的字段
+ set(Object obj, Object value) &  get(Object obj)：不可设置 final 字段
+ setAccessible(boolean flag)：设置其可访问性，用于访问 private 属性

Method 类：提供关于类或接口上单独某个方法的信息

+ getMethod(String name, Class<?>... parameterTypes)
+ getDeclaredMethod(String name, Class<?>... parameterTypes)
+ invoke(Object obj, Object... args)

反射调用流程：

+ 反射类和反射方法的获取，都是通过从列表中顺序搜寻查找匹配的方法
+ 当找到需要的方法时，都会 copy 一份出来，保证数据隔离
+ 每个类都可以获取 method 反射方法，并作用到其他实例身上
+ 反射也是线程安全的
+ 反射使用 reflectionData 缓存 Class 信息，避免开销



## 07 SPI 机制

SPI 机制：JDK 内置的服务提供发现机制，可以用来启用框架扩展和替换组件。服务提供者定义接口后，需要在 classpath 下的 `META-INF/services/` 目录下创建一个服务接口命名的文件，这个文件里的内容就是这个接口具体的实现类。

SPI 机制：JDBC DriverManager，在以前开发时，需要先 Class.forName 加载数据库相关的驱动，而在 JDBC4.0 之后直接获取连接就可以了

+ JDBC 接口定义：java 中定义了接口 `java.sql.Driver`，但是没有具体实现
+ 实现：
    + mysql：在 mysql 的 jar 包中，可以找到 `META-INF/services` 目录，该目录下面有一个 `java.sql.Driver` 的文件，文件内容是 `com.mysql.cj.jdbc.Driver`
    + postgresql：在对应的目录下面，也可以找到对应的配置文件
+ 使用方法：直接通过  `DriverManager.getConnection` 来获取连接，实际执行代码的步骤
    + 从系统变量中获取有关驱动的定义
    + 使用 SPI 来获取驱动的实现：`ServiceLoader.load`
    + 遍历使用 SPI 获取到的具体实现，实例化各个实现类

SPI 的缺点：

+ 不能按需加载，需要遍历所有的实现并实例化（懒加载），然后在循环中才能找到我们需要的实现
+ 获取某个实现类的方式不灵活，只能通过 Iterator 形式获取
+ 不是并发安全的



## 08 Collection 类

集合类：集合类用于容纳其他的 Java 对象，其只能存放对象，基本类型通常需要装包和解包

+ Collection：存储对象的集合

    ![img](《Java》备忘录/c25904af60394296a36c41d0c3749ab4.jpg)

+ Map：存储键值对的映射表

    ![img](《Java》备忘录/4c0ea9d4d39c4ab09ed7e81ac76993d1.jpg)

ArrayList：实现了 List 接口，允许存放 null 元素，底层通过 Object 数组实现，以便容纳任何类型的对象，为了追求效率，并没有实现线程同步

+ add，addAll，get，set，remove，indexOf，lastIndexOf
+ 自动扩容：如果添加数据时，超过 capacity 值，就会自动扩容，每次扩容变为之前容量的 1.5 倍，在实际添加大量元素前，可以通过 ensureCapacity 来提前分配
+ Fail-Fast：采用了快速失败机制，记录 modCount 参数来实现，在并发修改时，迭代器很快就会失败

LinkedList：底层是带有头尾节点的双向链表，同时实现了 List 接口和 Deque 接口，即可以看作是顺序容器，又可以看作是一个队列，同时可看作一个栈。不过关于栈或者队列，现在首选的是 ArrayDeque，其有着更好的性能。如果需要多个线程并发访问，可以采用 `Collections.synchronizedList()` 进行包装

+ getFirst，getLast，removeFirst，removeLast，remove，add，addAll，clear，set，get
+ Queue 方法：offer，poll，peek，remove，element
+ Qeque 方法：offerFirst，offerLast，peekFirst，peekLast，pollFirst，pollLast，removeFirstOccurrence，removeLastOccurrence

Stack：当需要使用栈时，推荐使用更高效的 ArrayDeque

Queue：支持两组格式的 api

+ 抛出异常：add，remove，element
+ 返回值（null）实现：offer，poll，peek

Deque：同样支持两组格式的 api，无非是如 offerFirst/offerLast 格式，ArrayDeque 实现了 Deque 接口，其底层采用循环数组实现

PriorityQueue：优先队列保证每次取出的元素都是队列中权值最小的（默认），元素大小即可以通过元素本身自然顺序，也可以通过构造时传入的比较器，不允许放入 null 元素，通过完全二叉树实现的小顶堆，意味着可以通过数组作为底层数据结构

+ 抛出异常：add，element，remove
+ 返回值：offer，peek，poll

HashMap：实现了 Map 接口，既允许 key 为 null，也允许 value 为 null，该类未实现线程同步

+ 插入：采用头插法进行插入，为了解决冲突，采用冲突链表方式

+ hashcode 决定了对象会被放到哪个 bucket 中，当多个对象的哈希值冲突时，equals 方法决定了这些对象是否是同一个对象

+ 数组扩容：有两个参数会影响 HashMap 的性能，初始容量和负载系数，负载系数用来指定自动扩容的临界值，当 entry 的数量超过 `capacity * load_factor` 时，容器将自动扩容并且重新哈希，每次扩容后容量为原来的 2 倍

+ Java 7 采用链表和数组实现 HashMap：

    ![HashMap_base](《Java》备忘录/HashMap_base.png)

+ Java 8 采用链表，数组和红黑树实现，主要不同在于当链表中的元素超过 8 个时，会将链表转换为红黑树，使得在进行查找的时候降低时间复杂度

    ![java-collection-hashmap8](《Java》备忘录/java-collection-hashmap8-164923318456410.png)

HashSet：对 HashMap 的一个简单封装，对 HashSet 的函数调用都会转换成合适的 HashMap 方法

LinkedHashMap：实现了 Map 接口，可以看作是 linkedlist 增强的 hashmap，其采用双向链表的形式将所有的 entry 连接起来，这样是为了保证元素的迭代顺序和插入顺序相同，另外，遍历的时候只需要从 header 开始遍历即可，遍历的时间复杂度和元素个数相同

![LinkedHashMap_base.png](《Java》备忘录/LinkedHashMap_base.png)

TreeMap：实现了 SortedMap 接口，会按照 key 的大小顺序对 Map 中的元素排序，其底层采用红黑树

+ ceilingKey，floorKey，higherKey，lowerKey
+ headMap，tailMap
+ descendingKeySet，pollFirstEntry，pollLastEntry，subMap

WeakHashMap：里面的 entry 可能会被 GC 自动删除，即使程序员没有调用 remove 或者 clear 方法

+ 用于需要缓存的场景，这是在于缓存 miss 并不会造成错误
+ 弱引用：虽然弱引用可以用来访问对象，但是在进行垃圾回收时并不会被考虑在内，仅有弱引用指向的对象依旧会被 GC 回收
+ 并没有 WeakHashSet：可以通过 `Collections.newSetFromMap`



## 09 IO 知识体系

![java-io-overview](《Java》备忘录/java-io-overview.jpg)

IO 分类：

+ 传输方式：
    + 字节流：读取单个字节，用来处理二进制文件
    + 字符流：读取单个字符，用来处理文本文件
+ 操作对象：文件，数组，管道，基本数据类型，打印，对象，缓冲，转换

字节转字符：通过 `{Input,Output}Stream{Reader,Writer}` 实现，char 类型使用 UTF-16be 编码

IO 设计模式：装饰者模式，FilterInputStream 属于抽象装饰者，为组件提供额外功能，如缓冲

![image](《Java》备忘录/DP-Decorator-java.io.png)

IO 常见类的使用：

+ 磁盘操作：File，表示文件和目录的信息
+ 字节操作：InputStream 和 OutputStream
+ 字符擦做：Reader 和 Writer
+ 对象操作：Serializable，只是一个标准接口，transient 关键字可以让某些属性不被序列化
+ 网络操作：Socket

























## 面试合集

+ Java 中应该使用什么数据类型来代表价格？

  如果不是特别关心内存和性能的话，使用 BigDecimal，否则使用预定义精度的 double 类型

+ 怎么将 byte 转换为 String？

  使用 new String(byte[] bytes) 创建，注意需要使用正确的编码 

+ Java 中怎样将 bytes 转换为 long 类型？

  先将其转换为 String，再使用 Long.parseLong

+ 存在两个类，B 继承 A，C 继承 B，我们能将 B 转换为 C 么? 如 C = (C) B；

  可以，向下转型，不安全，容易出现转型异常

+ 哪个类包含 clone 方法? 是 Cloneable 还是 Object？

  Object，Cloneable 只是一个标识性接口，不包含任何方法

+ a = a + b 与 a += b 的区别？

  += 隐式的将加操作的结果类型强制转换为持有结果的类型，如果两个整型（byte，short，int）相加，首先会将其提升到 int 类型，再执行加法操作

+ int 和 Integer 哪个会占用更多的内存？

  Integer，其需要额外存储对象的元数据

+ 我们能在 Switch 中使用 String 吗？

  从 Java 7 开始可以，但实际上是语法糖

+ 我们可以在 hashcode() 中使用随机数字吗？

  不可以，相同对象的哈希值必须相同

+ Java 中，Comparator 与 Comparable 有什么不同？

  Comparable 接口用于定义对象的自然顺序，而 comparator 通常用于定义用户定制的顺序。Comparable 总是只有一个，但是可以有多个 comparator 来定义对象的顺序。

+ final、finalize 和 finally 的不同之处？

  - final 是一个修饰符，可以修饰变量、方法和类。如果 final 修饰变量，意味着该变量的值在初始化后不能被改变
  - Java 技术允许使用 finalize() 方法在垃圾收集器将对象从内存中清除出去之前做必要的清理工作。这个方法是由垃圾收集器在确定这个对象没有被引用时对这个对象调用的，但是什么时候调用 finalize 没有保证
  - finally 是一个关键字，与 try 和 catch 一起用于异常的处理。finally 块一定会被执行，无论在 try 块中是否有发生异常

+ Java 中，Serializable 与 Externalizable 的区别？

  Serializable 接口是一个序列化 Java 类的接口，以便于它们可以在网络上传输或者可以将它们的状态保存在磁盘上，是 JVM 内嵌的默认序列化方式，成本高、脆弱而且不安全。Externalizable 允许你控制整个序列化过程，指定特定的二进制格式，增加安全机制。 

+ 异常关键字：throw、throws、try...catch、finally？

  throws 用在方法签名上，方法内部通过 throw 抛出异常，try 用于检测包住的语句块, 若有异常, catch子句捕获并执行catch块

+ finally 执行时机？

  当 try 和 catch 中有 return 时，finally 仍然会执行，finally 比 return 先执行，finally是在 return 后面的表达式运算后执行的（此时并没有返回运算后的值，而是先把要返回的值保存起来，管finally中的代码怎么样，返回的值都不会改变，仍然是之前保存的值），所以函数返回值是在 finally 执行前确定的，通常，finally 里面不要包含 return，否则程序会提前退出

+ 如何创建内部类和静态内部类对象？

  内部类：new OuterClass.new InnerClass；静态内部类：new OuterClass.StaticInnerClass

+ 不需要序列化的字段？

  声明为static和transient类型的数据不能被序列化， 反序列化需要一个无参构造函数

+ 局部变量为什么要初始化？

  局部变量分布在栈上，生命周期短，JVM 并不会主动初始化而降低自己的性能，因此，需要程序员在使用变量前给变量赋值





















