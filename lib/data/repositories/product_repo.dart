import '../../app/core/base_repository.dart';

class ProductRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> detailProduct({required String slug}) async =>
      await fetch(endPoint: "/products/$slug");
}
