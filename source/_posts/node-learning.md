---
title: node学习笔记
date: 2018-04-22 15:41:21
tags: 
    - node
    - JavaScript
---

写node也有一段时间了，整理一下。

首先看一下什么是node.js

- Node 是一个服务器端 JavaScript 
- Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行环境
- Node.js 使用了一个事件驱动、非阻塞式 I/O 的模型，使其轻量又高效
- Node.js 的包管理器 npm，是全球最大的开源库生态系统

模块系统是node最基本也是最常用的。一般可以分为四类：

- 原生模块
- 文件模块
- 第三方模块
- 自定义模块

node社区崇尚DRY文化，即Don't repeate yourself。这种文化使得node的生态异常繁荣，同样也由于某些包的质量低下引来了一些诟病。

谈谈自定义模块

我们在写node程序的时候，一般都是在写自定义模块。

- 创建模块

  ```javascript
  // b.js
  function FunA(){
      return "hello world";
  }

  // 暴露方法FunA
  module.exports = FunA;
  ```

- 加载模块

  ```javascript
  // a.js
  const FunA=require('./b.js');

  // 运行FunA
  const name=FunA();
  console.log(name);
  ```

在做模块到处的时候有两种方式：

- module.exports

  module.exports 就 Node.js 用于对外暴露，或者说对外开放指定访问权限的一个对象。

  一个模块中有且仅有一个 module.exports，如果有多个那后面的则会覆盖前面的。

- exports

  exports 是 module 对象的一个属性，同时它也是一个对象。在很多时候一个 js 文件有多个需要暴露的方法或是对象，module.exports 又只能暴露一个，那这个时候就要用到 exports:

  ```javascript
  function FunA(){
      return 'Tom';
  }

  function FunB(){
      return 'Sam';
  }

  exports.FunA = FunA;
  exports.FunB = FunB;
  ```

  ```javascript
  //FunA = exports,exports 是一个对象
  var FunA = require('./b.js');
  var name1 = FunA.FunA();// 运行 FunA，name = 'Tom'
  var name2 = FunA.FunB();// 运行 FunB，name = 'Sam'
  console.log(name1);
  console.log(name2);
  ```

  当然在引入的时候也可以这样写：

  ```javascript
  //FunA = exports,exports 是一个对象
  var {FunA, FunB} = require('./b.js');
  var name1 = FunA();// 运行 FunA，name = 'Tom'
  var name2 = FunB();// 运行 FunB，name = 'Sam'
  console.log(name1);
  console.log(name2);
  ```

常用的原生模块

常用的原生模块有如下四个：

- http
- url
- queryString
- fs

所有后端的语言要想运行起来，都得有服务器。node通过原生的http模块来搭建服务器：

1. 加载 http 模块
2. 调用 http.createServer() 方法创建服务，方法接受一个回调函数，回调函数中有两个参数，第一个是请求体，第二个是响应体。
3. 在回调函数中一定要使用 response.end() 方法，用于结束当前请求，不然当前请求会一直处在等待的状态。
4. 调用 listen 监听一个端口。

```javascript
//原生模块
var http = require('http');

http.createServer(function(reqeust, response){
    response.end('Hello Node');
}).listen(8080);
```

处理参数

- get

  当get请求的时候，服务器通过request.method来判断当前的请求方式并通过request.url来获取当前的请求参数：

  ```javascript
  var http = require('http');
  var url = require('url');
   
  http.createServer(function(req, res){
      var params = url.parse(req.url, true).query;
      res.end(params);
   
  }).listen(3000);
  ```

- post

  post请求则不能通过url来获取，这时候就得对请求体进行事件监听。

  ```javascript
  var http = require('http');
  var util = require('util');
  var querystring = require('querystring');
   
  http.createServer(function(req, res){
      // 定义了一个post变量，用于暂存请求体的信息
      var post = '';     
   
      // 通过req的data事件监听函数，每当接受到请求体的数据，就累加到post变量中
      req.on('data', function(chunk){    
          post += chunk;
      });
   
      // 在end事件触发后，通过querystring.parse将post解析为真正的POST请求格式，然后向客户端返回。
      req.on('end', function(){    
          post = querystring.parse(post);
          res.end(util.inspect(post));
      });
  }).listen(3000);
  ```

url

url和http是配合使用的。一般情况下url都是字符串类型的，包含的信息也比较多，比如有：协议、主机名、端口、路径、参数、锚点等。如果是对字符串进行直接解析的话，相当麻烦，node提供的url模块便可轻松解决这一类的问题。

