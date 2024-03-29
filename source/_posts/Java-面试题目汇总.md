---
title: Java 面试题目汇总
date: 2023-02-07 14:05:16
tags: ["Java"]
hidden: true
---



本文用于记录学习 Java 中遇到的问题，以备查阅。

<!-- More -->





1. Java 中对象和对象引用的区别？

   对象存储在堆内存中，对象引用一般存储在栈内存中，程序员直接操作的是对象引用，对象引用指向实际的对象。

2. JVM 中存在寄存器吗，若不存在该如何进行表达式计算呢？

   并不存在寄存器的概念，JVM 使用操作数栈来进行计算。

3. boolean 基本类型占用空间？

   Java 虚拟机规范中并没有明确指出 boolean 类型的内存占用，需要看虚拟机的具体实现，1 个字节或 4 个字节都是可能的。

4. static 关键字的作用？

   可以解释位类字段或者类方法，可以在不创建对象的时候直接使用，并且类变量在所有对象中共享。

5. 创建数组时，默认值是多少？

   全 0，对于对象数组则为 null。

6. 局部变量会被默认初始化吗？

   不会，对象字段会被默认初始化。

7. `i = i++` 和 `i = ++i` 的区别，i 初始值为 0？

   每个方法在执行时，都有一个栈帧与之对应，其中包含了局部变量，操作数栈以及其他数据。`i = i++` 表示先将 i 的值入栈，然后执行自增，这时局部变量 i 就变为 1，最后执行赋值操作，也就是将栈顶数据写回给 i，得到的最终值为 0；`i = ++i` 则是先执行自增操作，这是局部变量 i 为 1，接着将 i 入栈，最后执行出栈操作，得到最终值为 1。

8. Java 中浮点数强制转换为整型的规则？

   直接去掉浮点数，向 0 靠近。

9. Java 中如何跳出多重循环？

   使用标签和 break 即可。

10. Java 中的 switch case 语句支持字符串吗，原理如何？

    从 Java 7 开始支持字符串，JVM 虚拟机首先检查字符串的 hashCode，然后再对里面的字符串执行 equals，判断是否确实是对应的字符串，再决定是否跳转。

11. 方法重载的时候，返回值能否用于区分被重载的方法？

    不能，方法重载看的是方法签名，方法签名由方法名和方法参数类型构成。

12. 在构造器中调用本对象构造器时，需要注意什么？

    可以通过 this(param) 实现，但是只能调用一次，并且只能在构造器首行调用。

13. 在 Java 中为什么调用构造方法只能一次，并且在第一行？

    只能一次的原因是只需要创建一个对象就可以了，放在第一行可以保证其父类被安全创建。

    > JVM 规定：若构造器首行中没有构造器调用，则会插入 super() 调用，用于保证父类对象创建

14. 如何看待 Java 中 Object 对象提供的 finalize 方法？

    虽然该方法最初用于清理对象，但是现在一般不使用该方法，因为其可能导致对象意外复活；另外，无论是”垃圾回收”还是”终结”，都不保证一定会发生。如果 Java 虚拟机（JVM）并未面临内存耗尽的情形，它可能不会浪费时间执行垃圾回收以恢复内存。

15. 垃圾回收器工作方法？

    + 引用计数：对每个对象进行计数，每次有引用指向该对象时，引用计数加 1，而当引用被置为 null 时，引用计数减 1。垃圾回收器遍历对象，对那些引用计数为 0 的对象进行回收即可。该机制存在缺点，不能解决循环引用的问题。
    + 自适应的垃圾回收技术：对于任意“活”的对象，总是可以追溯到其存活在栈或者静态区的引用，从栈或者静态存储区出发，将会发现所有的活的对象。在垃圾对象较多的时候，可以采用停止-复制（stop-and-copy）算法，该算法需要阻塞主程序，并且需要两个堆，不适用于垃圾对象较少的情况；为此可以使用标记-清除（mark-and-sweep），每找到一个或对象，标记其即可，之后清除所有未标记的对象。

16. 不考虑继承，假设有个 Dog 类，当用户首次创建对象时，JVM 采取了哪些操作？

    + JVM 搜索类路径，找到 Dog.class，将其进行加载，即装入内存
    + 随后，执行静态初始化
    + 接着，当调用 `new Dog()` 时，首先需要在堆上为 Dog 对象分配足够的内存
    + 分配的内存首先会被清零
    + 执行出现在字段定义处的初始化动作，再接着执行实例初始化块
    + 最后执行对应的构造器

17. 考虑继承，假设 `Dog extends Animal`，当用户首次创建 Dog 对象时，初始化顺序？

    + 首先，JVM 查找 Dog.class，接着在加载过程中发现有一个父类，于是，转去先执行 Animal 类初始化的类加载和静态初始化操作，加载完成后再加载子类 Dog 和执行其静态初始化
    + 接着 new Dog 语句，执行对应的构造器，构造器首行一般有 JVM 插入的 super() 语句，于是先执行 Animal 类的实例初始化操作和构造器，接着再执行 Dog 类的实例初始化操作和构造器操作

    > JVM 会将对象初始化代码段里面的内容复制到所有构造器代码之前，super 调用之后，因此，在执行完子类的 static 代码段后，先去执行父类的初始化代码和构造器代码，再来执行子类的对象代码段和构造器代码段

18. 代码执行顺序分析？

    ```java
    class Test {
        int a = 1;
        {
            a = 2;
        }
        Test() {
            a = 3;
        }
    }
    ```

    通过 Java 字节码反编译，可以知道编译后的代码如下：

    ```java
    class Test {
        int a;
        Test() {
            super();    // jvm 插入的隐式调用父类构造器
            a = 1;		// jvm 移动初始赋值语句
            a = 2;		// jvm 移动实例初始化代码
            a = 3;		// 用户定义的构造器代码
        }
    }
    ```

    

19. enum 类型的 JVM 实现？

    enum 最终会编译为 class 对象，其继承 Enum 对象，并且里面的枚举值会被定义为对应的私有静态变量。

20. Java 访问权限修饰符？

    + public：当使用 public 关键字的时候，意味着 public 后声明的成员对于每个人都是可用的
    + protected：继承的类可以访问父类中对应的成员，同时也提供了包访问权限
    + default：指不加修饰符定义的成员，可以被相同包下的文件访问
    + private：除了包含成员的类，其他任何类都无法访问这个成员

21. 组合和继承的选择？

    当想要在新类中包含一个已有类的功能时，使用组合，而非继承；当使用继承时，使用一个现有类并开发出它的新版本，通常这意味着使用一个通用类，并为了某个特殊需求将其特殊化。组合用来表达“有一个”的关系，而继承则是“是一个”的关系。

22. 当父类没有无参构造器时，子类在构造器中需要显式指定父类的构造器，为什么？

    JVM 会为没有适用构造器调用的构造器加入 super() 语句，用于父类的初始化，但当父类没有无参构造器时，super() 就不能找到对应的构造器方法，从而产生报错。

23. final 关键字的作用？

    + final 数据：对于基本类型，final 使得数值恒定不变，对于对象引用，final 则是使得引用恒定不变
    + final 参数：在参数列表中，将参数声明为 final 意味着在方法中不能改变参数指向的对象或基本变量
    + final 方法：给方法上锁，防止子类通过覆写改变方法的行为，**类中所有的 private 方法都隐式地指定为 final**
    + final 类：当说一个类是 final ，就意味着它不能被继承

24. 类初始化和加载指什么？

    在 Java 中，每个类的编译代码都存在于它自己独立的文件中，该文件只有在使用程序代码时才会被加载。一般可以说“类的代码在首次使用时加载”。这通常是指创建类的第一个对象，或者是访问了类的 static 属性或方法。构造器也是一个 static 方法尽管它的 static 关键字是隐式的。因此，准确地说，一个类当它任意一个 static 成员被访问时，就会被加载。

25. 方法重载和方法重写区别？

    方法重载是指在同一个类中定义相同方法名，但是签名不同的方法；

    方法重写是指子类重写父类的方法（签名相同），可以借此实现多态特性。

26. Java 中的多态是如何实现的？

    当派生类重写父类方法后，并且使用向上转型后，调用重写方法后，编译器依旧会**动态绑定**到派生类中被重写的方法，执行方法调用。Java 中除了 static，final，private 方法是静态绑定，其他方法都是动态绑定的。

27. Java 中的多态能否实现对象属性的多态？

    不能，只有方法才能后期绑定，属性是根据引用类型来编译的，向上转型后，只能使用基类的属性。

28. Java 构造器内部多态方法的行为？

    如果在构造器中调用了正在构造的对象的动态绑定方法，就会用到那个方法的重写定义。

    ```java
    class Glyph {
        void draw(){System.out.println("Glyph.draw()");}
    
        Glyph() {
            System.out.println("Glyph() before draw()");
            draw();
            System.out.println("Glyph() after draw()");
        }
    }
    
    class RoundGlyph extends Glyph {
        private int radius = 999;
    
        RoundGlyph(int r) {
            draw();
            radius = r;
            System.out.println("RoundGlyph.RoundGLyph(), radius = " + radius);
        }
    
        void draw() {
            System.out.println("RoundGlyph.draw(), radius = " + radius);
        }
    }
    ```

    输出是：

    ```
    Glyph() before draw()
    RoundGlyph.draw(), radius = 0
    Glyph() after draw()
    RoundGlyph.draw(), radius = 999
    RoundGlyph.RoundGLyph(), radius = 5
    ```

29. 协变返回类型指什么？

    派生类在重写方法时，可以返回基类方法返回类型的派生类型。

30. Java8 后，接口中可以定义静态方法和默认方法，这些特性有什么作用？

    静态方法用于将工具功能置于接口中，使其成为通用的工具类；默认方法则是为那些没有实现接口方法提供的默认实现，可以在不破坏已有接口的结构下，在接口中中增加新的方法。

31. 抽象类和抽象方法？

    包含有抽象方法的类便是抽象类，抽象方法适用 abstract 关键词，不含有方法体。对于继承抽象类的派生类，需要实现所有的抽象方法，否则其也是一个抽象类，不可用于实例化。

32. 接口中定义的字段属于接口还是属于实现类的？

    接口中的字段自动是 static final 的，属于接口，可以使用其定义一堆常量，但在 Java8 中推荐使用 enum。

33. 抽象类和接口的异同点有哪些？

    相同点：提供了一种将接口与实现分离的更加结构化的方法

    不同点：

    + 类可以实现多个接口，但只能继承一个基类
    + 接口中不包含对象属性，抽象类中可以包含对象属性和类属性
    + 非抽象类可以不实现接口中的默认方法，但是必须实现抽象类中的抽象方法
    + 接口没有构造器，抽象类可以有构造器
    + 接口的可见形隐式 public，而抽象类可以有 protected 和 default 包访问权限

34. 接口可以被继承吗？

    可以，可以用于扩展原接口中的方法，另外，接口还支持多继承。

35. 内部类的创建方式？

    若在外部类的非静态方法里面，可以直接使用 new InnerClass 进行创建；否则的话必须使用 new OuterClass().new InnerClass() 语法进行创建。

