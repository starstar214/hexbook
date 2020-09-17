#!/bin/bash
echo "添加修改至暂存区......"
git add -A
read -p "输入提交信息: " msg
echo "提交中......"
#如果不输入提交信息,自动填充 "Undocumented Change!"
if [ ! $msg ]; then
	git commit -m "Undocumented Change!(modify at $(date "+%Y-%m-%d %H:%M:%S"))"
else
	git commit -m "$msg(modify at $(date "+%Y-%m-%d %H:%M:%S"))"
fi
echo "推送修改至远程服务器......"
#默认推送至master分支
git push origin master
