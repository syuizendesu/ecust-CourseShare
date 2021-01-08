#-*- coding: utf-8 -*-
#构建并测试CART决策树模型

import pandas as pd 
from random import shuffle 

datafile = '../data/model.xls' 
sdata = pd.read_excel(datafile)
sdata = sdata.values
shuffle(sdata)

p = 0.8 
train = data[:int(len(data)*p),:] 
test = data[int(len(data)*p):,:] 


#构建CART决策树模型
from sklearn.tree import DecisionTreeClassifier 

treefile = '../tmp/tree.pkl' 
tree = DecisionTreeClassifier() 
tree.fit(train[:,:3], train[:,3]) 

#保存模型
from sklearn.externals import joblib
joblib.dump(tree, treefile)

from cm_plot import * #导入自行编写的混淆矩阵可视化函数
cm_plot(train[:,3], tree.predict(train[:,:3])).show() #显示混淆矩阵可视化结果
#注意到Scikit-Learn使用predict方法直接给出预测结果。


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