---
title: 《Effective Java》笔记
date: 2020-12-06 18:04:57
tags: ["Java"]
---

本文是《Effective Java》第三版的读书笔记。

<!-- More -->

## 第二章 创建和销毁对象

1. 考虑使用静态工厂方法代替构造函数：获取一个类的实例的传统方式是使用类提供的公开构造函数，另外一种方法是类提供公开静态工厂方法，用于返回实例。使用静态工厂方法优点：

   + 静态工厂方法有确切名称，便于阅读
   + 静态工厂方法不需要在每次调用时创建新对象
   + 可以通过静态工厂方法获取返回类型的任何子类的对象，提供灵活性
   + 返回对象的类可以随调用的不同而变化，作为输入参数的函数，声明的返回类型的任何子类型都是允许的
   + 当编写包含方法的类时，返回对象的类不需要存在，如JDBC

   静态工厂方法缺点：

   + 没有公共或受保护构造函数的类不能被子类化
   + 程序员很难找到它们，下面是一些静态工厂方法的常用名称：
     + from：一种类型转换方法，接收单个参数并且返回相应实例
     + of：一个聚合方法，接受多个参数返回一个实例
     + valueOf：替代from和of但是更加冗长的方法
     + instance或getInstance：返回一个实例，该实例由参数描述，但具有不同的值（可能会缓存）
     + create或newInstance：该方法保证每个调用都返回一个新实例
     + getType：类似于 getInstance，但如果工厂方法位于不同的类中，则使用此方法
     + newType：与 newInstance 类似，但是如果工厂方法在不同的类中使用
     + type：一个用来替代 getType 和 newType 的比较简单的方式

2. 当构造函数有多个参数的时候，考虑使用构造器：静态工厂和构造函数都有一个局限，就是不能对大量可选参数做很好的扩展。当我们的可选参数个数大于4个时，往往需要重载很多个构造函数，会降低代码的可维护性。另外一种选择是JavaBean模式，但是JavaBean可能在构建的过程中处于不一致状态。此时我们可以使用构造器来生成所需对象。

   ```java
   // Builder Pattern
   public class NutritionFacts {
       private final int servingSize;
       private final int servings;
       private final int calories;
       private final int fat;
       private final int sodium;
       private final int carbohydrate;
   
       public static class Builder {
           // Required parameters
           private final int servingSize;
           private final int servings;
           // Optional parameters - initialized to default values
           private int calories = 0;
           private int fat = 0;
           private int sodium = 0;
           private int carbohydrate = 0;
   
           public Builder(int servingSize, int servings) {
               this.servingSize = servingSize;
               this.servings = servings;
           }
   
           public Builder calories(int val) {
               calories = val;
               return this;
           }
   
           public Builder fat(int val) {
               fat = val;
               return this;
           }
   
           public Builder sodium(int val) {
               sodium = val;
               return this;
           }
   
           public Builder carbohydrate(int val) {
               carbohydrate = val;
               return this;
           }
   
           public NutritionFacts build() {
               return new NutritionFacts(this);
           }
       }
   
       private NutritionFacts(Builder builder) {
           servingSize = builder.servingSize;
           servings = builder.servings;
           calories = builder.calories;
           fat = builder.fat;
           sodium = builder.sodium;
           carbohydrate = builder.carbohydrate;
       }
   }
   ```

   这样我们在生成代码的时候就可以通过链式调用来生成我们的对象实例。构造器模式很灵活，一个构造器可以构造多个对象。但是构造器的缺点就是为了创建一个对象，必须首先创建它的构造器。