36. 为什么当创建一个内部类的对象时，该对象能够访问到外部对象的所有成员，而不需要其他权限？

    当某个外部类的对象创建了一个内部类对象时，此内部类对象必定会秘密地捕获一个指向那个外部类对象的引用。编译器通过修改内部类的构造器实现，编译后内部类第一个参数便是外部类对象的引用。因此，在构造内部类时，经常需要先创建外部类对象。

37. `.this ` 和 `.new` 语法的作用？

    在内部类中，如果你需要生成对外部类对象的引用，可以使用外部类的名字后面紧跟圆点和 this；

    有时你可能想要告知某些其他对象，去创建其某个内部类的对象，此时可以使用 `.new` 语法。

38. 什么是嵌套类？

    实际上就是静态内部类，此时将内部类声明位 static 即可，此时内部类并不包含有指向外部类对象的引用，因此，可以直接通过 `new OuterClass.StaticInnerClass()` 方式进行创建，并且，嵌套类不能访问非静态的外部类对象的属性。另外，接口中的内部类默认是嵌套类。

39. 匿名内部类的作用？

    通常使用 `New ClassOrInterfaceName(params) {...}`，另外，如果匿名类内部希望使用一个定义在其外部的对象，那么编译器要求其参数引用必须是 final 的，或者必须是 effective final 的，但是注意在实例化匿名类的时候，可以使用非 final 修饰的变量。匿名内部类与正规的继承相比有些受限，因为匿名内部类既可以扩展类，也可以实现接口，但是不能两者兼备。而且如果是实现接口，也只能实现一个接口。

40. 如何实现继承内部类？

    因为内部类的构造器必须连接到指向其外部类对象的引用，所以在继承内部类的时候，事情会变得有点复杂。问题在于，那个指向外部类对象的“秘密的”引用必须被初始化，而在派生类中不再存在可连接的默认对象。因此需要创建一个包含构造器，构造器的参数需要有一个外部类的对象引用，然后通过 `outerObj.super()` 进行初始化。

41. Java 集合类库的两个概念?

    集合（Collection）和映射（Map）。

42. 迭代器工作原理？

    在 Java 中所有的集合类都实现了 iterable 接口，iterable 接口只有一个 iterator() 方法，具体的 iterator 则由集合类自己定义，通常是内部类（private），通过提供如 hasNext，next 等方法实现目的。也可以为了实现其他功能修改 iterator，如 ListIterator 就提供了前后遍历的方式。

43. 如何在遍历 List 的时候删除元素？

    + 使用迭代器提供的 remove 方法进行删除
    + 使用普通的 for 循环删除，但是需要注意删除后需要修改索引值（不推荐）
    + Java8 后，可以使用 removeIf 方法进行删除

44. LinkedList 实现了 Queue 接口和继承了 List 接口实现，peek 和 element 方法有什么不同？

    peek 在没有元素的时候会返回 null，但是 element 则会抛出异常。

45. Map 下主要有几类实现类？

    HashMap，TreeMap，LinkedHashMap。

46. ArrayDeque 的实现和作用？

    通过循环数组实现，可以当作栈，队列，双端队列使用。

47. Java 中 lambda 表达式基本格式？

    `(params) -> { statements; }`，只有一个参数的时候，可以省略括号，如果只有一行的话，花括号应该省略。

48. 方法引用基本格式以及注意事项？

    `ClassName::MethodName`，对于非静态方法，需要先实例化对象，在进行方法引用，对于构造器引用，直接使用 `ClassName::new` 即可。

49. 函数式接口主要分为哪几类？

    + 消费型接口：Consumer/accept，没有返回值，可以通过 andThen 组成消费者链
    + 供给型接口：Supplier/get，无参数，有返回值
    + 断言型接口：Predicate/test，有参数，boolean 返回值，可以通过 and，or 组合断言
    + 函数型接口：Function/apply，有参数和返回值，最为广泛

50. Java 中如何实现闭包？

    可以通过内部类实现，也可以通过函数式接口实现，Java 中的闭包的实现要求局部变量必须是 final 或者 effective final 的，其本质是因为 Java 中传参是按照 capture by value 来实现的，被引用的变量并不会提升到 heap 中。

51. 流式编程的特点？

    代码可读性更高；**懒加载**，意味着它只在绝对必要时才计算，由于计算延迟，流使我们能够表示非常大（甚至无限）的序列，而不需要考虑内存问题。

52. Java 中流操作主要分为三类，分别是？

    创建流，修改流元素（中间操作），消费流元素（终端操作）。

53. 创建流的方式有哪些？

    Stream.of 将一组元素转换为流元素，集合类可以通过 stream 方法产生流，数组则可以通过 Arrays.stream 产生，除此之外，还有随机数流，int 类型流等。

54. 流的中间操作有哪些？

    peek，sorted，distinct，filter，map，flatMap。

55. 流的终端操作有哪些？

    toArray，forEach，collect，reduce，allMatch，anyMatch，findFirst，findAny，count，min，max 等。

56. Optional 类的作用？

    主要是为了优雅解决 null 指针的问题，Optional 类中或者包含一个真实对象引用，或者为空。可以通过 empty，of，ofNullable 方法创建对象，通过 ifPresent/orElse/get 进行解包。

57. Java 中如何进行异常捕获的？

    通常使用 try-catch-finally 语句，在 Java7 后，也可以使用 try-wtih-resource 语句，其会自动关闭实现了 AutoClosable 接口的对象，并且是按照与创建顺序相反的顺序关闭它们，用于优雅关闭资源。

58. Java 中的 try-catch-finally 语句的执行方式，以及在不同代码块中加入 return，结果如何？

    + 无论 catch 是否捕获异常，finally 语句块都是要被执行的；

    + 当 try 块或 catch 块 return 一个值，那么 finally块中的代码会在执行 return 后，返回之前执行。（此时并没有返回运算后的值，而是把要返回的值**暂时保存**起来）。
    + finally 中如果包含 return，那么程序将**在这里返回**，而不是通过 try 或 catch 中的 return 返回，返回值就不是 try 或 catch 中保存的返回值了。

59. Java 中那两个类实现了对文件和路径的抽象？

    Path 和 File，分别有对应的工具类 Paths 和 Files。

60. 如何实现遍历目录的功能？

    通过 Files 下的 walk 或者 walkFileTree 即可实现遍历功能，后者灵活度更高。

61. 如何实现文件监听的功能？

    通过文件系统的 WatchService 可以设置一个进程对目录中的更改做出响应。

62. 什么是字符串的不可变性？

    String 对象是不可变的，String 类中的每个看起来会修改 String 值的方法，实际上都是创建了一个全新的 String 对象。但是如果内容并不改变，String 方法只是返回原始对象的一个引用而已。

63. StringBuilder 和 String Buffer 的异同点？

    都是用于原地操作字符串的类，区别在于前者不是线程安全的，后者是线程安全的。

64. CharSequese 接口的作用？

    从 CharBuffer，String，StringBuffer，StringBuilder 抽象出的一般化定义。

65. String 对象的 length 方法和 codePointCount 方法的区别？

    首先，对于 Java 来说，其采用 UTF-16 来保存文本，length 方法返回的是 code unit（也就是char）的数量，而 codePointCount 返回的是 UTF-16 编码下的字符个数。

66. Pattern 和 Matcher 类的作用？

    根据一个 String 对象生成一个 Pattern 对象，通过 Pattern 对象的 match 方法产生一个 Matcher 对象。

67. Matcher 中的组获取，对于 `A(B(C))D` ？

    `A(B(C))D` 中有三个组：组 0 是 ABCD，组 1 是 BC，组 2 是 C。通过 Matcher 对象的 group 方法可以获取到每个组。

68. Class 对象是什么？

    Class 对象包含了与类有关的信息，每个类都会产生一个 Class 对象，每当编译一个新类，就会产生一个 Class 对象（保存在同名的 .class 文件中）。为了生成该类的对象，JVM 首先会调用类加载器子系统将这个类加载到内存中。Java 是动态加载的，即只有在类需要的时候才会进行类的加载。所有的 Class 对象都属于 Class 类。

69. 如何获取类对应的 Class 对象？

    `类名.class`，`Class.forName` 和 `instance.getClass()`。

70. 类加载和链接的过程？

    加载：查找字节码，并且创建一个 Class 对象

    链接：验证字节码，为 static 字段分配存储空间，如果需要，将解析这个类对其他类的引用

    初始化：先初始化基类，然后执行 static 初始化器和 static 初始化块

71. 如何判断某个实例是否是某个类的实例？

    + instanceOf：关键字，判断某个实例是否是某个类的实例化对象
    + isInstance：Class 类中的方法，用于动态判断某个对象是否能强转为另外一个类，如 `0 instance of String` 本身会报错，但是 `String.class.isInstance(0)` 则可行。

72. 什么是反射以及反射的作用？

    指在程序的运行状态中，可以构造任意一个类的对象，可以了解任意一个对象所属的类，可以了解任意一个类的成员变量和方法，可以调用任意一个对象的属性和方法。 这种动态获取程序信息以及动态调用对象的功能称为Java语言的反射机制。

73. 动态代理是什么，实现原理？

    一个对象封装真实对象，代替其提供其他或不同的操作—这些操作通常涉及到与“真实”对象的通信，因此代理通常充当中间对象。通过调用静态方法 Proxy.newProxyInstance 来创建动态代理，同时还需要一个实现了 InvocationHandler 的类用于实现动态代理以便在调用方法前后进行一些个性化操作。

74. 泛型可以在哪些类型上应用？

    可以应用在泛型接口上，泛型类，泛型方法上。能使用泛型方法的话就不要使用泛型类。

75. `List<String>` 和 `List<Integer>` 在运行时类型信息是否相同？

    相同，涉及到泛型擦除，它们在运行时通过 getClass 得到的结果相同。

76. 如果想要使用泛型对应的方法，该如何定义泛型？

    可以使用 `<T extends Sup>` ，这样就可以使用 Sup 里面的方法。

77. 如何根据泛型创建对象？

    不可以用过 `new T()` 来实现，可以通过反射实现，可以传送一个 T 的 Class 对象，然后调用反射方法创建新的实例即可。

78. 泛型数组的声明和创建？

    可以通过 `List<String>[] list = new LinkedList[n]; list[0] = new LinkedList<String>();` 方式创建泛型数组；更加优雅的方式是通过 ArrayList 创建泛型数组。

79. 基本类型能否作为泛型类型？

    不能，但是可以使用对应的包装类型。

80. 什么是 Mixin？

    最基本的概念是混合多个类的能力，以产生一个可以表示混型中所有类型的类。Java 中实现方法有与接口混合，使用装饰器模式，与动态代理混合。

81. Arrays 相关方法？

    fill，setAll，asList，copyOfRange，deepToString，stream，sort & binarySearch。

82. enum 类型的本质？

    实际上就是继承自 Enum 类的派生类，在 enum 中的每个枚举值实际上就是 `public static final` 类型的变量。通过使用父类的 values 方法返回枚举值对应的类，使用 ordinal 方法返回枚举值的索引，使用 valueOf 则根据字符串常量创建对应的枚举类型。

83. enum 扩展性？

    enum 本身继承自 Enum 类型，不能再次继承，可以通过接口实现扩展，另外，可以在 enum 中声明自定义的方法和属性。

84. java.lang 中的注解有哪些？

    @Override，@Deprecated，@SuppressWarnings，@SafeVarargs，@FunctionalInterface。

