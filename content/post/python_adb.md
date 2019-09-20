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

	path = ''
	package = ''
	obbVersion = ''
# see: https://blog.csdn.net/chengxuyuanyonghu/article/details/54972854
	try:
		opt, args = getopt.getopt(sys.argv[1:], "hf:p:v:", ['file=', 'package=','obbVersion=','help'])
		for op, value in opt:
			if op in ("-f", "--file"):
				path = value
			if op in ("-p", "--package"):
				package = value
			if op in ("-v", "--obbVersion"):
				obbVersion = value
			if op in ("-h", "--help"):
				print "Usage: obb_push.py -f obb/file/full/path -p com.example.app.bundleid -v app_vesion"
				print "Options:"
				print "  <-f> <-p> <-v> should not be null !"
				print ""
				print "OR: <--file=> <--package=> <-obbVersion=> should not be null "
				print ""
				print "Sample : ./obb_push.py  -f obb/file/full/path.obb -p <com.example.app.bundleid> -v 15"
				print ""
				print "OR : ./obb_push.py --file=obb/file/full/path.obb --package=com.example.app.bundleid --obbVersion=15"
				print ""
				sys.exit()
		

	except getopt.GetoptError:  
           print "Usage: obb_push.py -f obb/file/full/path -p com.example.app.bundleid -v app_vesion"
           print "Options:"
           print "  <-f> <-p> <-v> should not be null !"
           print "OR:"
           print " <--file=> <--package=> <-obbVersion=> should not be null "
           print ""
           print "Sample : ./obb_push.py  -f obb/file/full/path.obb -p <com.example.app.bundleid> -v 15"
           print ""
           print "OR : ./obb_push.py --file=obb/file/full/path.obb --package=com.example.app.bundleid --obbVersion=15"
           print ""
           sys.exit()

	
	if path == '':
		print "you should input a obb file\'s path !"
		exit()

	print '\n'
	print '||--------------------------------------------------------------||'
	print '\n'
	print 'NOTICE:'
	print 'obb file name rule: [main.bundleVersionCode.bundleID.obb]'
	print '\n'
	print '||--------------------------------------------------------------||'
	print '\n'

	print 'Start to copy obb file >>>>>>>>> '
	print '  (1)===============> parsing obb file name:'
	obbFilePath = path
	if obbFilePath == '':
		print 'you should input a obb file\'s path !'
		exit()
	obbSubDirs = obbFilePath.split('/')
	# index  = len(obbSubDirs) - 1
	obbFileName = obbSubDirs[-1]
	print obbFileName
	if obbFileName == '' or obbFileName.find('.obb') == -1:
		print 'can not find a obb file in the path !'
		exit()
	
	# tmpPackageName = obbFileName.split('.')
	# print  '  (2)===================> parsing result: ' 
	# print tmpPackageName
	print '\n'


	# packageName = ''
	# for com in tmpPackageName[2:-2]:
	# 	print com
	# 	if com == tmpPackageName[-2]:
	# 	 	packageName += com
	# 	else:
	# 	 	packageName += com + "." 
	# packageName = '.'.join(tmpPackageName[2:-1])
	# print '    get package name = ' + packageName
	print '    get package name = ' + package

    #os.system('adb shell mount -o remount -o rw /system')
    

	print '\n'
	print '  (3)===============> adb shell mkdir :'
	obbDestPath = 'sdcard/Android/obb/' + package
	subDir = ''
	subDirs = obbDestPath.split('/')
	for dir in subDirs:
	 	subDir += '/' + dir
	 	# print subDir 
	 	os.system('adb shell mkdir ' + subDir)

	print '\n'
	print '  (4)===============> adb push obb file to device :'
	pushCmd = 'adb push ' + obbFilePath.replace(' ','\\ ')+ ' /' + obbDestPath + '/' 
	# print pushCmd
	os.system(pushCmd)

	print '\n'
	print '  (5)===============> adb push rename obb file:'
	newObbFileName = "main."+ obbVersion+"." + package + ".obb"
	oldFileFullPath = '/' + obbDestPath + '/' + obbFileName 
	newFileFullPath = '/' + obbDestPath + '/' + newObbFileName
	print '  old:' + oldFileFullPath
	reameCmd = 'adb shell mv ' + oldFileFullPath + " " + newFileFullPath
	os.system(reameCmd)
	print '  new:' + newFileFullPath
	print '\n'
	print '  (6)===============> Completed!!!'
	print '\n'
	exit()
```


* 使用方法，执行命令 :

```
 python </path/obb_push.py> -p <app package name > -f </path/of/obbfile> -v <app version code>
 
```



