import 'package:dio/dio.dart';

import '../../../app/core/base_repository.dart';

class MiscRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> upload({required FormData data}) async =>
      await postForm(endPoint: "/misc/upload", data: data);
}
