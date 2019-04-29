---
title: "Python执行Android adb 命令"
date: 2019-04-18T10:12:15+08:00
draft: false
categories: [Python]
tags: [Python,adb]
---


# 说明
本文以具体的python脚本为例进行说明，两个脚本都是根据开发过程中的业务需求而开发，并不具备通用性。但是其核心代码都是通过python的api执行adb命令：

``` shell
//example
cmd = 'adb shell' 
os.system(cmd)
```
# 1.`uninstall_clean_app.py`

根据app bundle id 卸载应用，并且删除该应用在sdcard目录下生成的文件夹等。当前脚本中所删除的目录是写死的，可以根据需要自己修改。

``` shell
#!/usr/bin/python
import subprocess
import os, sys
import getopt

BASE_DIR = os.path.dirname(os.path.dirname(__file__))


if __name__ == '__main__':

	""" change commands and add shell"""

	tag = ''

	try:
		opt, args = getopt.getopt(sys.argv[1:], "ht:", ['pkg', 'help'])
		for op, value in opt:
			if op in ("-t", "--pkg"):
				tag = value
			if op in ("-h", "--help"):
				print "Usage: main_app_clean.py -t APP_PKG_NAME"
				print "Options:"
				print "  -t  APP_PKG_NAME should be a bundle id !"
				print ""
				print "Sample : ./main_app_clean.py -t <bundle id>"
				print ""
				sys.exit()
	except getopt.GetoptError:  
            print "Error: Could not find the args."
            print "Usage: main_app_clean.py -t APP_PKG_NAME"
    	    print "Options:"
    	    print "  -t  APP_PKG_NAME should be a bundle id !"
    	    print ""
    	    print "Sample : ./main_app_clean.py -t <bundle id>"
    	    print ""
    	    sys.exit()

	
	if tag == '':
		print "you should input a bundle id  !"
		exit()
	pkg = tag

	print ''
	print '1) uninstalling ' + pkg +' ...'
	unInstallCmd = 'adb uninstall  ' + pkg 
	os.system(unInstallCmd)

	print ''
	print '2) cleaning the cached file...'
	cleanCmd1 = 'adb shell rm -fR /sdcard/.DataBackupTest'
	os.system(cleanCmd1)
	cleanCmd2 = 'adb shell rm -fR /sdcard/.DataBackup'
	os.system(cleanCmd2)
	print ''
	print '	All done !^_^!'
	print ''

	exit()

```

* 使用方法
	* 下载脚本到指定目录
	* 打开terminal，执行cd命令到脚本所在目录
	* 执行python命令 ` python ./uninstall_clean_app.py -t com.xxx.app`

	![01.png](https://upload-images.jianshu.io/upload_images/6174818-f6c015ef98358a93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

	
# 2.`obb_push.py`

该脚本作用是根据传入的obb文件完整路径，解析出app bundle id,然后将obb文件push到android设备上，减少出错机会和烦人的拷贝工作，执行该脚本可有快速完成。

``` shell
#!/usr/bin/python
import subprocess
import os, sys
import getopt

BASE_DIR = os.path.dirname(os.path.dirname(__file__))


if __name__ == '__main__':

	""" change commands and add shell"""

	tag = ''

	try:
		opt, args = getopt.getopt(sys.argv[1:], "ht:", ['tag', 'help'])
		for op, value in opt:
			if op in ("-t", "--tag"):
				tag = value
			if op in ("-h", "--help"):
				print "Usage: obb_push.py -t TAG_NAME"
				print "Options:"
				print "  -t  TAG_NAME.Choose what you want to use tag, should be a obb file path !"
				print ""
				print "Sample : ./obb_push.py -t <obb file path>"
				print ""
				sys.exit()
	except getopt.GetoptError:  
            print "Error: Could not find the args."
            print "Usage: obb_push.py -t TAG_NAME"
    	    print "Options:"
    	    print "  -t  TAG_NAME.Choose what you want to use tag, should be a obb file path !"
    	    print ""
    	    print "Sample : ./obb_push.py -t <obb file path>"
    	    print ""
    	    sys.exit()

	
	if tag == '':
		print "you should input a obb file\'s path !"
		exit()

	print '======to get package name=======>'
	obbFilePath = tag
	if obbFilePath == '':
		print 'you should input a obb file\'s path !'
		exit()
	obbSubDirs = obbFilePath.split('/')
	# index  = len(obbSubDirs) - 1
	obbFileName = obbSubDirs[-1]
	print '>>>obbFileName = ' + obbFileName
	if obbFileName == '' or obbFileName.find('.obb') == -1:
		print 'can not find a obb file in the path !'
		exit()
	
	tmpPackageName = obbFileName.split('.')
	print  tmpPackageName
	packageName = ''
	# for com in tmpPackageName[2:-2]:
	# 	print com
	# 	if com == tmpPackageName[-2]:
	# 	 	packageName += com
	# 	else:
	# 	 	packageName += com + "." 
	packageName = '.'.join(tmpPackageName[2:-1])
	print '>>>package name = ' + packageName


	print '=======adb shell mkdir ========>'
	obbDestPath = 'sdcard/Android/obb/' + packageName
	subDir = ''
	subDirs = obbDestPath.split('/')
	for dir in subDirs:
	 	subDir += '/' + dir
	 	# print subDir 
	 	os.system('adb shell mkdir ' + subDir)

	print '=======adb push obb file to device ========>'
	pushCmd = 'adb push ' + obbFilePath.replace(' ','\\ ')+ ' /' + obbDestPath + '/' 
	# print pushCmd
	os.system(pushCmd)

	exit()
```


* 使用方法同上，最后执行命令 `python ./obb_push.py -t <obb file path>`

![02.png](https://upload-images.jianshu.io/upload_images/6174818-ac29ee1f2a26a142.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