85. 如何定义注解以及元注解是什么？

    使用 @interface 定义注解，元注解即用来注解自定义的注解，包括 @Traget，@Retention，@Documented，@Inherited，@Repetable。

86. 如何编写注解处理器？

    主要通过 Java 提供的反射机制来实现，通过反射可以获取到对应注解元素的注解，并且可以获取注解中的属性。JUnit 便是基于注解的测试单元。

87. Java 中的对象关联的 Monitor 对象是什么？

    用于处理和锁相关的对象，每个 Java 对象都有一个 Monitor 对象，里面的 owner 是哪个线程便表示哪个线程具有某个对象的锁。

    ![img](Java-面试题目汇总/v2-c447699ef3e74bd7855c5710cd7308d2_1440w.webp)

88. Java 中的 synchronized 关键字作用以及对应实现原理？

    实现同步锁，修饰实例方法的时候锁住的是方法调用所在的对象，静态的 synchronized 方法以 Class 对象为锁。其实现原理通过 JVM 添加的 monitorenter&monitorexit/Access flags 指令实现，每个 Java 对象都有一个 monitor 对象，当 monitor 被占用时就会处于锁定状态，线程执行 monitorenter 指令时尝试获取 monitor 的所有权：

    + 如果 monitor 的进入数为 0，则该线程进入 monitor，然后将进入数设置为 1，该线程即为 monitor 的所有者。
    + 如果线程已经占有该 monitor，只是重新进入，则进入 monitor 的进入数加 1。
    + 如果其他线程已经占用了 monitor，则该线程进入阻塞状态，直到monitor的进入数为0，再重新尝试获取 monitor 的所有权。

    而执行 monitorexit 的线程必须是 objectref 所对应的 monitor 的所有者，指令执行时，monitor 的进入数减1，如果减 1 后进入数为 0，那线程退出 monitor，不再是这个 monitor 的所有者。其他被这个 monitor 阻塞的线程可以尝试去获取这个 monitor 的所有权。

    > 同步代码即为临界区，monitorenter 即为进入区，monitorexit 即为退出区

89. Java 中的 wait&notify 的作用以及实现原理？

    这两个方法通常用于多线程之间的同步处理，wait 用于将本线程状态修改为 waiting 状态，而 notify 则是将最先进入 waiting 状态的线程唤醒。wait 实现原理是将对应线程移动到 WaitSet 中，而 notify 则是将 WaitSet 中最先进入的线程移动到 EntryList 中，用于竞争锁，竞争到锁才能进入运行态。

90. 调用 notify/notifyAll 是随机从等待线程队列中取一个或者按某种规律取一个来执行？

    + 如果是通过 notify 来唤起的线程，那先进入 wait 的线程会先被唤起来
    + 如果是通过 notifyAll 唤起的线程，默认情况是最后进入的会先被唤起来，即 LIFO 的策略

91. 调用 notify/notifyAll 后等待中的线程会立刻运行吗？

    并不会，notify 后对应的进程只是进入了 EntryList，可以参与锁竞争，只有获取到了锁才会成为 Owner，进入运行态。

92. wait 会影响性能吗？

    wait/nofity 是通过 jvm 里的 park/unpark 机制来实现的，在 linux 下这种机制又是通过 pthread_cond_wait/pthread_cond_signal 来实现的，因此当线程进入到 wait 状态的时候其实是会放弃 cpu的，也就是说这类线程是不会占用 cpu 资源，从而不影响性能。

    > 虽然不影响性能，但是可能存在上下文切换的开销

93. join 关键字作用，如何实现？

    让主线程等待子线程结束之后才能继续运行，用于子线程和主线程之间的同步。

    join 方法本身是同步方法，当主线程调用时，主线程会获取子线程对象的 monitor，之后，在 join 方法里面，主线程执行了 wait 操作，其被加入到子线程对象 monitor 中的 WaitSet 中，实现主线程等待；之后，子线程结束时，JVM 会调用 notifyAll 唤醒所有等待进程，达到唤醒主线程的作用。

94. sleep 方法会释放锁资源吗，会释放 CPU 资源吗？

    sleep 方法并不会释放锁资源，但是会释放 CPU 资源。其是通过 JVM 封装操作系统底层实现而实现的：

    + 挂起进程（或线程）并修改其运行状态，即让出CPU控制权限；
    + 用 sleep() 提供的参数来设置一个定时器；
    + 当时间结束，定时器会触发，内核收到中断后修改进程（或线程）的状态。例如线程会被标志为就绪而进入就绪队列等待调度。

95. yield 方法作用？

    暂停当前线程，以便其他相同优先级的线程有机会执行，不过不能指定暂停的时间，并且也不能保证当前线程马上停止。yield 方法只是将 Running 状态转变为 Runnable 状态。

96. interrupt 方法的作用和实现方式？

    实际上是提供了一种优雅中止线程（线程协作）的方法。在以前可以通过 Thread.stop 暴力停止一个线程，这种方法太过暴力并且不是安全的，为此，stop 方法被废弃。interrupt 方法则不会真正停止一个线程，它仅仅是给这个线程发了一个信号告诉它它应该结束了（设置一个标志位）。而线程本身应该循环监测自己的中断标志位，以对其进行响应的操作，如回收资源，结束线程自身。

    Thread.interrupted() 会返回标记位，并且同时清除标志位，并不是代表线程又恢复了，可以理解为仅仅是代表它已经响应完了这个中断信号然后又重新置为可以再次接收信号的状态。

97. 什么是可重入锁？

    可重入锁就是说某个线程已经获得某个锁，可以再次获取该锁而不会出现死锁。synchronized 便是可重入锁。

98. Java 关键字 volatile 作用？

    其作用是对变量的更新操作对其他线程时可见的，适用于一个线程修改，多个线程读取的场景。不建议过度使用 volatile 变量，因为volatile 变量只能保证可见性，不能确保原子性。如果需要确保原子性，请使用 synchronized 关键字。

    实现原理通过对变量的写入和读取都直接通过主内存实现，即

    + 线程对变量进行修改之后，要立刻回写到主内存。
    + 线程对变量读取的时候，要从主内存中读，而不是工作内存。

    另外也通过防止重排序来保证该可见性。

99. 什么是线程封闭，如何实现线程封闭？

    避免同步的方式就是不共享数据，如果仅在单线程内访问数据，就不需要同步，这就是线程封闭。

    + Ad-hoc 线程封闭：维护线程封闭的职责完全由程序实现来承担。
    + 栈封闭：是线程封闭的一种特例，在栈封闭中，只能通过局部变量才能访问到对象。
    + ThreadLocal 类：创建一个只能被当前线程使用的对象。ThreadLocal 提供 get 和 set 方法，这些方法实际上是通过将对应的对象存入 Thread 类中的 threadLocals 映射中实现的。

100. 操作系统中进程状态有哪些，Java 中的线程状态有哪些？

     操作系统中进程状态有 New，Ready，Running，Blocked，Terminated，（Ready-Suspend，Blocked-Suspend）。

     Java 中的状态有：

     + New：A thread which has not yet started.
     + Runnable：for a runnable thread.  A thread in the runnable state is executing in the Java virtual machine but it may waiting for other resources from the operating system such as processor.
     + Blocked：for a thread blocked waiting for a monitor lock.
     + Waiting：for a waiting thread. After call wait, join, park with no timeout. A thread in the waiting state is waiting for another thread to perform a particular action.
     + Timed-Waiting：for a waiting thread with a specified waiting time. After call sleep, wait, join, parkNanos, parkUntil.
     + Terminated

     Java 中的 Runnable 状态对应操作系统中的 Ready 和 Running 状态，操作系统中的 BLOCKED 状态对应 Java 中的 Blocked，Waiting，Timed-Waiting 状态。

101. volatile 和 synchronized 区别？

     volatile 关键字只保证变量的可见性，即修改某个变量后可以保证其他线程可见，但不保证修改操作的原子性；而 synchronized 在修改了本地内存中的变量后，解锁前会将本地内存修改的内容刷新到主内存中，确保了共享变量的值是最新的，也就保证了可见性，另外其通过加锁实现了原子性。

102. final 关键字能保证可见性吗？

     final 可以保证可见性，被 final 修饰的字段在构造方法中一旦被初始化完成，并且构造方法没有把 this 引用传递出去，在其他线程中就能看见 final 字段值。

     + 写 final 域重排序规则：禁止把 final 域的写重排序到构造方法之外，编译器会在 final 域的写后，构造方法的 return 前，插入一个 Store Store 屏障。确保在对象引用为任意线程可见之前，对象的 final 域已经初始化过。
     + 读 final 域重排序规则：在一个线程中，初次读对象引用和初次读该对象包含的 final 域，JMM 禁止处理器重排序这两个操作。编译器在读 final 域操作的前面插入一个 Load Load 屏障，确保在读一个对象的 final 域前一定会先读包含这个 final 域的对象引用。

     在旧的 JMM 中，一个严重缺陷是线程可能看到 final 值改变。比如一个线程看到一个 int 类型 final 值为 0，此时该值是未初始化前的零值，一段时间后该值被某线程初始化，再去读这个 final 值会发现值变为 1。该漏洞通过 JSR-133 修复。

103. Java 中的单例模式创建方式有哪些？

     线程安全的懒汉式，线程安全的饿汉式，双重校验锁的饿汉式，枚举，静态内部类。

104. Java 中的双重校验锁实现的单例模式？

     ```java
     //双重校验锁单例
     public class SingleInstance {
         //必须volatile修饰 见分析1
         private volatile static SingleInstance instance;
         //私有化构造函数
         private SingleInstance() {
         }
     
         public static SingleInstance getInstance() {
             //第一个判空 见分析2
             if (instance == null) {
                 synchronized (SingleInstance.class) {
                     //第二个判空 见分析3
                     if (instance == null) {
                         //新建实例
                         instance = new SingleInstance();
                     }
                 }
             }
             return instance;
         }
     }
     ```

     + 分析2：为什么在进入同步代码块时需要进行进行判空，假如有线程A和线程B，这时线程A先判断instance为null，所以它进入了同步代码块，创建了对象，然后线程B再进来时，它就不必再进入同步代码快了，可以直接返回，也其实也就是懒加载，可以加快执行速度。

     + 分析3：为什么在同步代码块中还要再进行一次判断呢，假如有线程A和线程B，它俩A先调用方法，B紧接着调用，这时A、B在分析2出的判空都是空，所以A进入同步代码块，B进行等待，当A进入同步代码块中创建了对象后，A线程释放了锁，这时B再进入，如果这时不加分析3的判空，B又会创建一个实例，这明显不符合规矩。

     + 分析1：`instance = new SingleInstance()`，实际执行序列如下，

       1. 给 SingleInstance 分配内存
       2. 调用 SingleInstance 的构造方法
       3. 把 instance 指向分配的内存空间

       Java内存模型允许这个进行指令重排序，也就是这 3 步可能是 123 也可能是 132，所以这里就有问题了。假如线程 A 和线程 B，线程 A 已经跑到分析 3 处的代码，这时这条指令执行是 132，刚把步骤3执行完，这时线程 B 跑到了分析 1 处的代码，会发现instance不为null了，这时线程B就直接返回了，从而导致错误。既然知道了原因，那 volatile 关键字就是解决这个的，它可以禁止指令重新排序，而且保证所有线程看到这个变量是一致的，也就是不会从缓存中读取(这个特性后面有机会再说)，所以在创建 instance 实例时，它的步骤都是 123，就不会出错了。

