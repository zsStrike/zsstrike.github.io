---
title: 《Java并发编程实战》笔记
date: 2020-12-17 18:43:50
tags: ["Java"]
---

本文总结了《Java并发编程实战》中的关键点，可以用于查阅其中的知识点。

<!-- More -->

## 第二章 线程安全性

线程安全性：当多个类访问同一个类的时候，这个类始终都能表现出正确的行为，就称该线程是线程安全的。

原子性：

+ 竞态条件（Race Condition）：当某个计算的正确性取决于多个线程的交替执行时序时，那么就会发生竞态条件。比如懒汉式单例模式中的 getInstance 方法，基于先检查后执行，由于需要检查 instance 是否为 null，再判断是否需要实例化，此时就存在竞态条件。
+ 复合操作：指的是将一系列的操作合并成一个，使其满足原子性，比如 AtomicLong 里面的 incrementAndGet 方法。

加锁机制：

+ 内置锁：使用关键字 synchronized  实现同步锁，修饰方法的时候锁就是方法调用所在的对象，静态的 synchronized 方法以 Class 对象为锁。

  ```java
  synchronized (lock) {
  	// 访问或者修改由锁保护的共享对象
  }
  ```

+ 重入：当某个线程请求一个由其他线程持有的锁的时候，发出请求的线程会阻塞。但是如果一个线程试图获得一个已经由它自己持有的锁，那么这个请求就会成功。



## 第三章 对象的共享

可见性：

+ 失效数据：一个线程修改某个数据后，如果没有进行同步操作，另外一个线程再去读的话，可能就会读到之前的数据。
+ 非原子的 64 位操作：Java 内存模型要求，变量的读取和写入都是原子操作，但是对于非 volatile 类型的 long 和 double 变量，JVM 允许将其分解为两个 32 位的操作。此时就可能发生失效数据的读取。
+ 加锁与可见性：加锁的含义不仅在于互斥行为，还在于内存可见性，为了确保所有的线程能看到共享变量的最新值，所有执行读操作或者写操作的线程必须在同一个锁上同步。
+ volatile 变量：对变量的更新操作将会通知到其他线程。不建议过度使用 volatile 变量，因为volatile 变量只能保证可见性，不能确保原子性。

发布与逸出：发布指对象能够在当前作用域之外的代码中使用；逸出指的是当某个不应该被发布的对象被发布。不要在构造过程中使得 this 逸出，常见错误是在构造函数中启动一个线程。

线程封闭：避免同步的方式就是不共享数据，如果仅在单线程内访问数据，就不需要同步，这就是线程封闭。

+ Ad-hoc 线程封闭：维护线程封闭的职责完全由程序实现来承担。
+ 栈封闭：是线程封闭的一种特例，在栈封闭中，只能通过局部变量才能访问到对象。
+ ThreadLocal 类：能使线程中的某个值与保存值的对象关联起来。ThreadLocal 提供 get 和 set 方法，这些方法为每个使用该变量的线程都存有一份独立副本，因此是线程独立的。通常用于防止对可变的单例变量或全局变量进行共享。

不变性：不可变对象一定是线程安全的。

+ final 域：用于构造不可变性对象，使用 final 修饰的域是不可更改的。另外，final 域可以确保初始化过程的安全性。



## 第四章 对象的组合

设计线程安全的类：收集同步需求，以来状态的操作，状态的所有权。

实例封闭：封装简化了线程安全类的实现过程，当一个对象封装到另外一个对象中的时候，能够访问被封装对象的代码路径都是已知的，这样更适合对代码进行分析和加锁。

+ Java 监视器模式：使用私有锁对象而不是对象的内置锁的优点有，私有的锁对象可以将锁封装起来，但是客户端还是可以获取到共有方法来访问锁。

  ```java
  public class ProvateLock {
  	private final Object myLock = new Object();
  	Widget widget;
  	
  	void someMethod() {
  		synchronized (myLock) {
  			// 访问修改Widget的状态
  		}
  	}
  }
  ```

在现有的线程安全类中添加功能：

+ 客户端加锁机制：对于使用某个对象 X 的客户端代码，使用 X 本身用于保护其状态的锁来保护这段客户端代码。
+ 组合：使用组合方法构建对象，同时在上层再次加锁，实现同步。



