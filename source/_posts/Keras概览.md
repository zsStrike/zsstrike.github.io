---
title: Keras概览
date: 2020-02-13 16:22:59
tags: ["机器学习", "TensorFlow"]
mathjax: true
---

本节介绍Keras及其相关模块，以帮助我们快速构建人工神经网络。

<!-- More -->

## 构建一个简单模型

### 层叠式模型

在Keras中，我们使用层（layers）来构建我们的模型，模型通常是一个由多个层构成的流程图，最简单模型类型是层叠式（Sequential）类型。为了构建一个简单全连接的MLP，我们用如下代码：

```python
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

model = tf.keras.Sequential()
# Adds a densely-connected layer with 64 units to the model:
model.add(layers.Dense(64, activation='relu'))
# Add another:
model.add(layers.Dense(64, activation='relu'))
# Add an output layer with 10 output units:
model.add(layers.Dense(10))
```

### 调整层参数

有很多内建的层，它们都有一些公用的构造参数：

+ activation：设置激活函数
+ kernel_initializer和bias_initializer：用于初始化权重的方法
+ kernel_regularizer和bias_regularizer：定义正则化的方法

下面的代码构造使用不同的参数构造层：

```python
# Create a relu layer:
layers.Dense(64, activation='relu')
# Or:
layers.Dense(64, activation=tf.nn.relu)

# A linear layer with L1 regularization of factor 0.01 applied to the kernel matrix:
layers.Dense(64, kernel_regularizer=tf.keras.regularizers.l1(0.01))

# A linear layer with L2 regularization of factor 0.01 applied to the bias vector:
layers.Dense(64, bias_regularizer=tf.keras.regularizers.l2(0.01))

# A linear layer with a kernel initialized to a random orthogonal matrix:
layers.Dense(64, kernel_initializer='orthogonal')

# A linear layer with a bias vector initialized to 2.0s:
layers.Dense(64, bias_initializer=tf.keras.initializers.Constant(2.0))
```

## 训练和评估

### 训练时的设置

当模型被构建后，我们可以通过调用compile方法来调整学习过程：

```python
model = tf.keras.Sequential([
# Adds a densely-connected layer with 64 units to the model:
layers.Dense(64, activation='relu', input_shape=(32,)),
# Add another:
layers.Dense(64, activation='relu'),
# Add an output layer with 10 output units:
layers.Dense(10)])

model.compile(optimizer=tf.keras.optimizers.Adam(0.01),
      loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
      metrics=['accuracy'])
```

compile有以下重要参数：

+ optimizer：定义优化算法
+ loss：定义误差函数
+ metrix：用于观察训练的情况

下面的示例展示了调整模型的情况：

```python
# Configure a model for mean-squared error regression.
model.compile(optimizer=tf.keras.optimizers.Adam(0.01),
              loss='mse',       # mean squared error
              metrics=['mae'])  # mean absolute error

# Configure a model for categorical classification.
model.compile(optimizer=tf.keras.optimizers.RMSprop(0.01),
              loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])
```

### 从NumPy数据训练

对于小型的数据集，我们可以用如下方法训练：

```python
import numpy as np

data = np.random.random((1000, 32))
labels = np.random.random((1000, 10))

model.fit(data, labels, epochs=10, batch_size=32)
```

`fit`方法有以下重要的参数：

+ epochs：训练的迭代次数
+ batch_size：每个批次的样本数量
+ validation_data：用于定义验证集

```python
import numpy as np

data = np.random.random((1000, 32))
labels = np.random.random((1000, 10))

val_data = np.random.random((100, 32))
val_labels = np.random.random((100, 10))

model.fit(data, labels, epochs=10, batch_size=32,
          validation_data=(val_data, val_labels))
```

### 从tf.data中的datasets训练

使用Datasets中的方法来构建训练数据集：

```python
# Instantiates a toy dataset instance:
dataset = tf.data.Dataset.from_tensor_slices((data, labels))
dataset = dataset.batch(32)

model.fit(dataset, epochs=10)
```

Dataset数据会不断yield小批次的数据，因此不需要batch_size参数。

同样，Dataset可以用于验证：

