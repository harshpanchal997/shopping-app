import 'package:shopping/framework/controller/product/cart_controller.dart';
import 'package:shopping/framework/controller/product/product_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = ChangeNotifierProvider((ref) => ProductController());
final cartProvider = ChangeNotifierProvider((ref) => CartController());