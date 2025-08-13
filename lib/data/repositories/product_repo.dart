import '../../app/core/base_repository.dart';

class ProductRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> list() async =>
      await fetch(endPoint: "/products");

  Future<ResponseHandler<dynamic>> detailProduct({
    required String slug,
  }) async => await fetch(endPoint: "/products/$slug");

  Future<ResponseHandler<dynamic>> addProduct({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/products", data: data);

  Future<ResponseHandler<dynamic>> updateProduct({
    required int id,
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/products/$id", data: data);
}
