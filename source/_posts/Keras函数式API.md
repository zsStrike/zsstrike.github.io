---
title: Keras函数式API
date: 2020-02-14 14:23:53
tags: ["机器学习", "TensorFlow"]
mathjax: true
---

本章了解Keras的函数式API以及灵活使用它们的方法。

<!-- More -->

## 简介

我们已经熟悉了如何使用`keras.Sequential`函数来创建我们的层叠模型，而函数式API是比它更加灵活的创建模型的方法：它可以允许我们创建非线性的模型，共用层的模型以及多个输入输出的模型。函数式API的基本思路是深度学习网络是一种有向无环图（DAG），我们可以使用函数式API来创建这些层。

如下一个包含了3个层的模型：

```
(input: 784-dimensional vectors)
       ↧
[Dense (64 units, relu activation)]
       ↧
[Dense (64 units, relu activation)]
       ↧
[Dense (10 units, softmax activation)]
       ↧
(output: logits of a probability distribution over 10 classes)
```

为了使用函数式API来创建相同的模型，我们首先创建输入节点：

```python
from tensorflow import keras

inputs = keras.Input(shape=(784,))
```

我们声明了输入的数据是一个784维的向量，注意这里的shape是单个样本的shape，不是批次的shape。对于图片，假设数据是（32，32，3）类型的，我们可以使用以下代码：

```python
# Just for demonstration purposes
img_inputs = keras.Input(shape=(32, 32, 3))
```

我们得到的返回值inputs包含了输入数据的shape和类型。为了创建层节点，我们使用如下方法：

```python
from tensorflow.keras import layers

dense = layers.Dense(64, activation='relu')
x = dense(inputs)
```

调用层函数的作用相当于在两个节点之间画一条有向线，我们得到了经过第一层处理后的返回值`x`，接着，我们创建完剩余的层：

```python
x = layers.Dense(64, activation='relu')(x)
outputs = layers.Dense(10)(x)
```

到了这一步，我们现在可以创建我们的模型了：

```python
model = keras.Model(inputs=inputs, outputs=outputs)
```

至此，我们的模型就创建成功了。

## 训练评估和预测

训练评估和预测的使用方法其实和在Sequential中创建模型一致。下面是使用我们刚刚创建的模型进行训练评估和预测的代码：

```python
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()
x_train = x_train.reshape(60000, 784).astype('float32') / 255
x_test = x_test.reshape(10000, 784).astype('float32') / 255

model.compile(loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              optimizer=keras.optimizers.RMSprop(),
              metrics=['accuracy'])
history = model.fit(x_train, y_train,
                    batch_size=64,
                    epochs=5,
                    validation_split=0.2)
test_scores = model.evaluate(x_test, y_test, verbose=2)
print('Test loss:', test_scores[0])
print('Test accuracy:', test_scores[1])
```

## 序列化

同样地，使用函数式APiece创建出来的模型序列化和反序列化和使用Sequential创建的模型一致。最常用的方法是使用`save`方法，它会保存：

+ 模型的架构
+ 模型权重值（在训练中得到）
+ 模型训练配置（在`compile`的时候得到）
+ 模型优化配置

```python
model.save('path_to_my_model')
del model
# Recreate the exact same model purely from the file:
model = keras.models.load_model('path_to_my_model')
```

## 使用相同的层来创建多个模型

在使用函数式API创建模型时，我们只需要声明模型的输入和输出即可，这也就意味着我们可以使用相同的层来创建多个模型，以下是一个实例：

