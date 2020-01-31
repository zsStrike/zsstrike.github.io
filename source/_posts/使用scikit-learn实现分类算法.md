---
title: 使用scikit-learn实现分类算法
date: 2020-01-30 13:17:10
tags: ["机器学习"]
mathjax: true
---

在本节中，我们将会介绍常用分类算法的概念，以及如何使用 scikit-learn 机器学习库和选择机器学习算法时需要注意的问题。

<!-- More -->

## 分类算法的选择

机器学习算法涉及到的五个步骤可以描述如下：

1. 特征的选择
2. 确定性能评价标准
3. 选择分类器及其优化算法
4. 对模型性能的评估
5. 算法的调优

在本节中集中学习不同分类算法的概念，并再次回顾特征选择，预处理及性能评价指标等内容。

## 初涉 scikit-learn 的使用

首先，使用 scikit-learn 来实现一个感知器模型，这个模型和前面讲的感知器模型类似。仍旧使用鸢尾花数据集中的两个特征。

提取150朵鸢尾花的花瓣长度和宽度两个特征的值，并且由此构建矩阵$ X $，同时将对应的类标赋值给$ y $：

```python
from sklearn import datasets
import numpy as np

iris = datasets.load_iris()
X = iris.data[:, [2, 3]]
y = iris.target
```

为了评估训练得到的模型在位置数据上的表现，我们进一步将数据集划分为训练数据集和测试数据集：

```python
from sklearn.model_selection import train_test_split
# sklearn.cross_validation 已经废弃，改用sklearn.model_selection

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
```

由此，我们得到45个测试样本和105个训练样本。为了优化性能，还需要对数据进行特征缩放：

```python
from sklearn.preprocessing import StandardScaler

sc = StandardScaler()
sc.fit(X_train)
X_train_std = sc.transform(X_train)
X_test_std = sc.transform(X_test)
```

通过调用 `sc.fit`可以计算出`X_train`的每个特征的样本均值$ \mu $和标准差$ \sigma $。通过调用`transform`方法，可以使用已经计算出来的$ \mu $和$ \sigma $来对训练集数据做标准化处理。在特征缩放后，我们就可以训练感知器模型了：

```python
from sklearn.linear_model import Perceptron

ppn = Perceptron(max_iter=40, eta0=0.1, random_state=0)
ppn.fit(X_train_std, y_train)
```

训练好后，就可以进行预测了：

```python
y_pred = ppn.predict(X_test_std)
print('Misclassified samples: %d' % (y_test != y_pred).sum())
>> Misclassified samples: 5
```

最终可以看到有5个预测错误，从而准确率是$ 89\% $。同样地，scikit-learn还实现了许多不同 的性能矩阵，可以通过如下代码计算准确率：

```python
from sklearn.metrics import accuracy_score

print('Accuracy: %.2f' % accuracy_score(y_test, y_pred))
>> Accuracy: 0.89
```

最后，我们可以在第二章中实现的`plot_decision_regions`函数来绘制刚刚训练过的**决策区域**，并且观察不同分类的效果，代码如下：

```python
from matplotlib.colors import ListedColormap
import matplotlib.pyplot as plt

def plot_decision_regions(X, y, classifier, test_idx=None, resolution=0.02):
    # setup marker generator and color map
    markers = ('s', 'x', 'o', '^', 'v')
    colors = ('red', 'blue', 'lightgreen', 'gray', 'cyan')
    cmap = ListedColormap(colors[:len(np.unique(y))])
    
    # plot the decision surface
    x1_min, x1_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    x2_min, x2_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx1, xx2 = np.meshgrid(np.arange(x1_min, x1_max, resolution), np.arange(x2_min, x2_max, resolution))
    Z = classifier.predict(np.array([xx1.ravel(), xx2.ravel()]).T)
    Z = Z.reshape(xx1.shape)
    plt.contourf(xx1, xx2, Z, alpha=0.4, cmap=cmap)
    plt.xlim(xx1.min(), xx1.max())
    plt.ylim(xx2.min(), xx2.max())
    
    # plot all samples
    X_test, y_test = X[test_idx, :], y[test_idx]
    for idx, cl in enumerate(np.unique(y)):
        plt.scatter(x=X[y == cl, 0], y=X[y == cl, 1], alpha=0.8, c=cmap(idx), marker=markers[idx], label=cl)
    
    if test_idx:
        X_test, y_test = X[test_idx, :], y[test_idx]
        plt.scatter(X_test[:, 0], X_test[:, 1], c='orange', alpha=1, linewidth=1, marker='+', s=55, label='test set')
        
```

