import 'dart:typed_data';

import '../../app/core/base_repository.dart';

class AthleteRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listAthletes() async => ResponseHandler(
    supabase.from("m_athlete").select().order("created_at", ascending: false),
  );

  Future<ResponseHandler<dynamic>> detailAthlete({required String id}) async =>
      ResponseHandler(
        supabase.from("m_athlete").select().eq("id", id).single(),
      );

  Future<ResponseHandler<dynamic>> addAthlete({
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_athlete").insert(body).select().single(),
  );

  Future<ResponseHandler<dynamic>> updateAthlete({
    required String id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_athlete").update(body).eq("id", id).select().single(),
  );

  Future<ResponseHandler<dynamic>> deleteAthlete({required String id}) async =>
      ResponseHandler(supabase.from("m_athlete").delete().eq("id", id));

  Future<ResponseHandler<String>> uploadPicture({
    required Uint8List bytes,
    required String fileName,
  }) async => ResponseHandler(
    supabase.storage
        .from("athletes")
        .uploadBinary(fileName, bytes)
        .then((_) => "athletes/$fileName"),
  );

  Future<ResponseHandler<dynamic>> listAssignments({
    required String athleteId,
  }) async => ResponseHandler(
    supabase
        .from("t_athlete")
        .select('''
      *,
      product:m_products(id, name)
    ''')
        .eq("athlete_id", athleteId),
  );

  Future<ResponseHandler<dynamic>> addAssignments({
    required List<Map<String, dynamic>> body,
  }) async => ResponseHandler(supabase.from("t_athlete").insert(body).select());

  Future<ResponseHandler<dynamic>> deleteAssignments({
    required String athleteId,
  }) async => ResponseHandler(
    supabase.from("t_athlete").delete().eq("athlete_id", athleteId),
  );
}