```python
encoder_input = keras.Input(shape=(28, 28, 1), name='img')
x = layers.Conv2D(16, 3, activation='relu')(encoder_input)
x = layers.Conv2D(32, 3, activation='relu')(x)
x = layers.MaxPooling2D(3)(x)
x = layers.Conv2D(32, 3, activation='relu')(x)
x = layers.Conv2D(16, 3, activation='relu')(x)
encoder_output = layers.GlobalMaxPooling2D()(x)

encoder = keras.Model(encoder_input, encoder_output, name='encoder')
encoder.summary()

x = layers.Reshape((4, 4, 1))(encoder_output)
x = layers.Conv2DTranspose(16, 3, activation='relu')(x)
x = layers.Conv2DTranspose(32, 3, activation='relu')(x)
x = layers.UpSampling2D(3)(x)
x = layers.Conv2DTranspose(16, 3, activation='relu')(x)
decoder_output = layers.Conv2DTranspose(1, 3, activation='relu')(x)

autoencoder = keras.Model(encoder_input, decoder_output, name='autoencoder')
autoencoder.summary()
```

## 模型可调用

我们可以将模型看作是特殊的层，因为它接收Input或者其他层的输出作为参数。注意，我们调用模型的时候不仅仅只是使用了它的架构，还使用了它的权重：

```python
encoder_input = keras.Input(shape=(28, 28, 1), name='original_img')
x = layers.Conv2D(16, 3, activation='relu')(encoder_input)
x = layers.Conv2D(32, 3, activation='relu')(x)
x = layers.MaxPooling2D(3)(x)
x = layers.Conv2D(32, 3, activation='relu')(x)
x = layers.Conv2D(16, 3, activation='relu')(x)
encoder_output = layers.GlobalMaxPooling2D()(x)

encoder = keras.Model(encoder_input, encoder_output, name='encoder')
encoder.summary()

decoder_input = keras.Input(shape=(16,), name='encoded_img')
x = layers.Reshape((4, 4, 1))(decoder_input)
x = layers.Conv2DTranspose(16, 3, activation='relu')(x)
x = layers.Conv2DTranspose(32, 3, activation='relu')(x)
x = layers.UpSampling2D(3)(x)
x = layers.Conv2DTranspose(16, 3, activation='relu')(x)
decoder_output = layers.Conv2DTranspose(1, 3, activation='relu')(x)

decoder = keras.Model(decoder_input, decoder_output, name='decoder')
decoder.summary()

autoencoder_input = keras.Input(shape=(28, 28, 1), name='img')
encoded_img = encoder(autoencoder_input)
decoded_img = decoder(encoded_img)
autoencoder = keras.Model(autoencoder_input, decoded_img, name='autoencoder')
autoencoder.summary()
```

可以发现，模型可以包含子模型，一个常见的用途是用于模型的聚合：

```python
def get_model():
  inputs = keras.Input(shape=(128,))
  outputs = layers.Dense(1)(inputs)
  return keras.Model(inputs, outputs)

model1 = get_model()
model2 = get_model()
model3 = get_model()

inputs = keras.Input(shape=(128,))
y1 = model1(inputs)
y2 = model2(inputs)
y3 = model3(inputs)
outputs = layers.average([y1, y2, y3])
ensemble_model = keras.Model(inputs=inputs, outputs=outputs)
```

## 生成复杂模型

### 包含多个输入和输出的模型

我们可以使用函数式API生成包含多个输入输出的模型，这在Sequential中是不能被实现的。接下来我们创建一个将用户问题分类并且将其转交给哪个部门的模型，这个模型含有3个输入：

+ 问题的标题
+ 问题的内容
+ 用户添加的问题的标签（分类输入）

含有2个输出：

+ 优先级`[0, 1]`
+ 这个问题该交给哪个部门

下面是代码实现：

