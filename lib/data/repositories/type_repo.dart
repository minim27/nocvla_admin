import '../../app/core/base_repository.dart';

class TypeRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> list() async =>
      await fetch(endPoint: "/master/type");

  Future<ResponseHandler<dynamic>> add({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/master/type", data: data);

  Future<ResponseHandler<dynamic>> update({
    required int id,
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/master/type/$id", data: data);

  Future<ResponseHandler<dynamic>> remove({required int id}) async =>
      await putJson(endPoint: "/master/type/$id");
}