## 第五章 基础构建模块

同步容器类：

+ 问题：同步容器类都是线程安全的，但是在某些情况需要额外的客户端加锁实现复合操作。
+ 迭代器与 ConcurrentModificationException：如果在迭代期间对迭代对象进行了修改，可能就会抛出该异常。可以使用加锁来解决该问题，但是可能会带来验证 的性能问题。如果不想在迭代期间对对象进行加锁操作，可以先克隆容器，并在副本上迭代。
+ 隐藏迭代器：比如打印一个 set 的时候就隐式用到了迭代器。

并发容器：

+ ConcurrentHashMap：同步容器类在执行期间都持有一个锁，而并发容器类则使用了一种不同的加锁策略：使用粒度更细的加锁机制实现最大程度的共享，称为分段锁。该策略能够在并发编程的环境中实现更大的吞吐量。另外，并发容器类提供的迭代器不会抛出 ConcurrentModificationException，因此不需要在迭代过程中对容器加锁。由于他们返回的迭代器具有弱一致性，也即可以容忍并发的修改，当创建迭代器会遍历已有的元素，并可以（不保证）在迭代器构造后将修改反映给容器。
+ 额外的原子 Map 操作：由于并发容器不支持加锁，因此我们不能基于加锁来实现复合操作。但是，一些复合原子操作已经内置提供：`putifAbsent`，`remove`和`replace`。
+ CopyOnWriteArrayList：用于替代 List，提供更好的并发性能，并且迭代器件不需要对容器加锁或者复制。每次修改容器的时候都会复制底层数组，需要一定开销。

阻塞队列和生产者-消费者模式：

+ 阻塞队列：提供了可阻塞的 put 和 take 方法，以及支持定时的 offer 和 poll 方法。如果队列满了，那么 put 方法阻塞直到有空间可用。阻塞队列提供了 offer 方法，如果数据项不能添加到队列中，将返回失败状态，客户端可以根据此来调整生产者的数量。类库有 LinkedBlockingQueue 和 ArrayBlockingQueue。
+ 串行线程封闭：对于可变对象，生产者-消费者和阻塞队列一起，促进了穿行线程封闭，从而将对象所有权从生产者交付给消费者。
+ 双端队列：ArrayDeque 和 LinkedBlockingDeque。双端队列可用于另外一种工作模式，工作密取。在该模式下，每个消费者有自己的双端队列，如果一个消费者完成了自己双端队列中的全部工作，那么它可以从其他消费者双端队列末尾秘密获取工作。

阻塞方法与中断方法：线程可能会被阻塞，阻塞原因有：等待 IO 操作，等待一个锁，等待从 sleep 中醒来。阻塞的线程只有得到外部某个事件发生的时候，才能脱离阻塞，回到Runnable 状态。而中断是一种协作机制，一个线程不能强制要求其他线程停止正在执行的操作而去执行其他的操作。

同步工具类：

+ 闭锁（Latch）：闭锁的作用相当于一扇门：在闭锁到达结束状态之前，这扇门一直关闭，并且没有任何线程能通过，当到达结束状态时，这扇门会打开并且允许所有线程通过。一旦到达结束状态后，就再也不会改变状态。在 Java 中可以使用 CountDownLatch。
+ FutureTask：也可用作闭锁。其状态有三种：等待执行，正在运行，运行完成。Future.get 的行为取决于任务的状态，如果任务完成，立即返回结果，否则将阻塞直到任务完成。
+ 信号量（Semaphore）：计数信号量用来控制访问某个特定资源的操作数量，或者同时执行某个指定操作的数量。可以通过 acquire 和 release 来进行获取和释放信号量的操作。
+ 栅栏（Barrier）：栅栏类似闭锁，它能阻塞一组线程直到某个时间发生。栅栏和闭锁的关键区别在于，所有线程必须同事到达栅栏位置，才能继续执行。闭锁用于等待事件，栅栏则用于等待其他线程。CyclicBarrier 可以使一定数量的参与方反复在栅栏处汇集。当线程达到栅栏的时候，调用 await 方法，这个方法将阻塞直到所有线程都到达栅栏位置。如果所有线程都到达，那么栅栏将会打开，此时所有线程将被释放，而栅栏被重置以便下次使用。如果对 await 的调用超时，那么栅栏就被认为是打破了，所有阻塞的 await 调用将终止并且抛出 BrokenBarrierException。



