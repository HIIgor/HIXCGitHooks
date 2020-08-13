#!/bin/sh

msg_color_green="\033[0;32m"
msg_color_magenta='\033[0;31m';
msg_color_yellow='\033[0;33m';
msg_color_none='\033[0m';

MIN_LENGTH=8;
MAX_LENGTH=100;

MESSAGE_TOO_SHORT="${msg_color_yellow}INVALID COMMIT MSG: commit message too short!${msg_color_none} \n"
MESSAGE_TOO_LONG="${msg_color_yellow}INVALID COMMIT MSG: commit message too long!${msg_color_none} \n"
INVALID_COMMIT_TIP="${msg_color_magenta}INVALID COMMIT MSG: does not match '<type>(<scope>): <subject>'!${msg_color_none} \n";


# Merge request message
MERGE_COMMIT_PATTERN='^Merge[[:space:]]+.*$';
# Revert request message
REVERT_COMMIT_PATTERN='^Revert[[:space:]]+.*$';
# Split request message, for git-subtree
SPLIT_COMMIT_PATTERN='^Split[[:space:]]+.*$';
# fixup! and squash! are part of Git, commits tagged with them are not intended to be merged, cf. https://git-scm.com/docs/git-commit
GIT_INTERNAL_PATTERN='^((fixup![[:space:]]|squash![[:space:]])?(\w+)(?:\(([^\)\s]+)\))?: (.+))(?:\n|$)';
# Custom commit message
CUSTOM_COMMIT_PATTERN='^(Feat|Mod|Fix|Docs|Style|Refactor|Perf|Test):[[:space:]]+.*$';


COMMIT_EDITMSG=$1; shift;

if [ -f "$COMMIT_EDITMSG" ]
then
  commitMessage=`head -n 1 $COMMIT_EDITMSG`;
else
  commitMessage="$COMMIT_EDITMSG"
fi

commitMessage=`echo "$commitMessage" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

[ ${#commitMessage} -le $MIN_LENGTH ] && echo -e "$MESSAGE_TOO_SHORT" && exit 1;
[ ${#commitMessage} -ge $MAX_LENGTH ] && echo -e "$MESSAGE_TOO_LONG" && exit 1;


echo "Checking commit message: ${msg_color_green}$commitMessage${msg_color_none} \n";

patterns=(
  $MERGE_COMMIT_PATTERN
  $REVERT_COMMIT_PATTERN
  $SPLIT_COMMIT_PATTERN
  $GIT_INTERNAL_PATTERN
  $CUSTOM_COMMIT_PATTERN
);

for pattern in ${patterns[*]}; do
  if [[ $commitMessage =~ $pattern ]];
  then
    exit 0;
  fi
done


echo "    ------------COMIT MSG TEMPLATE--------------"
echo "        Please input the commit-msg like this: "
echo "        {Type}:{Subject} --{Header} 必须"
echo "        {Body}           --{Body}   非必须"
echo "        {Footer}!        --{Footer} 非必须\n"
echo "     {Type} must be of the following type:"
echo "       --Feat:    (feature)        新增功能"
echo "       --Mod:     (modifiedCode)   修改功能"
echo "       --Fix:     (bugFix)         修复bug"
echo "       --Docs:    (documentation)  文档"
echo "       --Style:   (onlyStyle)      格式"
echo "       --Refactor:(refactor)       重构"
echo "       --Perf:    (appPerformance) 性能优化"
echo "       --Test:    (test)           增加测试"
echo "    ------------------END-----------------------"
exit 1

