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