3. 使用私有构造函数或枚举类型实施单例模式：实现单例模式的第一种方法：

   ```java
   // Singleton with public final field
   public class Elvis {
       public static final Elvis INSTANCE = new Elvis();
       private Elvis() { ... }
       public void leaveTheBuilding() { ... }
   }
   ```

   上述代码可以防止用户来自己创建Elvis实例。但是拥有特殊权限的客户端可以借助AccessibleObject.setAccessible 方法利用反射调用私有构造函数，如果需要防范这种问题，需要修改构造器，使其在请求创建第二个实例的时候抛出异常即可。另外一种方法：

   ```java
   // Singleton with static factory
   public class Elvis {
       private static final Elvis INSTANCE = new Elvis();
       private Elvis() { ... }
       public static Elvis getInstance() { return INSTANCE; }
       public void leaveTheBuilding() { ... }
   }
   ```

   静态工厂方法的一个优点是，它可以在不更改 API 的情况下决定类是否是单例，如为每个线程返回一个单例；第二个优点是，如果应用程序需要的话，可以编写泛型的单例工厂。实现单例的第三种方法：

   ```java
   // Enum singleton - the preferred approach
   public enum Elvis {
       INSTANCE;
       public void leaveTheBuilding() { ... }
   }
   ```

   这种方法类似于 public 字段方法，但是它更简洁，默认提供了序列化机制，提供了对多个实例化的严格保证，即使面对复杂的序列化或反射攻击也是如此。

4. 用私有构造函数实现不可实例化：对于一个工具类库，如Arrays，实例化这些类是没有意义的。试图通过使类抽象来实施不可实例化是行不通的。因为可以对类进行子类化，并实例化子类。有一个简单的习惯用法来确保不可实例化。只有当类不包含显式构造函数时，才会生成默认构造函数，因此可以通过包含私有构造函数使类不可实例化：

   ```java
   // Noninstantiable utility class
   public class UtilityClass {
       // Suppress default constructor for noninstantiability
       private UtilityClass() {
           throw new AssertionError();
       } ... // Remainder omitted
   }
   ```

   因为显式构造函数是私有的，所以在类之外是不可访问的。AssertionError 不是严格要求的，但是它提供了保障，以防构造函数意外地被调用。

5. 依赖注入优于硬连接资源：尽量将类依赖的资源在创建新实例时将资源传递给构造函数，从而实现依赖注入。

   ```java
   // Dependency injection provides flexibility and testability
   public class SpellChecker {
       private final Lexicon dictionary;
       public SpellChecker(Lexicon dictionary) {
           this.dictionary = Objects.requireNonNull(dictionary);
       }
       public boolean isValid(String word) { ... }
       public List<String> suggestions(String typo) { ... }
   }
   ```

   另外，这种模式的一个有用变体是将资源工厂传递给构造函数。Java 8 中引入的 `Supplier<T>` 非常适合表示工厂。尽管依赖注入极大地提高了灵活性和可测试性，但它可能会使大型项目变得混乱，这些项目通常包含数千个依赖项。

6. 避免创建不必要的对象：作为一个不该做的极端例子，请考虑下面的语句：

   ```java
   String s = new String("bikini"); // DON'T DO THIS!
   ```

   该语句每次执行时都会创建一个新的 String 实例，而这些对象创建都不是必需的。String 构造函数的参数 `("bikini")` 本身就是一个 String 实例，在功能上与构造函数创建的所有对象相同。另外，有些对象的创建代价很高，如果你需要重复地使用这样一个「昂贵的对象」，那么最好将其缓存以供复用：

   ```java
   // Reusing expensive object for improved performance
   public class RomanNumerals {
       private static final Pattern ROMAN = Pattern.compile("^(?=.)M*(C[MD]|D?C{0,3})" + "(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$");
       static boolean isRomanNumeral(String s) {
           return ROMAN.matcher(s).matches();
       }
   }
   ```

   另外，还需要注意基本类型优于包装类，需要提防意外的自动自动装箱。