## 第六章 任务执行

在线程中执行任务：

+ 串行地执行任务：每次只会执行一个任务，但是执行的性能低下。
+ 显式地为任务创建线程：通过为每个请求提供一个新的线程提供服务，实现更高的响应性。
+ 无限制创建线程的不足：线程生命周期开销高，资源消耗，稳定性。

Executor 框架：Java 中，任务执行的主要抽象是 Executor，而不是 Thread。Executor 基于生产者-消费者模式。其接口定义：

```java
public interface Executor {
	void execute(Runnable command);
}
```

+ 线程池：指的是管理一组同构工作线程的资源池。通过重用现有的线程而不是创建新的线程来处理新的请求，可以减少新的线程的创建和销毁的开销。通常需要配置一个合适大小的线程池，使得提高处理器的效率和防止过多线程竞争资源使得内存耗尽。在 Java 中可以通过调用静态工厂方法来创建一个线程池：`newFixedThreadPool`，`newCachedThreadPool`，`newSingleThreadPool`，`newScheduledThreadPool`。
+ Executor 生命周期：添加了 ExecutorService 接口，其中包含了3种状态：运行，关闭和已终止。shutdown 方法将会执行平缓的关闭过程：不再接受新的任务，同时等待已经提交的任务执行完成。而 shutdownNow 方法则执行粗暴的关闭过程：它将尝试取消所有运行中的任务，同时不再启动队列中尚未开始的任务。
+ 延迟任务和周期管理：Timer 类负责管理延迟任务以及周期任务。Timer 在执行所有的定时任务的时候只会创建一个线程。如果某个任务的执行时间过长，那么将会破坏其他 TimerTask 的定时精确性。基于以上原因，建议使用 `ScheduledThreadPoolExecutor`。

找出可利用的并行性：

+ 携带结果的任务 Callable 和 Future：Runnable 是一种有很大局限的抽象，虽然 run 能写入到日志文件或者某个共享的数据结构，但是它不能返回一个值或者抛出一个异常。Callable 则是一种更好的抽象，他认为主入口点将返回一个值，并可能抛出一个异常。而 Future 则表示一个任务的生命周期，并且提供相应的方法来判断是否完成，以及获取任务的结果等。

  ```java
  public interface Callable<V> {
  	V call() throws Exception;
  }
  public interface Future<V> {
    boolean cancel(boolean mayInterruptIfRunning);
    boolean isCancelled();
    boolean isDone();
    V get() throws InterruptedException, ExecutionException, CancellationException;
    V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, CancellationException, TimeoutException;
  }
  ```

+ CompletionService：将 Executor 与 BlockingQueue 的功能结合在一起，通过将一组 Callable 任务提交给它来执行，然后使用 take 和 poll 等方法来获得已经完成的结果，这些结果会被封装成 Future。ExecutorCompletionService 实现了 CompletionService。

+ 为任务设置时限：可以通过 Future.get 来支持该需求。



## 第七章 取消与关闭

任务取消：

+ 中断：线程中断是一种协作机制，每个线程都有一个 boolean 类型的中断状态。当这个线程被被中断的时候，其状态设置为 true。对于中断操作的正确理解：它不会真正地中断一个正在运行的线程，而只是发出中断请求，然后由线程在下一个合适的时刻中断自己。

+ 中断策略：合理的中断策略应该是某种形式的线程级取消操作或者是服务级取消操作。如果需要恢复中断状态：

  ```java
  Thread.currentThread().interrupt();
  ```

+ 响应中断：当调用可中断的阻塞函数时，如  Thread.sleep，有两种策略用于处理 InterruptException。其一是传递异常，其二是恢复中断状态。

+ 通过 Future 实现取消：ExecutorService.submit 将返回一个 Future 来描述任务。Future 拥有一个 cancel 方法，该方法带有一个 boolean 类型的参数 mayInterruptIfRunning。

+ 采用 newTaskFor 来封装非标准的取消：newTaskFor 是一个工厂方法，它将创建 Future 代表任务，通过定制表示任务的 Future 可以改表 Future.cancel 的行为。

停止基于线程的服务：

