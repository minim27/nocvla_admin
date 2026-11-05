import '../../app/core/base_repository.dart';

class AthleteApplicationRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listApplications({
    required String status,
  }) async => ResponseHandler(
    supabase
        .from("m_athlete_application")
        .select()
        .eq("status", status)
        .order("created_at", ascending: false),
  );

  Future<ResponseHandler<dynamic>> listAllApplications() async =>
      ResponseHandler(
        supabase
            .from("m_athlete_application")
            .select()
            .order("created_at", ascending: false),
      );

  Future<ResponseHandler<dynamic>> detailApplication({
    required String id,
  }) async => ResponseHandler(
    supabase.from("m_athlete_application").select().eq("id", id).single(),
  );

  Future<ResponseHandler<dynamic>> listAllTrainingFocus() async =>
      ResponseHandler(
        supabase
            .from("m_training_focus")
            .select()
            .order("sort_order", ascending: true)
            .order("name", ascending: true),
      );

  Future<ResponseHandler<dynamic>> addTrainingFocus({
    required Map<String, dynamic> body,
  }) async =>
      ResponseHandler(supabase.from("m_training_focus").insert(body).select());

  Future<ResponseHandler<dynamic>> updateTrainingFocus({
    required String id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_training_focus").update(body).eq("id", id).select(),
  );

  Future<ResponseHandler<dynamic>> updateTrainingFocusOrders({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_training_focus").upsert(body).select());

  Future<ResponseHandler<dynamic>> deleteTrainingFocus({
    required String id,
  }) async => ResponseHandler(
    supabase.from("m_training_focus").delete().eq("id", id).select(),
  );

  Future<ResponseHandler<dynamic>> photoUrl({required String path}) async =>
      ResponseHandler(
        supabase.storage.from("applications").createSignedUrl(path, 3600),
      );

  Future<ResponseHandler<dynamic>> updateStatus({
    required String id,
    required String status,
  }) async => ResponseHandler(
    supabase
        .from("m_athlete_application")
        .update({"status": status})
        .eq("id", id)
        .select()
        .single(),
  );
}
