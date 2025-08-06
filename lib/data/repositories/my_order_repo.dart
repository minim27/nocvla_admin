import '../../app/core/base_repository.dart';

class MyOrderRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> myOrder() async =>
      await fetch(endPoint: "/me/my-order");

  Future<ResponseHandler<dynamic>> myOrderDetail({required int id}) async =>
      await fetch(endPoint: "/me/my-order/$id");
}