105. Java 监视器模式设计？

     通过组合的方式封装内部对象，内部对象可能是线程不安全的，但是通过增加外部监视器对象，其可以变成线程安全的。在 Java 中的 Vector，Stack 和 HashTable 便采用了监视器模式。

106. 为什么 Java 中的 Vector，Stack 等对象被弃用？

     + Vector 默认扩容 1 倍，ArrayList 默认扩容 0.5 倍，节省空间

     + Vector 每个方法加锁，在单线程中没有必要

     + 尽管 Vector 每个方法是线程安全的，但是不代表外部使用者使用它们也是线程安全的

       ```java
       if (!vector.contains(key)) { vector.add(key); }
       ```

       加入两个两个线程，先后执行 vector.contains(key)，那么此时 vector 中会被添加两次 key，与预期并不符合。推荐使用 CopyOnWriteArrayList。

107. CopyOnWriteArrayList 如何实现的，是绝对线程安全的吗？

     ReentrantLock + volatile + 数组拷贝 实现，volatile 保证修改后其他线程可见新的内部数组引用。

     也不是，并发执行如下执行序列可能会报错：

     ```java
     Thread A: size = list.size();
     Thread B: list.remove(0);
     Thread A: list.get(size - 1);
     // ArrayIndexOutOfBound
     ```

108. hashcode 和 equals 方法的作用，以及使用案例？

     都是 Object 类下面的方法，因此所有类都继承该方法：

     + equals 默认比较两个对象的地址，和使用 == 效果相同；
     + hashcode 则返回对象的哈希码，是一个本地方法

     通常，如果自定义对象需要作为 HashMap，HashSet 等结构的键时，这时我们就需要重写 hashcode 算法，以提高效率，如果两个对象生成的 hashcode 相同，那么此时就需要使用 equals 方法进行比对。因此可以总结出：

     + equals 相同的对象必定含有相同的 hashcode 值，但 hashcode 相同的对象它们不一定 equals 相同

     在实践上，推荐只要重写了 equals 方法的对象，都重写一下 hashcode 方法，免得在使用它们作为 Map 键时遗忘。

109. 什么是 ConcurrentModificationException？如何解决该问题？

     如果在迭代期间对迭代对象进行了修改，可能就会抛出该异常。常用方案：

     + 使用加锁：效率较低
     + 克隆容器：先克隆容器，然后再其上进行迭代，空间消耗较大，如 CopyOnWriteList

110. ConcurrentHashMap，HashTable 和 Collections.synchronizedMap 有什么不同？

     HashTable 和 Collections.synchronizedMap 都是通过 synchronized 加锁实现的，实现基本类似；

     ConcurrentHashMap 则通过采用分段锁的思想，通过一系列的 Segments 来保存数据，这样就降低了锁粒度，提高了并发度。并发容器类提供的迭代器不会抛出 ConcurrentModificationException，因此不需要在迭代过程中对容器加锁。由于他们返回的迭代器具有弱一致性，也即可以容忍并发的修改，当创建迭代器会遍历已有的元素，并可以（不保证）在迭代器构造后将修改反映给容器。

     > ConcurrentHashMap 在 JDK8 后，若溢出块太多，采用红黑树来管理溢出块，加速访问

111. ConcurrentHashMap 为什么不允许键值为 null？

     不允许值为 null：会带来二义性问题，如通过 map.get(key) 返回 null 的时候，可能是 map 中本来就没有这个 key，或者 map 中有这个键，但是键对应的值为 null。在 HashMap 中允许值为 null 是因为可以通过 map.containsKey 来进行判断，但是在多线程中，map.containsKey 不是原子执行的，可能在执行过程中，其他线程进行了 put 动作，导致得到非预期的结果。

     不允许键为 null：在源码中定义的，Dogue Lea 强制规定的，他本人比较讨厌 null。

112. 阻塞队列中的 take&put 和 poll&offer 方法有什么区别？

     阻塞队列在实现上是通过 Conditon 接口中的 await/signal 实现线程间同步的。

     take 在队列空时会进入等待，会等待下一个生产者通过 signal 唤醒，是可以进入阻塞态的；

     而 poll 在队列空时，直接返回 null，非阻塞实现。

113. Conditon 接口有什么作用？其实现生产者-消费者阻塞队列的原理？

     Condition 是在 java 1.5 中才出现的，它用来替代传统的 Object 的 wait()、notify() 实现线程间的协作，相比使用 Object 的 wait()、notify()，使用 Condition 的 await()、signal() 这种方式实现线程间协作更加安全和高效。

     对于由 Condition 实现的生产者-消费者阻塞队列：当线程 Consumer 中调用 await 方法后，线程Consumer 将释放锁，并且将自己沉睡，等待唤醒，线程 Producer 获取到锁后，开始做事，完毕后，调用Condition 的 signalall 方法，唤醒线程 Consumer，线程 Consumer恢复执行。

114. 有哪些可以实现线程间同步的类或接口？

     + CountDownLatch：像是个门闩，通过 countDown&await 实现线程间同步
     + Semaphore：信号量，通常用作可用资源的计数统计，通过 acquire&release 实现同步
     + Barrier：类似 Latch，但是用于运行速度快的线程等待慢的线程，通过 await 等待，所有线程到达将会自动打开，Java 中实现了 CyclicBarrier
     + FutureTask：实例化可以传入一个 Callable 接口，然后通过 fut.get() 实现线程同步
     + wait&notify：通过 JVM 实现，实现线程同步
     + await&signal：通过 JUC 实现，是 Condition 接口里面的方法

115. 在 Java 中如何执行大批量的任务，或者执行任务的优雅方式是什么？

     通过 Executor 来实现任务执行的抽象，其包含有一个 execute 接口。内置的几种默认的 ExecutorService：

     + Executors.newFixedThreadPool：固定线程个数的线程池
     + Executors.newCachedThreadPool：线程个数不固定的线程池，但是会尝试复用已经创建了的线程
     + Executors.newSingleThreadPool：单线程的线程池
     + Executors.newScheduledThreadPool：固定个数的线程池，用于处理周期任务

116. ExecutorService 生命周期是什么？其中的 shutdown 和 shutdownNow 方法的区别？

     生命周期是运行，关闭，已终止。

     shutdown 方法将会执行平缓的关闭过程：不再接受新的任务，同时等待已经提交的任务执行完成。而 shutdownNow 方法则执行粗暴的关闭过程：它将尝试取消所有运行中的任务，同时不再启动队列中尚未开始的任务。

117. ExecutorService 中的 execute 和 submit 的异同点？

     + 都用来向线程池中添加一个任务，让线程池异步执行该任务
     + execute 只能添加 Runnable 任务，submit 可以添加 Runnable 和 Callable 任务
     + execute 是在 Executor 接口中定义的，submit 则是在 ExecutorService 中定义的
     + submit 返回值 Future 类型，execute 没有返回值
     + submit 方式提交的任务若在执行的过程中抛出了异常的话，异常信息会被吃掉（在控制台中看不到），需要通过 Future.get 方法来获取这个异常；使用 execute 方式提交的任务若在执行的过程中出现异常的话，异常信息会被打印到控制台

118. Java 中如何进行延迟任务和周期任务？

     + 可以使用 Timer 和 TimerTask 实现延迟任务和周期任务
     + 可以使用 ScheduledExecutorService，Timer 在执行所有的定时任务的时候只会创建一个线程。如果某个任务的执行时间过长，那么将会破坏其他 TimerTask 的定时精确性。基于以上原因，建议使用 ScheduledThreadPoolExecutor。

119. Runnable 和 Callable 的区别？

     两者都可以用作任务的抽象，但是前者不包含返回值，而后者包含返回值。

     当使用 Callable 作为任务的抽象时，可以使用 Future 来检测任务是否执行并且获取运行结果，以便进行线程间的同步。

120. CompletionService 的作用？

     将 Executor 与 BlockingQueue 的功能结合在一起，通过将一组 Callable 任务提交给它来执行，然后使用 take 和 poll 等方法来获得已经完成的结果，这些结果会被封装成 Future。ExecutorCompletionService 实现了 CompletionService。

121. 什么是守护线程，它有什么作用，适用场景？

     守护线程指的是用来在后台执行任务的线程，如 GC 进程。JVM 在进行关闭的时候只需要看是否存在非守护线程正在运行，如果只有守护线程正在运行，JVM 是可以直接结束并且回收守护线程的，因此，守护线程中最好不要放打开资源的执行语句，以防止资源没有正确关闭。

122. FutureTask 类有什么作用？

     FutureTask 实现了 RunnableFuture 接口，该接口同时继承 Runnable 接口和 Future 接口，可以用于异步取消事务。

123. 如何中止正在执行的线程？

     + 使用中断：每个线程都有一个 boolean 类型的中断状态。它不会真正地中断一个正在运行的线程，而只是发出中断请求，然后由线程在下一个合适的时刻中断自己。Thread.interrupted() 会返回中断状态，并且置空中断状态位
     + 通过 Future 取消：在使用 ExecutorService 提交任务时，会返回一个 Future 对象，可以通过 cancel 来取消
     + 通过 Executor 取消：使用 shutdown/shutdownNow 
     + 毒丸对象：在基于生产者-消费者模型中，可以添加一个毒丸对象，是指特定的一个放在队列上的对象，当消费者得到这个对象的时候，立刻停止执行

124. shutdownNow 的局限性？

     使用该方法的时候，它将会取消所有正在执行的任务，并且返回所有已经提交但尚未开始的任务。然而，我们并不知道那些任务已经开始但是尚未正常结束。

125. 如何对非正常的线程中止进行监控？

     导致线程提前死亡的原因主要就是 RuntimeException。如果没有捕获该异常，程序就会在控制台打印栈信息，然后退出执行。在 Thread 中提供了 UncaughtExceptionHandler，它能检测出某个线程由于未捕获的异常而终结的情况。

126. JVM 关闭时的关闭钩子是什么，守护线程会阻碍 JVM 关闭吗？

     在正常的关闭中，JVM 首先调用所有已注册过的关闭钩子（Shutdown Hook）。JVM 不保证关闭钩子的调用顺序。守护线程并不会阻碍 JVM 关闭，因此不要在守护线程中进行资源打开的操作，以防止资源未正确关闭。

127. 如何构建一个自定义线程池？

     可以通过 ThreadPoolExecutor 实现该需求，该类继承自 AbstractExecutorService：

     ```java
     public ThreadPoolExecutor(int corePoolSize,
                               int maximumPoolSize,
                               long keepAliveTime,
                               TimeUnit unit,
                               BlockingQueue<Runnable> workQueue,
                               ThreadFactory threadFactory,
                               RejectedExecutionHandler handler) { ... }
     ```

     handler 用于处理在等待队列满时，应该采取的措施，如中止，抛弃，抛弃最旧的；

     threadFactory 则用于定制化工作，通过实现 ThreadFactory 接口即可；

     另外，也可以继承 ThreadPoolExecutor，并重写 beforeExecute，afterExecute 和 terminated 方法来实现定制。

