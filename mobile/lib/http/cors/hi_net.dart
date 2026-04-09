import 'package:fang_bili/http/cors/dio_adapter.dart';
import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/cors/hi_net_adapter.dart';
import 'package:fang_bili/http/request/base_request.dart';

// 定义一个名为 HiNet 的类，用于网络请求封装
class HiNet {
  // 私有命名构造函数：外部无法通过 HiNet() 创建对象，保证单例安全
  HiNet._();

  // 静态私有变量：存储唯一的单例对象，初始为 null
  static HiNet? _instance;

  // 静态公共方法：获取单例实例（懒汉式单例核心方法）
  static HiNet? getInstance() {
    // 如果 _instance 为 null，则创建一个新的 HiNet 实例赋值给它
    // ??= 表示：为空才赋值，不为空则跳过
    _instance ??= HiNet._();

    // 返回唯一的单例对象
    return _instance;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        HiNetError(status!, result.toString(), data: result);
    }
    return result;
  }

  // 真正执行请求发送的方法，泛型 T 可用于指定返回类型
  // async 表示异步，返回 Future 类型
  Future<dynamic> send<T>(BaseRequest request) async {
    // 打印请求 URL 日志
    printLog("url:${request.url()}");

    // // 使用Mock发送请求
    // HiNetAdapter adapter = MockAdapter();
    // return adapter.send(request);
    // 使用Dio 发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
    // // 使用Http发送请求
    //   HiNetAdapter adapter = HttpAdapter();
    //   return adapter.send(request);
  }

  // 通用日志打印方法，统一格式输出
  void printLog(log) {
    print("hi_net:${log.toString()}");
  }
}