```python
dataset = tf.data.Dataset.from_tensor_slices((data, labels))
dataset = dataset.batch(32)

val_dataset = tf.data.Dataset.from_tensor_slices((val_data, val_labels))
val_dataset = val_dataset.batch(32)

model.fit(dataset, epochs=10,
          validation_data=val_dataset)
```

### 评估和预测

代码如下：

```python
# With Numpy arrays
data = np.random.random((1000, 32))
labels = np.random.random((1000, 10))

model.evaluate(data, labels, batch_size=32)

# With a Dataset
dataset = tf.data.Dataset.from_tensor_slices((data, labels))
dataset = dataset.batch(32)

model.evaluate(dataset)
```

同样，我们可以使用以下代码进行预测：

```python
result = model.predict(data, batch_size=32)
print(result.shape)
```

## 构建复杂模型

### 函数式API

层叠式模型是一种将多个层之间连接的简单模型，我们可以使用Keras中的函数式API来构建复杂的模型：

+ 多个输入模型
+ 多个输出模型
+ 包含共享层（同一个层被多次调用）的模型
+ 不包含顺序流的模型（如残差模型）

接下来我们使用函数式API来构建这样的一个模型：

1. 一个层实例是可以被调用的并且可以返回一个张量
2. 输入输出张量可以被用来定义模型实例
3. 该模型训练方法和层叠模型一致

下面的代码用于构建一个简单全连接的网络：

```python
inputs = tf.keras.Input(shape=(32,))  # Returns an input placeholder

# A layer instance is callable on a tensor, and returns a tensor.
x = layers.Dense(64, activation='relu')(inputs)
x = layers.Dense(64, activation='relu')(x)
predictions = layers.Dense(10)(x)
```

接下来实例化模型：

```python
model = tf.keras.Model(inputs=inputs, outputs=predictions)

# The compile step specifies the training configuration.
model.compile(optimizer=tf.keras.optimizers.RMSprop(0.001),
              loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

# Trains for 5 epochs
model.fit(data, labels, batch_size=32, epochs=5)
```

### 模型子类化

为了构建一个高度定制的模型，我们可以构造模型的子类。我们可以在`__init__`方法中定义层和层的属性，同时在`call`方法中定义前向传播。代码示例如下：

```python
class MyModel(tf.keras.Model):

  def __init__(self, num_classes=10):
    super(MyModel, self).__init__(name='my_model')
    self.num_classes = num_classes
    # Define your layers here.
    self.dense_1 = layers.Dense(32, activation='relu')
    self.dense_2 = layers.Dense(num_classes)

  def call(self, inputs):
    # Define your forward pass here,
    # using layers you previously defined (in `__init__`).
    x = self.dense_1(inputs)
    return self.dense_2(x)
```

接下来定义新的模型子类：

```python
model = MyModel(num_classes=10)

# The compile step specifies the training configuration.
model.compile(optimizer=tf.keras.optimizers.RMSprop(0.001),
              loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

# Trains for 5 epochs.
model.fit(data, labels, batch_size=32, epochs=5)
```

### 自定义层

自定义的层可以通过构建`tf.keras.layers.Layer`的子类来进行，需要实现如下方法：

+ `__init__`：可选，用于定义这一层中将要使用子层
+ `build`：创建层的权重，可以通过`add_weight`方法来添加权重
+ `call`：定义前向传播
+ 可选，可以通过实现get_config和from_config方法实现序列化和反序列化

下面代码实现了一个矩阵相乘的层：

```python
class MyLayer(layers.Layer):

  def __init__(self, output_dim, **kwargs):
    self.output_dim = output_dim
    super(MyLayer, self).__init__(**kwargs)

  def build(self, input_shape):
    # Create a trainable weight variable for this layer.
    self.kernel = self.add_weight(name='kernel',
                                  shape=(input_shape[1], self.output_dim),
                                  initializer='uniform',
                                  trainable=True)

  def call(self, inputs):
    return tf.matmul(inputs, self.kernel)

  def get_config(self):
    base_config = super(MyLayer, self).get_config()
    base_config['output_dim'] = self.output_dim
    return base_config

  @classmethod
  def from_config(cls, config):
    return cls(**config)
```

使用自定义层来构建模型：