字符串转对象

- 格式：url.parse(urlstring, boolean)
- 参数
  - urlstring：字符串格式的 url
  - boolean：在 url 中有参数，默认参数为字符串，如果此参数为 true，则会自动将参数转转对象
- 常用属性
  - href： 解析前的完整原始 URL，协议名和主机名已转为小写
  - protocol： 请求协议，小写
  - host： url 主机名，包括端口信息，小写
  - hostname: 主机名，小写
  - port: 主机的端口号
  - pathname: URL中路径，下面例子的 /one
  - search: 查询对象，即：queryString，包括之前的问号“?”
  - path: pathname 和 search的合集
  - query: 查询字符串中的参数部分（问号后面部分字符串），或者使用 querystring.parse() 解析后返回的对象
  - hash: 锚点部分（即：“#”及其后的部分）

对象转字符串

- 格式：url.format(urlObj)
- 参数 urlObj 在格式化的时候会做如下处理
  - href: 会被忽略，不做处理
  - protocol：无论末尾是否有冒号都会处理，协议包括 http, https, ftp, gopher, file 后缀是 :// (冒号-斜杠-斜杠)
  - hostname：如果 host 属性没被定义，则会使用此属性
  - port：如果 host 属性没被定义，则会使用此属性
  - host：优先使用，将会替代 hostname 和port
  - pathname：将会同样处理无论结尾是否有/ (斜杠)
  - search：将会替代 query属性，无论前面是否有 ? (问号)，都会同样的处理
  - query：(object类型; 详细请看 querystring) 如果没有 search,将会使用此属性.
  - hash：无论前面是否有# (井号, 锚点)，都会同样处理

拼接

当有多个 url 需要拼接处理的时候，可以用到 url.resolve

```javascript
var url = require('url');
url.resolve('http://dk-lan.com/', '/one')// 'http://dk-lan.com/one'
```

url是对url字符串的处理，而querystring就是仅针对参数的处理。

字符串转对象

```javascript
var str = 'firstname=dk&url=http%3A%2F%2Fdk-lan.com&lastname=tom&passowrd=123456';
var param = querystring.parse(param);
//结果
//{firstname:"dk", url:"http://dk-lan.com", lastname: 'tom', passowrd: 123456};
```

对象转字符串

```javascript
var querystring = require('querystring');

var obj = {firstname:"dk", url:"http://dk-lan.com", lastname: 'tom', passowrd: 123456};
//将对象转换成字符串
var param = querystring.stringify(obj);
//结果
//firstname=dk&url=http%3A%2F%2Fdk-lan.com&lastname=tom&passowrd=123456
```

任何服务端语言都不能缺失文件的读写操作。

读取文本 -- 异步读取

```
var fs = require('fs');
// 异步读取
// 参数1：文件路径，
// 参数2：读取文件后的回调
fs.readFile('demoFile.txt', function (err, data) {
   if (err) {
       return console.error(err);
   }
   console.log("异步读取: " + data.toString());
});
```

读取文本 -- 同步读取

```
var fs = require('fs');
var data = fs.readFileSync('demoFile.txt');
console.log("同步读取: " + data.toString());
```

写入文本 -- 覆盖写入

```
var fs = require('fs');
//每次写入文本都会覆盖之前的文本内容
fs.writeFile('input.txt', '抵制一切不利于中国和世界和平的动机！',  function(err) {
   if (err) {
       return console.error(err);
   }
   console.log("数据写入成功！");
   console.log("--------我是分割线-------------")
   console.log("读取写入的数据！");
   fs.readFile('input.txt', function (err, data) {
      if (err) {
         return console.error(err);
      }
      console.log("异步读取文件数据: " + data.toString());
   });
});
```

写入文本 -- 追加写入

```
var fs = require('fs');
fs.appendFile('input.txt', '愿世界和平！', function (err) {
   if (err) {
       return console.error(err);
   }
   console.log("数据写入成功！");
   console.log("--------我是分割线-------------")
   console.log("读取写入的数据！");
   fs.readFile('input.txt', function (err, data) {
      if (err) {
         return console.error(err);
      }
      console.log("异步读取文件数据: " + data.toString());
   });
});
```

图片读取

图片读取不同于文本，因为文本读出来可以直接用 console.log() 打印，但图片则需要在浏览器中显示，所以需要先搭建 web 服务，然后把以字节方式读取的图片在浏览器中渲染。

