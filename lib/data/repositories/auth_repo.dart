import '../../app/core/base_repository.dart';

class AuthRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> login({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/auth/login", data: data);

  Future<ResponseHandler<dynamic>> forgotPassword({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/auth/forgot-password", data: data);

  Future<ResponseHandler<dynamic>> resetPassword({
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/auth/reset-password", data: data);
}