7. 排除过时的对象引用：考虑一个栈的pop操作：

   ```java
   public Object pop() {
       if (size == 0)
       	throw new EmptyStackException();
       return elements[--size];
   }
   ```

   上述代码没有明显的问题，但是存在内存泄露的隐患：如果堆栈增长，然后收缩，那么从堆栈中弹出的对象将不会被垃圾收集，即使使用堆栈的程序不再引用它们。改进方式：

   ```java
   public Object pop() {
       if (size == 0)
           throw new EmptyStackException();
       Object result = elements[--size];
       elements[size] = null; // Eliminate obsolete reference
       return result;
   }
   ```

   一般来说，一个类管理它自己的内存时，程序员应该警惕内存泄漏。当释放一个元素时，该元素中包含的任何对象引用都应该被置为 null。

   另一个常见的内存泄漏源是缓存。一旦将对象引用放入缓存中，就很容易忘记它就在那里，并且在它变得无关紧要之后很久仍将它留在缓存中。如果你非常幸运地实现了一个缓存，只要缓存外有对其键的引用，那么就将缓存表示为 WeakHashMap，当条目过时后，条目将被自动删除。

   内存泄漏的第三个常见来源是侦听器和其他回调。 如果你实现了一个 API，其中客户端注册回调，但不显式取消它们，除非你采取一些行动，否则它们将累积。

8. 避免使用终结器和清除器：终结器是不可预测的，通常是危险的，也是不必要的。清除器的危险比终结器小，但仍然不可预测、缓慢，而且通常是不必要的。终结器和清除器的一个缺点是不能保证它们会被立即执行，另外一个缺点是它们可能会使的即将要被清理的对象死而复生。终结器和清除器可以充当一个安全网，以防资源的所有者忽略调用它的 close 方法。

9. 使用try-with-resources优于try-finally：从历史上看，try-finally 语句是确保正确关闭资源的最佳方法，即使在出现异常或返回时也是如此。但是当存在两个资源的时候，可能就需要嵌套的调用了，这会导致代码不易阅读。最好的方法就是使用try-with-resources：

   ```java
   // try-with-resources on multiple resources - short and sweet
   static void copy(String src, String dst) throws IOException {
       try (InputStream in = new FileInputStream(src);OutputStream out = new FileOutputStream(dst)) {
           byte[] buf = new byte[BUFFER_SIZE];
           int n;
           while ((n = in.read(buf)) >= 0)
               out.write(buf, 0, n);
       }
   }
   ```




## 第三章 对象的通用方法

10. 覆盖 equals 方法时应该遵守的约定：当满足下面的条件的时候，不应该覆盖equals方法：

    + 类的每个实例本质上是唯一的
    + 该类不需要提供逻辑相等测试
    + 超类已经覆盖了equals，超类行为适合于这个类
    + 类是私有的或者包私有的，并且你确信它的 equals 方法永远不会被调用

    equals方法实现了等价关系：反身性，对称性，传递性，一致性，最后还需要满足非无效性：即`o.equals(null)`返回false。为了搞笑实现equals方法，需要：

    + 使用 == 运算符检查参数是否是对该对象的引用
    + 使用 instanceof 运算符检查参数是否具有正确的类型
    + 将参数转换为正确的类型
    + 对于类中的每个「重要」字段，检查参数的字段是否与该对象的相应字段匹配
    + 是否满足等价关系

11. 当覆盖 equals 方法的时候，总要覆盖 hashCode 方法：由于相等的对象必须具有相等的散列码，如果PhoneNumber没有实现hashCode方法的话：

    ```java
    Map<PhoneNumber, String> m = new HashMap<>();
    m.put(new PhoneNumber(707, 867, 5309), "Jenny");
    // m.get(new PhoneNumber(707, 867,5309)) == null
    ```

    第三行的结果将是null，而不是`"Jenny"`。实现hashCode方法的一个简单方法步骤：

    + 声明一个名为 result 的 int 变量，并将其初始化为对象中第一个重要字段的散列码 c
    + 对象中剩余的重要字段 f，执行以下操作：
      + 为字段计算一个整数散列码 c：如果字段是基本数据类型，计算 `Type.hashCode(f)`，其中 type 是与 f 类型对应的包装类。如果字段是对象引用，并且该类的 equals 方法通过递归调用 equals 方法来比较字段，则递归调用字段上的 hashCode 方法。如果字段是一个数组，则将其每个重要元素都视为一个单独的字段。也就是说，通过递归地应用这些规则计算每个重要元素的散列码，并将每个步骤 2.b 的值组合起来。如果数组中没有重要元素，则使用常量，最好不是 0。如果所有元素都很重要，那么使用 `Arrays.hashCode`。
      + 将步骤 2.a 中计算的散列码 c 合并到 result 变量
    + 返回result

    一个简单的demo：

    ```java
    // Typical hashCode method
    @Override
    public int hashCode() {
        int result = Short.hashCode(areaCode);
        result = 31 * result + Short.hashCode(prefix);
        result = 31 * result + Short.hashCode(lineNum);
        return result;
    }
    ```

