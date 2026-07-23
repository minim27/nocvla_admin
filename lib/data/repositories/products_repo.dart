import 'dart:typed_data';

import '../../app/core/base_repository.dart';

class ProductsRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listProducts({
    String? name,
    String? typeId,
  }) async {
    var query = supabase.from("m_products").select('''
      *,
      images:m_product_images(image_url, is_main, sort_order),
      variation:m_product_stock(size, qty, price)
    ''');

    if (name != null && name.isNotEmpty) query = query.ilike("name", "%$name%");
    if (typeId != null && typeId.isNotEmpty) {
      query = query.eq("product_type_id", typeId);
    }

    return ResponseHandler(
      query
          .order("name", ascending: true)
          .order("sort_order", referencedTable: "images"),
    );
  }

  Future<ResponseHandler<dynamic>> detailProduct({required String id}) async =>
      ResponseHandler(
        supabase
            .from("m_products")
            .select('''
      *,
      images:m_product_images(image_url, is_main, sort_order),
      variation:m_product_stock(size, qty, price)
    ''')
            .eq("id", id)
            .order("sort_order", referencedTable: "images")
            .single(),
      );

  Future<ResponseHandler<dynamic>> addProduct({
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_products").insert(body).select().single(),
  );

  Future<ResponseHandler<dynamic>> deleteProduct({required String id}) async =>
      ResponseHandler(supabase.from("m_products").delete().eq("id", id));

  Future<ResponseHandler<dynamic>> updateProduct({
    required String id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_products").update(body).eq("id", id).select().single(),
  );

  Future<ResponseHandler<dynamic>> addImages({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_product_images").insert(body).select());

  Future<ResponseHandler<dynamic>> deleteProductImages({
    required String productId,
  }) async => ResponseHandler(
    supabase.from("m_product_images").delete().eq("product_id", productId),
  );

  Future<ResponseHandler<dynamic>> addStocks({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_product_stock").insert(body).select());

  Future<ResponseHandler<dynamic>> deleteProductStocks({
    required String productId,
  }) async => ResponseHandler(
    supabase.from("m_product_stock").delete().eq("product_id", productId),
  );

  Future<ResponseHandler<dynamic>> listProductTypes() async => ResponseHandler(
    supabase
        .from("m_product_type")
        .select()
        .eq("is_active", true)
        .order("sort_order"),
  );

  Future<ResponseHandler<String>> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async => ResponseHandler(
    supabase.storage
        .from("products")
        .uploadBinary(fileName, bytes)
        .then((_) => "products/$fileName"),
  );
}
