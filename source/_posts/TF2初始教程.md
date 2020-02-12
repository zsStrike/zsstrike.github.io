---
title: TF2初始教程
date: 2020-02-12 14:38:17
tags: ["机器学习", "TensorFlow"]
mathjax: true
---

本节我们学习一些TensorFlow的基本使用方法，包括使用TensorFlow构建神经网络来对MNIST数据集进行划分以及学习一下数据的加载方法。

<!-- More -->

## 使用TensorFlow对MNIST数据集进行划分

首先，我们加载MNIST数据集，同时将数据映射到$ [0, 1] $上：

```python
import tensorflow as tf

mnist = tf.keras.datasets.mnist
(X_train, y_train), (X_test, y_test) = mnist.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0
```

接下来将各层堆叠起来，来搭建`tf.keras.Sequential`模型：

```python
model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=(28, 28)),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(10, activation='softmax')
])
```

接下来我们将已经搭建的模型进行编译：

```python
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', 
              metrics=['accuracy'])
```

接下来，训练并且验证模型：

```python
model.fit(X_train, y_train, epochs=5)
model.evaluate(X_test, y_test, verbose=2)
```

得到的结果如下：

```
Train on 60000 samples
Epoch 1/5
60000/60000 [==============================] - 5s 87us/sample - loss: 0.2942 - accuracy: 0.9140
Epoch 2/5
60000/60000 [==============================] - 5s 75us/sample - loss: 0.1416 - accuracy: 0.9582
Epoch 3/5
60000/60000 [==============================] - 4s 75us/sample - loss: 0.1056 - accuracy: 0.9681
Epoch 4/5
60000/60000 [==============================] - 4s 73us/sample - loss: 0.0888 - accuracy: 0.9724
Epoch 5/5
60000/60000 [==============================] - 4s 73us/sample - loss: 0.0752 - accuracy: 0.9761
10000/1 - 1s - loss: 0.0385 - accuracy: 0.9779
[0.07606992674819194, 0.9779]
```

现在，我们得到的照片分类器的准确率已经达到了98%。相较于之前我们实现的分类器，这个分类器的准确率更加优良。

## 对Fashion MNIST数据集划分

这一节我们会构建一个神经网络模型来区分关于衣物的图片，首先导入我们需要的库：

```python
import tensorflow as tf
from tensorflow import keras

import numpy as np
import matplotlib.pyplot as plt
print(tf.__version__)
>> 2.0.0
```

接下来导入Fashion MNIST数据集，这个数据集包含了共70000张10个类别的图片，每个图片用$ 28 \times 28 $的矩阵来表示。我们将60000张图片用作是训练，10000章图片用作是评估。代码如下：

```python
fashion_mnist = keras.datasets.fashion_mnist
(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()
```

该数据集的类标对应关系如下：

| Label | Class       |
| :---- | :---------- |
| 0     | T-shirt/top |
| 1     | Trouser     |
| 2     | Pullover    |
| 3     | Dress       |
| 4     | Coat        |
| 5     | Sandal      |
| 6     | Shirt       |
| 7     | Sneaker     |
| 8     | Bag         |
| 9     | Ankle boot  |

我们可以构建一个列表，来映射相应类标对应的类别：

```python
class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']
```

下面我们看一下训练集中的第一张图片：

```python
plt.figure()
plt.imshow(train_images[0])
plt.colorbar()
plt.grid(False)
plt.show()
```

得到的图像如下：

![img](./Wed,%2012%20Feb%202020%20150702.png)

接下来我们需要进行特征缩放：

```python
train_images = train_images / 255.0
test_images = test_images / 255.0
```

然后，看一下训练集中的前25张图片：

```python
# first 25 pic
plt.figure(figsize=(10, 10))
for i in range(25):
    plt.subplot(5, 5, i+1)
    plt.xticks([])
    plt.yticks([])
    plt.grid(False)
    plt.imshow(train_images[i], cmap=plt.cm.binary)
    plt.xlabel(class_names[train_labels[i]])
plt.show()
```

图像如下：

![img](./Wed,%2012%20Feb%202020%20150922.png)

至此，我们来构建并且编译模型：

```python
# build model
## set up layers
model = keras.Sequential([
    keras.layers.Flatten(input_shape=(28, 28)),
    keras.layers.Dense(128, activation='relu'),
    keras.layers.Dense(10)
])
## compile the model
model.compile(optimizer='adam', 
             loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
             metrics=['accuracy'])
```