12. 始终覆盖 toString 方法：虽然Object提供了默认的toString方法，但是它返回的字符串通常不是用户希望看到的。提供一个好的 toString 实现（能）使类更易于使用，使用该类的系统（也）更易于调试。当实际使用时，toString 方法应该返回对象中包含的所有有用信息。

13. 明智地覆盖 clone 方法：Cloneable 接口的目的是作为 mixin 接口，用于让类来宣称它们允许克隆。不幸的是，它没有达到这个目的。它的主要缺点是缺少 clone 方法，并且 Object 类的 clone 方法是受保护的。它决定了 Object 类受保护的 clone 实现的行为：如果一个类实现了 Cloneable 接口，Object 类的 clone 方法则返回该类实例的逐字段拷贝；否则它会抛出 CloneNotSupportedException。默认提供的clone方法执行的是浅拷贝，如果需要深拷贝，就需要自己覆盖clone方法，实现该功能。

14. 考虑实现 Comparable 接口：与本章讨论的其他方法不同，compareTo 方法不是在 Object 中声明的。相反，它是 Comparable 接口中的唯一方法。通过让类实现 Comparable，就可与依赖于此接口的所有通用算法和集合实现进行互操作。如果一个类有多个重要的字段，此时就需要用户来指定对应的比较顺序。在 Java 8 中，Comparator 接口配备了一组比较器构造方法，可以流畅地构造比较器。然后可以使用这些比较器来实现 Comparator 接口所要求的 compareTo 方法。

    ```java
    // Comparable with comparator construction methods
    private static final Comparator<PhoneNumber> COMPARATOR = comparingInt((PhoneNumber pn) -> pn.areaCode)
        .thenComparingInt(pn -> pn.prefix)
        .thenComparingInt(pn -> pn.lineNum);
    
    public int compareTo(PhoneNumber pn) {
        return COMPARATOR.compare(this, pn);
    }
    ```

    

## 第四章 类和接口

15. 尽量减少类和成员的可访问性：隐藏内部数据和其他实现细节用于实现信息封装，可以解耦组成系统的组件。通用方法是让每个类或者成员尽可能不可访问。对于顶级（非嵌套）类和接口，只有两个可能的访问级别：包私有和公共。如果一个方法覆盖了超类方法，那么它在子类中的访问级别就不能比超类更严格。公共类的实例字段很少采用 public 修饰，因为带有公共可变字段的类通常不是线程安全的。请注意，非零长度的数组总是可变的，因此对于类来说，拥有一个公共静态 final 数组字段或返回该字段的访问器是错误的。如果一个类具有这样的字段或访问器，客户端将能够修改数组的内容。对于 Java 9，作为模块系统的一部分，还引入了另外两个隐式访问级别。模块是包的分组单位，就像包是类的分组单位一样。模块可以通过模块声明中的导出声明显式地导出它的一些包。

16. 在公共类中，使用访问器方法，而不是公共字段：如果类可以在包之外访问，那么提供访问器方法来保持更改类内部表示的灵活性。但是，如果一个类是包级私有的或者是私有嵌套类，那么公开它的数据字段并没有什么本质上的错误。无论是在类定义还是在使用它的客户端代码中，这种方法产生的视觉混乱都比访问方法少。虽然公共类直接公开字段从来都不是一个好主意，但是如果字段是不可变的，那么危害就会小一些。

