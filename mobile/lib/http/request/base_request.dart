// 1. 定义请求方法枚举：包含 GET、POST、DELETE 三种常用请求类型
enum HttpMethod { GET, POST, DELETE }

// 2. 抽象类：所有网络请求的基类，封装通用请求逻辑
abstract class BaseRequest {
  // 路径参数：用于拼接在 URL 路径中的参数，例如 /user/123 中的 123
  var pathParams;

  // 是否使用 HTTPS 协议，默认 true（使用 HTTPS）
  var useHttps = false;

  // 获取请求的主机域名（服务器地址），子类可重写
  String authority() {
    return '192.168.1.120:3000';
  }

  // 抽象方法：由子类实现，指定当前请求的方法类型（GET/POST/DELETE）
  HttpMethod httpMethod();

  // 抽象方法：由子类实现，指定当前请求的接口路径
  String path();

  // 拼接生成完整的请求 URL（核心方法）
  String url() {
    // 声明 Uri 对象，用于拼接 URL
    Uri url;

    // 获取子类定义的接口路径
    var pathStr = path();

    // ====================== 拼接路径参数 ======================
    // 如果有路径参数，则进行拼接
    if (pathParams != null) {
      // 判断接口路径是否以 / 结尾
      if (path().endsWith('/')) {
        // 例子：path = /user/ → 拼接后 → /user/123
        pathStr = "${path()}$pathParams";
      } else {
        // 例子：path = /user → 拼接后 → /user/123
        pathStr = "${path()}/$pathParams";
      }
    }

    // ====================== 切换 HTTP/HTTPS ======================
    if (useHttps) {
      // 使用 HTTPS 协议拼接完整 URL
      url = Uri.https(authority(), pathStr, params);
    } else {
      url = Uri.http(authority(), pathStr, params);
    }
    print("url:${url.toString()}");

    return url.toString();
  }

  bool needLogin();

  // 请求参数：存储接口传递的键值对参数
  Map<String, String> params = Map();

  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, String> body = Map();

  // body
  BaseRequest addBody(String k, Object v) {
    body[k] = v.toString();
    return this;
  }

  // 请求头：存储接口请求头参数
  Map<String, dynamic> header = Map();


  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
