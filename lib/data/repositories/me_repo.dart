import '../../app/core/base_repository.dart';

class MeRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> me() async => await fetch(endPoint: "/me");

  Future<ResponseHandler<dynamic>> updateProfile({
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/me/update", data: data);

  Future<ResponseHandler<dynamic>> updatePassword({
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/me/update/password", data: data);

  Future<ResponseHandler<dynamic>> myAddress() async =>
      await fetch(endPoint: "/me/my-address");

  Future<ResponseHandler<dynamic>> updateAddress({
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/me/my-address/update", data: data);
}