17. 减少可变性：不可变类就是一个实例不能被修改的类。要使类不可变，请遵循以下 5 条规则：

    1. 不要提供修改对象状态的方法
    2. 确保类不能被扩展
    3. 所有字段用 final 修饰
    4. 所有字段设为私有
    5. 确保对任何可变组件的独占访问

    不可变对象提供的好处：

    1. 不可变对象本质上是线程安全的
    2. 不可变对象可以很好的作为其他对象的构建模块
    3. 不可变对象自带提供故障原子性。他们的状态从未改变，所以不可能出现暂时的不一致。

    不可变类的主要缺点是每个不同的值都需要一个单独的对象。

18. 优先选择复合而不是继承：在包中使用继承是安全的，其中子类和超类实现由相同的程序员控制。在对专为扩展而设计和文档化的类时使用继承也是安全的。然而，对普通的具体类进行跨包边界的继承是危险的。与方法调用不同，继承破坏了封装。换句话说，子类的功能正确与否依赖于它的超类的实现细节。子类脆弱的一个原因是他们的超类可以在后续版本中获得新的方法。有一种方法可以避免上述所有问题。与其扩展现有类，不如为新类提供一个引用现有类实例的私有字段。这种设计称为复合，因为现有的类是新类的一个组件。只有在子类确实是超类的子类型的情况下，继承才合适。换句话说，只有当两个类之间存在「is-a」关系时，类 B 才应该扩展类 A。

19. 继承要设计良好并且具有文档，否则禁止使用：首先，类必须精确地在文档中记录覆盖任何方法的效果。换句话说，类必须在文档中记录它对可覆盖方法的自用性。对于每个公共或受保护的方法，文档必须指出方法调用的可覆盖方法、调用顺序以及每次调用的结果如何影响后续处理过程。但是，这是否违背了一个格言：好的 API 文档应该描述一个给定的方法做什么，而不是如何做？是的，它确实违背了！这是继承违反封装这一事实的不幸结果。要为一个类编制文档，使其能够安全地子类化，你必须描述实现细节，否则这些细节应该是未指定的。为了允许继承，类必须遵守更多的限制。构造函数不能直接或间接调用可重写的方法。 如果你违反了这个规则，程序就会失败。超类构造函数在子类构造函数之前运行，因此在子类构造函数运行之前将调用子类中的覆盖方法。如果重写方法依赖于子类构造函数执行的任何初始化，则该方法的行为将不像预期的那样。

20. 接口优于抽象类：Java 有两种机制来定义允许多种实现的类型：接口和抽象类。由于 Java 8 中引入了接口的默认方法，这两种机制都允许你为一些实例方法提供实现。一个主要区别是，一个类要实现抽象类定义的类型，该类必须是抽象类的子类。因为 Java 只允许单一继承，这种限制对抽象类而言严重制约了它们作为类型定义的使用。使用接口的优点：

    1. 可以很容易地对现有类进行改造，以实现新的接口
    2. 接口是定义 mixin（混合类型）的理想工具
    3. 接口允许构造非层次化类型框架

21. 为后代设计接口：在 Java 8 之前，在不破坏现有实现的情况下向接口添加方法是不可能的。如果在接口中添加新方法，通常导致现有的实现出现编译时错误，提示缺少该方法。在 Java 8 中，添加了默认的方法构造，目的是允许向现有接口添加方法。除非必要，否则应该避免使用默认方法向现有接口添加新方法，在这种情况下，你应该仔细考虑现有接口实现是否可能被默认方法破坏。尽管默认方法现在已经是 Java 平台的一部分，但是谨慎地设计接口仍然是非常重要的。虽然默认方法使向现有接口添加方法成为可能，但这样做存在很大风险。 如果一个接口包含一个小缺陷，它可能会永远影响它的使用者；如果接口有严重缺陷，它可能会毁掉包含它的 API。

