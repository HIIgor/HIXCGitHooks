# DSXCGitHooks

司机端代码Git hook 脚本 配合  DSClangFormat 使用

1. xcode_pre_build 

> 该脚本被关联到Xcode的build phases的pre build时机。
当Xcode运行起来时，会执行该脚本，该脚本会查询当前开发模式下的pod，并将该项目中 pre_commit.sh 和 commit_msg.sh 注入到各个开发模式的.git/hooks目录下

2. commit_msg.sh
> 该脚本用于检测git message 的规范性。
Feat、Mod、Fix、Docs、Style、Refactor、Perf、Test 为前缀 加冒号 空格 提交信息不能过短
例如：git commit -m "Fix: 修复了一个很严重的bug"

3. pre_commit.sh
> 在被注入到.git/hooks 动态修改静态风格检测脚本的所在位置