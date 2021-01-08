# kobe_tuple = ([2, 'Jump shot'], 'Los Angeles Lakers', 'POR')
# kobe_tuple[0][0] = 3
# kobe_tuple[0][1] = 'Slam Dunk Shot'
# print(kobe_tuple)

# shot_id = [1,2,3]
# shot_zone_area = ['Right Side(R)', 'Left Side(L)', 'Left Side Center(LC)']
# kobe_dict = {}
# for key, value in zip(shot_id,shot_zone_area):
#     kobe_dict[key] = value
# print(kobe_dict)
# print('1',kobe_dict.keys())
# kobe_dict.pop(2)
# print(kobe_dict)
# kobe_dict.clear()
#
# a = [2,5,7,4,5,2,10,67,84]
# b = []
# for x in a:
#     b.append(x*2)
# print(b)

# l = [i**2 for i in range(3,6)]
# print(l)
#
# complete = [2,5,4,6,4,3,2,6,5,6]
# mean = sum(complete)/len(complete)
# delta = [i - mean for i in complete]
# print(delta)


# complete = ['2','5','7','3','5','2','5','8']
# d = {ch:i for i,ch in enumerate(complete)}  //生成的字典的value为这个key最后出现的位置的下标
# print(d)

#
# f = open('test.txt',mode='w')
# # print(f.read())
# f.write('this is written in\n')
# f.write('7')
# f.close()
#
# with open('test.txt') as fi:
#     content = fi.read()
#     print(content)

#
# path = '../test_csv.txt'
# f = open(path,mode='r')
# con = f.readlines()
# print(con[0])
# print(con[1])
# con_new = []
# for c in con:
#     temp = c.strip()
#     temp = temp.split('\t')
#     con_new.append(temp)
# print(con_new[0])
# print(con_new[1])
# f.close()
#
# f = open(path,mode='w')
#
# content = []
# for x in con_new:
#     content.append(x)
# # content.append(['1'])
# print(content)
# # f.close()
#
# for x in content:
#     x = '\t'.join(x)
#     x = x + '\n'
#     f.write(x)
# f.close()
import csv
path = 'white_wine.csv'
f = open(path,'r')
reader = csv.reader(f)
content = []
for row in reader:
    content.append(row)
f.close()
# for i in range(5):
#     print(content[i])

qualities = []
for row in content[1]:
    qualities.append(int(row[-1]))
unity_qualities = set(qualities)
print(unity_qualities)

content_dict = {}
for row in content[1:]:
    quality = int(row[-1])
    if quality not in content_dict.keys():
        content_dict[quality] = [row]

    else:
        content_dict[quality].append(row)
print(content_dict.keys())

mean_tuple = []
for key, value in content_dict.items():
    sum_ = 0
    for row in value:
        sum_ += float(row[0])
    mean_tuple.append((key, sum_/len(value)))
for x in mean_tuple:
    print(x)
# print(mean_tuple)























