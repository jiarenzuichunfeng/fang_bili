// Node.js 标准 require 写法
const Koa = require('koa');
const koaBody = require('koa-body').default;

// 导入路由模块
const userRoutes = require('./server/user/index.js');

const app = new Koa();

// 解析请求体：支持表单、文件上传
app.use(
  koaBody({
    multipart: true,
    keepExtensions: true,
    parsedMethods: ['POST', 'PUT', 'DELETE', 'PATCH'],
  })
);

// 挂载用户路由
app.use(userRoutes.routes()).use(userRoutes.allowedMethods());

// 启动服务
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Mock server running at http://localhost:${PORT}`);
});