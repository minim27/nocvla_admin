import 'dart:typed_data';

import '../../app/core/base_repository.dart';

class ProductsRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listProducts({
    String? name,
    String? typeId,
  }) async {
    var query = supabase.from("m_product_color").select('''
      id, name, product_id,
      product:m_products!inner(id, name, is_featured, product_type_id),
      images:m_product_images(image_url, sort_order),
      variation:m_product_stock(size, qty, price)
    ''');

    if (name != null && name.isNotEmpty) {
      query = query.ilike("product.name", "%$name%");
    }
    if (typeId != null && typeId.isNotEmpty) {
      query = query.eq("product.product_type_id", typeId);
    }

    return ResponseHandler(
      query.order("sort_order", ascending: true, referencedTable: "images"),
    );
  }

  Future<ResponseHandler<dynamic>> detailProductWithColors({
    required String id,
  }) async => ResponseHandler(
    supabase
        .from("m_products")
        .select('''
      *,
      colors:m_product_color(
        id, name,
        images:m_product_images(image_url, sort_order),
        variation:m_product_stock(size, qty, price)
      )
    ''')
        .eq("id", id)
        .order("sort_order", ascending: true, referencedTable: "colors.images")
        .single(),
  );

  Future<ResponseHandler<dynamic>> listProductNames() async => ResponseHandler(
    supabase.from("m_products").select("id, name").order("name", ascending: true),
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

  Future<ResponseHandler<dynamic>> addColor({
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_product_color").insert(body).select().single(),
  );

  Future<ResponseHandler<dynamic>> deleteColor({required String id}) async =>
      ResponseHandler(supabase.from("m_product_color").delete().eq("id", id));

  Future<ResponseHandler<dynamic>> listProductColorIds({
    required String productId,
  }) async => ResponseHandler(
    supabase.from("m_product_color").select("id").eq("product_id", productId),
  );

  Future<ResponseHandler<dynamic>> deleteProductColorsByProduct({
    required String productId,
  }) async => ResponseHandler(
    supabase.from("m_product_color").delete().eq("product_id", productId),
  );

  Future<ResponseHandler<dynamic>> addImages({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_product_images").insert(body).select());

  Future<ResponseHandler<dynamic>> deleteProductImages({
    required String productColorId,
  }) async => ResponseHandler(
    supabase
        .from("m_product_images")
        .delete()
        .eq("product_color_id", productColorId),
  );

  Future<ResponseHandler<dynamic>> addStocks({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_product_stock").insert(body).select());

  Future<ResponseHandler<dynamic>> deleteProductStocks({
    required String productColorId,
  }) async => ResponseHandler(
    supabase
        .from("m_product_stock")
        .delete()
        .eq("product_color_id", productColorId),
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
