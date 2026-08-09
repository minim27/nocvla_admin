import 'dart:typed_data';

import '../../app/core/base_repository.dart';

class EarlyAccessRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> getSettings() async =>
      ResponseHandler(supabase.from("m_app_settings").select().single());

  Future<ResponseHandler<dynamic>> updateSettings({
    required dynamic id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_app_settings").update(body).eq("id", id).select().single(),
  );

  Future<ResponseHandler<dynamic>> setPassword({
    required String newPassword,
  }) async => ResponseHandler(
    supabase.rpc("set_early_access_password", params: {"new_password": newPassword}),
  );

  Future<ResponseHandler<dynamic>> listImages() async => ResponseHandler(
    supabase
        .from("m_early_access_images")
        .select()
        .order("sort_order", ascending: true),
  );

  Future<ResponseHandler<dynamic>> addImages({
    required List<Map<String, dynamic>> body,
  }) async => ResponseHandler(
    supabase.from("m_early_access_images").insert(body).select(),
  );

  Future<ResponseHandler<dynamic>> deleteAllImages() async => ResponseHandler(
    supabase
        .from("m_early_access_images")
        .delete()
        .neq("id", "00000000-0000-0000-0000-000000000000"),
  );

  Future<ResponseHandler<String>> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async => ResponseHandler(
    supabase.storage
        .from("early_access")
        .uploadBinary(fileName, bytes)
        .then((_) => "early_access/$fileName"),
  );
}