```python
model = tf.keras.Sequential([
    MyLayer(10)])

# The compile step specifies the training configuration
model.compile(optimizer=tf.keras.optimizers.RMSprop(0.001),
              loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

# Trains for 5 epochs.
model.fit(data, labels, batch_size=32, epochs=5)
```

## Callbacks

callback对象用于传给模型以此在训练期间被使用，可以使用自定义的callback，同样可以使用内建的callback：

+ [`tf.keras.callbacks.ModelCheckpoint`](https://tensorflow.google.cn/api_docs/python/tf/keras/callbacks/ModelCheckpoint): 每次迭代保存检验点
+ [`tf.keras.callbacks.LearningRateScheduler`](https://tensorflow.google.cn/api_docs/python/tf/keras/callbacks/LearningRateScheduler): 动态改变学习速率
+ [`tf.keras.callbacks.EarlyStopping`](https://tensorflow.google.cn/api_docs/python/tf/keras/callbacks/EarlyStopping): 如果模型没有改经就停止训练
+ [`tf.keras.callbacks.TensorBoard`](https://tensorflow.google.cn/api_docs/python/tf/keras/callbacks/TensorBoard): 监视模型的行为

使用方法如下：

```python
callbacks = [
  # Interrupt training if `val_loss` stops improving for over 2 epochs
  tf.keras.callbacks.EarlyStopping(patience=2, monitor='val_loss'),
  # Write TensorBoard logs to `./logs` directory
  tf.keras.callbacks.TensorBoard(log_dir='./logs')
]
model.fit(data, labels, batch_size=32, epochs=5, callbacks=callbacks,
          validation_data=(val_data, val_labels))
```

## 保存和恢复

### 保存权重值

使用方法：

```python
# Save weights to a TensorFlow Checkpoint file
model.save_weights('./weights/my_model')

# Restore the model's state,
# this requires a model with the same architecture.
model.load_weights('./weights/my_model')
```

同样，可以将文件格式保存为HDF5类型：

```python
# Save weights to a HDF5 file
model.save_weights('my_model.h5', save_format='h5')

# Restore the model's state
model.load_weights('my_model.h5')
```

### 保存模型配置参数

一个模型的配置参数可以被保存（但是不保存权重），即使是在没有代码定义，一个模型的配置可以用于创建和初始化同样的模型。Keras支持JSON和YAML的两种序列化的格式：

```python
# Serialize a model to JSON format
json_string = model.to_json()	# save
fresh_model = tf.keras.models.model_from_json(json_string)	# restore

# Serialize a model to YAML format
yaml_string = model.to_yaml()
fresh_model = tf.keras.models.model_from_yaml(yaml_string)
```

### 保存整个模型到一个文件

整个模型的权重值，模型配置参数和优化配置参数可以被保存在一个文件中，这样可以让我们的模型在检查点处保存和恢复：

```python
# Create a simple model
model = tf.keras.Sequential([
  layers.Dense(10, activation='relu', input_shape=(32,)),
  layers.Dense(10)
])
model.compile(optimizer='rmsprop',
              loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])
model.fit(data, labels, batch_size=32, epochs=5)


# Save entire model to a HDF5 file
model.save('my_model')

# Recreate the exact same model, including weights and optimizer.
model = tf.keras.models.load_model('my_model')
```

## 分布式运行

### 在GPUs上运行

首先需要在分布策略范围内定义模型：

```python
strategy = tf.distribute.MirroredStrategy()

with strategy.scope():
  model = tf.keras.Sequential()
  model.add(layers.Dense(16, activation='relu', input_shape=(10,)))
  model.add(layers.Dense(1))

  optimizer = tf.keras.optimizers.SGD(0.2)

  model.compile(loss=tf.keras.losses.BinaryCrossentropy(from_logits=True),
                optimizer=optimizer)

model.summary()
```

接下来，按照平常的方式进行训练：

```python
x = np.random.random((1024, 10))
y = np.random.randint(2, size=(1024, 1))
x = tf.cast(x, tf.float32)
dataset = tf.data.Dataset.from_tensor_slices((x, y))
dataset = dataset.shuffle(buffer_size=1024).batch(32)

model.fit(dataset, epochs=1)
```

