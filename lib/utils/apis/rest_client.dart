import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping/utils/theme_const.dart';
import 'dio_logger.dart';

class RestClient {
  static var dio = Dio();

  final String _token = "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz";

  static Future<Response> getData(BuildContext context, String endpoint) async {
    try {
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.get(endpoint);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<Response> postData(BuildContext context, String endpoint, Map<String, dynamic> req) async {
    try {
      String data = jsonEncode(req);
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.post(endpoint, data: data);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<Response> postForm(BuildContext context, String endpoint, FormData formData) async {
    try {
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.post(endpoint, data: formData);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<Response> putData(BuildContext context, String endpoint, Map<String, dynamic> req, {String? s, String? userId}) async {
    try {
      String data = jsonEncode(req);
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.put(endpoint, data: data);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<Response> putForm(BuildContext context, String endpoint, FormData formData) async {
    try {
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.put(endpoint, data: formData);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<Response> deleteData(BuildContext context, String endpoint, Map<String, dynamic> req) async {

    try {
      String data = jsonEncode(req);
      String token = getUserAccessToken();

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        //"Accept-Language": getAppLanguage(),
      };

      if(token != ""){
        headers.addAll({"token": token});
      }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.delete(endpoint, data: data);
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

}