接下来，就可以回值决策区域图了：

```python
X_combined_std = np.vstack((X_train_std, X_test_std))
y_combined = np.hstack((y_train, y_test))
plot_decision_regions(X=X_combined_std, y=y_combined, classifier=ppn, test_idx=range(105, 150))
plt.xlabel('petal length')
plt.ylabel('petal width')
plt.legend(loc='upper left')
plt.show()
```

绘图如下：

![img](./Thu,%2030%20Jan%202020%20144855.png)

从图中我们发现无法通过一个线性的决策边界完美划分三类样本。对于无法完美线性可分的数据集，感知器算法将会永远无法收敛，这也是实践中一般不使用感知器算法的原因。

## 逻辑斯蒂回归中的类别概率

### 初识逻辑斯蒂回归模型

逻辑斯蒂回归模型和Adaline模型类似，不同的是在Adaline中，我们使用$ \phi(z)=z $作为激励函数，而在逻辑斯蒂回归中使用的是sigmoid函数作为激励模型：
$$
sigmoid(z) = \phi(z) = \frac{1}{1+e^{-z}}
$$
它的函数图像如下：

![img](./timg-1580368063667.jfif)

在给定特征$ x $和权重$ w $的情况下，sigmoid函数的输出值给出了特定样本$ x $属于类别1的概率$ \phi(z) = P(y=1|x;w) $。预测到的概率可以通过一个量化器进行二元输出：
$$
\hat{y}=\begin{cases}
1 & \phi(z) \ge 0.5\\
0 & others
\end{cases}
$$
对应的，逻辑斯蒂回归模型图如下：

![See the source image](./th-1580368751444.jfif)

### 逻辑斯蒂回归模型的代价函数

在构建逻辑斯蒂回归模型时，需要先定义一个最大似然函数，公式如下:
$$
L(w) = \prod_{i=1}^{n}P(y^i|x^i;w)=(\phi(z^i))^{y^i}(1-\phi(z))^{1-y^i}
$$
然后取对数并且改写一下，得到如下：
$$
J(w) = \sum_i^n-y^ilog(\phi(z^i)) - (1-y^i)log(1-\phi(z^i))
$$
我们可以对单个样本实例进行成本分析：
$$
J(\phi(z),y;w) = \begin{cases}
-log(\phi(z)) & y=1\\
-log(1-\phi(z)) & y=0
\end{cases}
$$
![1580370420597](./1580370420597.png)

可以看到，如果正确将样本划分到类别1和0中，代价都将会趋于0，但是如果错误分类，代价将会区域无穷，这也就意味着错误预测带来的代价将会越来越大。

### 使用scikit-learn训练逻辑斯蒂回归模型

接下来，我们使用逻辑斯蒂回归模型来训练鸢尾花数据集：

```python
from sklearn.linear_model import LogisticRegression

lr = LogisticRegression(C=1000.0, random_state=0)
lr.fit(X_train_std, y_train)
plot_decision_regions(X_combined_std, y_combined, classifier=lr, test_idx=range(105, 150))
plt.xlabel('length')
plt.ylabel('width')
plt.legend(loc='upper left')
plt.show()
```

得到的决策区域图如下：

![img](./Thu,%2030%20Jan%202020%20155618.png)

此外，可以通过`predict_proba`来预测样本属于某个类别的概率：

```python
lr.predict_proba(X_test_std[0:1, :])
>> array([[1.78177322e-11, 6.12453348e-02, 9.38754665e-01]])
```

此结果表示模型预测此样本属于类标1的概率是$ 6.1\% $，属于类标2的概率是$ 93.9\% $。

### 通过正则化解决过拟合问题

过拟合是机器学习中常见的问题，过拟合具有高方差，这可能是使用了较多的参数，使得模型过于复杂。同样地，模型也会面临着欠拟合问题，欠拟合具有高偏差，这意味着模型过于简单，使得我们在预测时性能不佳。

![img](./u=1743534219,2796932966&fm=173&app=49&f=JPEG.jfif)

偏差-方差权衡（bias-variance tradeoff）就是通过正则化来调整模型的复杂度。正则化时解决共线性（特征间高度相关）的一个很有用的方法，最常用的正则化形式是**L2正则化**，可以写作：
$$
\frac{\lambda}{2}||w||^2=\frac{\lambda}{2}\sum_{j=1}^m w_j^2
$$
其中，$ \lambda $是正则化系数。

