import 'package:flutter/material.dart';
import 'package:mentorkhoj/common/enums/product_filter_type_enum.dart';
import 'package:mentorkhoj/common/models/api_response_model.dart';
import 'package:mentorkhoj/common/providers/cart_provider.dart';
import 'package:mentorkhoj/common/models/product_model.dart';
import 'package:mentorkhoj/common/reposotories/product_repo.dart';
import 'package:mentorkhoj/features/search/domain/reposotories/search_repo.dart';
import 'package:mentorkhoj/helper/api_checker_helper.dart';
import 'package:mentorkhoj/main.dart';
import 'package:mentorkhoj/utill/product_type.dart';
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  final SearchRepo searchRepo;

  ProductProvider({required this.productRepo, required this.searchRepo});

  ProductModel? _allProductModel;
  Product? _product;
  int? _imageSliderIndex;
  ProductModel? _dailyProductModel;
  ProductModel? _featuredProductModel;
  ProductModel? _mostViewedProductModel;
  ProductFilterType _selectedFilterType = ProductFilterType.latest;

  // New loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Product? get product => _product;
  ProductModel? get allProductModel => _allProductModel;
  ProductModel? get dailyProductModel => _dailyProductModel;
  ProductModel? get featuredProductModel => _featuredProductModel;
  ProductModel? get mostViewedProductModel => _mostViewedProductModel;
  int? get imageSliderIndex => _imageSliderIndex;
  ProductFilterType get selectedFilterType => _selectedFilterType;

  // Existing methods
  Future<void> getAllProductList(int offset, bool reload, {bool isUpdate = true}) async {
    if (reload) {
      _allProductModel = null;

      if (isUpdate) {
        notifyListeners();
      }
    }

    ApiResponseModel? response = await productRepo.getAllProductList(offset, _selectedFilterType);
    if (response.response != null && response.response?.data != null && response.response?.statusCode == 200) {
      if (offset == 1) {
        _allProductModel = ProductModel.fromJson(response.response?.data);
      } else {
        _allProductModel!.totalSize = ProductModel.fromJson(response.response?.data).totalSize;
        _allProductModel!.offset = ProductModel.fromJson(response.response?.data).offset;
        _allProductModel!.products!.addAll(ProductModel.fromJson(response.response?.data).products!);
      }

      notifyListeners();
    } else {
      ApiCheckerHelper.checkApi(response);
    }
  }

  Future<void> getItemList(int offset, {bool isUpdate = true, bool isReload = true, required String? productType}) async {
    if (offset == 1) {
      _dailyProductModel = null;
      _featuredProductModel = null;
      _mostViewedProductModel = null;

      if (isUpdate) {
        notifyListeners();
      }
    }
    ApiResponseModel apiResponse = await productRepo.getItemList(offset, productType);

    if (apiResponse.response?.statusCode == 200) {
      if (offset == 1) {
        if (productType == ProductType.dailyItem) {
          _dailyProductModel = ProductModel.fromJson(apiResponse.response?.data);
        } else if (productType == ProductType.featuredItem) {
          _featuredProductModel = ProductModel.fromJson(apiResponse.response?.data);
        } else if (productType == ProductType.mostReviewed) {
          _mostViewedProductModel = ProductModel.fromJson(apiResponse.response?.data);
        }
      } else {
        if (productType == ProductType.dailyItem) {
          _dailyProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _dailyProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _dailyProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        } else if (productType == ProductType.featuredItem) {
          _featuredProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _featuredProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _featuredProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        } else if (productType == ProductType.mostReviewed) {
          _mostViewedProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _mostViewedProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _mostViewedProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        }
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<Product?> getProductDetails(String productID, {bool searchQuery = false}) async {
    final CartProvider cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    _product = null;
    ApiResponseModel apiResponse = await productRepo.getProductDetails(
      productID, searchQuery,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _product = Product.fromJson(apiResponse.response!.data);
      cartProvider.initData(_product!);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();

    return _product;
  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  void onChangeProductFilterType(ProductFilterType type) {
    _selectedFilterType = type;
    notifyListeners();
  }
  Future<bool> saveProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Directly pass the Product object to the saveProductDetails method
      ApiResponseModel response = await productRepo.saveProductDetails(product);

      // Check for both 200 and 201 status codes as success
      if (response.response != null &&
          (response.response?.statusCode == 200 || response.response?.statusCode == 201)) {
        // Success handling
        return true; // Indicate success
      } else {
        // Error handling
        ApiCheckerHelper.checkApi(response);
        return false; // Indicate failure
      }
    } catch (e) {
      // Exception handling
      return false; // Indicate failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




// New saveProduct method
  /*
  Future<void> saveProduct(Map<String, dynamic> productData) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponseModel response = await productRepo.saveProductDetails(productData as Product); // Assuming this method exists

      if (response.response != null && response.response?.statusCode == 200) {
        // Success handling
        //ScaffoldMessenger.of(context).showSnackBar(
         // SnackBar(content: Text('Product saved successfully!')),
     //   )
    //;
      } else {
        // Error handling
        ApiCheckerHelper.checkApi(response);
      }
    } catch (e) {
      // Exception handling
      //ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text('Failed to save product: $e')),
      //
      //);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   */
}
