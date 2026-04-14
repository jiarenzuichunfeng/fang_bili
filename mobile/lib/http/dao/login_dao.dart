import 'package:fang_bili/db/hi_cacke.dart';
import 'package:fang_bili/http/cors/hi_net.dart';
import 'package:fang_bili/http/request/base_request.dart';
import 'package:fang_bili/http/request/login_request.dart';
import 'package:fang_bili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

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
      request
          .addBody("username", userName)
          .addBody("password", password)
          .addBody("imoocId", imoocId)
          .addBody('orderId', orderId);
    } else {
      request = LoginRequest();
      request.addBody("username", userName).addBody("password", password);
    }

    var result = await HiNet.getInstance()?.fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      // 保存登录令牌
      HiCacke.getInstance()?.setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCacke.getInstance()?.get(BOARDING_PASS);
  }
}
