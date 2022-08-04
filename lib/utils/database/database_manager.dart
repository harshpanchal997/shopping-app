import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shopping/utils/database/table_product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

// const String tblName = "emp_track";
// const String tbl_const_data = "tbl_const_data";
// const String tbl_money_trip = "tbl_money_trip";
// const String columnId = "id";
// const String columnName = "name";
// const String columnMobile = "mobile";

class DBManager {
  DBManager._privateConstructor();
  static final DBManager instance = DBManager._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    var databaseDirectory = await Directory("${dir.path}/database").create(recursive: true);
    var path = databaseDirectory.path + "/shopping.db";

    print("Database Path - $path");

    var database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print("ON Create Called++++++");
          _database = db;
          // db.execute('''
          // create table $tblName (
          // $columnId integer primary key autoincrement,
          // $columnName text not null,
          // $columnMobile text not null)
          // ''');

          await TblProduct.instance.createTable();
        },
        onOpen: (db) {
          print('On Open Database Called++++++++');
        }
    );
    _database = database;
    return database;
  }

/*Future<List<Map<String, dynamic>>> getTestData() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');//DESC
    var result = await db.query(tblName, orderBy: '$columnId ASC');
    print("Fetched Data - $result");
    return result;
  }

  Future<int> insertTestData(TestModel model) async {
    Database db = await this.database;
    var result = await db.insert(tblName, model.toJson());
    return result;
  }

  Future<int> updateTodo(TestModel model) async {
    var db = await this.database;
    var result = await db.update(tblName, model.toJson(), where: '$columnId = ?', whereArgs: [model.id]);
    return result;
  }

  Future<int> deleteTestData(String id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tblName WHERE $columnId = $id');
    return result;
  }*/


}