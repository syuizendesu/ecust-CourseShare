#-*- coding: utf-8 -*-
#拉格朗日插值代码
import pandas as pd
from scipy.interpolate import lagrange


inputfile = '../data/missing_data.xls'
outputfile = '../tmp/missing_data_processed.xls'

data = pd.read_excel(inputfile, header=None)
# print(data)
#自定义列向量插值函数
#s为列向量，n为被插值的位置，k为取前后的数据个数，默认为5
def ployinterp_column(s, n, k=5):
  y = s.reindex(list(range(n-k, n)) + list(range(n+1, n+1+k)))
  # print(y)
  y = y[y.notnull()]
  # print(y)
  return lagrange(y.index, list(y))(n)

for i in data.columns:
  for j in range(len(data)):
    if (data[i].isnull()[j]):
      data[i][j] = ployinterp_column(data[i], j)

data.to_excel(outputfile, header=None, index=False)

###########################################################################

from random import shuffle

datafile = '../data/model.xls'
sdata = pd.read_excel(datafile)
# print(data)
sdata = sdata.values
# sdata = sdata.values()
shuffle(sdata)

p = 0.8
train = sdata[:int(len(sdata)*p),:]
test = sdata[int(len(sdata)*p):,:]

##########################################################################

#构建CART决策树模型
from sklearn.tree import DecisionTreeClassifier

treefile = '../tmp/tree.pkl'
tree = DecisionTreeClassifier()
tree.fit(train[:,:3], train[:,3])

#保存模型
# from sklearn.externals import joblib
import pickle as pkl
with open(treefile,'wb') as pkl_path:
  pkl.dump(tree, pkl_path)

###################################################################

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
cm_plot(train[:,3], tree.predict(train[:,:3])).show() #显示混淆矩阵可视化结果
#注意到Scikit-Learn使用predict方法直接给出预测结果。

#############################################################

from sklearn.metrics import roc_curve
import matplotlib.pyplot as plt

fpr, tpr, thresholds = roc_curve(test[:,3], tree.predict_proba(test[:,:3])[:,1], pos_label=1)
plt.plot(fpr, tpr, linewidth=2, label = 'ROC of CART', color = 'green')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.ylim(0,1.05)
plt.xlim(0,1.05)
plt.legend(loc=4)
plt.show()

#############################################################