然后，训练这个模型：

```python
model.fit(train_images, train_labels, epochs=10)
```

运行结果如下：

```

Train on 60000 samples
Epoch 1/10
60000/60000 [==============================] - 5s 76us/sample - loss: 0.5019 - accuracy: 0.8227
Epoch 2/10
60000/60000 [==============================] - 4s 67us/sample - loss: 0.3747 - accuracy: 0.8639
Epoch 3/10
60000/60000 [==============================] - 4s 68us/sample - loss: 0.3375 - accuracy: 0.8772
Epoch 4/10
60000/60000 [==============================] - 4s 68us/sample - loss: 0.3132 - accuracy: 0.8858
Epoch 5/10
60000/60000 [==============================] - 4s 72us/sample - loss: 0.2913 - accuracy: 0.8926
Epoch 6/10
60000/60000 [==============================] - 4s 73us/sample - loss: 0.2791 - accuracy: 0.8977
Epoch 7/10
60000/60000 [==============================] - 4s 74us/sample - loss: 0.2660 - accuracy: 0.9014
Epoch 8/10
60000/60000 [==============================] - 5s 82us/sample - loss: 0.2538 - accuracy: 0.9048
Epoch 9/10
60000/60000 [==============================] - 5s 78us/sample - loss: 0.2454 - accuracy: 0.9086
Epoch 10/10
60000/60000 [==============================] - 5s 90us/sample - loss: 0.2362 - accuracy: 0.9113
```

接下来，我们看一下模型在评估集上面的准确率：

```python
test_loss, test_acc = model.evaluate(test_images, test_labels, verbose=2)
print('Acc: %.2f' % test_acc)
>> Acc: 0.88
```

可以发现我们的模型在评估集上面的准确率比在训练集上面的准确率低，说明我们的模型过拟合了。

接下来，我们来进行预测：

```python
predictions = model.predict(test_images)
predictions[0]
>> array([-10.688818 , -11.685984 , -11.544111 , -15.445654 ,  -9.708677 ,
>>        -1.1382349, -10.859651 ,   2.193298 , -12.344756 ,   6.487081 ],
>>      dtype=float32)
```

可以发现一个预测的结果是一个包含10个数字的数组，数字代表着这张图片属于某个类标的可信度。同样可以使用`argmax`函数来得到最高可信度对应的类标：

```python
np.argmax(predictions[0])
>> 9
```

同样的，当我们需要对单独一个未知的数据进行预测的时候，需要将其转换为$ (n,28,28) $的shape：

```python
img = test_images[1]
img = np.expand_dims(img, 0)
print(img.shape)
>> (1, 28, 28)
```

接下里就可以进行预测了：

```python
predictions_single = model.predict(img)
print(predictions_single)
>> [[ -2.5079174  -16.936686     8.989066   -12.332449     2.5185988
>>    -2.7389777   -0.61303186 -22.695055   -13.934152   -30.008425  ]]
```

相应的类标如下：

```python
np.argmax(predictions_single[0])
>> 2
```

## 加载CSV数据

本节学习如何将CSV文件加载到`tf.data.Dataset`中，将要使用的是泰坦尼克号乘客的数据，模型会根据乘客的年龄，性别，票务舱和是否独立旅行等特征来预测乘客生还的可能性。

首先，导入必要的库：

```python
import functools
import numpy as np
import tensorflow as tf
import tensorflow_datasets as tfds
```

接下来，下载数据文件：

```python
TRAIN_DATA_URL = "https://storage.googleapis.com/tf-datasets/titanic/train.csv"
TEST_DATA_URL = "https://storage.googleapis.com/tf-datasets/titanic/eval.csv"

train_file_path = tf.keras.utils.get_file("train.csv", TRAIN_DATA_URL)
test_file_path = tf.keras.utils.get_file("eval.csv", TEST_DATA_URL)
```

同时设置一下numpy的输出设置，让他的输出精度是3位：

```python
np.set_printoptions(precision=3, suppress=True)
```

首先，来看一下CSV文件的前面几行：

```python
!head {train_file_path}
```

得到的输出如下：