128. AbstractExecutorService 中的 newTaskFor 作用？

     可以将三类参数转化为 RunnableFuture 对象，是在 Runnable 和 Callable 上的进一步抽象。

129. 什么是死锁，如何进行死锁避免和检测？

     死锁：当多个线程相互持有彼此正在等待的锁而又不释放自己已经持有的锁的时候，就会发生死锁。

     + 支持定时的锁：可以使用 Lock 类的定时 tryLock 功能来代替内置锁机制。当使用内置锁的时候，只要没有获得锁就会一直等待下去，而显式锁则可以指明一个超时时限。
     + 通过线程转储信息来分析死锁：线程转储信息中包含了加锁信息，例如每个线程持有了哪些锁，在那些栈帧中获得了这些锁，以及被阻塞的线程正在等待哪一个锁。

130. 什么是饥饿，什么是活锁？

     饥饿：当线程无法访问它所需要的资源而不能继续执行的时候，就会发生饥饿。引发饥饿的最常见资源就是 CPU 时钟周期。

     活锁：该问题尽管不会阻塞线程，但也不能继续执行，因为线程将不断重复执行相同的操作，而且总会失败。可以通过引入随机性来解决该问题。

131. 多线程编程的开销主要集中在哪些方面？

     + 上下文切换
     + 内存同步：同步可能使用特殊指令，即内存栅栏，该指令可以刷新缓存，使得缓存无效，从而使得各个线程都能看到最新的值。内存栅栏会抑制一些编译器的优化操作。
     + 阻塞：当在锁上发生竞争的时候，竞争失败的线程就会阻塞。JVM 实现阻塞的行为有自旋等待，或者通过操作系统挂起。

132. 如何减少锁的竞争？

     + 缩小锁的范围
     + 减少锁的粒度，如锁分段，ConcurrentHashMap
     + 使用替代独占锁的方式：使用并发容器，ReadWriteLock，不可变对象（String）以及原子变量

133. Lock 和 ReentrantLock 关系，ReentrantLock 相较于 synchronized 有什么特点？

     Lock 接口提供了一种基于条件的，可定时的以及可中断的锁获取操作。ReentrantLock 则实现了 Lock 接口。相较于 synchronized，其特点有：

     + 轮询锁与定时锁：由 tryLock 方法实现，具有完善的错误恢复机制，使用这两种锁可以避免死锁的发生。
     + 可中断的锁获取操作：lockInterruptibly 方法能够在获得锁的同时保持对中断的响应。
     + 非块结构的加锁：内置锁中，锁的获取和释放操作都是基于代码块的。而 Lock 技术则不是块结构的锁
     + 公平锁和非公平锁：ReentrantLock 还可以实现非公平锁，可提高效率，但是可能造成饿死

134. ReentrantLock 中的公平锁和非公平锁区别？

     + 非公平锁在调用 lock 后，首先就会调用 CAS 进行一次抢锁，如果这个时候恰巧锁没有被占用，那么直接就获取到锁返回了
     + 非公平锁在 CAS 失败后，和公平锁一样都会进入到 tryAcquire 方法，在 tryAcquire 方法中，如果发现锁这个时候被释放了（state == 0），非公平锁会直接 CAS 抢锁，但是公平锁会判断等待队列是否有线程处于等待状态，如果有则不去抢锁，乖乖排到后面

     公平锁和非公平锁就这两点区别，如果这两次 CAS 都不成功，那么后面非公平锁和公平锁是一样的，都要进入到阻塞队列等待唤醒。

135. 如何使用 Lock 接口进行线程间同步？

     使用 Lock 接口中的 newCondition 方法，然后通过 await&signal 实现同步，其作用和 wait&notify 作用相同，但是 Lock 可以创建多个 Condition，以创建多个同步队列。同样地，await&signal 方法需要在获取了锁之后进行调用。

136. ReadWriteLock 有何作用？

     ReentrantLock 实现了一种标准的互斥锁，互斥通常是一种过硬的加锁规则，因此限制了并发性。可以使用读写锁来改善：在读写锁的加锁策略中，允许多个操作同时执行，但每次最多只允许一个写操作。ReentrantReadWriteLock 实现了上述接口，提供可重入的语义，同时构造的时候可以选择是否公平锁。

137. Condition 接口的作用以及对应的实现？

     正如 Lock 是一种广义的内置锁，Condition 也是一种广义的内置条件队列。内置锁的缺陷在于每个内置锁都只能有一个相关联的条件队列。而 Condition 和 Lock 一起使用就可以消除该问题。和内置条件队列不同的是，对于每个 Lock，可以有任意数量的 Condition 对象。在 Condition 中相应的方法是 await，signal 和 signalAll。

     真正实现的 Condition 接口的有 ConditionObject，位于 AQS 类中。

138. AbstractQueuedSynchronizer（AQS）有何作用？

     AQS 是一个用于构建锁和同步器的框架，CountDownLatch，ReentrantReadWriteLock， FutureTask，ReentrantLock，Semaphore，CyclicBarrier 等都是基于 AQS 实现。其内部类 ConditionObject 实现了 Condition 接口，用于产生条件队列。

139. volatile 和 synchronized 的区别？

     + volatile 只能修饰实例变量和类变量，而 synchronized 可以修饰方法，以及代码块
     + volatile 保证数据的可见性，但是不保证原子性(多线程进行写操作，不保证线程安全)；而 synchronized 是一种排他(互斥)的机制
     + volatile 用于禁止指令重排序：可以解决单例双重检查对象初始化代码执行乱序问题
     + volatile 可以看做是轻量版的 synchronized，volatile 不保证原子性，但是**如果是对一个共享变量进行多个线程的赋值，而没有其他的操作**，那么就可以用 volatile 来代替 synchronized，因为赋值本身是有原子性的，而 volatile 又保证了可见性，所以就可以保证线程安全了

140. 原子变量类有何作用，存在的优势是什么，有哪些类型？

     原子变量类 **比锁的粒度更细，更轻量级**，原子变量将发生竞争的范围缩小到单个变量上。原子变量类相当于一种泛化的 `volatile` 变量，能够**支持原子的、有条件的读/改/写操**作。原子类在内部使用 CAS 指令（基于硬件的支持）来实现同步，在高度竞争的情况下，锁的性能超过原子变量的性能；而在适度竞争情况下，原子变量的性能超过锁的性能。常见的原子变量类：

     + 基本类型：AtomicInteger，AtomicLong，AtomicBoolean
     + 引用类型：AtomicReference，AtomicStampedReference，AtomicMarkableReference
     + 数组类型：AtomicIntegerArray，AtomicLongArray，AtomicReferenceArray
     + 属性更新器类型：AtomicIntegerFieldUpdater，AtomicLongFieldUpdater，AtomicReferenceFieldUpdater

141. 现代处理器的内存模型是怎样的？

     在共享内存的多处理器体系结构中，每个处理器有自己的缓存，并且定期的与主内存进行协调。在需要进行内存同步的时候，就可以执行内存栅栏指令，来保证数据的一致性。JVM 通过在合适的位置上插入内存栅栏来屏蔽 JMM 与底层平台内存模型的差异。

142. 什么是 Happens-Before 关系，有什么作用，包括哪些规则？

     + 如果一个操作 happens-before 另一个操作，那么第一个操作的执行结果将对第二个操作可见，而且第一个操作的执行顺序排在第二个操作之前。
     + 两个操作之间存在 happens-before 关系，并不意味着一定要按照 happens-before 原则制定的顺序来执行。如果重排序之后的执行结果与按照 happens-before 关系来执行的结果一致，那么这种重排序并不非法

     要想保证操作 B 看到操作 A 的结果（无论 A 和 B 是否在同一线程），那么 A 和 B 操作之间必须存在 Happens-Before 关系，如果两个操作之间缺乏 Happens-Before 关系，那么 JVM 就可以对他们进行任意重排序。包括：

     + 程序次序规则：一个线程内，按照代码顺序，书写在前面的操作先行发生于书写在后面的操作
     + **锁定规则**：一个 unLock 操作先行发生于后面对同一个锁的 lock 操作
     + **volatile 变量规则**：对一个 volatile 变量的写操作先行发生于后面对这个变量的读操作
     + **传递规则**
     + 线程启动，结束规则
     + 线程中断规则
     + 对象终结规则

143. final 关键字能否保证对象的可见性？

     final 确保可见性是指一旦完成初始化，那么在其他线程中就可以看见 final 字段，可以安全使用，唯一需要担心的就是 this 引用逃逸。

     对于 final 域，编译器和处理器要遵守两个重排序规则：

     + 在构造函数内对一个 final 域的写入，与随后把这个被构造对象的引用赋值给一个引用变量，这两个操作之间不能重排序（先写入 final 变量，后调用该对象引用）。编译器会在final域的写之后，插入一个StoreStore屏障
     + 初次读一个包含 final 域的对象的引用，与随后初次读这个 final 域，这两个操作之间不能重排序（先读对象的引用，后读 final 变量）。编译器会在读 final 域操作的前面插入一个 LoadLoad 屏障

144. Java 内存区域是如何划分的，每个线程区域所有线程可见吗？

     主要分为以下五个区域：

     + 虚拟机栈：每个方法执行的时候会创建一个栈帧，用于存储局部变量，方法出口等信息。

     + 本地方法栈：同虚拟机栈，只不过本地方法栈是为本地方法服务的。

     + 堆：几乎所有的对象实例都会在这里面分配。

     + 方法区：用于存储已被虚拟机加载的类型信息、常量、静态变量、即时编译器编译后的代码缓存等数据。

       + 运行时常量池：是方法区的一部分，常量池表，Class 文件中描述信息会放在此处。

         > 每个类对应的 Class 对象实例实际还是存储在栈区域中的

     + 程序计数器：通过改变其值来获取下一条需要执行的字节码指令。

     程序计数器和栈是线程独占的，方法区和堆空间则是线程共享的。

145. 如何理解 Java 中的直接内存？

     直接内存也被称为堆外内存，与之相对的便是由 JVM 管理的堆内内存。JDK1.4 加入了新的 NIO 机制，目的是防止 Java 堆和 Native 堆之间往复的数据复制带来的性能损耗，NIO 可以使用 Native 的方式直接在 Native 堆分配内存，然后通过一个存储在Java 堆里面的 DirectByteBuffer 对象作为这块内存的引用进行操作。

146. JVM 如何处理对象的创建？

     当 Java 虚拟机遇到一条字节码 new 指令时，首先去检查这个指令的参数是否能在常量池中定位到一个类的符号引用，并且检查这个符号引用代表的类是否已被加载、解析和初始化过。如果没有，那必须先执行相应的类加载过程。在类加载检查通过后，接下来虚拟机将为新生对象分配内存。分配方式有指针碰撞和空闲列表两种方式。接下来，就需要执行构造函数了，也就是 Class 文件中的 `<init>()` 方法。

147. 对象的内存布局是怎样的？

     对象在堆里面的内存布局分为三部分：对象头，实例数据，对齐填充

     + 对象头：mark word 和 klass pointer。第一部分用于存储对象自身的运行时数据，如哈希码，GC 分代年龄等，第二部分是类型指针，用于确定该对象是那个类的实例。
     + 实例数据：从父类继承和该类中定义的数据，都存储实例数据内存部分，注意如果子类定义了相同类型和名称的数据，那么父类属性将不会被继承。
     + 对齐填充：用于保证对象是 8 字节对齐的。

