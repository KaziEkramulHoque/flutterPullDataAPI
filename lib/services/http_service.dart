import 'package:dio/dio.dart';
import 'package:pillar_test/model/user.dart';

class HttpService {
  late Dio _dio;

  final baseUrl = "https://jsonplaceholder.typicode.com/";

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    initializeInterceptors();
  }

  Future<Response> getRequest(String endPoint) async {
    Response response;

    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  // Future<List<User>?> getUsers(String endPoint) async {
  //   Response response;
  //   response = await _dio.get(endPoint);
  //   if (response.statusCode == 200) {
  //     var json = response.data;
  //     return User.fromJson(response.data);
  //   }
  // }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        print("${request.method} ${request.baseUrl}${request.path}");
        return handler.next(request);
      },
      onResponse: (response, handler) {
        print("${response.data}");
        return handler.next(response);
      },
      onError: (error, handler) {
        print("${error.message}");
        return handler.next(error);
      },
    ));
  }
}
