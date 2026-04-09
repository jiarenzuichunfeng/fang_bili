// 登录
import 'package:fang_bili/http/request/base_request.dart';

class LoginRequest  extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
   return true;
  }

  @override
  String path() {
    return '/user/login';
  }
}