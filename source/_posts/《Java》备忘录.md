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





