148. JVM 中的常见的对象访问定位方式有哪些？

     主流的方式有两种，使用句柄或者使用直接指针，HotSpot 虚拟机使用直接指针方式。

     + 句柄：好处就是 reference 中存储的是稳定句柄地址（存储在堆空间），在对象被移动（垃圾收集时移动对象是非常普遍的行为）时只会改变句柄中的实例数据指针，而 referrence 不用修改
     + 直接指针：好处就是速度更快，它节省了一次指针定位的时间开销

149. 垃圾回收中，如何判断对象是否存活？

     + 引用计数算法：在对象中添加一个引用计数器，每当有一个地方引用它时，计数器值就加一；当引用失效时，计数器值就减一；任何时刻计数器为零的对象就是不可能再被使用的。该方法不能检测循环引用。
     + 可达性分析算法：基本思路就是通过一系列称为“GC Roots”的根对象作为起始节点集，从这些节点开始，根据引用关系向下搜索，搜索过程所走过的路径称为“引用链”（Reference Chain），如果某个对象到 GC Roots 间没有任何引用链相连，或者用图论的话来说就是从GC Roots 到这个对象不可达时，则证明此对象是不可能再被使用的。在 Java 技术体系中，GC Roots 对象有：

       + 虚拟机栈中引用的对象
       + 在方法区中类静态属性引用的对象，常量引用的对象
       + 同步锁持有的对象

150. Java 中的引用类型有几种，分别是什么？

     + 强引用：最传统的“引用”的定义，是指在程序代码之中普遍存在的引用赋值
     + 软引用：来描述一些还有用，但非必须的对象。只被软引用关联着的对象，在系统将要发生内存溢出异常前，会把这些对象列进回收范围之中进行第二次回收
     + 弱引用：也是用来描述那些非必须对象，但是它的强度比软引用更弱一些，被弱引用关联的对象只能生存到下一次垃圾收集发生为止
     + 虚引用：最弱的一种引用关系，一个对象是否有虚引用的存在，完全不会对其生存时间构成影响，也无法通过虚引用来取得一个对象实例，为一个对象设置虚引用关联的唯一目的只是为了能在这个对象被收集器回收时收到一个系统通知

151. 对象的自我拯救是什么意思？

     即使在可达性分析算法中判定为不可达的对象，这时候它们暂时还处于“缓刑”阶段，要真正宣告一个对象死亡，至少要经历两次标记过程：如果对象在进行可达性分析后发现没有与 GC Roots 相连接的引用链，那它将会被第一次标记，随后进行一次筛选，筛选的条件是此对象是否有必要执行 finalize() 方法。如果这个对象被判定为确有必要执行 finalize() 方法，那么该对象将会被放置在一个名为 F-Queue 的队列之中，并在稍后由一条由虚拟机自动建立的、低调度优先级的 Finalizer 线程去执行它们的 finalize() 方法。finalize() 方法是对象逃脱死亡命运的最后一次机会，即只要重新与引用链上的任何一个对象建立关联即可，譬如把自己（this关键字）赋值给某个类变量或者对象的成员变量，那在第二次标记时它将被移出“即将回收”的集合。

152. 有必要回收方法区吗？

     Java 虚拟机规范中规定可以不要求虚拟机在方法区中实现垃圾收集。方法区的回收主要包括常量池中废弃的常量和不再使用的类型，回收条件苛刻，如果没有发生内存泄露，一般可以不用对方法区进行回收。

153. 谈谈分代收集理论？

     建立在三个假说之上：

     1. 弱分代假说：绝大多数对象都是朝生夕灭的。
     2. 强分代假说：熬过越多次垃圾收集过程的对象就越难以消亡。
     3. 跨代引用假说：跨代引用相对于同代引用来说仅占极少数。

     前两个假说表明如果一个区域中大多数对象都是朝生夕灭，难以熬过垃圾收集过程的话，那么把它们集中放在一起，每次回收时只关注如何保留少量存活而不是去标记那些大量将要被回收的对象，就能以较低代价回收到大量的空间；如果剩下的都是难以消亡的对象，那把它们集中放在一块，虚拟机便可以使用较低的频率来回收这个区域，这就同时兼顾了垃圾收集的时间开销和内存的空间有效利用；第三点表明我们就不应再为了少量的跨代引用去扫描整个老年代，也不必浪费空间专门记录每一个对象是否存在及存在哪些跨代引用。

154. 垃圾回收有哪些算法，有什么优缺点？

     + 标记-清除算法：首先标记出所有需要回收的对象，在标记完成后，统一回收掉所有被标记的对象。缺点是存在大量垃圾时效率较低（老年代）和存在空间碎片
     + **标记-复制算法**：将可用内存按容量划分为大小相等的两块，每次只使用其中的一块，另一块用于复制。缺点是需要双倍空间，不适用于存活对象多的内存区域（老年代）
     + **标记-整理算法**：其中的标记过程仍然与“标记-清除”算法一样，但后续步骤不是直接对可回收对象进行清理，而是让所有存活的对象都向内存空间一端移动，然后直接清理掉边界以外的内存。缺点是移动对象需要重新更新引用

155. 经典的垃圾回收器有哪些？

     + Serial/Serial Old 收集器：对新生代采用标记复制算法，对老年代采用标记整理算法，都是单线程，STW

     + ParNew/Parallel Old 收集器：可以理解为 Serial/Serial Old 的多线程并行版本，STW

     + CMS （Concurrent **Mark Sweep**）收集器：是一种以最短回收停顿时间为目标的收集器。包括四个步骤：

       + 初始标记：记仅仅只是标记一下GC Roots能直接关联到的对象，速度很快；STW
       + 并发标记：是从GC Roots的直接关联对象开始遍历整个对象图的过程，这个过程耗时较长但是不需要停顿用户线程，可以与垃圾收集线程一起并发运行
       + 重新标记：则是为了修正并发标记期间，因用户程序继续运作而导致标记产生变动的那一部分对象的标记记录；STW
       + 并发清除：清理删除掉标记阶段判断的已经死亡的对象，由于不需要移动存活对象，所以这个阶段也是可以与用户线程同时并发的

       优点是并发收集，低停顿；缺点是对处理器资源敏感，无法处理浮动垃圾（并发清理阶段，用户线程是还在继续运行的，程序在运行自然就还会伴随有新的垃圾对象不断产生），空间碎片问题

     + G1 （Garbage First）收集器：和上述收集器不同的是，G1 不再坚持固定大小以及固定数量的分代区域划分，而是把连续的 Java 堆划分为多个大小相等的独立区域（Region），每一个 Region 都可以根据需要，扮演新生代的 Eden 空间、Survivor 空间，或者老年代空间。收集器能够对扮演不同角色的 Region 采用不同的策略去处理，从而获取更好的收集效果。收集过程如下：

       + 初始标记：仅仅只是标记一下 GC Roots 能直接关联到的对象，需要短暂停顿，STW

       + 并发标记：从 GC Root 开始对堆中对象进行可达性分析，递归扫描整个堆里的对象图，找出要回收的对象，这阶段耗时较长，但可与用户程序并发执行
       + 最终标记：对用户线程做另一个短暂的暂停，用于处理并发阶段结束后仍遗留下来的最后那少量的SATB 记录
       + 筛选回收：负责更新 Region 的统计数据，对各个 Region 的回收价值和成本进行排序，根据用户所期望的停顿时间来制定回收计划，可以自由选择任意多个 Region 构成回收集，然后把决定回收的那一部分 Region 的存活对象复制到空的 Region 中，再清理掉整个旧 Region 的全部空间。这里的操作涉及存活对象的移动，是必须暂停用户线程，由多条收集器线程并行完成的，**标记整理**

     + ZGC 收集器：使用了读屏障、染色指针和内存多重映射等技术来实现可并发的**标记-整理**算法的，以低延迟为首要目标的一款垃圾收集器。希望在尽可能对吞吐量影响不太大的前提下，实现在任意堆内存大小下都可以把垃圾收集的停顿时间限制在 10 毫秒以内的低延迟。ZGC 也采用基于 Region 的堆内存布局，但与它们不同的是，ZGC 的 Region 具有动态性——动态创建和销毁，以及动态的区域容量大小。分为四个阶段：并发标记，并发预备重分配，并发重分配，并发重映射（通常和下一次并发标记一起）

       > 读屏障：当读取处于重分配集的对象时，会被读屏障拦截，通过转发表记录将访问转发到新复制的对象上，并同时修正更新该引用的值，使其直接指向新对象
       >
       > 染色指针：直接把标记信息记在引用对象的指针上，目前在 Linux 下 64 位的操作系统中高 18 位是不能用来寻址的，但是剩余的 46 为却可以支持 64 T的空间，到目前为止我们几乎还用不到这么多内存。于是 ZGC 将 46 位中的高 4 位取出，用来存储 4 个标志位，剩余的 42 位可以支持 4TB

     + Epsilon 收集器：不能够进行垃圾回收的垃圾收集器，主要用于和其他垃圾回收器进行对照

156. Java 中提供了哪些性能检测和故障处理工具？

     基础故障工具有：

     + jps：虚拟机进程状况工具，可以列出正在运行的虚拟机进程，并显示虚拟机执行主类（Main Class，main()函数所在的类）名称以及这些进程的本地虚拟机唯一ID（LVMID，Local Virtual Machine Identifier）。
     + jstat（JVM Statistics Monitoring Tool）：用于监视虚拟机各种运行状态信息的命令行工具，可以显示本地或者远程[1]虚拟机进程中的类加载、内存、垃圾收集、即时编译等运行时数据。
     + jinfo（Configuration Info for Java）：实时查看和调整虚拟机各项参数。
     + jmap（Memory Map for Java）：用于生成堆转储快照（一般称为heapdump或dump文件）。
     + jhat（JVM Heap Analysis Tool）：与jmap搭配使用，来分析jmap生成的堆转储快照。
     + jstack（Stack Trace for Java）：用于生成虚拟机当前时刻的线程快照（一般称为threaddump或者 javacore文件），线程快照就是当前虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的目的通常是定位线程出现长时间停顿的原因，如线程间死锁、死循环。

     可视化故障处理工具：

     + JConsole：Java 监视与管理控制台
     + VisualVM：多合-故障处理工具，是功能最强大的运行监视和故障处理程序之一
     + JMC（Java Mission Control）：可持续在线的监控工具

157. JVM 平台无关性指的是什么？

     字节码(Byte Code)文件是构成平台无关性的基石，Java 虚拟机只接受字节码文件，而不管这些文件是怎么的得到的，这就为其他语言可以运行在 Java 虚拟机上提供了基础。

158. class 文件结构是怎样的？

     采用一种类似 C 语言的言结构体的伪结构来存储数据，这种伪结构中只有两种数据类型：“无符号数”和“表”。整个 class 文件也可以当做一个表：

     + magic, minor version, major version：分别表示文件魔数，小版本号，大版本号
     + **constant_pool_count, constant_pool**：分别表示常量数量和常量池
     + access_flag, this_class, super_class：分别表示类或者接口的访问信息，类索引和父类索引
     + interfaces_count, interfaces：表示类实现的接口
     + fields_count, fields：字段数量和字段表
     + methods_count, methods：方法数量和方法表
     + attributes_count, attributes：属性表，class 文件、字段表、方法表都可以携带自己的属性表集合

