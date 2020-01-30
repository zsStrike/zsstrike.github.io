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

从图中我们发现无法通过一个线性的决策边界完美划分三类样本。对于无法完美线性可分的数据集，感知器算法将会永远无法收敛，这也是事件中一般不使用感知器算法的原因。

## 逻辑斯蒂回归中的类别概率