+ 关闭 ExecutorService：使用 shutdown 或者 shutdownNow。
+ 毒丸对象：另外一种关闭生产者-消费者的方法就是使用毒丸对象：毒丸是指一个放在队列上的对象，当消费者得到这个对象的时候，立刻停止执行。
+ shutdownNow 的局限性：使用该方法的时候，它将会取消所有正在执行的任务，并且返回所有已经提交但尚未开始的任务。然而，我们并不知道那些任务已经开始但是尚未正常结束。

处理非正常的线程中止：导致线程提前死亡的原因主要就是 RuntimeException。如果没有捕获该异常，程序就会在控制台打印栈信息，然后退出执行。在 Thread 中提供了 UncaughtExceptionHandler，它能检测出某个线程由于未捕获的异常而终结的情况。

JVM 关闭：

+ 关闭钩子：在正常的关闭中，JVM 首先调用所有已注册过的关闭钩子（Shutdown Hook）。JVM 不保证关闭钩子的调用顺序。
+ 守护线程：守护线程不会阻碍 JVM 的关闭。应该尽量少使用守护线程。
+ 终结期：在回收器释放对象之前，会调用它们的 finalize 方法，从而保证一些持久化的资源被释放。最好不要使用 finalize 方法进行资源回收。



## 第八章 线程池的使用

在任务与执行策略之间的隐性耦合：

+ 线程饥饿死锁：如果两个线程相互依赖对方的执行结果，那么就会发生饥饿死锁。
+ 运行时间较长的任务：如果任务的执行时间较长，那么即使不出现死锁，线程池的响应性也会变得很糟糕。可以限定任务等待资源的事件，而不是无限制的等待。如果等待超时，那么需要中止任务或者将任务重新放回队列中。

设置线程池的大小：配置合适的线程池的大小既不会造成资源的浪费，也不会产生线程频繁切换的代价。

配置 ThreadPoolExecutor：可以使用它的通用构造函数来自定义：

```java
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler) { ... }
```

+ 线程的创建和销毁：线程池的基本大小，最大大小以及存活时间等因素共同负责线程的创建与销毁。
+ 管理任务队列：ThreadPoolExecutor 允许提供一个 BlockingQueue 来保存等待执行的任务。基本的任务排队方式有三种：无界队列，有界队列和同步移交。
+ 饱和策略：当有界队列被填满后，饱和策略开始发挥作用。如中止，抛弃，抛弃最旧的。调用者运行策略既不会抛弃任务，也不会抛出异常，而是将某些任务会退到调用者，从而降低新任务的流量。
+ 线程工厂：每当线程池需要创建一个线程的时候，都是通过线程工厂方法来完成的。通过实现 ThreadFactory 接口，可以进行定制化的工作。

扩展 ThreadPoolExecutor：可以在子类中改写 beforeExecute，afterExecute 和 terminated 方法来实现定制。



## 第十章 避免活跃性危险

死锁：

+ 锁顺序死锁：两个线程试图以不同的顺序获得相同的锁。通过固定顺序获得锁，可以消除该问题。
+ 动态的锁顺序死锁：考虑 `transfer(from, to, amount)`，如果存在`transfer(A, B, 10)` 和 `transfer(B, A, 10)` ，那么就可能发生死锁。
+ 开放调用：如果在调用某个方法的时候不需要持有锁，那么称其为开放调用。
+ 资源死锁：当多个线程相互持有彼此正在等待的锁而又不释放自己已经持有的锁的时候，就会发生死锁。

死锁的避免和检测：

+ 支持定时的锁：可以使用 Lock 类的定时 tryLock 功能来代替内置锁机制。当使用内置锁的时候，只要没有获得锁就会一直等待下去，而显式锁则可以指明一个超时时限。
+ 通过线程转储信息来分析死锁：线程转储信息中包含了加锁信息，例如每个线程持有了哪些锁，在那些栈帧中获得了这些锁，以及被阻塞的线程正在等待哪一个锁。

其他活跃性危险：

+ 饥饿：当线程无法访问它所需要的资源而不能继续执行的时候，就会发生饥饿。引发饥饿的最常见资源就是 CPU 时钟周期。
+ 糟糕的响应性：不良的锁管理也会导致糟糕的响应性。如果某个线程长时间占用锁（容器的迭代），其他想访问该容器的线程就必须等待很长时间。
+ 活锁：该问题尽管不会阻塞线程，但也不能继续执行，因为线程将不断重复执行相同的操作，而且总会失败。可以通过引入随机性来解决该问题。