159. 方法中的代码存储在 class 文件中何处？

     方法存储在 class 文件中的方法表中，方法表中的代码实际存储在方法表中的 attribute 中，通过属性名为 Code 的属性存储相应的虚拟机代码。

160. Java 字节码相关指令有哪些？

     Java 采用的是面向操作数栈的架构，所以大多数指令不含操作数，并且只用一个字节来代表操作码，可以尽可能获得短小精干的编译长度：

     + 加载存储指令：iload，iload_n，istore，istore_n
     + 运算指令：iadd，ladd，fadd，dadd，不原生支持 byte，char，short 和 boolean，通过将这些数据进行符号位扩展和零位扩展实现运算
     + 类型转换指令：窄化类型转换需要，如 i2b，i2c 等
     + 对象创建和访问指令：new，newarray，getstatic，getfield，iaload，arraylength，instanceof，checkcast
     + 操作数管理指令：pop，dup，swap
     + 控制转移指令：ifeq，ret，if_icmpeq
     + **方法调用和返回指令**：invokevirtual，invokeinterface，invokespecial，invokestatic，invokedynamic
     + 异常处理指令：athrow
     + 同步指令：monitor_enter，monitor_exit

161. 字节码中的 invokevirtual，invokeineterface，invokespecial，invokestatic，invokedynamic 不同点？

     + invokevirtual 指令：用于调用对象的实例方法，根据对象的**实际类型**进行分派（虚方法分派），这也是Java 语言中最常见的方法分派方式。
     + invokeinterface 指令：用于调用接口方法，它会在运行时搜索一个实现了这个接口方法的对象，找出适合的方法进行调用。
     + invokespecial 指令：用于调用一些需要特殊处理的实例方法，包括实例初始化方法、私有方法和父类方法。
     + invokestatic指令：用于调用类静态方法（static方法）。
     + invokedynamic 指令：用于在运行时动态解析出调用点限定符所引用的方法，并执行该方法。前面四条调用指令的分派逻辑都固化在 Java 虚拟机内部，用户无法改变，而 invokedynamic 指令的分派逻辑是由用户所设定的引导方法决定的。

162. JVM 如何处理 invokedynamic 调用的？

     1. JVM 首次执行 invokedynamic 调用时会调用引导方法（Bootstrap Method）
     2. 引导方法返回 CallSite 对象，CallSite 内部根据方法签名进行目标方法查找。它的 getTarget 方法返回方法句柄（MethodHandle）对象。
     3. 在 CallSite 没有变化的情况下，MethodHandle 可以一直被调用，如果 CallSite 有变化的话重新查找即可。

     <img src="Java-面试题目汇总/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE3MzA1MjQ5,size_16,color_FFFFFF,t_70.png" alt="在这里插入图片描述" style="zoom:50%;" />

163. 虚拟机实现方式有哪些方式？

     《Java虚拟机规范》描绘了Java虚拟机应有的共同程序存储格式：Class文件格式以及字节码指令集。但一个优秀的虚拟机实现，在满足《Java虚拟机规范》的约束下对具体实现做出修改和优化也是完全可行的。虚拟机实现的方式主要有以下两种：

     + 将输入的 Java 虚拟机代码在加载时或执行时翻译成另一种虚拟机的指令集；
     + 将输入的 Java 虚拟机代码在加载时或执行时翻译成宿主机处理程序的本地指令集（即即时编译器代码生成技术）

164. 什么是类的加载机制？类加载机制主要分为那几个步骤？

     Java虚拟机把描述类的数据从Class文件加载到内存，并对数据进行校验、转换解析和初始化，最终形成可以被虚拟机直接使用的Java类型，这个过程被称作虚拟机的类加载机制。分为以下步骤：

     1. 加载：

        + 通过一个类的全限定名来获取定义此类的二进制字节流。

        + 将这个字节流所代表的静态存储结构转化为方法区的运行时数据结构。

        + 在内存中生成一个代表这个类的java.lang.Class对象，作为方法区这个类的各种数据的访问入口。

     2. 验证：这一阶段的目的是确保Class文件的字节流中包含的信息符合《Java虚拟机规范》的全部约束要求，保证这些信息被当作代码运行后不会危害虚拟机自身的安全。如字节码验证，符号引用验证等。

     3. 准备：是正式为类中定义的变量（即静态变量，被static修饰的变量）分配内存并设置类变量初始值的阶段。需要注意的是如果是`static int value = 123`，准备阶段的初始值是 0 而不是 123，但是如果是`public static final int value = 123`，那么准备阶段的值就是 123。

     4. 解析：是 Java 虚拟机将常量池内的符号引用替换为直接引用的过程，如字段解析，方法解析，类解析等。

     5. 初始化：初始化阶段就是执行类构造器`<clinit>()`方法的过程。`<clinit>()`方法是由编译器自动收集类中的所有类变量的赋值动作和静态语句块（static{}块）中的语句合并产生的，编译器收集的顺序是由语句在源文件中出现的顺序决定的，静态语句块中只能访问到定义在静态语句块之前的变量。Java虚拟机会保证在子类的`<clinit>()`方法执行前，父类的`<clinit>()`方法已经执行完毕。

165. 类加载过程中解析步骤一定发生在初始化之前吗？

     加载、验证、准备、初始化和卸载这五个阶段的顺序是确定的，而解析阶段则不一定：它在某些情况下可以在初始化阶段之后再开始，这是为了支持Java语言的运行时绑定特性（也称为动态绑定或晚期绑定）。

166. 类加载过程中，若类尚未加载，什么时候需要对类立即进行初始化步骤？

     + 遇到 new、getstatic、putstatic 或 invokestatic 这四条字节码指令
     + 使用 java.lang.reflect 包的方法对类型进行反射调用的时候
     + 当初始化类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化
     + 当虚拟机启动时，用户需要指定一个要执行的主类（包含main()方法的那个类），虚拟机会先初始化这个主类
     + 如果一个java.lang.invoke.MethodHandle实例最后的解析结果为REF_getStatic、REF_putStatic、REF_invokeStatic、REF_newInvokeSpecial四种类型的方法句柄，并且这个方法句柄对应的类没有进行过初始化，则需要先触发其初始化
     + 当一个接口中定义了JDK 8新加入的默认方法（被default关键字修饰的接口方法）时，如果有这个接口的实现类发生了初始化，那该接口要在其之前被初始化。

167. 类加载器的职责是什么？

     Java 虚拟机设计团队有意把类加载阶段中的“通过一个类的全限定名来获取描述该类的二进制字节流”这个动作放到 Java 虚拟机外部去实现，以便让应用程序自己决定如何去获取所需的类。实现这个动作的代码被称为“类加载器”（Class Loader）。

168. JVM 是如何比较两个是否相等的？

     比较两个类是否“相等”，只有在这两个类是由同一个类加载器加载的前提下才有意义，否则，即使这两个类来源于同一个Class文件，被同一个Java虚拟机加载，只要加载它们的类加载器不同，那这两个类就必定不相等。

169. JVM 中的类加载器怎么分层的，分别有什么作用？

     JVM 中存在三层类加载器：

     + 启动类加载器：这个类加载器负责加载存放在<JAVA_HOME>\lib目录，是Java虚拟机能够识别的（按照文件名识别，如rt.jar、tools.jar，名字不符合的类库即使放在lib目录中也不会被加载）类库加载到虚拟机的内存中。
     + 扩展类加载器：负责加载\lib\ext目录中，或者被java.ext.dirs系统变量所指定的路径中所有的类库
     + 应用程序类加载器：由于应用程序类加载器是ClassLoader类中的getSystemClassLoader()方法的返回值，所以有些场合中也称它为“系统类加载器”。它负责加载用户类路径（ClassPath）上所有的类库，开发者同样可以直接在代码中使用这个类加载器。

     如果用户认为有必要，还可以加入自定义的类加载器来进行拓展。

170. JVM 中的类加载机制是怎么样的，为什么采取该设计？

     采用的是双亲委派模型，如果一个类加载器收到了类加载的请求，它首先不会自己去尝试加载这个类，而是把这个请求委派给父类加载器去完成，每一个层次的类加载器都是如此，因此所有的加载请求最终都应该传送到最顶层的启动类加载器中，只有当父加载器反馈自己无法完成这个加载请求（它的搜索范围中没有找到所需的类）时，子加载器才会尝试自己去完成加载。好处是Java中的类随着它的类加载器一起具备了一种带有优先级的层次关系。同时可以安全判断两个类是否相同，以及不会加载相同的类两次。

171. JDK9 中引入了模块，对类加载器做了哪些修改？

     + 扩展类加载器被平台类加载器取代
     + 平台类加载器和应用程序类加载器都不再派生自 java.net.URLClassLoader，现在启动类加载器、平台类加载器、应用程序类加载器全都继承于 jdk.internal.loader.BuiltinClassLoader
     + JDK 9 中虽然仍然维持着三层类加载器和双亲委派的架构，但类加载的委派关系也发生了变动。当平台及应用程序类加载器收到类加载请求，在委派给父加载器加载前，要先判断该类是否能够归属到某一个系统模块中，如果可以找到这样的归属关系，就要优先委派给负责那个模块的加载器完成加载

172. JVM 中的栈帧结构是怎样的？

     每个栈帧里面包含有局部变量表、操作数栈、动态连接、方法返回地址和一些额外的附加信息。

     + 局部变量表：是一组变量值的存储空间，用于存放方法参数和方法内部定义的局部变量，对于实例方法，局部变量表第0位代表的就是方法所属对象的引用，方法中通过 this 隐式访问到。
     + 操作数栈：用于保存相应的操作数。在进行运算的时候需要检查指令和对应的数据类型是否匹配。在概念模型上，两个不同的栈帧是完全相互独立的，但是在实际过程中，可能存在重合，这样做的好处是节约空间，同时无需进行额外的实参-形参转换。
     + 动态链接：每个栈帧都包含一个指向运行时常量池中该栈帧所属方法的引用，持有这个引用是为了支持方法调用过程中的动态连接（Dynamic Linking）。
     + 方法返回地址：正常返回上层方法调用者，可能会提供返回值，异常返回的话，不带任何返回值。推出的过程实际上等同于将当前栈帧出栈。

173. JVM 如何处理方法调用的？

     主要存在解析和分派两种方式：

     + 解析：在类加载的过程中，如果方法的调用版本在运行期不可变，就可以将方法的符号引用转化为直接引用，该类方法的调用称为解析。在 Java 中，这样的方法有静态方法，私有方法，实例构造器，父类方法，final 方法。这些方法称为“非虚方法”，其他的就成为“虚方法”。

     + 分派：

       + 静态分派：静态分派的最典型应用表现就是方法重载。静态分派发生在编译阶段。虽然编译器能够在确定方法重载版本，但是实际上只是选择一个相对更合适的版本。

       + 动态分派：与重写有关。在执行的时候会找到变量指向对象的实际类型，然后在实际类型中找到方法签名一致的方法，否则根据继承链向上查找即可

         > 注意，方法存在多态，但是字段不存在多态。