1. 图片读取是以字节的方式
2. 图片在浏览器的渲染因为没有 img 标签，所以需要设置响应头为 image

```
var http = require('http');
var fs = require('fs');
var content =  fs.readFileSync('001.jpg', "binary");

http.createServer(function(request, response){
    response.writeHead(200, {'Content-Type': 'image/jpeg'});
    response.write(content, "binary");
    response.end();
}).listen(8888);

console.log('Server running at http://127.0.0.1:8888/');
```

stream流处理

对http 服务器发起请求的request 对象就是一个 Stream，还有stdout（标准输出）。往往用于打开大型的文本文件，创建一个读取操作的数据流。所谓大型文本文件，指的是文本文件的体积很大，读取操作的缓存装不下，只能分成几次发送，每次发送会触发一个data事件，发送结束会触发end事件。

主要分为

- 读取流
- 写入流
- 管道流
- 链式流

这几种流都是fs的一部分。

路由

在BS架构中，路由的概念都是一样的，可以理解为根据客户端请求的url映射到不同的方法实现。一般web框架中都会有相应的路由模块。但是在原生node中去处理的话只能是解析url来进行映射，实现起来不够简洁。

fetch

axios是一种对ajax的封装，fetch是一种浏览器原生实现的请求方式，跟ajax对等。

在现在发起http请求里，都是通过fetch来发送请求，和ajax类似。

```javascript
const fetch=require('isomorphic-fetch');

const options={
    header:{},
    body:JSON.strify({}),
    method: ''
}

try{
    const res=await fetch('url', options);
}catch(err){
    
}
```

使用node，都绕不开express。

express的使用比较简单，由于我最早接触的是spring那套web框架，所以在使用到express的时候觉得node的web特别轻量简单。

加载模块

```javascript
const express=require('express');
const app=express();
```

监听端口8080

```javascript
app.listen(3000, ()=>consloe.log('running'));
```

express对路由的处理特别简单，配合中间件body parser，很方便的提供rest接口：

```javascript
app.get('/', (req, res)=>{
    res.send('hello world');
})
```

`response.send()` 可理解为 `response.end()`，其中一个不同点在于 `response.send()` 参数可为对象。

Node.js 默认是不能访问静态资源文件（*.html、*.js、*.css、*.jpg 等），如果要访问服务端的静态资源文件则要用到方法 `sendFile`

__dirname 为 Node.js 的系统变量，指向文件的绝对路径。

```javascript
app.get('/index.html', function (req, res) {
   res.sendFile( __dirname + "/" + "index.html" );
});
```

Express -- GET 参数接收之路径方式

访问地址：`http://localhost:8080/getusers/admin/18`，可通过 `request.params` 来获取参数

```javascript
app.get('/getUsers/:username/:age', function(request, response){
    var params = {
        username: request.params.username,
        age: request.params.age
    }
    response.send(params);
})
```

Express -- POST

- post 参数接收，可依赖第三方模块 body-parser 进行转换会更方便、更简单，该模块用于处理 JSON, Raw, Text 和 URL 编码的数据。
- 安装 body-parser `npm install body-parser`
- 参数接受和 GET 基本一样，不同的在于 GET 是 `request.query` 而 POST 的是 `request.body`

```javascript
var bodyParser = require('body-parser');
// 创建 application/x-www-form-urlencoded 编码解析
var urlencodedParser = bodyParser.urlencoded({ extended: false })
app.post('/getUsers', urlencodedParser, function (request, response) {
    var params = {
        username: request.body.username,
        age: request.body.age
    }
   response.send(params);
});
```

Express -- 跨域支持(放在最前面)

```javascript
app.all('*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Content-Type,Content-Length, Authorization, Accept,X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By",' 3.2.1')
    if(req.method=="OPTIONS") {
      res.send(200);/*让options请求快速返回*/
    } else{
      next();
    }
});
```

Async

Node.js 是一个异步机制的服务端语言，在大量异步的场景下需要按顺序执行，那正常做法就是回调嵌套回调，回调嵌套太多的问题被称之回调地狱。

Node.js 为解决这一问题推出了异步控制流 ———— Async

Async/Await

Async/Await 就 ES7 的方案，结合 ES6 的 Promise 对象，使用前请确定 Node.js 的版本是 7.6 以上。

Async/await的主要益处是可以避免回调地狱（callback hell），且以最接近同步代码的方式编写异步代码。

基本规则