## 第十一章 性能与可伸缩性

对性能的思考：

+ 性能与可伸缩性：性能可以通过服务时间，延迟时间，吞吐率，效率等指标衡量。可伸缩性指的是当增加计算资源时，程序的吞吐量或者处理能力相应增加。
+ Amdahl 定律

线程引入的开销：

+ 上下文切换
+ 内存同步：同步可能使用特殊指令，即内存栅栏，该指令可以刷新缓存，使得缓存无效，从而使得各个线程都能看到最新的值。内存栅栏会抑制一些编译器的优化操作。
+ 阻塞：当在锁上发生竞争的时候，竞争失败的线程就会阻塞。JVM 实现阻塞的行为有自旋等待，或者通过操作系统挂起。

减少锁的竞争：

+ 缩小锁的范围
+ 减少锁的粒度
+ 锁分段：如 ConcurrentHashMap
+ 一些替代独占锁的方法：使用并发容器，ReadWriteLock，不可变对象以及原子变量



## 第十二章 并发程序的测试

正确性测试：

+ 基本的单元测试
+ 对阻塞操作的测试
+ 安全性的测试
+ 资源管理的测试

性能测试：

+ 增加计时功能
+ 多种算法比较
+ 响应性衡量

避免性能测试的陷阱：

+ 垃圾回收：垃圾回收的执行时序是无法预测的
+ 动态编译
+ 对代码路径的不真实采样
+ 不真实的竞争程度
+ 无用代码消除

其他的测试方法：

+ 代码审查
+ 静态分析工具
+ 分析与检测工具



## 第十三章 显式锁

Lock 与 ReentrantLock：Lock 接口提供了一种无条件的，可轮询的，定时的以及可中断的锁获取操作。ReentrantLock 则实现了 Lock 接口。

```java
public interface Lock {
  void lock();
  void lockInterruptibly() throws InterruptedException;
  boolean tryLock();
  boolean tryLock(long timeout, TimeUnit unit) throws InterruptedException;
  void unlock();
  Condition newCondition();
}
```

+ 轮询锁与定时锁：由 tryLock 方法实现，同时具有完善的错误恢复机制，使用这两种锁可以避免死锁的发生。
+ 可中断的锁获取操作：lockInterruptibly 方法能够在获得锁的同时保持对中断的响应。
+ 非块结构的加锁：内置锁中，锁的获取和释放操作都是基于代码块的。而分段锁技术则不是块结构的锁。

性能考虑因素：在 Java5 中，当线程数增大的时候，内置锁的性能急剧下降，而 ReentrantLock 的性能下降更加平缓。在 Java6 中，两者的可伸缩性基本相同。

公平性：ReentrantLock 的构造函数中提供了两种公平性的选择：创建一个非公平的锁（默认）或者一个公平的锁。在公平的锁上，线程将按照他们发出请求的顺序来获得锁，但是在非公平的锁上，则允许插队。大多数的情况下，非公平锁的性能高于公平锁的性能。

在 synchronized 和 ReentrantLock 之间进行选择：ReentrantLock 在加锁和内存上提供的语义与内置锁相同，另外，它还实现了其他功能，如定时的锁等待，公平性以及非块结构的加锁。内置锁则更加简洁，同时能在线程转储中给出哪些栈帧获得了哪些锁。

读写锁：ReentrantLock 实现了一种标准的互斥锁，互斥通常是一种过硬的加锁规则，因此限制了并发性。可以使用读写锁来改善：

```java
public interface ReadWriteLock {
	Lock readLock();
	Lock writeLock();
}
```

在读写锁的加锁策略中，允许多个操作同时执行，但每次最多只允许一个写操作。ReentrantReadWriteLock 实现了上述接口，提供可重入的语义，同时构造的时候可以选择是否公平锁。



## 第十四章 构建自定义的同步工具

状态依赖性的管理：如 BlockingQueue 中的 put 和 take 操作的前提分别时队列不为空或者满的状态，当前提没有满足的时候，可以抛出异常，或者保持阻塞直到条件被满足。

