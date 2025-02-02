import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/dio_client.dart';
import 'package:mentorkhoj/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mentorkhoj/common/models/api_response_model.dart';
import 'package:mentorkhoj/features/onboarding/domain/models/onboarding_model.dart';
import 'package:mentorkhoj/localization/app_localization.dart';
import 'package:mentorkhoj/utill/images.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponseModel> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoarding1, 'select_your_mentor'.tr, 'onboarding_1_text'.tr),
        OnBoardingModel(Images.onBoarding2, 'book_your_mentor'.tr, 'onboarding_2_text'.tr),
        OnBoardingModel(Images.onBoarding3, 'grow_with_correct_guidance'.tr, 'onboarding_3_text'.tr),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
