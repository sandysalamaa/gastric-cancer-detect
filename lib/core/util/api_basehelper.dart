import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';

class ApiBaseHelper {
  final String _baseUrl = "";

  final Dio dio = Dio();
  void dioInit() {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers = headers;
    dio.options.sendTimeout = 15000; // time in ms
    dio.options.connectTimeout = 15000; // time in ms
  }

  ApiBaseHelper();
  Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": 'application/json'
  };
  void updateLocalInHeaders(String local) {
    headers["Accept-Language"] = local;
    dio.options.headers = headers;
  }

  Future<dynamic> get({required String url, String? token}) async {
    try {
      // headers["Content-language"] = local;
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
        dio.options.headers = headers;
      } else {
        log(" headers.remove Authorization )");
        dio.options.headers.remove("Authorization");
      }
      log(url);
      final Response response = await dio.get(url);
      log(response.data.toString());
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log(e.toString());
      log(e.response?.toString() ?? "no response");
      final String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      throw ServerException(message: message);
    }
  }

  Future<dynamic> put({
    required String url,
    String? token,
    Map<String, dynamic>? body,
  }) async {
    try {
      // headers["Content-language"] = local;
      final Response response;
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
        dio.options.headers = headers;
      } else {
        log(" headers.remove Authorization )");
        dio.options.headers.remove("Authorization");
      }
      log(url);
      if (body != null) {
        // FormData formData = FormData.fromMap(body);
        response = await dio.put(url, data: body);
      } else {
        response = await dio.put(url);
      }
      log(response.data.toString());
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log(e.toString());
      log(e.response?.toString() ?? "no response");
      final String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      throw ServerException(message: message);
    }
  }

  Future<dynamic> post(
      {required String url,
      required Map<String, dynamic> body,
      void Function(int, int)? onSendProgress,
      String? token}) async {
    try {
      // headers["Content-language"] = local;
      if (token != null) {
        log(token);
        headers["Authorization"] = "Bearer $token";
        dio.options.headers = headers;
      } else {
        log(" headers.remove Authorization )");
        dio.options.headers.remove("Authorization");
      }
      FormData formData = FormData.fromMap(body);
      log(url);
      log(body.toString());
      final Response response =
          await dio.post(url, data: formData, onSendProgress: onSendProgress);
      log(response.data.toString());
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log(e.toString());
      log(e.response?.toString() ?? "no response");
      final String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      throw ServerException(message: message);
    }
  }

  Future<dynamic> delete(
      {required String url,
      required Map<String, dynamic> body,
      String? token}) async {
    try {
      // headers["Content-language"] = local;
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
        dio.options.headers = headers;
      } else {
        log(" headers.remove Authorization )");
        dio.options.headers.remove("Authorization");
      }
      FormData formData = FormData.fromMap(body);
      log(url);
      final Response response = await dio.delete(url, data: formData);
      log(response.data.toString());
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log(e.toString());
      log(e.response?.toString() ?? "no response");
      final String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      throw ServerException(message: message);
    }
  }

  Future<dynamic> postWithImage(
      {required String url,
      required Map<String, dynamic> body,
      String? token}) async {
    try {
      dio.options.sendTimeout = 40000; // time in ms
      dio.options.connectTimeout = 40000; // time in ms
      dio.options.receiveTimeout = 40000;
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
        dio.options.headers = headers;
        log(url + token);
      }
      log(body.toString());
      log(url);
      log(dio.options.headers.toString());
      FormData formData = FormData.fromMap(body);
      final Response response = await dio.post(url, data: formData);
      final responseJson = _returnResponse(response);
      log(responseJson.toString());
      dio.options.sendTimeout = 9000; // time in ms
      dio.options.connectTimeout = 9000; // time in ms
      dio.options.receiveTimeout = 9000;
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log("e.response?.data.${e.response?.data}");
      String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      if (e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectTimeout ||
          e.message.contains('SocketException')) {
        message = tr("error_no_internet");
      }
      message = (e.response?.data as Map<String, dynamic>)["error"] is List
          ? ((e.response?.data as Map<String, dynamic>)["error"] as List)
              .first
              .toString()
          : message;
      message =
          (e.response?.data as Map<String, dynamic>)["message"] ?? message;
      message = (e.response?.data as Map<String, dynamic>)["msg"] ?? message;
      throw ServerException(message: message);
    }
  }

  Future uploadImage({required String url, required File file}) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final Response response = await dio.post(url, data: formData);
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw ServerException(message: tr("error_no_internet"));
    } on DioError catch (e) {
      log(e.toString());
      log(e.toString());
      log(e.response?.toString() ?? "no response");
      final String message =
          e.response?.data["message"] ?? tr("error_please_try_again");
      throw ServerException(message: message);
    }
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw ServerException(message: response.data['message']);
      case 422:
        throw response.data.toString();
      case 401:
      case 403:
        throw UnauthorizedException(message: response.data);
      case 500:
      default:
        debugPrint(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode} ${response.data}');
        throw ServerException(
            message:
                'Error occurred while Communication with Server with StatusCode : ${response.statusCode} ${response.data}');
    }
  }
}

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);
  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
