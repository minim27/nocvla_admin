import '../../app/core/base_repository.dart';

class BankRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> type() async =>
      await fetch(endPoint: "/master/bank/type");

  Future<ResponseHandler<dynamic>> list({dynamic type, dynamic id}) async =>
      await fetch(endPoint: "/master/bank?type=${type ?? ""}&id=${id ?? ""}");

  Future<ResponseHandler<dynamic>> add({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/master/bank", data: data);

  Future<ResponseHandler<dynamic>> update({
    required int id,
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/master/bank/$id", data: data);

  Future<ResponseHandler<dynamic>> remove({required int id}) async =>
      await putJson(endPoint: "/master/bank/$id");
}
