import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/CommonUtils.dart';
import '../../utils/strings.dart';
import 'api_end_point.dart';
import 'logging_interceptor.dart';

class ApiHitter {
  static Dio? _dio;
  static CancelToken _cancelToken = CancelToken();
  final GlobalKey key = new GlobalKey();

  static Dio getDio() {
    if (_dio == null) {
      _dio = new Dio();
      _cancelToken = CancelToken();
      BaseOptions options = new BaseOptions(
        baseUrl: ApiEndpoint.baseUrl,
        connectTimeout: 300000,
        receiveTimeout: 300000,
      );
      _dio!.options = options;
      return _dio!..interceptors.add(LoggingInterceptor());
    } else {
      return _dio!;
    }
  }

  Future<ApiResponse> getApiResponse(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParams}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await getDio().get(endPoint,
              options: Options(headers: headers), queryParameters: queryParams);
          if (response.statusCode == 200) {
            // debugPrint("vcarez response status code is " +
            //     response.statusCode.toString());
            // debugPrint("vcarez response response.data message is " +
            //     response.data["message"]);
            // debugPrint("vcarez response response.data status is " +
            //     response.data["status"]);
            // debugPrint("vcarez response response.data response is " +
            //     response.data["response"]);

            if (response.statusCode == 200 && response.statusMessage != null) {
              return ApiResponse(true,
                  responseCode: response.statusCode,
                  response: response,
                  message: response.statusMessage!);
            } else if (response.data["status"] == 200 &&
                response.data["message"] == null) {
              return ApiResponse(true,
                  responseCode: response.data["status"],
                  response: response,
                  message: '');
            } else {
              return ApiResponse(true,
                  responseCode: response.data["status"],
                  response: response,
                  message: response.data["message"]);
            }
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } catch (error) {
          print('Api Hitter error:  ${error.toString()}');

          return ApiResponse(false,
              responseCode: error.hashCode, message: error.hashCode.toString());
        }
      } else {
        return ApiResponse(false, responseCode: 301, message: errorNoInternet);
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  getApiRawResponse(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParams}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await getDio().get(endPoint,
              options: Options(headers: headers), queryParameters: queryParams);

          return response;
        } catch (error) {
          return error;
        }
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getPostApiResponse(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? data,
      var postFormData,
      bool isFormData = false}) async {
    try {
      var response;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await getDio().post(endPoint,
              options: Options(headers: headers),
              data: isFormData ? postFormData : data,
              // data: {'email': 'jigartest@gmail.com', 'password': '12345'},
              onSendProgress: (int sent, int total) {});
          debugPrint("vcarez the response ==> is $response");
          if (response.statusCode == 200) {
            return ApiResponse(
              true,
              responseCode: response.data["success"],
              response: response,
              // message: response.data["message"]
            );
          } else if (response.statusCode == 401) {
            return ApiResponse(true,
                responseCode: response.data["success"],
                // response: response,
                message: response.data["message"] ?? "");
          } else if (response.statusCode == 400) {
            return ApiResponse(
              false,
              // responseCode: response.data["success"],
              response: response,
              // message: response.data["message"]
            );
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        debugPrint("vcarez the error.toString() ==> is " + error.toString());
        try {
          response = error;
          return ApiResponse(false,
              responseCode: response.response!.statusCode!,
              message: response.response.data['message']);
        } catch (e) {
          debugPrint("vcarez the somehting went wrong ==> is " + e.toString());
          return ApiResponse(false,
              responseCode: 400,
              // message: response.response
              message: 'Something went wrong.Try again later');
        }
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getPostApiJson(String endPoint,
      {Map<String, dynamic>? headers,
      String? data,
      FormData? formData,
      bool isFormData = false}) async {
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var response = await getDio().post(endPoint,
              options: Options(headers: headers),
              data: isFormData ? formData : data,
              onSendProgress: (int sent, int total) {});
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"],
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        return ApiResponse(false,
            responseCode: error.hashCode, message: error.hashCode.toString());
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getPostApiJsonWithQueryParam(String endPoint,
      {Map<String, dynamic>? headers,
      String? data,
      FormData? formData,
      Map<String, dynamic>? queryParam,
      bool isFormData = false}) async {
    try {
      var response;
      try {
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await getDio().post(endPoint,
              options: Options(headers: headers),
              queryParameters: queryParam,
              data: isFormData ? formData : data,
              onSendProgress: (int sent, int total) {});
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"],
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        try {
          response = error;
          return ApiResponse(false,
              responseCode: response.response!.statusCode!,
              message: response.response.data['body']);
        } catch (e) {
          return ApiResponse(false,
              responseCode: 400, message: 'Something went wrong..');
        }
      }
      // catch (error) {
      //   return ApiResponse(false, error.hashCode, message: error.hashCode.toString());
      // }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> postApiWithQueryParam(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? queryParam,
      bool isFormData = false}) async {
    try {
      var response;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await getDio().put(endPoint,
              options: Options(headers: headers),
              data: isFormData ? formData : data,
              queryParameters: queryParam,
              onSendProgress: (int sent, int total) {});
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"],
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        try {
          response = error;
          return ApiResponse(false,
              responseCode: response.response!.statusCode!,
              message: response.response.data['body']);
        } catch (e) {
          return ApiResponse(false,
              responseCode: 400, message: 'Something went wrong..');
        }
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getPutApiJson(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? data,
      FormData? formData,
      bool isFormData = false}) async {
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // var response = await getDio().put(endPoint,
          //     options: Options(headers: headers),
          //     data: isFormData ? formData : data,
          //     onSendProgress: (int sent, int total) {});
          var response = await getDio().put(endPoint,
              options: Options(headers: headers),
              data: isFormData ? formData : data,
              // data: {'email': 'jigartest@gmail.com', 'password': '12345'},
              onSendProgress: (int sent, int total) {});
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"],
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        return ApiResponse(false,
            responseCode: error.hashCode, message: error.hashCode.toString());
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getDeleteApi(String endPoint,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? data,
      FormData? formData,
      bool isFormData = false}) async {
    try {
      var response;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await getDio().delete(endPoint,
              options: Options(headers: headers),
              data: isFormData ? formData : data);
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"] != null
                    ? response.data["status"]
                    : 200,
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        try {
          response = error;
          return ApiResponse(false,
              responseCode: response.response!.statusCode!,
              message: response.response.data['body']);
        } catch (e) {
          return ApiResponse(false,
              responseCode: 400, message: 'Something went wrong..');
        }
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  Future<ApiResponse> getPatchApiJson(String endPoint,
      {Map<String, dynamic>? headers,
      String? data,
      FormData? formData,
      bool isFormData = false}) async {
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var response = await getDio().patch(endPoint,
              options: Options(headers: headers),
              data: isFormData ? formData : data,
              onSendProgress: (int sent, int total) {});
          if (response.statusCode == 200) {
            return ApiResponse(true,
                responseCode: response.data["status"],
                response: response,
                message: response.data["message"]);
          } else {
            return ApiResponse(false,
                responseCode: response.statusCode!,
                response: response,
                message: response.data["message"]);
          }
        } else {
          return ApiResponse(false,
              responseCode: 301, message: errorNoInternet);
        }
      } catch (error) {
        return ApiResponse(false,
            responseCode: error.hashCode, message: error.hashCode.toString());
      }
    } on Exception {
      return CommonUtils.utils.onInternetError();
    }
  }

  void cancelRequests({CancelToken? cancelToken}) {
    cancelToken == null
        ? _cancelToken.cancel('Cancelled')
        : cancelToken.cancel();
  }
}

class ApiResponse {
  final bool success;
  var responseCode;

  // final String message;
  final String message;
  final Response? response;

  ApiResponse(this.success,
      {this.message = "Success", this.response, this.responseCode});
}
