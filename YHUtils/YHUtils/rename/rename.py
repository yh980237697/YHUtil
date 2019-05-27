# -*- coding: utf-8 -*- 

import os 

def rename_file(rootDir): 
    list_dirs = os.walk(rootDir) 
    for root, dirs, files in list_dirs: 

        # for d in dirs: 
        #     print os.path.join(root, d)  

        print root

        for name in files:
            try:

                # 文件名前缀替换
                wm = name.index(Replace_old, 0, 3)
                # print wm

                if wm == 0:

                    oriPath = os.getcwd()
                    os.chdir(root)
                    # print os.getcwd()

                    os.rename(name, Replace_new + name[len(Replace_old):])
                    print('rename done === ' + name)
                    os.chdir(oriPath)
                    # print os.getcwd()



            except:
                print('no need rename === ' + name)



# 判断是路径还是文件

def fileOrPath(root):
    if os.path.isdir(root):
        print "it's a directory"
    elif os.path.isfile(root):
        print "it's a normal file"
    else:
        print "it's a special file(socket,FIFO,device file)"



print '==============================================\n'
print '脚本作用:替换文件名称\n'
print '适用范围：此路径以及子路径下的所有文件名称\n'
print '替换方法：输入需要被替换的字符和替换字符，可以替换前缀，以及“+"后边的字符'

Replace_old = raw_input("请输入需要被替换的字符")
print u"你输入的字符是：" + Replace_old

Replace_new = raw_input("请输入新字符")
print u"你输入的字符是：" + Replace_new

rename_file(os.getcwd())
