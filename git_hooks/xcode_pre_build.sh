#!/bin/bash


#pre build shell


#开发模式的pod库
devpods=`cat podfile | grep pod_one | awk -F "[\ \',\\/]" '{print $9}'`

# 壳工程git目录
project_dir=$( cd "$(dirname $(dirname "${BASH_SOURCE[0]}") )" && pwd )
echo $project_dir
cp -f "${project_dir}/format/.clang-format" ~

for element in ${devpods[@]}; do
	#组件
	dev_pod_path=`pwd`/${element}/.git/hooks

	if [[ -e $dev_pod_path ]]; then

		precommit="$dev_pod_path/pre-commit"
		commitmsg="$dev_pod_path/commit-msg"

		cp -f ${project_dir}/git_hooks/git_pre_commit.sh $precommit && chmod 777 $precommit
		cp -f ${project_dir}/git_hooks/commit_msg.sh $commitmsg && chmod 777 $commitmsg
		#获取"current_repo_path="所在行号
		#repo_line=`grep -n "current_repo_path=" $precommit | cut -d ":" -f 1`

		#替换第3行
		sed -i '' '3c\
		'current_repo_path=$(echo ${project_dir})'
		' $precommit
	else
		echo "$dev_pod_path does not exist"
	fi
done

