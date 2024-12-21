import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'POST') {
      if (kDebugMode) {
        print(
            'REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data.toString()} => HEADER: ${options.headers}');
      }
    } else if (options.method == 'PATCH') {
      if (kDebugMode) {
        print(
            'REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data.toString()} => HEADER: ${options.headers}');
      }
    } else if (options.method == 'PUT') {
      if (kDebugMode) {
        print(
            'REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data.toString()} => HEADER: ${options.headers}');
      }
    } else if (options.method == 'DELETE') {
      if (kDebugMode) {
        print(
            'REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data.toString()} => HEADER: ${options.headers}');
      }
    } else {
      if (kDebugMode) {
        print(
            'REQUEST[${options.method}] => PATH: ${options.path} => QUERY: ${options.queryParameters}  => HEADER: ${options.headers}');
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} => DATA: ${response.data}',
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}=> DATA: ${err.error}',
    );
    return super.onError(err, handler);
  }
}
