import 'package:flutter/cupertino.dart';
import 'package:shopping/framework/repository/product/model/cart_response_model.dart';
import 'package:shopping/utils/database/table_product.dart';

class CartController extends ChangeNotifier {

  void clearProvider() {
    arrProduct = [];
    totalItems = 0;
    totalPrice = 0;

    notifyListeners();
  }

  List<CartResponseModel> arrProduct = [];
  Future<void> fillProductList() async {
    arrProduct = await TblProduct.instance.getDataModel();
    updateTotalItems();
    updateTotalPrice();
  }

  void deleteData(int productId) {
    int index = arrProduct.indexWhere((element) => (element.id == productId));
    arrProduct.removeAt(index);
    updateTotalItems();
    updateTotalPrice();
  }

  void updateQuantity(int productId, int quantity) {
    int index = arrProduct.indexWhere((element) => (element.id == productId));
    arrProduct[index].quantity = quantity;
    notifyListeners();
  }

  int totalItems = 0;
  void updateTotalItems() {
    int item = 0;
    for (CartResponseModel element in arrProduct) {
      item += (element.quantity ?? 0);
    }
    totalItems = item;
    print("Total Quantity  $totalItems");
    notifyListeners();
  }

  int totalPrice = 0;
  void updateTotalPrice() {
    int price = 0;
    for (CartResponseModel element in arrProduct) {
      price += (((element.price ?? 0) * (element.quantity ?? 0)));
    }
    totalPrice = price;
    print("Total Price  $totalPrice");
    notifyListeners();
  }


}