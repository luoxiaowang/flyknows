#!/bin/sh  
echo "please enter order (publish:1  preview:2):"
read line
if [[ -z $line || $line == 1 ]]
then
	cd /Users/luoxiao/学习/flyknows
	pwd
	hexo clean
	echo "clean finish..."
	hexo g
	echo "generator finish..."
	hexo deploy
	echo "deploy finish..."
	echo "success"
elif [ $line == 2 ]
then
	cd /Users/luoxiao/学习/flyknows
	pwd
	hexo clean
	echo "clean finish..."
	hexo g
	echo "generator finish..."
	hexo s
else
	echo "输入错误！"
fi
