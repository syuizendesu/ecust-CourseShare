#-*- coding: utf-8 -*-

import numpy as np
import pandas as pd
from random import shuffle
import tensorflow as tf

datafile = '../data/model.xls'
data = pd.read_excel(datafile)
data = data.values
shuffle(data)

p = 0.8 #设置训练数据比例
train = data[:int(len(data)*p),:]
test = data[int(len(data)*p):,:]

# print(train[:,3])
# print(train[:,:3])

#构建LM神经网络模型
from keras.models import Sequential #导入神经网络初始化函数
# from keras.layers.core import Dense, Activation #导入神经网络层函数、激活函数

netfile = '../tmp/net.model' #构建的神经网络模型存储路径

# net = Sequential() #建立神经网络
# net.add(Dense(input_dim = 3, output_dim = 10)) #添加输入层（3节点）到隐藏层（10节点）的连接
# net.add(Activation('relu')) #隐藏层使用relu激活函数
# net.add(Dense(input_dim = 10, output_dim = 1)) #添加隐藏层（10节点）到输出层（1节点）的连接
# net.add(Activation('sigmoid')) #输出层使用sigmoid激活函数
# net.compile(loss = 'binary_crossentropy', optimizer = 'adam', class_mode = "binary") #编译模型，使用adam方法求解

net = tf.keras.models.Sequential([
  tf.keras.layers.Dense(3, activation='sigmoid'),
  tf.keras.layers.Dense(10, activation='sigmoid'),
  tf.keras.layers.Dense(1, activation='sigmoid')
])

net.compile(loss='binary_crossentropy', optimizer='adam'
            # , class_mode='binary'
            )
net.fit(train[:,:3], train[:,3], epochs=50, batch_size=1) #训练模型，循环1000次
net.save_weights(netfile) #保存模型

# r = net.predict(train[:,:3]).reshape(len(train))
# # print(r)
# for i in range(len(train)):
#     if r[i] > 0.5:
#         r[i] = 1
#     else:
#         r[i] = 0
# print('predict_result=', r)
# predict_result = r
# res = net.evaluate(train[:,:3], test[:,3], verbose=1)
predict_result = (net.predict(train[:,:3]) > 0.5).astype("int").reshape(len(train))
print('predict_result=', predict_result)
# predict_result = net.predict_classes(train[:,:3]).reshape(len(train)) #预测结果变形
'''这里要提醒的是，keras用predict给出预测概率，predict_classes才是给出预测类别，而且两者的预测结果都是n x 1维数组，而不是通常的 1 x n'''

def cm_plot(y, yp):
  from sklearn.metrics import confusion_matrix  # 导入confusion矩阵函数

  cm = confusion_matrix(y, yp)  # 混淆矩阵

  import matplotlib.pyplot as plt  # 导入作图库
  plt.matshow(cm, cmap=plt.cm.Greens)  # 画混淆矩阵图，配色风格使用cm.Greens，更多风格请参考官网。
  plt.colorbar()  # 颜色标签

  for x in range(len(cm)):  # 数据标签
    for y in range(len(cm)):
      plt.annotate(cm[x, y], xy=(x, y), horizontalalignment='center', verticalalignment='center')

  plt.ylabel('True label')  # 坐标轴标签
  plt.xlabel('Predicted label')  # 坐标轴标签
  return plt

# from cm_plot import * #导入自行编写的混淆矩阵可视化函数
cm_plot(train[:,3], predict_result).show() #显示混淆矩阵可视化结果

from sklearn.metrics import roc_curve #导入ROC曲线函数
import matplotlib.pyplot as plt #导入作图库

predict_result = net.predict(test[:,:3]).reshape(len(test))
fpr, tpr, thresholds = roc_curve(test[:,3], predict_result, pos_label=1)
plt.plot(fpr, tpr, linewidth=2, label = 'ROC of LM') #作出ROC曲线
plt.xlabel('False Positive Rate') #坐标轴标签
plt.ylabel('True Positive Rate') #坐标轴标签
plt.ylim(0,1.05) #边界范围
plt.xlim(0,1.05) #边界范围
plt.legend(loc=4) #图例
plt.show() #显示作图结果
