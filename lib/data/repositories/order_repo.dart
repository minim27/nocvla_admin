import '../../app/core/base_repository.dart';

class OrderRepository extends BaseRepository {
  Future<ResponseHandler<dynamic>> listCart() async =>
      await fetch(endPoint: "/order/cart");

  Future<ResponseHandler<dynamic>> addToCart({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/order/cart/add", data: data);

  Future<ResponseHandler<dynamic>> updateCart({
    required int id,
    required Map<String, dynamic> data,
  }) async => await putJson(endPoint: "/order/cart/update/$id", data: data);

  Future<ResponseHandler<dynamic>> removeCart({required int id}) async =>
      await delete(endPoint: "/order/cart/remove/$id");

  Future<ResponseHandler<dynamic>> paymentMethod() async =>
      await fetch(endPoint: "/order/payment-methods");

  Future<ResponseHandler<dynamic>> checkout({
    required Map<String, dynamic> data,
  }) async => await postJson(endPoint: "/order/cart/checkout", data: data);
}