22. 接口只用于定义类型：当一个类实现了一个接口时，这个接口作为一种类型，可以用来引用类的实例。不满足上述条件的一种接口是所谓的常量接口。如果你想导出常量，有几个合理的选择。如果这些常量与现有的类或接口紧密绑定，则应该将它们添加到类或接口。例如，所有数值包装类，比如 Integer 和 Double，都导出 MIN_VALUE 和 MAX_VALUE 常量。如果将这些常量看作枚举类型的成员，那么应该使用 enum 类型导出它们。否则，你应该使用不可实例化的工具类导出常量。

23. 类层次结构优于带标签的类：有时候，你可能会遇到这样一个类，它的实例有两种或两种以上的样式，并且包含一个标签字段来表示实例的样式。这样的标签类有许多缺点。它们充斥着样板代码，包括 enum 声明、标签字段和 switch 语句。标签类冗长、容易出错和低效。面向对象的语言提供了一个更好的选择来定义能够表示多种类型对象的单一数据类型：子类型。标签类只是类层次结构的简易模仿。

24. 静态成员类优于非静态成员类：有四种嵌套类：静态成员类、非静态成员类、匿名类和局部类。除了第一种，所有的类都被称为内部类。静态成员类是最简单的嵌套类。最好把它看做是一个普通的类，只是碰巧在另一个类中声明而已，并且可以访问外部类的所有成员，甚至那些声明为 private 的成员。静态成员类的一个常见用法是作为公有的辅助类。从语法上讲，静态成员类和非静态成员类之间的唯一区别是静态成员类在其声明中具有修饰符 static。如果声明的成员类不需要访问外部的实例，那么应始终在声明中添加 static 修饰符，使其成为静态的而不是非静态的成员类。匿名类的适用性有很多限制。你不能实例化它们，除非在声明它们的时候。在 lambda 表达式被添加到 Java 之前，匿名类是动态创建小型函数对象和进程对象的首选方法，但 lambda 表达式现在是首选方法。局部类是四种嵌套类中最不常用的。局部类几乎可以在任何能够声明局部变量的地方使用，并且遵守相同的作用域规则。局部类具有与其他嵌套类相同的属性。

25. 源文件仅限有单个顶层类：虽然 Java 编译器允许你在单个源文件中定义多个顶层类，但这样做没有任何好处，而且存在重大风险。这种风险源于这样一个事实：在源文件中定义多个顶层类使得为一个类提供多个定义成为可能。



## 第五章 泛型

