import 'package:mentorkhoj/data/datasource/remote/dio/dio_client.dart';
import 'package:mentorkhoj/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mentorkhoj/common/models/api_response_model.dart';
import 'package:mentorkhoj/utill/app_constants.dart';

class CategoryRepo {
  final DioClient dioClient;
  CategoryRepo({required this.dioClient});

  Future<ApiResponseModel> getCategoryList() async {
    try {
      final response = await dioClient.get(AppConstants.categoryUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getSubCategoryList(String parentID) async {
    try {
      final response = await dioClient.get('${AppConstants.subCategoryUri}$parentID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCategoryProductList(String categoryID) async {
    try {
      final response = await dioClient.get('${AppConstants.categoryProductUri}$categoryID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}