```output
survived,sex,age,n_siblings_spouses,parch,fare,class,deck,embark_town,alone
0,male,22.0,1,0,7.25,Third,unknown,Southampton,n
1,female,38.0,1,0,71.2833,First,C,Cherbourg,n
1,female,26.0,0,0,7.925,Third,unknown,Southampton,y
1,female,35.0,1,0,53.1,First,C,Southampton,n
0,male,28.0,0,0,8.4583,Third,unknown,Queenstown,y
0,male,2.0,3,1,21.075,Third,unknown,Southampton,n
1,female,27.0,0,2,11.1333,Third,unknown,Southampton,n
1,female,14.0,1,0,30.0708,Second,unknown,Cherbourg,n
1,female,4.0,1,1,16.7,Third,G,Southampton,n
```

可以发现，CSV文件的每列都有一个列名。dataset构造函数会自动识别这些列名。如果某个CSV文件不包含列名，我们可以自己手动设置：

```python

CSV_COLUMNS = ['survived', 'sex', 'age', 'n_siblings_spouses', 'parch', 'fare', 'class', 'deck', 'embark_town', 'alone']

dataset = tf.data.experimental.make_csv_dataset(
     ...,
     column_names=CSV_COLUMNS,
     ...)
  
```

这个示例使用了所有的列，当然我们也可以只使用某些选中的列：

```python

dataset = tf.data.experimental.make_csv_dataset(
  ...,
  select_columns = columns_to_use, 
  ...)

```

对于包含模型需要预测的值的列是需要显式指定的：

```python
LABEL_COLUMN = 'survived'
LABELS = [0, 1]
```

现在从文件中读取CSV数据并创建dataset：

```python
def get_dataset(file_path):
  dataset = tf.data.experimental.make_csv_dataset(
      file_path,
      batch_size=12, # 为了示例更容易展示，手动设置较小的值
      label_name=LABEL_COLUMN,
      na_value="?",
      num_epochs=1,
      ignore_errors=True)
  return dataset

raw_train_data = get_dataset(train_file_path)
raw_test_data = get_dataset(test_file_path)
```

dataset中的每个条目都是一个批次，用一个元组表示（多个样本，多个标签）。样本中的数据组织形式是**以列为主**的张量，每个条目中包含的元素个数就是批次大小（本例中是12）。

我们首先获取第一个条目的数据：

```python
examples, labels = next(iter(raw_train_data)) # 第一个批次
print("EXAMPLES: \n", examples, "\n")
print("LABELS: \n", labels)
```

输出：

```
EXAMPLES: 
 OrderedDict([('sex', <tf.Tensor: id=170, shape=(12,), dtype=string, numpy=
array([b'male', b'male', b'female', b'female', b'female', b'male',
       b'male', b'male', b'male', b'male', b'male', b'male'], dtype=object)>), ('age', <tf.Tensor: id=162, shape=(12,), dtype=float32, numpy=
array([19., 17., 42., 22.,  9., 24., 28., 36., 37., 32., 28., 28.],
      dtype=float32)>), ('n_siblings_spouses', <tf.Tensor: id=168, shape=(12,), dtype=int32, numpy=array([0, 0, 1, 1, 4, 1, 0, 0, 2, 0, 1, 0], dtype=int32)>), ('parch', <tf.Tensor: id=169, shape=(12,), dtype=int32, numpy=array([0, 2, 0, 1, 2, 0, 0, 1, 0, 0, 0, 0], dtype=int32)>), ('fare', <tf.Tensor: id=167, shape=(12,), dtype=float32, numpy=
array([  6.75 , 110.883,  26.   ,  29.   ,  31.275,  16.1  ,  13.863,
       512.329,   7.925,   7.896,  19.967,  26.55 ], dtype=float32)>), ('class', <tf.Tensor: id=164, shape=(12,), dtype=string, numpy=
array([b'Third', b'First', b'Second', b'Second', b'Third', b'Third',
       b'Second', b'First', b'Third', b'Third', b'Third', b'First'],
      dtype=object)>), ('deck', <tf.Tensor: id=165, shape=(12,), dtype=string, numpy=
array([b'unknown', b'C', b'unknown', b'unknown', b'unknown', b'unknown',
       b'unknown', b'B', b'unknown', b'unknown', b'unknown', b'C'],
      dtype=object)>), ('embark_town', <tf.Tensor: id=166, shape=(12,), dtype=string, numpy=
array([b'Queenstown', b'Cherbourg', b'Southampton', b'Southampton',
       b'Southampton', b'Southampton', b'Cherbourg', b'Cherbourg',
       b'Southampton', b'Southampton', b'Southampton', b'Southampton'],
      dtype=object)>), ('alone', <tf.Tensor: id=163, shape=(12,), dtype=string, numpy=
array([b'y', b'n', b'n', b'n', b'n', b'n', b'y', b'n', b'n', b'y', b'n',
       b'y'], dtype=object)>)]) 

LABELS: 
 tf.Tensor([0 1 1 1 0 0 1 1 0 0 0 1], shape=(12,), dtype=int32)
```

