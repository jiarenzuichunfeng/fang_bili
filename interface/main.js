const Koa = require("koa");
const Router = require("koa-router");
const { koaBody } = require("koa-body");
const fs = require("fs").promises;

const app = new Koa();
const router = new Router();

app.use(
  koaBody({
    multipart: true, // 支持 form-data
    formidable: {
      keepExtensions: true,
    },
    parsedMethods: ["POST", "PUT", "DELETE"],
  }),
);

router.get("/test", (ctx) => {
  ctx.body = {
    code: 0,
    msg: "success",
    data: {
      message: "测试Moke数据成功！",
    },
  };
});

// 获取数据库里的账号
async function getName(username) {
  const jsonStr = await fs.readFile("./db/user.json", "utf8");
  const data = JSON.parse(jsonStr);
  return data[username];
}

// 登录
router.post("/user/login", async (ctx) => {
  try {
    const { username, password } = ctx.request.body;
    const header = ctx.request.header;
    const { username: fsusername, password: fspassword } =
      await getName(username);

    if (header['course-flag'] == "fa" && header['auth-token'] == "test-token" ) {
      if (username === fsusername && password === fspassword) {
        ctx.body = { code: 0, 'boarding-pass': "mock-token-123456" };
      } else {
        ctx.body = { code: -1, msg: "用户名或密码错误" };
      }
    }
  } catch (err) {
    ctx.body = { code: -1, msg: "服务器错误：" + err.message };
  }
});

// 往本地数据库写入数据
async function writeJson(username, password,imoocId,orderId) {
  const jsonStr = await fs.readFile("./db/user.json", "utf8");
  const data = JSON.parse(jsonStr);
  data[username] = { username, password ,imoocId,orderId};
  fs.writeFile("./db/user.json", JSON.stringify(data, null, 2), "utf8");
}

// 注册
router.post("/user/registration", async (ctx) => {
  const { username, password,imoocId,orderId } = ctx.request.body;
  const header = ctx.request.header;
  const {username:fsusername} = await getName(username);

  if (header['course-flag'] == "fa") {
    if (fsusername == username) {
      ctx.body = { code: -1, msg: "用户名已存在" };
    }else{
      writeJson(username, password,imoocId,orderId);
      ctx.body = { code: 0, msg: "注册成功" };
    }
  }
});

// 支持动态路由
router.get("/api/post/:id", (ctx) => {
  ctx.body = {
    id: ctx.params.id,
    title: "文章标题",
  };
});

// -------------------------------------------------

app.use(router.routes()).use(router.allowedMethods());

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Mock server running at http://localhost:${PORT}`);
});
