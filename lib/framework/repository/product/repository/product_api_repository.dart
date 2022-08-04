import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopping/framework/repository/product/contarct/product_repository.dart';
import 'package:shopping/framework/repository/product/model/product_list_response_model.dart';
import 'package:shopping/utils/apis/api_end_points.dart';
import 'package:shopping/utils/apis/api_result.dart';
import 'package:shopping/utils/apis/network_exceptions.dart';
import 'package:shopping/utils/apis/rest_client.dart';

class ProductApiRepository implements ProductRepository {

  @override
  Future getProductList(BuildContext context, Map<String, dynamic> _request) async {
    try {
      Response? response = await RestClient.postData(context, ApiEndPoints.productList, _request);
      ProductListResponseModel responseModel = productListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}