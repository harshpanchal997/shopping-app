import 'package:shopping/framework/repository/product/contarct/product_repository.dart';
import 'package:shopping/framework/repository/product/repository/product_api_repository.dart';

class ProductRepositoryBuilder {
  static ProductRepository repository() {
    return ProductApiRepository();
  }
}