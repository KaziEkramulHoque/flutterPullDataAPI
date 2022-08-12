import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:pillar_test/model/user.dart';

class HttpService {
  late Dio _dio;
  String error = "";
  final baseUrl = "https://jsonplaceholder.typicode.com/";

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    initializeInterceptors();
  }

  Future<Result<Exception, Response>> getRequest(String endPoint) async {
    Response response;

    try {
      response = await _dio.get(endPoint,
          options: buildCacheOptions(
            Duration(days: 7), //duration of cache
            //forceRefresh: refresh, //to force refresh
            maxStale: Duration(days: 10), //before this time, if error like
            //500, 500 happens, it will return cache
          ));
      return Success(response);
    } on SocketException catch (e) {
      print(e);
      error = e.toString();
      return Error(e);

      //error = e.message;

    }
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
