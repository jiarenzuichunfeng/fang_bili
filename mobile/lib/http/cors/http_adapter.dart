import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/cors/hi_net_adapter.dart';
import 'package:fang_bili/http/request/base_request.dart';
import 'package:http/http.dart' as http;

class HttpAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response;
    Map<String, String> head = {...request.header};
    final url = Uri.parse(request.url());
    var error;

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await http.get(url, headers: head);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await http.post(
          Uri(path: request.url()),
          headers: head,
          body: request.params,
        );
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await http.delete(
          Uri(path: request.url()),
          headers: head,
          body: request.params,
        );
      } 
    } catch (e) {
      throw HiNetError(
        response?.statusCode ?? -1,
        error.toString(),
        data: buildRes(response, request),
      );
    }
    return buildRes(response, request);
  }

  buildRes(response, BaseRequest request) {
    return HiNetResponse(
      data: response.body,
      request: request,
      statusCode: response.statusCode,
      statusMessage: response.reasonPhrase,
      extra: response,
    );
  }
}
