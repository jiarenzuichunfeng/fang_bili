import 'package:fang_bili/http/cors/hi_net.dart';
import 'package:fang_bili/http/request/base_request.dart';
import 'package:fang_bili/http/request/login_request.dart';
import 'package:fang_bili/http/request/registration_request.dart';

class LoginDao {
  static Login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
    String userName,
    String password,
    String? imoocId,
    String? orderId,
  ) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password, {imoocId, orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request
        .addBody("username", userName)
        .addBody("password", password)
        .addBody("imoocId", imoocId)
        .addBody('orderId', orderId)
        .addHeader("courseflag", "fa");
    var result = await HiNet.getInstance()?.fire(request);
    print(result);
    return result;
  }
}
