// 导入数据库方法 + 路由
const { getName, writeJson } = require("../../db/index.js");
const Router = require('koa-router');
const router = new Router({ prefix: '/user' });

// 登录
router.post("/login", async (ctx) => {
  try {
    // 1. 获取请求体 + 请求头
    const { username, password } = ctx.request.body || {};
    const header = ctx.request.header;

    // 2. 校验请求头必须存在
    const courseFlag = header['course-flag'];
    const authToken = header['auth-token'];

    if (!courseFlag || !authToken) {
      ctx.body = { code: -1, msg: "请求头参数缺失" };
      return;
    }

    // 3. 校验请求头合法性
    if (courseFlag !== "fa" || authToken !== "test-token") {
      ctx.body = { code: -1, msg: "非法请求" };
      return;
    }

    // 4. 校验用户名密码不能为空
    if (!username || !password) {
      ctx.body = { code: -1, msg: "用户名或密码不能为空" };
      return;
    }

    // 5. 查询数据库
    const user = await getName(username);
    if (!user) {
      ctx.body = { code: -1, msg: "用户不存在" };
      return;
    }

    // 6. 密码校验
    if (username === user.username && password === user.password) {
      ctx.body = { code: 0, data: "mock-token-123456" };
    } else {
      ctx.body = { code: -1, msg: "用户名或密码错误" };
    }

  } catch (err) {
    ctx.body = { code: -1, msg: "服务器错误：" + err.message };
  }
});

// 注册
router.post("/registration", async (ctx) => {
  try {
    // 1. 获取参数
    const { username, password, imoocId, orderId } = ctx.request.body || {};
    const courseFlag = ctx.request.header['course-flag'];

    // 2. 校验请求头
    if (courseFlag !== "fa") {
      ctx.body = { code: -1, msg: "非法请求" };
      return;
    }

    // 3. 必传参数校验
    if (!username || !password) {
      ctx.body = { code: -1, msg: "用户名和密码不能为空" };
      return;
    }

    // 4. 查询用户是否已存在
    const user = await getName(username);

    if (user) {
      ctx.body = { statusCode: -1, msg: "用户名已存在" };
      return;
    }

    // 5. 执行注册
    await writeJson(username, password, imoocId, orderId);
    ctx.body = { code: 0, msg: "注册成功" };

  } catch (err) {
    ctx.body = { code: -1, msg: "注册失败：" + err.message };
  }
});

router.get("/notice", async (ctx) => {
  if(ctx.request.header['boarding-pass'] !== "mock-token-123456") {
    ctx.body = { code: -1, msg: "请先登录" };
  }
  
});

// 导出路由（CommonJS 写法）
module.exports = router;