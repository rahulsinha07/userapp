import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/dio_client.dart';
import 'package:mentorkhoj/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mentorkhoj/common/models/api_response_model.dart';
import 'package:mentorkhoj/common/models/language_model.dart';
import 'package:mentorkhoj/utill/app_constants.dart';

class LanguageRepo {
  final DioClient? dioClient;

  LanguageRepo({required this.dioClient});

  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }

  Future<ApiResponseModel> changeLanguageApi({required String? languageCode}) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.changeLanguage,
        data: {'language_code' : languageCode},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
