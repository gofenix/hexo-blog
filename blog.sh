#! /bin/sh

if [ -z "$1" ]; then
    currentTime=`date "+%Y-%m-%d-%H-%M-%S"`
    filename=${currentTime}
    echo ${filename}
else
    filename=$1
    echo ${filename}
fi


newBlog=`hexo new ${filename}`

codeOpen=`code source/_posts/${filename}.md`