> 特征缩放之所以很重要，其中一个原因是正则化。为了使得正则化起作用，需要确保所有特征的衡量标准保持统一。

使用正则化方法时，我们只需要在逻辑斯蒂回归的代价函数中加入正则化项，以降低系数带来的副作用：
$$
J(w) = \left(\sum_i^n-y^ilog(\phi(z^i)) - (1-y^i)log(1-\phi(z^i))\right)+\frac{\lambda}{2}||w||^2
$$
前面用到的scikit-learn中的LogisticRegression类，其中的参数`C`时正则化系数的倒数：
$$
C = \frac{1}{\lambda}
$$

## 使用支持向量机最大化分类间隔

另外一种性能强大且广泛应用的学习算法时支持向量机（SVM），它可以看作是对感知器的扩展。在SVM中，我们的目标是最大化分类间隔。在此处间隔指的是两个分离的决策边界间的距离，而最靠近决策边界的训练样本称作是支持向量：

![支持向量机（SVM）——原理篇](./v2-197913c461c1953c30b804b4a7eddfcc_1200x500-1580373915538.jpg)

### 对分类间隔最大化的直观认识

我们将平面分为正平面和负平面，对于正平面来说：
$$
w_0+w^TX_{pos}=1
$$
对于负平面：
$$
w_0+w^TX_{neg}=-1
$$
对以上两式，相减得
$$
w^T(X_{pos}-X_{neg})=2
$$
定义$ ||w|| =  \sqrt{\sum_{j=1}^{m}w_j^2} $，于是可得到如下等式：
$$
\frac{w^T(X_{pos}-X_{neg})}{||w||}=\frac{2}{||w||}
$$
上述等式的左侧可以解释为正负平面间的距离，也就是我们要最大化的距离。在样本正确分类的前提下，最大化分类间隔就是$ \frac{2}{||w||} $最大化，这也是SVM的目标函数，记作：
$$
w_0+w^Tx^i \ge 1, if\ y^i=1\\
w_0+w^Tx^i \lt -1, if\ y^i=-1
$$
这两个方程可以解释为：所有的负样本都落在负超平面一侧，所有的正样本都落在正超平面一侧划分的区域中。实践中，使用二次规划方法很容易求出$ \frac{||w||}{2} $的最小值。

### 使用松弛变量解决非线性可分问题

引入松弛变量$ \xi $的目的是：放松线性约束条件，以保证在适当的惩罚项样本下，对错误分类的情况进行优化时能够收敛。

取值为正的松弛变量可以简单的加到线性约束条件中：
$$
w^Tx^i \ge 1, if\ y^i=1 - \xi^i\\
w^Tx^i \lt -1, if\ y^i=-1 + \xi^i
$$
由此，新的优化目标为
$$
\frac{||w||}{2}+C(\sum_i\xi^i)
$$
通过变量C，我们可以控制对错误分类的惩罚程度，进而在偏差和方差之间取得平衡。

### 使用scikit-learn实现SVM

接下来，我们使用SVM模型来对鸢尾花数据集中的样本进行分类：

```python
from sklearn.svm import SVC

svm = SVC(kernel='linear', C=1.0, random_state=0)
svm.fit(X_train_std, y_train)
plot_decision_regions(X_combined_std, y_combined, classifier=svm, test_idx=range(105, 150))
plt.xlabel('length')
plt.ylabel('width')
plt.legend(loc='upper left')
plt.show()
```

得到图像如下：

![img](./Fri,%2031%20Jan%202020%20123057.png)

> 在实际的分类任务中，线性逻辑斯蒂回归和支持向量机往往得到相似的结果。但是逻辑斯蒂回归比SVM更容易处理离群点，而SVM更关注接近决策边界的点。

在有些数据集很大的时候，可以使用scikit-learn提供的SGDClassifier类供用户选择，这个流泪还提供了`partial-fit`方法支持在线学习。SGDClassifier类的概念类似于随机梯度算法。

我们可以使用以下方式分别构建基于随机梯度下降的感知器，逻辑斯蒂回归以及支持向量机模型。

```python
from sklearn.linear_model import SGDClassifier

ppn = SGDClassifier(loss='perceptron')
lr = SGDClassifier(loss='log')
svm = SGDClassifier(loss='hinge')
```

## 使用核SVM解决非线性问题

SVM受欢迎的一个原因是：通过“核技巧”可以很容易解决非线性可分问题。

首先来了解非线性可分问题到底是什么。