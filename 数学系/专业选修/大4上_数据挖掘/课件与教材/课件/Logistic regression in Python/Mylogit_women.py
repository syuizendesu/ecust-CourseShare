import pandas as pd
import statsmodels.api as sm
import pylab as pl
import numpy as np
 
# 加载数据
df = pd.read_csv("women.csv")
 
# 浏览数据集
print(df.head())

# summarize the data
print(df.describe())

# 查看每一列的标准差
print(df.std())

# plot all of the columns
df.hist()
pl.show()

# 为逻辑回归创建所需的data frame
cols_to_keep = ['Y', 'A', 'S']
data = df[cols_to_keep]
print(data.head())

# 需要自行添加逻辑回归所需的intercept变量
data['intercept'] = 1.0

# 指定作为训练变量的列，不含目标列`admit`
train_cols = data.columns[1:]
# Index([gre, gpa, prestige_2, prestige_3, prestige_4], dtype=object)
 
logit = sm.Logit(data['Y'], data[train_cols])
 
# 拟合模型
result = logit.fit()

# 构建预测集
# 与训练集相似，一般也是通过 pd.read_csv() 读入
# 在这边为方便，我们将训练集拷贝一份作为预测集（不包括 Y 列）
import copy
combos = copy.deepcopy(data)
 
# 数据中的列要跟预测时用到的列一致
predict_cols = combos.columns[1:]
 
# 预测集也要添加intercept变量
combos['intercept'] = 1.0
 
# 进行预测，并将预测评分存入 predict 列中
combos['predict'] = result.predict(combos[predict_cols])
 
# 预测完成后，predict 的值是介于 [0, 1] 间的概率值
# 我们可以根据需要，提取预测结果
# 例如，假定 predict > 0.5，则表示会被录取
# 在这边我们检验一下上述选取结果的精确度
total = 0
hit = 0
for value in combos.values:
  # 预测分数 predict, 是数据中的最后一列
  predict = value[-1]
  # 实际录取结果
  Y = int(value[0])
 
  # 假定预测概率大于0.5则表示预测被录取
  if predict > 0.5:
    total += 1
    # 表示预测命中
    if Y == 1:
      hit += 1
 
# 输出结果
print('Total: %d, Hit: %d, Precision: %.2f' % (total, hit, 100.0*hit/total))

# 查看数据的要点
print(result.summary())

# 查看每个系数的置信区间
print(result.conf_int())
#                    0         1

# 输出 odds ratio
print(np.exp(result.params))

# odds ratios and 95% CI
params = result.params
conf = result.conf_int()
conf['OR'] = params
conf.columns = ['2.5%', '97.5%', 'OR']
print(np.exp(conf))
