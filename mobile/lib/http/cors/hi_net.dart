import 'package:fang_bili/http/cors/dio_adapter.dart';
import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/cors/hi_net_adapter.dart';
import 'package:fang_bili/http/request/base_request.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  static HiNet? getInstance() {
    _instance ??= HiNet._();

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
