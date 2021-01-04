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

   

