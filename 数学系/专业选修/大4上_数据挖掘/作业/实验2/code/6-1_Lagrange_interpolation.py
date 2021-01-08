#-*- coding: utf-8 -*-
#拉格朗日插值代码
import pandas as pd 
from scipy.interpolate import lagrange 

inputfile = '../data/missing_data.xls' 
outputfile = '../tmp/missing_data_processed.xls' 

data = pd.read_excel(inputfile, header=None) 

#自定义列向量插值函数
#s为列向量，n为被插值的位置，k为取前后的数据个数，默认为5
def ployinterp_column(s, n, k=5):
  y = s[list(range(n-k, n)) + list(range(n+1, n+1+k))] 
  y = y[y.notnull()] 
  return lagrange(y.index, list(y))(n) 

for i in data.columns:
  for j in range(len(data)):
    if (data[i].isnull())[j]: 
      data[i][j] = ployinterp_column(data[i], j)

data.to_excel(outputfile, header=None, index=False) 