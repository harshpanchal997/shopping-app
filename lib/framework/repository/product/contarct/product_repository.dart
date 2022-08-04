
import 'package:flutter/material.dart';

abstract class ProductRepository {

  Future getProductList(BuildContext context, Map<String, dynamic> _request);

}