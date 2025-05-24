import 'package:dio/dio.dart';

import '../model/feature_product.dart';

class ProductService{
  final Dio _dio;
  ProductService(): _dio = Dio(BaseOptions(baseUrl: "https://dummyjson.com"));

  Future<FeatureProduct?> getProducts(int limit) async{
    try{
      final res = await _dio.get("/product?limit=${limit}");
      return FeatureProduct.fromJson(res.data);
    }on DioException catch(e){
      return null;
    }
  }
}