+ 条件队列：使得一组线程（等待线程集合）能够通过某种方式来等待特定的条件变成真。Object 中的 wait，notify 和 notifyAll 方法就构成了内部条件队列的 API。Object.wait 会自动释放锁，并且请求操作系统挂起当前线程。当被挂起的线程醒来的时候，它将在返回之前重新获取锁。

使用条件队列：

+ 条件谓词：指的是操作正常执行的前提条件，如队列不为空
+ 过早唤醒：wait 方法的返回并不意味着线程正在等待的条件谓词已经变成真的了。因为可能被其他线程通过 notifyAll 唤醒，但是它的条件为此可能并未变为真的，此时就需要再次进行条件判断。
+ 丢失的信号：也是一种活跃性故障。指的是线程必须等待一个已经为真的条件，但在开始等待之前没有检查条件谓词。
+ 通知：在 put 方法成功执行后，将会调用 notifyAll，向任何等待“不为空”条件的线程发出通知。只使用 notify 可能会造成信号丢失的情况。

显式的 Condition 对象：正如 Lock 是一种广义的内置锁，Condition 也是一种广义的内置条件队列。

```java
public interface Condition {
  void await() throws InterruptedException;
  boolean await(long time, TimeUnit unit) throws InterruptedException;
  long awaitNanos(long nanosTimeout) throws InterruptedException;
  void awaitUninterruptibly();
  boolean awaitUntil(Date deadline) throws InterruptedException;
  void signal();
  void signalAll();
}
```

内置锁的缺陷在于每个内置锁都只能有一个相关联的条件队列。而 Condition 和 Lock 一起使用就可以消除该问题。和内置条件队列不同的是，对于每个 Lock，可以有任意数量的 Condition 对象。在 Condition 中相应的方法是 await，signal 和 signalAll。

Synchronizer 剖析：在 ReentrantLock 和 Semaphore 两个接口存在许多共同点，如都可以用作阀门，即每次只允许一定数量的线程通过；都支持可中断；都支持公平和非公平的队列操作。事实上，它们的实现都使用了一个共同的基类，AbstractQueuedSynchronizer（AQS）。AQS 是一个用于构建锁和同步器的框架，CountDownLatch，ReentrantReadWriteLock 和 FutureTask 都是基于 AQS 实现。

同步容器中的 AQS：

+ ReentrantLock：支持独占，实现了 tryAcquire，tryRelease 和 isHeldExclusively。将同步状态用于保存锁获取操作的次数，还维护一些 owner 的变量保存当前所有者线程的标识符。
+ Semaphore 和 CountDownLatch：前者将同步状态用于保存当前可用许可的数量，后者保存当前的计数值。
+ FutureTask：同步状态用来保存任务的状态。



## 第十五章 原子变量与非阻塞同步机制

锁的劣势：重量级的同步方式，使用 volatile 变量可以同步，但是不支持原子操作，另外，当一个线程正在等待锁的时候，不能做任何有用的事情。

原子变量类：

+ 原子变量是一种更好的 volatile：原子变量不但支持同步操作，还提供部分原子操作支持。
+ 锁与原子变量的性能比较：在高度竞争的情况下，锁的性能超过原子变量的性能；而在适度竞争情况下，原子变量的性能超过锁的性能。

非阻塞算法：如果在某个算法中，一个线程的失败挥着挂起不会造成其他线程的失败或挂起，俺么该算法就是非阻塞算法。

+ 非阻塞的栈
+ 非阻塞的链表
+ 原子的域更新器：compareAndSet 保证了操作的原子性



## 第十六章 Java 内存模型

内存模型：

+ 在共享内存的多处理器体系结构中，每个处理器有自己的缓存，并且定期的与主内存进行协调。在需要进行内存同步的时候，就可以执行内存栅栏指令，来保证数据的一致性。JVM 通过在合适的位置上插入内存栅栏来屏蔽 JMM 与底层平台内存模型的差异。

+ 重排序

+ Java 内存模型：如果两个操作之间缺乏 Happens-Before 关系，那么 JVM 就可以对他们进行任意重排序。

  > Happens-Before 的规则包括：
  >
  > + 程序顺序规则
  > + 监视器锁规则
  > + volatile 变量规则
  > + 线程启动规则
  > + 线程结束规则
  > + 中断规则
  > + 终结期规则
  > + 传递性





















