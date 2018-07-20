---
title: cls-hooked
date: 2018-07-13 15:02:00
tags:
---

想问下大家，在打日志的时候，把每个请求的traceId记录下来，大家有没有一个好的办法？根据我之前在nodejs的实践，在express的一个中间件中，用cls-hooked创建一个namespace，然后把每个请求的traceid记录下来。然后在logger的时候，从这个namespace里面读出来traceId即可。但是go这种我就不知道怎么做了。。。所以想请教一下大家。 



我看到公司有人在写vertx的程序的时候，采用的是在handler的时候从http header里面把traceId拿出来，然后一层层的透传到service  dao  等方法里 



go会有cls-hooked的这样的东西吗 



https://github.com/xizhibei/blog/issues/74