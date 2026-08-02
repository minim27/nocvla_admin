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

  Future<ResponseHandler<dynamic>> detailApplication({
    required String id,
  }) async => ResponseHandler(
    supabase.from("m_athlete_application").select().eq("id", id).single(),
  );

  Future<ResponseHandler<dynamic>> updateStatus({
    required String id,
    required String status,
  }) async => ResponseHandler(
    supabase
        .from("m_athlete_application")
        .update({"status": status})
        .eq("id", id),
  );
}