26. 不要使用原始类型：声明中具有一个或多个类型参数的类或接口就是泛型类或泛型接口，每个泛型都定义了一个原始类型，它是没有任何相关类型参数的泛型的名称。例如，`List<E>` 对应的原始类型是 List。原始类型的行为就好像所有泛型信息都从类型声明中删除了一样。它们的存在主要是为了与之前的泛型代码兼容。当从集合中检索元素时，编译器会为你执行不可见的强制类型转换，并确保它们不会失败。使用原始类型（没有类型参数的泛型）是合法的，但是你永远不应该这样做。如果使用原始类型，就会失去泛型的安全性和表现力。考虑如下程序：

    ```java
    // Fails at runtime - unsafeAdd method uses a raw type (List)!
    
    public static void main(String[] args) {
        List<String> strings = new ArrayList<>();
        unsafeAdd(strings, Integer.valueOf(42));
        String s = strings.get(0); // Has compiler-generated cast
    }
    
    private static void unsafeAdd(List list, Object o) {
        list.add(o);
    }
    ```

    该程序可以编译，但因为它使用原始类型 List，所以你会得到一个警告：

    ```
    Test.java:10: warning: [unchecked] unchecked call to add(E) as a
    member of the raw type List
    list.add(o);
    ^
    ```

    实际上，如果你运行程序，当程序试图将调用 `strings.get(0)` 的结果强制转换为字符串时，你会得到一个 ClassCastException。这是一个由编译器生成的强制类型转换，它通常都能成功，但在本例中，我们忽略了编译器的警告，并为此付出了代价。

    如果将 unsafeAdd 声明中的原始类型 List 替换为参数化类型 `List`，并尝试重新编译程序，你会发现它不再编译，而是发出错误消息：

    ```
    Test.java:5: error: incompatible types: List<String> cannot be
    converted to List<Object>
    unsafeAdd(strings, Integer.valueOf(42));
    ^
    ```

    对于元素类型未知且无关紧要的集合，你可能会尝试使用原始类型。这种方法是可行的，但是它使用的是原始类型，这是很危险的。安全的替代方法是使用无界通配符类型。如果你想使用泛型，但不知道或不关心实际的类型参数是什么，那么可以使用问号代替。

    ```
    // Uses unbounded wildcard type - typesafe and flexible
    static int numElementsInCommon(Set<?> s1, Set<?> s2) { ... }
    ```

    对于不应该使用原始类型的规则，有一些小的例外。必须在类字面量中使用原始类型。换句话说，`List.class`，`String[].class` 和 `int.class` 都是合法的，但是 `List.class` 和 `List.class` 不是。第二个例外是 instanceof 运算符。由于泛型信息在运行时被删除，因此在不是无界通配符类型之外的参数化类型上使用 instanceof 操作符是非法的。使用无界通配符类型代替原始类型不会以任何方式影响 instanceof 运算符的行为。在这种情况下，尖括号和问号只是多余的。下面的例子是使用通用类型 instanceof 运算符的首选方法：

    ```java
    // Legitimate use of raw type - instanceof operator
    if (o instanceof Set) { // Raw type
        Set<?> s = (Set<?>) o; // Wildcard type
        ...
    }
    ```

    总之，使用原始类型可能会在运行时导致异常，所以不要轻易使用它们。它们仅用于与引入泛型之前的遗留代码进行兼容和互操作。快速回顾一下，`Set` 是一个参数化类型，表示可以包含任何类型的对象的集合，`Set` 是一个通配符类型，表示只能包含某种未知类型的对象的集合，Set 是一个原始类型，它选择了泛型系统。前两个是安全的，后一个就不安全了。

27. 消除 unchecked 警告：使用泛型获得的经验越多，得到的警告就越少，但是不要期望新编写的代码能够完全正确地编译。力求消除所有 unchecked 警告。 如果你消除了所有警告，你就可以确信你的代码是类型安全的，这是一件非常好的事情。如果不能消除警告，但是可以证明引发警告的代码是类型安全的，那么（并且只有在那时）使用 SuppressWarnings("unchecked") 注解来抑制警告。SuppressWarnings 注解可以用于任何声明中，从单个局部变量声明到整个类。总是在尽可能小的范围上使用 SuppressWarnings 注解。 每次使用SuppressWarnings("unchecked") 注解时，要添加一条注释，说明这样做是安全的。

28. list 优于数组：数组与泛型有两个重要区别。首先，数组是协变的。这个听起来很吓人的单词的意思很简单，如果 Sub 是 Super 的一个子类型，那么数组类型 Sub[] 就是数组类型 Super[] 的一个子类型。数组和泛型之间的第二个主要区别：数组是具体化的。这意味着数组在运行时知道并强制执行他们的元素类型。相比之下，泛型是通过擦除来实现的。

    由于这些基本差异，数组和泛型不能很好地混合。例如，创建泛型、参数化类型或类型参数的数组是非法的。因此，这些数组创建表达式都不是合法的：`new List[]`、`new List[]`、`new E[]`。所有这些都会在编译时导致泛型数组创建错误。为了更具体，请考虑以下代码片段：

    ```java
    // Why generic array creation is illegal - won't compile!
    List<String>[] stringLists = new List<String>[1]; // (1)
    List<Integer> intList = List.of(42); // (2)
    Object[] objects = stringLists; // (3)
    objects[0] = intList; // (4)
    String s = stringLists[0].get(0); // (5)
    ```

    假设创建泛型数组的第 1 行是合法的。第 2 行创建并初始化一个包含单个元素的 `List`。第 3 行将 `List` 数组存储到 Object 类型的数组变量中，这是合法的，因为数组是协变的。第 4 行将 `List` 存储到 Object 类型的数组的唯一元素中，这是成功的，因为泛型是由擦除实现的：`List` 实例的运行时类型是 List，`List`[] 实例的运行时类型是 List[]，因此这个赋值不会生成 ArrayStoreException。现在我们有麻烦了。我们将一个 `List` 实例存储到一个数组中，该数组声明只保存 `List` 实例。在第 5 行，我们从这个数组的唯一列表中检索唯一元素。编译器自动将检索到的元素转换为 String 类型，但它是一个 Integer 类型的元素，因此我们在运行时得到一个 ClassCastException。为了防止这种情况发生，第 1 行（创建泛型数组）必须生成编译时错误。

    当你在转换为数组类型时遇到泛型数组创建错误或 unchecked 强制转换警告时，通常最好的解决方案是使用集合类型 `List`，而不是数组类型 E[]。

    总之，数组和泛型有非常不同的类型规则。数组是协变的、具体化的；泛型是不变的和可被擦除的。因此，数组提供了运行时类型安全，而不是编译时类型安全，对于泛型反之亦然。一般来说，数组和泛型不能很好地混合。如果你发现将它们混合在一起并得到编译时错误或警告，那么你的第一个反应该是将数组替换为 list。