```python
num_tags = 12  # Number of unique issue tags
num_words = 10000  # Size of vocabulary obtained when preprocessing text data
num_departments = 4  # Number of departments for predictions

title_input = keras.Input(shape=(None,), name='title')  # Variable-length sequence of ints
body_input = keras.Input(shape=(None,), name='body')  # Variable-length sequence of ints
tags_input = keras.Input(shape=(num_tags,), name='tags')  # Binary vectors of size `num_tags`

# Embed each word in the title into a 64-dimensional vector
title_features = layers.Embedding(num_words, 64)(title_input)
# Embed each word in the text into a 64-dimensional vector
body_features = layers.Embedding(num_words, 64)(body_input)

# Reduce sequence of embedded words in the title into a single 128-dimensional vector
title_features = layers.LSTM(128)(title_features)
# Reduce sequence of embedded words in the body into a single 32-dimensional vector
body_features = layers.LSTM(32)(body_features)

# Merge all available features into a single large vector via concatenation
x = layers.concatenate([title_features, body_features, tags_input])

# Stick a logistic regression for priority prediction on top of the features
priority_pred = layers.Dense(1, name='priority')(x)
# Stick a department classifier on top of the features
department_pred = layers.Dense(num_departments, name='department')(x)

# Instantiate an end-to-end model predicting both priority and department
model = keras.Model(inputs=[title_input, body_input, tags_input],
                    outputs=[priority_pred, department_pred])
```

至此我们完成的模型的创建，接下里需要完成模型的编译：

```
model.compile(optimizer=keras.optimizers.RMSprop(1e-3),
              loss=[keras.losses.BinaryCrossentropy(from_logits=True),
                      keras.losses.CategoricalCrossentropy(from_logits=True)],
              loss_weights=[1., 0.2])
```

如上，我们可以为输出赋予不同的误差函数，以帮助我们控制他们两个输出对误差的贡献。由于我们已经为输出层赋予了名字，我们也可以使用如下方式编译：

```python
model.compile(optimizer=keras.optimizers.RMSprop(1e-3),
              loss={'priority':keras.losses.BinaryCrossentropy(from_logits=True),
                      'department': keras.losses.CategoricalCrossentropy(from_logits=True)},
              loss_weights=[1., 0.2])
```

接下来进行训练，对于在NumPy产生的数据：

```python
import numpy as np

# Dummy input data
title_data = np.random.randint(num_words, size=(1280, 10))
body_data = np.random.randint(num_words, size=(1280, 100))
tags_data = np.random.randint(2, size=(1280, num_tags)).astype('float32')
# Dummy target data
priority_targets = np.random.random(size=(1280, 1))
dept_targets = np.random.randint(2, size=(1280, num_departments))

model.fit({'title': title_data, 'body': body_data, 'tags': tags_data},
          {'priority': priority_targets, 'department': dept_targets},
          epochs=2,
          batch_size=32)
```

当我们使用`Dataset`对象时，它要么yield数组元组：`([title_data, body_data, tags_data], [priority_targets, dept_targets])`，要么yield字典元组：`({'title': title_data, 'body': body_data, 'tags': tags_data}, {'priority': priority_targets, 'department': dept_targets})`。

### 一个简单的残差网络模型

函数式API还可以创建非线性的模型，一个常见的应用是构建残差模型：

```python
inputs = keras.Input(shape=(32, 32, 3), name='img')
x = layers.Conv2D(32, 3, activation='relu')(inputs)
x = layers.Conv2D(64, 3, activation='relu')(x)
block_1_output = layers.MaxPooling2D(3)(x)

x = layers.Conv2D(64, 3, activation='relu', padding='same')(block_1_output)
x = layers.Conv2D(64, 3, activation='relu', padding='same')(x)
block_2_output = layers.add([x, block_1_output])

x = layers.Conv2D(64, 3, activation='relu', padding='same')(block_2_output)
x = layers.Conv2D(64, 3, activation='relu', padding='same')(x)
block_3_output = layers.add([x, block_2_output])

x = layers.Conv2D(64, 3, activation='relu')(block_3_output)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dense(256, activation='relu')(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(10)(x)

model = keras.Model(inputs, outputs, name='toy_resnet')
model.summary()
```

训练方法如下：

