import '../../app/core/base_repository.dart';

class OrderRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listOrders() async => ResponseHandler(
    supabase
        .from("t_wa_orders")
        .select('''
      *,
      athlete:m_athlete(code, name),
      items:t_wa_order_items(*)
    ''')
        .order("created_at", ascending: false),
  );

  Future<ResponseHandler<dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    String? athleteCode,
    String? customerName,
    String? customerPhone,
    String? address,
  }) async => ResponseHandler(
    supabase.rpc(
      "create_wa_order",
      params: {
        "p_items": items,
        "p_athlete_code": athleteCode,
        "p_customer_name": customerName,
        "p_customer_phone": customerPhone,
        "p_address": address,
      },
    ),
  );

  Future<ResponseHandler<dynamic>> updateOrder({
    required dynamic id,
    num? shippingFee,
    String? courier,
    String? awb,
    String? status,
  }) async => ResponseHandler(
    supabase.rpc(
      "update_wa_order",
      params: {
        "p_id": id,
        "p_shipping_fee": shippingFee,
        "p_courier": courier,
        "p_awb": awb,
        "p_status": status,
      },
    ),
  );

  Future<ResponseHandler<dynamic>> markPaid({required dynamic id}) async =>
      ResponseHandler(supabase.rpc("mark_order_paid", params: {"p_id": id}));

  Future<ResponseHandler<dynamic>> cancel({required dynamic id}) async =>
      ResponseHandler(supabase.rpc("cancel_order", params: {"p_id": id}));
}
