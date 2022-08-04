import 'package:flutter/material.dart';
import 'package:shopping/framework/repository/product/contarct/product_repository.dart';
import 'package:shopping/framework/repository/product/model/product_list_response_model.dart';
import 'package:shopping/framework/repository/product/repository/product_repository_builder.dart';
import 'package:shopping/utils/apis/api_end_points.dart';
import 'package:shopping/utils/apis/api_result.dart';
import 'package:shopping/utils/apis/network_exceptions.dart';
import 'package:shopping/utils/theme_const.dart';

class ProductController extends ChangeNotifier {

  clearProvider(){
    isLoading = false;
    isLoadingPagination = false;
    isError = false;

    pageNo = 1;
    productListResponseModel = null;
    arrProduct = [];

    notifyListeners();
  }

  bool isLoading = false;
  bool isLoadingPagination = false;
  bool isError = false;

  ///Update Is Loading
  void updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  ///Update Is Loading
  void updateIsLoadingPagination(bool value) {
    isLoadingPagination = value;
    notifyListeners();
  }

  ///Update Is Error
  void updateIsError(bool value) {
    isError = value;
    notifyListeners();
  }

  final ProductRepository _productRepository = ProductRepositoryBuilder.repository();

  ProductListResponseModel? productListResponseModel;
  List<ProductData> arrProduct = [];
  int pageNo = 1;
  ///Product List Api
  Future<void> getProductListApi(BuildContext context) async {
    bool hasNextPage = ((productListResponseModel?.totalPage ?? 0) > pageNo);
    pageNo = (hasNextPage == true) ? (pageNo + 1) : 1;
    if(pageNo == 1){
      productListResponseModel = null;
      arrProduct = [];
    }

    (pageNo == 1) ? updateIsLoading(true) : updateIsLoadingPagination(true);
    updateIsError(false);

    Map<String, dynamic> _request = {
      "page": pageNo,
      "perPage": 5
    };

    ApiResult apiResult = await _productRepository.getProductList(context, _request);

    apiResult.when(success: (data) async {

      (pageNo == 1) ? updateIsLoading(false) : updateIsLoadingPagination(false);
      productListResponseModel = data as ProductListResponseModel;

      if(productListResponseModel?.status == ApiEndPoints.apiStatus_200){
        arrProduct.addAll(productListResponseModel?.data ?? []);
      }
      else{
        updateIsError(true);
        showMessageDialog(context, productListResponseModel?.message ?? "", null);
      }
    }, failure: (NetworkExceptions error) {
      (pageNo == 1) ? updateIsLoading(false) : updateIsLoadingPagination(false);
      updateIsError(true);

      String errorMsg = NetworkExceptions.getErrorMessage(error);
      showMessageDialog(context, errorMsg, null);
    });
    notifyListeners();
  }
}