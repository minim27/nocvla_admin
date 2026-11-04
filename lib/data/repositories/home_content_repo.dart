import 'dart:typed_data';

import '../../app/core/base_repository.dart';

class HomeContentRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> getHero() async => ResponseHandler(
    supabase
        .from("m_banners")
        .select()
        .eq("is_active", true)
        .gte("end_date", DateTime.now().toUtc().toIso8601String())
        .order("sort_order", ascending: true)
        .limit(1)
        .maybeSingle(),
  );

  Future<ResponseHandler<dynamic>> addHero({
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_banners").insert(body).select().single(),
  );

  Future<ResponseHandler<dynamic>> updateHero({
    required dynamic id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_banners").update(body).eq("id", id).select().single(),
  );

  Future<ResponseHandler<dynamic>> listSeries() async => ResponseHandler(
    supabase.from("m_series").select().order("sort_order", ascending: true),
  );

  Future<ResponseHandler<dynamic>> deleteAllSeries() async => ResponseHandler(
    supabase
        .from("m_series")
        .delete()
        .neq("id", "00000000-0000-0000-0000-000000000000"),
  );

  Future<ResponseHandler<dynamic>> addSeries({
    required List<Map<String, dynamic>> body,
  }) async => ResponseHandler(supabase.from("m_series").insert(body).select());

  Future<ResponseHandler<String>> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async => ResponseHandler(
    supabase.storage
        .from("banners")
        .uploadBinary(fileName, bytes)
        .then((_) => "banners/$fileName"),
  );
}
