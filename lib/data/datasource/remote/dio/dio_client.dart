/*
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:mentorkhoj/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(this.baseUrl,
      Dio? dioC, {
        required this.loggingInterceptor,
        required this.sharedPreferences,
      }) {
    token = sharedPreferences.getString(AppConstants.token);
    dio = dioC ?? Dio();


    updateHeader(dioC: dioC, getToken: token);

  }

  Future<void> updateHeader({String? getToken, Dio? dioC})async {
    dio?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $getToken',
        'X-localization': sharedPreferences.getString(AppConstants.languageCode)
            ?? AppConstants.languages[0].languageCode,
        'guest-id': sharedPreferences.getString(AppConstants.guestId) ?? '',

      };

    dio?.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {

      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (kDebugMode) {
        print('===============${e.toString()}');
      }
      rethrow;
    }
  }

  Future<Response> post(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postMultipart(String uri, {
    Map<String, dynamic>? data,
    List<XFile?>? files,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try{
      List<MultipartFile> fileList = [];

      if(files != null) {
        for(int i = 0; i < files.length; i++) {
          fileList.add(MultipartFile.fromBytes(
            await files[i]!.readAsBytes(),
            filename: files[i]!.name,
          ));
        }
      }

      if(fileList.isNotEmpty) {
        data?.addAll({
          '${fileKey ?? 'image'}[]' : fileList,
        });
      }

    }catch(e) {
      rethrow;
    }




    try {
      var response = await dio!.post(
        uri,
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> put(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

}

 */
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:mentorkhoj/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(this.baseUrl,
      Dio? dioC, {
        required this.loggingInterceptor,
        required this.sharedPreferences,
      }) {
    token = sharedPreferences.getString(AppConstants.token);
    dio = dioC ?? Dio();

    updateHeader(dioC: dioC, getToken: token);
  }

  Future<void> updateHeader({String? getToken, Dio? dioC}) async {
    dio?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $getToken',
        'X-localization': sharedPreferences.getString(AppConstants.languageCode)
            ?? AppConstants.languages[0].languageCode,
        'guest-id': sharedPreferences.getString(AppConstants.guestId) ?? '',
      };

    dio?.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    String fullUrl = _buildFullUrl(uri, queryParameters);
    debugPrint('GET Request: Full URL => $fullUrl');
    debugPrint('GET Request: Headers => ${dio!.options.headers}');

    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('GET Response: ${response.statusCode}');
      debugPrint('GET Response: ${response.data}');

      return response;
    } on SocketException catch (e) {
      debugPrint('GET Error (SocketException): ${e.message}');
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      debugPrint('GET Error (FormatException): Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('GET Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<Response> post(String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String fullUrl = _buildFullUrl(uri, queryParameters);
    debugPrint('POST Request: Full URL => $fullUrl');
    debugPrint('POST Request: Headers => ${dio!.options.headers}');
    debugPrint('POST Request: Body => $data');

    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('POST Response: ${response.statusCode}');
      debugPrint('POST Response: ${response.data}');

      return response;
    } on FormatException catch (_) {
      debugPrint('POST Error (FormatException): Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('POST Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<Response> put(String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String fullUrl = _buildFullUrl(uri, queryParameters);
    debugPrint('PUT Request: Full URL => $fullUrl');
    debugPrint('PUT Request: Headers => ${dio!.options.headers}');
    debugPrint('PUT Request: Body => $data');

    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('PUT Response: ${response.statusCode}');
      debugPrint('PUT Response: ${response.data}');

      return response;
    } on FormatException catch (_) {
      debugPrint('PUT Error (FormatException): Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('PUT Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<Response> delete(String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    String fullUrl = _buildFullUrl(uri, queryParameters);
    debugPrint('DELETE Request: Full URL => $fullUrl');
    debugPrint('DELETE Request: Headers => ${dio!.options.headers}');
    debugPrint('DELETE Request: Body => $data');

    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      debugPrint('DELETE Response: ${response.statusCode}');
      debugPrint('DELETE Response: ${response.data}');

      return response;
    } on FormatException catch (_) {
      debugPrint('DELETE Error (FormatException): Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('DELETE Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<Response> postMultipart(String uri, {
    Map<String, dynamic>? data,
    List<XFile?>? files,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String fullUrl = _buildFullUrl(uri, queryParameters);
    debugPrint('POST Multipart Request: Full URL => $fullUrl');
    debugPrint('POST Multipart Request: Headers => ${dio!.options.headers}');
    debugPrint('POST Multipart Request: Body => $data');

    try {
      List<MultipartFile> fileList = [];

      if (files != null) {
        for (int i = 0; i < files.length; i++) {
          fileList.add(MultipartFile.fromBytes(
            await files[i]!.readAsBytes(),
            filename: files[i]!.name,
          ));
        }
      }

      if (fileList.isNotEmpty) {
        data = data ?? {};
        data.addAll({
          '${fileKey ?? 'files'}[]': fileList,
        });
      }

      var formData = FormData.fromMap(data ?? {});

      var response = await dio!.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('POST Multipart Response: ${response.statusCode}');
      debugPrint('POST Multipart Response: ${response.data}');

      return response;
    } on FormatException catch (_) {
      debugPrint('POST Multipart Error (FormatException): Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('POST Multipart Error: ${e.toString()}');
      rethrow;
    }
  }

  // Helper function to build the full URL with query parameters
  String _buildFullUrl(String uri, Map<String, dynamic>? queryParameters) {
    String queryString = Uri(queryParameters: queryParameters).query;
    return '$baseUrl$uri${queryString.isNotEmpty ? '?$queryString' : ''}';
  }
}
