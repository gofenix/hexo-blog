---
title: git常用操作
date: 2018-05-14 10:04:02
tags:
    - git
---

整理一下常用的git操作，不用再到处找了。

git放弃本地修改，强制更新

```
git fetch --all
git reset --hard origin/master
```



git修改远程仓库地址

```
git remote set-url origin url
```



git