```python
(x_train, y_train), (x_test, y_test) = keras.datasets.cifar10.load_data()
x_train = x_train.astype('float32') / 255.
x_test = x_test.astype('float32') / 255.
y_train = keras.utils.to_categorical(y_train, 10)
y_test = keras.utils.to_categorical(y_test, 10)

model.compile(optimizer=keras.optimizers.RMSprop(1e-3),
              loss=keras.losses.CategoricalCrossentropy(from_logits=True),
              metrics=['acc'])
model.fit(x_train, y_train,
          batch_size=64,
          epochs=1,
          validation_split=0.2)
```

## 共享层

函数式API的另外一个优点是我们可以使用共享层。为了创建共享层，我们只需要创建层的实例，然后再不断调用即可：

```python
# Embedding for 1000 unique words mapped to 128-dimensional vectors
shared_embedding = layers.Embedding(1000, 128)

# Variable-length sequence of integers
text_input_a = keras.Input(shape=(None,), dtype='int32')

# Variable-length sequence of integers
text_input_b = keras.Input(shape=(None,), dtype='int32')

# We reuse the same layer to encode both inputs
encoded_input_a = shared_embedding(text_input_a)
encoded_input_b = shared_embedding(text_input_b)
```

## 提取和重用节点

由于我们使用函数式API创建的模型是静态的，所以它容易被存取和检查。这个过程和画图差不多。这也就意味着我们可以获取模型中节点并且重用他们。接下来我们看一下带有权重的VGG19模型：

```python
from tensorflow.keras.applications import VGG19

vgg19 = VGG19()
```

可以通过模型的结构获取到中间的层（节点）：

```python
features_list = [layer.output for layer in vgg19.layers]
```

我们可以通过这些节点来构建一个模型，用于获取通过每个层的中间值：

```python
feat_extraction_model = keras.Model(inputs=vgg19.input, outputs=features_list)

img = np.random.random((1, 224, 224, 3)).astype('float32')
extracted_features = feat_extraction_model(img)
```

## 自定义层来扩展API

`tf.keras`含有大量的内建层：

+ 卷积层：`Conv1D`, `Conv2D`, `Conv3D`, `Conv2DTranspose`
+ 池化层：`MaxPooling1D`, `MaxPooling2D`, `MaxPooling3D`, `AveragePooling1D`
+ RNN层：`GRU`, `LSTM`, `ConvLSTM2D`
+ `BatchNormalization`, `Dropout`, `Embedding`，etc.

如果这些都不能满足要求，我们可以创建Layer的子类，每个子类需要实现：

+ call：定义这一层完成的运算
+ build：创建这一层的权重

下面是Dense层的简单实现：

```python
class CustomDense(layers.Layer):

  def __init__(self, units=32):
    super(CustomDense, self).__init__()
    self.units = units

  def build(self, input_shape):
    self.w = self.add_weight(shape=(input_shape[-1], self.units),
                             initializer='random_normal',
                             trainable=True)
    self.b = self.add_weight(shape=(self.units,),
                             initializer='random_normal',
                             trainable=True)

  def call(self, inputs):
    return tf.matmul(inputs, self.w) + self.b

inputs = keras.Input((4,))
outputs = CustomDense(10)(inputs)

model = keras.Model(inputs, outputs)
```

如果想支持序列化，这时也需要实现get_config方法，该方法将会返回构造器的参数：

```python
class CustomDense(layers.Layer):

  def __init__(self, units=32):
    super(CustomDense, self).__init__()
    self.units = units

  def build(self, input_shape):
    self.w = self.add_weight(shape=(input_shape[-1], self.units),
                             initializer='random_normal',
                             trainable=True)
    self.b = self.add_weight(shape=(self.units,),
                             initializer='random_normal',
                             trainable=True)

  def call(self, inputs):
    return tf.matmul(inputs, self.w) + self.b

  def get_config(self):
    return {'units': self.units}


inputs = keras.Input((4,))
outputs = CustomDense(10)(inputs)

model = keras.Model(inputs, outputs)
config = model.get_config()

new_model = keras.Model.from_config(
    config, custom_objects={'CustomDense': CustomDense})
```

同样可以实现from_config方法来实现层的重构，默认的from_config方法如下：

