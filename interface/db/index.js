const fs = require('fs/promises');
const path = require('path');
// const mysql = require('mysql2/promise');

// 创建数据库连接池
// const connection = mysql.createConnection({
//   host:'localhost',
//   user:'root',
//   password:'wxhn521',
//   database:'fang_bili',
//   waitForConnections: true, // 启用排队等待
//   connectionLimit: 10,  // 最大连接数
//   queueLimit: 0 // 不限制排队长度
// })


// 关键：固定文件路径（防止路径错误）
const USER_FILE = path.resolve('./db/user.json');

// 获取数据库里的账号
async function getName(username) {
  try {
    const jsonStr = await fs.readFile(USER_FILE, 'utf8');
    // 空文件兼容处理
    const data = jsonStr ? JSON.parse(jsonStr) : {};
    // 返回用户对象（不存在返回 undefined）
    return data[username];
  } catch (err) {
    // 文件不存在时，返回空
    return undefined;
  }
}

// 往本地数据库写入数据
async function writeJson(username, password, imoocId, orderId) {
  try {
    let data = {};
    try {
      const jsonStr = await fs.readFile(USER_FILE, 'utf8');
      data = jsonStr ? JSON.parse(jsonStr) : {};
    } catch (err) {
      // 文件不存在，初始化空对象
      data = {};
    }

    // 写入用户数据
    data[username] = { username, password, imoocId, orderId };

    // 必须加 await！否则数据丢失
    await fs.writeFile(USER_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (err) {
    throw new Error('写入用户数据失败：' + err.message);
  }
}

// 导出函数（CommonJS 写法）
module.exports = {
  getName,
  writeJson
};