- async 表示这是一个async函数，await只能用在这个函数里面。
- await 表示在这里等待promise返回结果了，再继续执行。
- await 后面跟着的应该是一个promise对象

express的中间件编写——过滤器

简单使用

```javascript
const express = require('express')
const app = express();

let filter = (req, res, next) => {
    if(req.params.name == 'admin' && req.params.pwd == 'admin'){
        next()
    } else {
        next('用户名密码不正确')
    }
    
}

app.get('/:name/:pwd', filter, (req, res) => {
    res.send('ok')
}).listen(88)
```

这里写了一个filter方法，有一个next参数。在路由的时候，把filter作为一个参数，则就可以先执行filter函数，然后执行路由的逻辑。

如果想要全局使用的话，就直接使用use方法即可。

```javascript
app.use(filter);
```

文件上传

前面说到的body-parser不支持文件上传，那么使用multer则可以实现。

操作数据库

node一般会使用mongo和mysql，使用下面这个例子即可：

操作 MongoDB

官方 api `http://mongodb.github.io/node-mongodb-native/`

```javascript
var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
var db;

MongoClient.connect("mongodb://localhost:27017/test1705candel", function(err, database) {
  if(err) throw err;

  db = database;
});

module.exports = {
    insert: function(_collection, _data, _callback){
        var i = db.collection(_collection).insert(_data).then(function(result){
            _callback(result);
        });
    },
    select: function(_collection, _condition, _callback){
        var i = db.collection(_collection).find(_condition || {}).toArray(function(error, dataset){
            _callback({status: true, data: dataset});
        })
    }
}
```

操作 MySql

```javascript
var mysql = require('mysql');

//创建连接池
var pool  = mysql.createPool({
  host     : 'localhost',
  user     : 'root',
  password : 'root',
  port: 3306,
  database: '1000phone',
  multipleStatements: true
});


module.exports = {
    select: function(tsql, callback){
        pool.query(tsql, function(error, rows){
      if(rows.length > 1){
        callback({rowsCount: rows[1][0]['rowsCount'], data: rows[0]});
      } else {
        callback(rows);
      }
        })
    }
}
```

session

Session 是一种记录客户状态的机制，不同的是 Cookie 保存在客户端浏览器中，而 Session 保存在服务器上的进程中。

客户端浏览器访问服务器的时候，服务器把客户端信息以某种形式记录在服务器上，这就是 Session。客户端浏览器再次访问时只需要从该 Session 中查找该客户的状态就可以了。

如果说 Cookie 机制是通过检查客户身上的“通行证”来确定客户身份的话，那么 Session 机制就是通过检查服务器上的“客户明细表”来确认客户身份。

Session 相当于程序在服务器上建立的一份客户档案，客户来访的时候只需要查询客户档案表就可以了。

Session 不能跨域。

node操作session和cookie也很简单，也是通过中间件的形式。

```javascript
const express = require('express')
const path = require('path')
const app = express();

const bodyParser = require('body-parser');

const cp = require('cookie-parser');
const session = require('express-session');

app.use(cp());
app.use(session({
    secret: '12345',//用来对session数据进行加密的字符串.这个属性值为必须指定的属性
    name: 'testapp',   //这里的name值得是cookie的name，默认cookie的name是：connect.sid
    cookie: {maxAge: 5000 },  //设置maxAge是5000ms，即5s后session和相应的cookie失效过期
    resave: false,
    saveUninitialized: true,    
}))
app.use(bodyParser.urlencoded({extended: false}));
app.use(express.static(path.join(__dirname, '/')));

app.get('/setsession', (request, response) => {
    request.session.user = {username: 'admin'};
    response.send('set session success');
})

app.get('/getsession', (request, response) => {
    response.send(request.session.user);
})

app.get('/delsession', (request, response) => {
    delete reqeust.session.user;
    response.send(request.session.user);
})

app.listen(88)
```

Token的特点

- 随机性
- 不可预测性
- 时效性
- 无状态、可扩展
- 跨域

基于Token的身份验证场景

1. 客户端使用用户名和密码请求登录
2. 服务端收到请求，验证登录是否成功
3. 验证成功后，服务端会返回一个 Token 给客户端，反之，返回身份验证失败的信息
4. 客户端收到 Token 后把 Token 用一种方式(cookie/localstorage/sessionstorage/其他)存储起来
5. 客户端每次发起请求时都选哦将 Token 发给服务端
6. 服务端收到请求后，验证Token的合法性，合法就返回客户端所需数据，反之，返回验证失败的信息

