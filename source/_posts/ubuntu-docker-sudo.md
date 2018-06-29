---
title: ubuntu-docker-sudo
date: 2018-06-29 13:54:25
tags:
---

```
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "/home/$USER/.docker" -R
```

