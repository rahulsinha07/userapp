import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mentorkhoj/common/enums/product_filter_type_enum.dart';
import 'package:mentorkhoj/data/datasource/remote/dio/dio_client.dart';
import 'package:mentorkhoj/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mentorkhoj/common/models/api_response_model.dart';
import 'package:mentorkhoj/utill/product_type.dart';
import 'package:mentorkhoj/utill/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/product_model.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponseModel> getAllProductList(int? offset, ProductFilterType type) async {
    try {
      final response = await dioClient!.get('${AppConstants.allProductList}?limit=10&offset=$offset&sort_by=${type.name}');
      return ApiResponseModel.withSuccess(response);

    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponseModel> getItemList(int offset, String? productType) async {
    try {
      String? apiUrl;
      if(productType == ProductType.featuredItem){
        apiUrl = AppConstants.featuredProduct;
      }else if(productType == ProductType.dailyItem){
        apiUrl = AppConstants.dailyItemUri;
      } else if(productType == ProductType.mostReviewed){
        apiUrl = AppConstants.mostReviewedProduct;
      }

      final response = await dioClient!.get('$apiUrl?limit=10&&offset=$offset',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getProductDetails(String productID, bool searchQuery) async {
    try {
      String params = productID;
      if(searchQuery) {
        params = '$productID?attribute=product';
      }
      final response = await dioClient!.get('${AppConstants.productDetailsUri}$params');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchProduct(String productId, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.searchProductUri}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getBrandOrCategoryProductList(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.categoryProductUri}$id');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getFlashDeal(int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.flashDealUri}?limit=10&&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> createProduct(Product product) async {
    try {
      final response = await dioClient!.post(
        AppConstants.createProductUri,
        data: product.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponseModel> saveProductDetails(Product product) async {
    try {
      // Create a new FormData object to handle multipart/form-data requests
      FormData formData = FormData();

      // Add other product fields to the FormData
      formData.fields.addAll([
        MapEntry('id', product.id.toString()),
        MapEntry('name', product.name ?? ''),
        MapEntry('description', product.description ?? ''),
        MapEntry('price', product.price.toString()),
        MapEntry('tax', product.tax.toString()),
        MapEntry('unit', product.unit ?? ''),
        MapEntry('capacity', product.capacity.toString()),
        MapEntry('total_stock', product.totalStock.toString()),
        MapEntry('stock', product.totalStock.toString()),  // map total_stock to stock
        MapEntry('discount', product.discount.toString()),
        MapEntry('discount_type', product.discountType ?? ''),
        MapEntry('tax_type', product.taxType ?? ''),
        MapEntry('maximum_order_quantity', product.maximumOrderQuantity.toString()),
      ]);

      // Handle category_ids as an array of objects (without JSON encoding)
      if (product.categoryIds != null && product.categoryIds!.isNotEmpty) {
        for (int i = 0; i < product.categoryIds!.length; i++) {
          formData.fields.add(MapEntry('category_ids[$i][id]', product.categoryIds![i].id.toString()));
          formData.fields.add(MapEntry('category_ids[$i][position]', (i + 1).toString()));
        }
      }

      // Handle image uploads
      if (product.image != null && product.image!.isNotEmpty) {
        for (int i = 0; i < product.image!.length; i++) {
          File imageFile = File(product.image![i]);
          if (await imageFile.exists()) {
            formData.files.add(MapEntry(
              'images[]',
              await MultipartFile.fromFile(
                imageFile.path,
                filename: imageFile.path.split('/').last,
              ),
            ));
          }
        }
      } else {
        // Set default image if no images are provided
        final ByteData imageData = await rootBundle.load('assets/image/apple_logo.png');
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = '${tempDir.path}/default_image.png';
        final File tempFile = File(tempPath);

        await tempFile.writeAsBytes(imageData.buffer.asUint8List());

        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            tempFile.path,
            filename: 'default_image.png',
          ),
        ));
      }

      // Determine if it's an update or creation based on the presence of an ID
      final bool isUpdate = product.id != null && product.id! > 0;
      final String url = isUpdate
          ? '${AppConstants.createProductUri}/${product.id}'
          : AppConstants.createProductUri;

      Response response;

      if (isUpdate) {
        response = await dioClient!.put(
          url,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );
      } else {
        response = await dioClient!.post(
          url,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );
      }

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


/*
  Future<ApiResponseModel> saveProductDetails(Product product) async {
    try {
      // Create a new FormData object to handle multipart/form-data requests
      FormData formData = FormData();

      // Add other product fields to the FormData
      formData.fields.addAll([
        MapEntry('id', product.id.toString()),
        MapEntry('name', product.name ?? ''),
        MapEntry('description', product.description ?? ''),
        MapEntry('price', product.price.toString()),
        MapEntry('tax', product.tax.toString()),
        MapEntry('unit', product.unit ?? ''),
        MapEntry('capacity', product.capacity.toString()),
        MapEntry('total_stock', product.totalStock.toString()),
        MapEntry('stock', product.totalStock.toString()),  // map total_stock to stock
        MapEntry('discount', product.discount.toString()),
        MapEntry('discount_type', product.discountType ?? ''),
        MapEntry('tax_type', product.taxType ?? ''),
        MapEntry('maximum_order_quantity', product.maximumOrderQuantity.toString()),
      ]);

      // Convert category_ids from a list of objects to a list of integers
      formData.fields.addAll(product.categoryIds!
          .map((category) => MapEntry('category_ids[]', category.id.toString()))
          .toList());

      // Handle image uploads
      if (product.image != null && product.image!.isNotEmpty) {
        for (int i = 0; i < product.image!.length; i++) {
          File imageFile = File(product.image![i]);
          if (await imageFile.exists()) {
            formData.files.add(MapEntry(
              'images[]',
              await MultipartFile.fromFile(
                imageFile.path,
                filename: imageFile.path.split('/').last,
              ),
            ));
          }
        }
      } else {
        // Set default image if no images are provided
        final ByteData imageData = await rootBundle.load('assets/image/apple_logo.png');
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = '${tempDir.path}/default_image.png';
        final File tempFile = File(tempPath);

        await tempFile.writeAsBytes(imageData.buffer.asUint8List());

        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            tempFile.path,
            filename: 'default_image.png',
          ),
        ));
      }

      // Determine if it's an update or creation based on the presence of an ID
      final bool isUpdate = product.id != null && product.id! > 0;
      final String url = isUpdate
          ? '${AppConstants.createProductUri}/${product.id}'
          : AppConstants.createProductUri;

      Response response;

      if (isUpdate) {
        response = await dioClient!.put(
          url,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );
      } else {
        response = await dioClient!.post(
          url,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );
      }

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  Future<ApiResponseModel> saveProductDetails(Product product) async {
    try {
      // Determine if it's an update or a creation based on the presence of an id
      final bool isUpdate = product.id != null && product.id! > 0;
      final String url = isUpdate
          ? '${AppConstants.createProductUri}/${product.id}'  // Update existing product
          : AppConstants.createProductUri; // Create new product

      Response response;

      if (isUpdate) {
        // Use PUT for updating an existing product
        response = await dioClient!.put(
          url,
          data: product.toJson(),
          options: Options(
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
          ),
        );
      } else {
        // Use POST for creating a new product
        response = await dioClient!.post(
          url,
          data: product.toJson(),
          options: Options(
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
          ),
        );
      }

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

   */

/*
  Future<ApiResponseModel> saveProductDetails(Product product) async {
    try {
      final response = await dioClient!.put(
        AppConstants.createProductUri, // Assuming you pass product ID in the URL
        data: product.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

   */



}
