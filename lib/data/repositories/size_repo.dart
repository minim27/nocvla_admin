import '../../app/core/base_repository.dart';

class SizeRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> list({dynamic id}) async =>
      await fetch(endPoint: "/master/size?id=${id ?? ""}");

  Future<ResponseHandler<dynamic>> add({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/master/size", data: data);

  Future<ResponseHandler<dynamic>> update({
    required int id,
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/master/size/$id", data: data);

  Future<ResponseHandler<dynamic>> remove({required int id}) async =>
      await putJson(endPoint: "/master/size/$id");
}