接下来，我们进行数据的预处理。

CSV数据中有些列是分类的列，也就是这些列中的值只能在有限的集合中取值。使用`tf.feature_column`API创建一个`tf.feture_column.indicator_column`集合，集合中每个元素对应着一个分类的列。我们先将其转换：

```python
CATEGORIES = {
    'sex': ['male', 'female'],
    'class' : ['First', 'Second', 'Third'],
    'deck' : ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
    'embark_town' : ['Cherbourg', 'Southhampton', 'Queenstown'],
    'alone' : ['y', 'n']
}

categorical_columns = []
for feature, vocab in CATEGORIES.items():
    cat_col = tf.feature_column.categorical_column_with_vocabulary_list(
    	key=feature, vocabulary_list=vocab)
    categorical_columns.append(tf.feature_column.indicator_column(cat_col)
    
categorical_columns    
```

得到的输出如下：

```python
[IndicatorColumn(categorical_column=VocabularyListCategoricalColumn(key='sex', vocabulary_list=('male', 'female'), dtype=tf.string, default_value=-1, num_oov_buckets=0)),
 IndicatorColumn(categorical_column=VocabularyListCategoricalColumn(key='class', vocabulary_list=('First', 'Second', 'Third'), dtype=tf.string, default_value=-1, num_oov_buckets=0)),
 IndicatorColumn(categorical_column=VocabularyListCategoricalColumn(key='deck', vocabulary_list=('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'), dtype=tf.string, default_value=-1, num_oov_buckets=0)),
 IndicatorColumn(categorical_column=VocabularyListCategoricalColumn(key='embark_town', vocabulary_list=('Cherbourg', 'Southhampton', 'Queenstown'), dtype=tf.string, default_value=-1, num_oov_buckets=0)),
 IndicatorColumn(categorical_column=VocabularyListCategoricalColumn(key='alone', vocabulary_list=('y', 'n'), dtype=tf.string, default_value=-1, num_oov_buckets=0))]
```

这是后续构建模型时处理输入数据的一部分。

而对于连续数据，我们需要将其进行标准化，写一个函数标准化这些值，然后将这些值改造成2维德张量：

```python
def process_continuous_data(mean, data):
  # 标准化数据
  data = tf.cast(data, tf.float32) * 1/(2*mean)
  return tf.reshape(data, [-1, 1])
```

现在创建一个数值列的集合。`tf.feature_columns.numeric_column` API 会使用 `normalizer_fn` 参数。在传参的时候使用 [`functools.partial`](https://docs.python.org/3/library/functools.html#functools.partial)，`functools.partial` 由使用每个列的均值进行标准化的函数构成。

```python
MEANS = {
    'age' : 29.631308,
    'n_siblings_spouses' : 0.545455,
    'parch' : 0.379585,
    'fare' : 34.385399
}

numerical_columns = []

for feature in MEANS.keys():
    num_col = tf.feature_column.numeric_column(feature,
    	normalizer_fn=functools.partial(process_continuous_data, MEANS[feature]))
    numerical_columns.append(num_col)
```

接下来创建预处理层：

```python
preprocessing_layer = tf.keras.layers.DenseFeatures(categorical_columns+numerical_columns)
```

然后基于预处理层构建并编译模型：

```python
model = tf.keras.Sequential([
    preprocessing_layer,
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dense(1, activation='sigmoid'),
])

model.compile(
    loss='binary_crossentropy',
    optimizer='adam',
    metrics=['accuracy'])
```

接下来，我们就可以实例化和训练模型：

```python
train_data = raw_train_data.shuffle(500)
test_data = raw_test_data
model.fit(train_data, epochs=20)
```

训练完成后，我们可以在测试集上检查准确性：

```python
test_loss, test_accuracy = model.evaluate(test_data)
print('\n\nTest Loss {}, Test Accuracy {}'.format(test_loss, test_accuracy))
>> Test Loss 0.44521663270213385, Test Accuracy 0.814393937587738
```

可以发现，该模型的预测准确率是81%。

