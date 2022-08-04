import 'dart:convert';
import 'package:shopping/framework/repository/product/model/cart_response_model.dart';
import 'package:shopping/framework/repository/product/model/product_list_response_model.dart';
import 'package:shopping/utils/database/database_const.dart';
import 'package:shopping/utils/database/database_manager.dart';
import 'package:shopping/utils/extensions/datetime_extensions.dart';
import 'package:sqflite/sqflite.dart';

class TblProduct {

  TblProduct._privateConstructor();
  static final TblProduct instance = TblProduct._privateConstructor();

  ///Table Properties
  String tblName = "tbl_product";
  String columnId = "id";
  String columnSlug = "slug";
  String columnTitle = "title";
  String columnDescription = "description";
  String columnPrice = "price";
  String columnFeaturedImage = "featured_image";
  String columnStatus = "status";
  String columnQuantity = "quantity";
  String columnCreatedAt = "created_at";

  ///Create Table Method
  Future<void> createTable() async {
    Database db = await DBManager.instance.database;
//$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    await db.execute('''
        CREATE TABLE $tblName (  
        $columnId INTEGER NOT NULL, 
        $columnSlug TEXT NOT NULL, 
        $columnTitle TEXT NOT NULL, 
        $columnDescription TEXT NOT NULL, 
        $columnPrice INTEGER NOT NULL,
        $columnFeaturedImage TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnQuantity INTEGER NOT NULL,
        $columnCreatedAt TEXT NOT NULL)
        ''');
  }

  ///Insert Record InTo Table
  Future<int> insertTestData(
      int id,
      String slug,
      String title,
      String description,
      int price,
      String featuredImage,
      String status,
      int quantity,
      String createdAt
      ) async {
    Database db = await DBManager.instance.database;

    Map<String, dynamic> data = {
      columnId : id,
      columnSlug : slug,
      columnTitle : title,
      columnDescription : description,
      columnPrice : price,
      columnFeaturedImage : featuredImage,
      columnStatus : status,
      columnQuantity : quantity,
      columnCreatedAt : createdAt
    };

    var result = await db.insert(tblName, data);
    print("Insert into $tblName, result - $result");
    return result;
  }

  ///Delete Data
  Future<int> deleteData(int productId) async {
    Database db = await DBManager.instance.database;
    return await db.delete(tblName, where: '$columnId = ?', whereArgs: [productId]);
  }

  ///Update Data
  Future<int> updateData(CartResponseModel _data) async {
    Database db = await DBManager.instance.database;
    return await db.update(tblName, _data.toJson(), where: '$columnId = ?', whereArgs: [_data.id]);
  }

  ///Get Table Data Method
  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await DBManager.instance.database;

    var result = await db.query(tblName);
    print("Fetched Product Data - $result");
    return result;
  }

  ///Get Table Data With Model
  Future<List<CartResponseModel>> getDataModel() async {
    List<Map<String, dynamic>> tipsData = await TblProduct.instance.getData();
    List<CartResponseModel> model = cartResponseModelFromJson(jsonEncode(tipsData));
    return model;
  }

  ///Truncate Table
  Future<void> truncateTable() async {
    Database db = await DBManager.instance.database;
    await db.execute('''DELETE FROM $tblName''');
  }

}