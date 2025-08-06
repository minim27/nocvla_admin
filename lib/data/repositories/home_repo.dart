import '../../app/core/base_repository.dart';

class HomeRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> home() async =>
      await fetch(endPoint: "/homepage");
}
