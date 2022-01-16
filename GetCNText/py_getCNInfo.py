#-*- coding:utf-8-*-
#处理中文字符的情况
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
 
import os
import re
import codecs
 
# 搜寻以下文件类型
suf_set = (".m", ".swift", ".xib", ".storyboard")
# 项目路径
project_path = os.path.split(os.path.realpath(__file__))[0]

def logYellow(str):
    print("\033[36m%s\033[0m"%(str))
def logRed(str):
    print("\033[31m%s\033[0m"%(str))
def logLightRed(str):
    print("\033[35m%s\033[0m"%(str))
def logCyanLink(str):
    print("\033[4;36m%s\033[0m"%(str))

# 忽略文件
ignoreFileNames = ["LanguageManager.swift","LaunchScreen.storyboard"]
# 比如批量处理过的类
repairFileNames = [""]
ignoreFileNames.extend(repairFileNames)

separatorStr = "--*--"
codeStr = {"",}
xibStr = {"",}
wholePathStr = {"",}
codeCNNum = 0
xibCNNum = 0
logYellow("🛫️🛫️🛫️🛫️🛫️遍历开始🛫️🛫️🛫️🛫️🛫️")
for (root, dirs, files) in os.walk(project_path):
    for file_name in files:
        if file_name.endswith(suf_set):
            if file_name in ignoreFileNames:
                continue
            with open(os.path.join(root, file_name), 'r+') as f:
                print("********%s********" % (file_name))
                lineList = f.readlines()
                f.close()
                isComment = False
                for str in lineList:
                    str = str.decode()
                    str = str.strip()
                    # log assert类型 忽略
                    if  str.startswith("//") or str.startswith("DYYLog") or str.startswith("NSLog") or str.startswith("print") or str.startswith("NSAssert") or str.startswith("assert"):
                        continue
                    if str.startswith("/*"):
                        isComment = True
                    if str.endswith("*/"):
                        isComment = False
                    if isComment:
                        continue
                    # 匹配包含中文
                    matchObjs = re.findall(u'"[^"]*[\u4E00-\u9FA5]+[^"\n]*?"', str, re.M|re.S)
                    if matchObjs and len(matchObjs) > 0:
                        for cnStr in matchObjs:
                            # 已本地化则忽略
                            locali1 = "JJLocalized(" + cnStr
                            locali2 = "JJLocalized(@" + cnStr
                            locali3 = cnStr + ".localizedString"
                            if locali1 in str or locali2 in str or locali3 in str:
                                continue
                            isXibFile = ".xib" in file_name or ".storyboard" in file_name
                            if isXibFile:
                                xibTip = file_name + separatorStr + cnStr + "\n"
                                if not xibTip in xibStr:
                                    xibCNNum = xibCNNum + 1
                                    logLightRed(xibTip.strip())
                                    xibStr.add(xibTip)
                            newData = file_name + separatorStr + cnStr + "\n"
                            wholePath = os.path.join(root, file_name) + separatorStr + cnStr + "\n"
                            # 去重
                            if not newData in codeStr:
                                codeStr.add(newData)
                                if not isXibFile:
                                    codeCNNum = codeCNNum + 1
                                    logRed(newData.strip())
                                    wholePathStr.add(wholePath)

logYellow("🛬️🛬️🛬️🛬️🛬️遍历结束🛬️🛬️🛬️🛬️🛬️")
logRed("代码中文(去重)：%d处, xib中文(去重)：%d处"%(codeCNNum,xibCNNum))

def writeFile(path, data):
    if os.path.exists(path):
        os.remove(path)
    logCyanLink(path)
    with codecs.open(path, 'a', encoding='utf-8') as f2:
        f2.writelines(data)
        f2.close()

file_path1 = project_path + "/py_cnStr.txt"
xibTipPath = project_path + "/py_xibCnStr.xlsx"
whole_path = project_path + "/py_cn_wholePath.txt"
list1 = list(codeStr)
list2 = list(xibStr)
list3 = list(wholePathStr)

writeFile(file_path1, list1)
writeFile(xibTipPath, list2)
writeFile(whole_path, list3)