29. 优先使用泛型：考虑一个泛型栈结构：

    ```java
    public Stack() {
        elements = new E[DEFAULT_INITIAL_CAPACITY];
    }
    ```

    通常至少会得到一个错误或警告，这个类也不例外。幸运的是，这个类只生成一个错误：

    ```
    Stack.java:8: generic array creation
    elements = new E[DEFAULT_INITIAL_CAPACITY];
    ^
    ```

    每当你编写由数组支持的泛型时，就会出现这个问题。有两种合理的方法来解决它。第一个解决方案直接绕过了创建泛型数组的禁令：创建对象数组并将其强制转换为泛型数组类型。现在，编译器将发出一个警告来代替错误。这种用法是合法的，但（一般而言）它不是类型安全的：

    ```
    Stack.java:8: warning: [unchecked] unchecked cast
    found: Object[], required: E[]
    elements = (E[]) new Object[DEFAULT_INITIAL_CAPACITY];
    ^
    ```

    消除 Stack 中泛型数组创建错误的第二种方法是将字段元素的类型从 E[] 更改为 Object[]。如果你这样做，你会得到一个不同的错误：

    ```
    Stack.java:19: incompatible types
    found: Object, required: E
    E result = elements[--size];
    ^
    ```

    通过将从数组中检索到的元素转换为 E，可以将此错误转换为警告，但你将得到警告：

    ```
    Stack.java:19: warning: [unchecked] unchecked cast
    found: Object, required: E
    E result = (E) elements[--size];
    ^
    ```

    消除泛型数组创建的两种技术都有其追随者。第一个更容易读：数组声明为 E[] 类型，这清楚地表明它只包含 E 的实例。它也更简洁：在一个典型的泛型类中，从数组中读取代码中的许多点；第一种技术只需要一次转换（在创建数组的地方），而第二种技术在每次读取数组元素时都需要单独的转换。因此，第一种技术是可取的，在实践中更常用。

    泛型比需要在客户端代码中转换的类型更安全、更容易使用。

30. 优先使用泛型方法：允许类型参数被包含该类型参数本身的表达式限制，尽管这种情况比较少见。这就是所谓的递归类型限定。递归类型边界的一个常见用法是与 Comparable 接口相关联，后者定义了类型的自然顺序：

    ```java
    public interface Comparable<T> {
        int compareTo(T o);
    }
    ```

    许多方法采用实现 Comparable 的元素集合，在其中进行搜索，计算其最小值或最大值，等等。要做到这些，需要集合中的每个元素与集合中的每个其他元素相比较，换句话说，就是列表中的元素相互比较。

    ```java
    // Using a recursive type bound to express mutual comparability
    public static <E extends Comparable<E>> E max(Collection<E> c);
    ```

    类型限定 `<E extends Comparable<E>>` 可以被理解为「可以与自身进行比较的任何类型 E」，这或多或少与相互可比性的概念相对应。

