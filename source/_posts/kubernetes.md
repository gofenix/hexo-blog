---
title: kubernetes
date: 2018-10-08 15:29:21
tags:
---

### docker

利用Linux的cgroups和namespace，构建一个沙箱运行环境。

### docker镜像

其实就是一个压缩包，这个压缩包是由一个完整的操作系统的所有文件目录构成，包含了这个应用运行所需要的所有依赖，所以本地开发环境和测试环境是一样的。

解决了应用打包的根本性问题。

### 容器编排

对 Docker 容器的一系列定义、配置和创建动作的管理

> 容器本身没有价值，有价值的是“容器编排”。

### 原理

容器技术的核心功能，就是通过约束和修改进程的动态表现，从而为其创造一个“边界”。

在创建一个容器进程的时候，指定了这个进程所需要启动的一组Namespace参数，这样容器就只能看到当前Namespace所限定的资源、文件、设备、状态或配置。

Cgroups主要作用是为一个进程组设置资源上限，如CPU、内存、磁盘和带宽等。也可以设置进程优先级，审计，挂起，重启等。

因此，一个正在运行的Docker容器，其实就是一个启用了多个Namespace的应用进程，而这个进程能够使用的资源是由Cgroups来限制。

挂载在容器根目录上，用来为容器进程提供隔离后执行环境的文件系统，就是容器镜像，rootfs。

- 启动Namespace配置
- 设置Cgroups参数
- 切换进程根目录rootf

docker镜像设计时，引入了层（layer），用户制作镜像的每一步操作都会生成一个层，也就是一个增量的rootfs。AuFS，所以就有了共享层，镜像不用那么大。

一个进程，可以选择加入到某个进程已有的 Namespace当中，从而达到进入这个进程所在的容器的目的，这正是docker exec的实现原理。

volume机制，允许你将宿主机上指定的目录或文件，挂载到容器里面进行读取和修改操作。

### 主要依赖Linux依赖三大技术：

- Namespace
- Cgroups
- rootfs

### 和虚拟机比较

虚拟机是通过硬件虚拟化功能，模拟一套操作系统所需要的各种硬件，如CPU、内存、IO设备等，然后安装一个新的操作系统。

docker是利用Linux的Namespace原理，帮助用户启动的还是系统的应用进程，只是加了一些参数，限制其能看到的资源。因此相对于虚拟机资源消耗更小，而且轻量级，敏捷高性能。

不过缺点就是隔离不彻底，多个容器进程公用宿主机操作系统内核。有些资源和对象不可以被Namespace化的，如时间。



kubernetes要解决的问题

编排？调度？容器云？集群管理？

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw117whrc6j31hc0u0gq5.jpg)

- master
  - kube-apiserver：API服务
  - kube-scheduler：调度
  - kube-controller-manager：编排
- node
  - kubelet：同容器运行时打交道。依赖于CRI（container runtime interface容器运行接口）远程调用接口，这个接口定义了容器运行时的各项核心操作。
  - 
- etcd