```python
def from_config(cls, config):
  return cls(**config)
```

## 使用函数式API的时机

什么时候该使用函数式API构建模型，什么时候使用模型子类构建模型？总体来说，函数式API是一种更加易用安全，多特性的方法，而模型子类则提供了更高的灵活性。

函数式API的优点如下：

+ 简洁的：

  ```python
  # 函数式API
  inputs = keras.Input(shape=(32,))
  x = layers.Dense(64, activation='relu')(inputs)
  outputs = layers.Dense(10)(x)
  mlp = keras.Model(inputs, outputs)
  
  # 模型子类
  class MLP(keras.Model):
  
    def __init__(self, **kwargs):
      super(MLP, self).__init__(**kwargs)
      self.dense_1 = layers.Dense(64, activation='relu')
      self.dense_2 = layers.Dense(10)
  
    def call(self, inputs):
      x = self.dense_1(inputs)
      return self.dense_2(x)
  
  # Instantiate the model.
  mlp = MLP()
  # Necessary to create the model's state.
  # The model doesn't have a state until it's called at least once.
  _ = mlp(tf.zeros((1, 32)))
  ```

+ 在构建模型的时候提供检查：每一层可以根据输入数据的shape和dtype判断是否是合法的输入

+ 模型更易构建：构建模型就像是画图一样简单

+ 模型可以被序列化和克隆

函数式API缺点如下：

+ 不支持动态架构

## 混合模式构建模型

我们可以混合使用函数式API和模型子类方式来构建模型：

```python
units = 32
timesteps = 10
input_dim = 5

# Define a Functional model
inputs = keras.Input((None, units))
x = layers.GlobalAveragePooling1D()(inputs)
outputs = layers.Dense(1)(x)
model = keras.Model(inputs, outputs)


class CustomRNN(layers.Layer):

  def __init__(self):
    super(CustomRNN, self).__init__()
    self.units = units
    self.projection_1 = layers.Dense(units=units, activation='tanh')
    self.projection_2 = layers.Dense(units=units, activation='tanh')
    # Our previously-defined Functional model
    self.classifier = model

  def call(self, inputs):
    outputs = []
    state = tf.zeros(shape=(inputs.shape[0], self.units))
    for t in range(inputs.shape[1]):
      x = inputs[:, t, :]
      h = self.projection_1(x)
      y = h + self.projection_2(state)
      state = y
      outputs.append(y)
    features = tf.stack(outputs, axis=1)
    print(features.shape)
    return self.classifier(features)

rnn_model = CustomRNN()
_ = rnn_model(tf.zeros((1, timesteps, input_dim)))
```

下面是一个使用函数式模型构建RNN网络：

```python
units = 32
timesteps = 10
input_dim = 5
batch_size = 16


class CustomRNN(layers.Layer):

  def __init__(self):
    super(CustomRNN, self).__init__()
    self.units = units
    self.projection_1 = layers.Dense(units=units, activation='tanh')
    self.projection_2 = layers.Dense(units=units, activation='tanh')
    self.classifier = layers.Dense(1)

  def call(self, inputs):
    outputs = []
    state = tf.zeros(shape=(inputs.shape[0], self.units))
    for t in range(inputs.shape[1]):
      x = inputs[:, t, :]
      h = self.projection_1(x)
      y = h + self.projection_2(state)
      state = y
      outputs.append(y)
    features = tf.stack(outputs, axis=1)
    return self.classifier(features)

# Note that we specify a static batch size for the inputs with the `batch_shape`
# arg, because the inner computation of `CustomRNN` requires a static batch size
# (when we create the `state` zeros tensor).
inputs = keras.Input(batch_shape=(batch_size, timesteps, input_dim))
x = layers.Conv1D(32, 3)(inputs)
outputs = CustomRNN()(x)

model = keras.Model(inputs, outputs)

rnn_model = CustomRNN()
_ = rnn_model(tf.zeros((1, 10, 5)))
```

