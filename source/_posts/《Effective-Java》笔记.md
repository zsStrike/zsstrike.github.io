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