Token 身份验证实现 —— jsonwebtoken

先安装第三方模块 jsonwebtoken `npm install jsonwebtoken`

```javascript
const express = require('express')
const path = require('path')
const app = express();
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');

app.use(bodyParser.urlencoded({extended: false}));
app.use(express.static(path.join(__dirname, '/')));

app.all('*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Content-Type,Content-Length, Auth, Accept,X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By",' 3.2.1')
    if(req.method=="OPTIONS") {
          res.sendStatus(200);/*让options请求快速返回*/
    } else{
          next();
    }
});


app.get('/createtoken', (request, response) => {
    //要生成 token 的主题信息
    let user = {
        username: 'admin',
    }
    //这是加密的 key（密钥）
    let secret = 'dktoken';
    //生成 Token
    let token = jwt.sign(user, secret, {
        'expiresIn': 60*60*24 // 设置过期时间, 24 小时
    })      
    response.send({status: true, token});
})

app.post('/verifytoken', (request, response) => {
    //这是加密的 key（密钥），和生成 token 时的必须一样
    let secret = 'dktoken';
    let token = request.headers['auth'];
    if(!token){
        response.send({status: false, message: 'token不能为空'});
    }
    jwt.verify(token, secret, (error, result) => {
        if(error){
            response.send({status: false});
        } else {
            response.send({status: true, data: result});
        }
    })
})

app.listen(88)
```

HTTP 协议可以总结几个特点：

- 一次性的、无状态的短连接：客户端发起请求、服务端响应、结束。
- 被动性响应：只有当客户端请求时才被执行，给予响应，不能主动向客户端发起响应。
- 信息安全性：得在服务器添加 SSL 证书，访问时用 HTTPS。
- 跨域：服务器默认不支持跨域，可在服务端设置支持跨域的代码或对应的配置。

TCP 协议可以总结几个特点：

- 有状态的长连接：客户端发起连接请求，服务端响应并建立连接，连接会一直保持直到一方主动断开。
- 主动性：建立起与客户端的连接后，服务端可主动向客户端发起调用。
- 信息安全性：同样可以使用 SSL 证书进行信息加密，访问时用 WSS 。
- 跨域：默认支持跨域。



安装第三方模块 ws：`npm install ws`

开启一个 WebSocket 的服务器，端口为 8080

```
var socketServer = require('ws').Server;
var wss = new socketServer({
    port: 8080
});
```

也可以利用 Express 来开启 WebSocket 的服务器

```
var app = require('express')();
var server = require('http').Server(app);

var socketServer = require('ws').Server;
var wss = new socketServer({server: server, port: 8080});
```

- 用 on 来进行事件监听
- connection：连接监听，当客户端连接到服务端时触发该事件
- close：连接断开监听，当客户端断开与服务器的连接时触发
- message：消息接受监听，当客户端向服务端发送信息时触发该事件
- send: 向客户端推送信息

soket.io 可以理解为对 WebSocket 的一种封装。好比前端的 jQuery 对原生 javascript 的封装。
soket.io 依靠事件驱动的模式，灵活的使用了自定义事件和调用事件来完成更多的场景，不必依赖过多的原生事件。

- 安装第三方模块 `npm install express socket.io`
- 开户 Socket 服务器，端口为 88

```javascript
var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
http.listen(88);
```

- 用 on 来进行事件监听和定义事件
- connection：监听客户端连接,回调函数会传递本次连接的socket
- emit：触发用客户端的事件

```javascript
io.on('connection', function(client){
    //把当前登录的用户保存到对象 onlinePersons，并向所有在线的用户发起上线提示
    //serverLogin 为自定义事件，供客户端调用
    client.on('serverLogin', function(_person){
        var _personObj = JSON.parse(_person);
        onlinePersons[_personObj.id] = _personObj;
        //向所有在线的用户发起上线提示
        //触发客户端的 clientTips 事件
        //clientTips 为客户端的自定义事件
        io.emit('clientTips', JSON.stringify(onlinePersons));
    })

    //当监听到客户端有用户在移动，就向所有在线用户发起移动信息，触发客户端 clientMove 事件
    //serverMove 为自定义事件，供客户端调用
    client.on('serverMove', function(_person){
        var _personObj = JSON.parse(_person);
        onlinePersons[_personObj.id] = _personObj;
        console.log('serverLogin', onlinePersons);
        //clientTips 为客户端的自定义事件
        io.emit('clientMove', _person);
    });
})
```