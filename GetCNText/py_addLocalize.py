#-*- coding:utf-8-*-
#处理中文字符的情况
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
 
import os
import codecs
 
project_path = os.path.split(os.path.realpath(__file__))[0]

def logYellow(str):
    print("\033[36m%s\033[0m"%(str))

def updateFile(file,old_str):
    logYellow(file)
    with open(file,"r") as f:
        file_data = f.read()
        f.close
    new_str = old_str + ".localizedString"
    # 替换
    new_file_data = file_data.replace(old_str,new_str)
    # 已处理场景需还原
    new_file_data = new_file_data.replace(new_str + ".localizedString",new_str)
    new_file_data = new_file_data.replace("JJLocalized(%s)"%(new_str),"JJLocalized(%s)"%(old_str))
    new_file_data = new_file_data.replace("JJLocalized(@%s)"%(new_str),"JJLocalized(@%s)"%(old_str))
    
    with open(file,"w") as f:
        f.write(new_file_data)
        f.close
    logYellow("已更新" + old_str)

separatorStr = "--*--"
with open(os.path.join(project_path, "py_cn_wholePath.txt"), 'r+') as f:
    lineList = f.readlines()
    f.close()
    for str in lineList:
        str = str.decode()
        str = str.strip()
        path_info = str.split(separatorStr)
        cnStr = path_info[1]
        updateFile(path_info[0],cnStr)


