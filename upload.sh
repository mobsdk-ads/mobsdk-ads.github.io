#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
COMMIT_MESSAGE="${*:-1. upload maven files}"
echo "Upload Bash Message >>>"
echo Commit Message : $COMMIT_MESSAGE

if [[ -n "$(git status --porcelain)" ]]; then
    echo "There are file changes (modified, added, or deleted)"
else
    echo "No file changes detected"
    exit 0
fi

echo "Upload script start to execute ..."

echo "Write commit message to file ..."
#记录日志文件，新内容放在前面
mkdir -p $SCRIPT_DIR/release/logs
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")
commit_message_file=$SCRIPT_DIR/release/logs/commit_message.log
touch $commit_message_file
{
  echo [$current_datetime]
  echo "$COMMIT_MESSAGE"
  cat $commit_message_file
} > tmp.txt && mv tmp.txt $commit_message_file

$SCRIPT_DIR/config/file_list.sh

WORKDIR=$(pwd)

echo "WORKDIR = $WORKDIR"

REMOTE_URL=$(git remote get-url origin)

echo "REMOTE_URL = $REMOTE_URL"

echo "WEB_PAGE = https://mobsdk-ads.github.io/"

BRANCH=$(git branch)

echo "BRANCH = $BRANCH"

git status --porcelain

git add .

git commit -m "$COMMIT_MESSAGE"

echo "push $BRANCH -> $REMOTE_URL"

git push -u origin HEAD

echo "Upload script execute over ..."
