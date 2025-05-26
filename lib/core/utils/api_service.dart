import 'package:dio/dio.dart';


class ApiUrl {
  static const baseUrl = "https://student.valuxapps.com/api/";
  static const banners = "banners";
  static const categories = "categories";
  static const favorite = "favorites";
  static const cart = "carts";
  static const search = "products/search";
  static const faqs = "faqs";
  static const products = "products";
  static const productDetails = "products/{id}";
}

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postData({
    required String path,
    required Map<String, dynamic> data,
    String token = '',
  }) {
    dio.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return dio.post(path, data: data);
  }

  static Future<Response> putData({
    required String path,
    required Map<String, dynamic> data,
    required String token,
  }) {
    dio.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return dio.put(path, data: data);
  }

  static Future<Response> getData({
    required String path,
    String token = '',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters, required String Token,
  }) {
    dio.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return dio.get(path, queryParameters: queryParameters);
  }
}