174. JVM 如何实现动态分派的？

     通常虚拟机会创建一个虚方法表（vtable，对应的还有接口方法表itable），使用虚方法表索引来代替元数据查找以提高性能。

175. MethodHandle 和 Reflection 有什么异同点？

     + Reflection和MethodHandle机制本质上都是在模拟方法调用，但是Reflection是在模拟Java代码层次的方法调用，而MethodHandle是在模拟字节码层次的方法调用。
     + Reflection中的java.lang.reflect.Method对象远比MethodHandle机制中的java.lang.invoke.MethodHandle对象所包含的信息来得多。
     + Reflection API的设计目标是只为Java语言服务的，而MethodHandle则设计为可服务于所有Java虚拟机之上的语言。

176. 谈谈 invokedynamic 指令的理解？

     作为 Java 诞生以来唯一一条新加入的字节码指令，都是为了解决原有4条“invoke*”指令方法分派规则完全固化在虚拟机之中的问题，把如何查找目标方法的决定权从虚拟机转嫁到具体用户代码之中。invokedynamic指令的第一个参数不再是代表方法符号引用的CONSTANT_Methodref_info常量，而是变为JDK 7 时新加入的CONSTANT_InvokeDynamic_info常量，从这个新常量中可以得到3项信息：引导方法（Bootstrap Method，该方法存放在新增的BootstrapMethods属性中）、方法类型（MethodType）和名称。

177. 如何在类中直接调用祖父类中的方法？

     可以通过 MethodHandle 来进行访问，如遇到权限问题，可以使用`lookupImpl.setAccessible(true)`来解决。

178. 基于栈的指令集与基于寄存器的指令集有什么优缺点？

     Java 指令基于栈结构，x86 指令基于寄存器，使用栈结构带来的好处是可移植性更强，缺点是运行速度慢。

179. Tomcat 中的自定义类加载器及其作用是什么？

     + Common 类加载器：继承自应用程序类加载器，用于加载 /common 目录中库，可被 Tomcat 和所有的Web 应用程序共同使用
     + Catalina 类加载器：继承自 Common 类加载器，用于加载 /server 目录中库，只可被 Tomcat使用
     + Shared 类加载库：继承自 Common 类加载器，用于加载 /shared 目录中库，只可被所有的Web应用程序共同使用
     + WebApp 类加载器：继承自 Shared 类加载器，用于加载 /WebApp/WEB-INF 目录中库，仅仅可以被某个 Web 应用程序使用
     + Jsp 类加载器：继承自 WebAPP 类加载器，用于加载 jsp 文件

180. Java 中的前端编译是什么，主要包含几个部分？

     一般指将`*.java`编译为`*.class`字节码文件的过程，主要有下列过程：

     1. 准备过程：初始化插入式注解处理器
     2. 解析与填充符号表过程：词法，语法分析，填充符号表
     3. 插入式注解处理器的注解处理过程：插入式注解处理器的执行阶段，会对语法树进行过修改，编译器将回到解析及填充符号表的过程重新处理，直到所有插入式注解处理器都没有再对语法树进行修改为止
     4. 语义分析与字节码生成过程：标注检查，解语法糖，字节码生成

181. 字节码中的 `<init>()` 方法和构造方法的区别？

     `<init>()`和`<clinit>()`这两个构造器的产生实际上是一种代码收敛的过程，编译器会把语句块（对于实例构造器而言是“{}”块，对于类构造器是“static{}”块）、变量初始化（实例变量和类变量）、调用父类的实例构造器（仅仅是实例构造器，`<clinit>()`方法中无须调用父类的`<clinit>()`方法，Java虚拟机会自动保证父类构造器的正确执行）等操作收敛到`<init>()`和`<clinit>()`方法之中。

182. 讲讲 Java 语法糖有哪些？

     + 泛型：Java 选择的泛型实现方式是类型擦除式泛型，而 C# 选择的泛型实现方式是具现化式泛型。java中的泛型只在程序源码中存在，在编译后的字节码文件中，全部泛型都被替换为原来的裸类型（Raw Type）了，并且在相应的地方插入了强制转型代码，因此对于运行期的Java语言来说，`ArrayList<int>`与`ArrayList<String>`其实是同一个类型。当初Java选择这种方式实现泛型的历史原因在于Java语言的向后兼容性。
     + 自动装箱，拆箱
     + for-in 遍历循环

183. 常见的编译器优化技术有哪些？

     + 方法内联：是其他优化的基础，减少方法分派的开销
     + 逃逸分析：分析对象动态作用域，当一个对象在方法里面被定义后，它可能被外部方法所引用，例如作为调用参数传递到其他方法中，这种称为方法逃逸；甚至还有可能被外部线程访问到，譬如赋值给可以在其他线程中访问的实例变量，这种称为线程逃逸；从不逃逸、方法逃逸到线程逃逸，称为对象由低到高的不同逃逸程度。根据不同逃逸程度：可以执行栈上分配，标量替换，同步消除。
     + 公共子表达式消除
     + 数组边界检查消除

184. 什么是即时编译器，其作用是什么？

     在运行时，虚拟机将会把热点代码编译成本地机器码，并以各种手段尽可能地进行代码优化，运行时完成这个任务的后端编译器被称为即时编译器。

185. Java 内存模型中，主内存和工作内存的概念？

     规定了所有的变量都存储在主内存（Main Memory）中，每条线程还有自己的工作内存（Working Memory，可与前面讲的处理器高速缓存类比），线程的工作内存中保存了被该线程使用的变量的主内存副本，线程对变量的所有操作（读取、赋值等）都必须在工作内存中进行，而不能直接读写主内存中的数据。

186. 当一个变量被 volatile 定义的时候，具有什么特性？

     + 保证此变量对所有线程的可见性，这里的“可见性”是指当一条线程修改了这个变量的值，新值对于其他线程来说是可以立即得知的。
     + 禁止指令重排序优化，普通的变量仅会保证在该方法的执行过程中所有依赖赋值结果的地方都能获取到正确的结果，而不能保证变量赋值操作的顺序与程序代码中的执行顺序一致。

187. 什么是线程安全，如何实现线程安全？

     当多个线程同时访问一个对象时，如果不用考虑这些线程在运行时环境下的调度和交替执行，也不需要进行额外的同步，或者在调用方进行任何其他的协调操作，调用这个对象的行为都可以获得正确的结果，那就称这个对象是线程安全的。线程安全的实现方式有：

     + 互斥同步：临界区（Critical Section）、互斥量（Mutex）和信号量（Semaphore）都是常见的互斥实现方式。在Java里面，互斥同步手段是synchronized关键字，这是一种块结构的同步语法。另外的话也有重入锁（ReentrantLock），相较于synchronized，重入锁提供：等待可中断，公平锁，锁绑定多个条件。
     + 非阻塞同步：互斥同步面临的主要问题是进行线程阻塞和唤醒所带来的性能开销，因此这种同步也被称为阻塞同步。基于冲突检测的乐观并发策略，通俗地说就是不管风险，先进行操作，如果没有其他线程争用共享数据，那操作就直接成功了；如果共享的数据的确被争用，产生了冲突，那再进行其他的补偿措施，最常用的补偿措施是不断地重试，直到出现没有竞争的共享数据为止。需要硬件支持，如测试并设置（Test-and-Set）；获取并增加（Fetch-and-Increment）；交换（Swap）；比较并交换（Compare-and-Swap，下文称CAS）。
     + 无同步方案：如果能让一个方法本来就不涉及共享数据，那它自然就不需要任何同步措施去保证其正确性，因此会有一些代码天生就是线程安全的。

188. 什么是自旋锁与自适应自旋？

     互斥同步对性能最大的影响是阻塞的实现，挂起线程和恢复线程的操作都需要转入内核态中完成，这些操作给Java虚拟机的并发性能带来了很大的压力。如果物理机器有一个以上的处理器或者处理器核心，能让两个或以上的线程同时并行执行，我们就可以让后面请求锁的那个线程“稍等一会”，但不放弃处理器的执行时间，看看持有锁的线程是否很快就会释放锁。为了让线程等待，我们只须让线程执行一个忙循环（自旋），这项技术就是所谓的自旋锁。自适应意味着自旋的时间不再是固定的了，而是由前一次在同一个锁上的自旋时间及锁的拥有者的状态来决定的。

189. 锁优化技术有哪些？

     + 锁消除：锁消除是指虚拟机即时编译器在运行时，对一些代码要求同步，但是对被检测到不可能存在共享数据竞争的锁进行消除。需要逃逸分析处理。
     + 锁粗化：原则上，总是推荐将同步块的作用范围限制得尽量小，这样是为了使得需要同步的操作数量尽可能变少，即使存在锁竞争，等待锁的线程也能尽可能快地拿到锁。但是如果一系列的连续操作都对同一个对象反复加锁和解锁，甚至加锁操作是出现在循环体之中的，那即使没有线程竞争，频繁地进行互斥同步操作也会导致不必要的性能损耗。因此可以进行锁粗化操作。
     + 锁细化：如 ConcurrentHashMap 采用分段锁便是锁细化的实例
     + 偏向锁：偏向锁会偏向于第一个获得它的线程，如果在接下来的执行过程中，该锁一直没有被其他的线程获取，则持有偏向锁的线程将永远不需要再进行同步。
     + 轻量级锁：虚拟机将使用CAS操作尝试把对象的Mark Word更新为指向Lock Record的指针。如果这个更新动作成功了，即代表该线程拥有了这个对象的锁，并且对象Mark Word的锁标志位将转变为“00”，表示此对象处于轻量级锁定状态。

190. 谈谈 synchronized 锁优化技术？

     首先需要了解对象头：

     ![image-20201206125352406](Java-面试题目汇总/image-20201206125352406.png)

     重量级锁的锁标志位为 '10'，指针指向的是 monitor 对象的起始地址；

     轻量级锁是相对基于OS的互斥量实现的重量级锁而言的，它的本意是在没有多线程竞争的前提下，减少传统的重量级锁使用OS的互斥量而带来的性能消耗。轻量级锁提升性能的经验依据是：对于绝大部分锁，在整个同步周期内都是不存在竞争的。如果没有竞争，轻量级锁就可以使用 CAS 操作避免互斥量的开销，从而提升效率。

     轻量级锁是在无多线程竞争的情况下，使用 CAS 操作去消除互斥量；偏向锁是在无多线程竞争的情况下，将这个同步都消除掉。偏向锁提升性能的经验依据是：对于绝大部分锁，在整个同步周期内不仅不存在竞争，而且总由同一线程多次获得。偏向锁会偏向第一个获得它的线程，如果接下来的执行过程中，该锁没有被其他线程获取，则持有偏向锁的线程不需要再进行同步。这使得线程获取锁的代价更低。

191. 哈希码和锁有关吗？

     只要对象计算过一致性哈希，偏向模式就置为0了，也就意味着该对象锁不能再偏向了，最低也会膨胀成轻量级锁。如果对象锁处于偏向模式时遇到计算一致性哈希请求，那么会跳过轻量级锁模式，直接膨胀为重量级锁。

192. 谈谈偏向锁，轻量级锁，重量级锁的优缺点和适用范围？

     ![img](Java-面试题目汇总/162b43380325e25dtplv-t2oaga2asx-zoom-in-crop-mark4536000.png)













