import '../../app/core/base_repository.dart';

class ConfigRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listConfigs() async =>
      ResponseHandler(supabase.from("m_configurations").select());

  Future<ResponseHandler<dynamic>> addConfig({
    required String name,
    required String value,
  }) async => ResponseHandler(
    supabase.from("m_configurations").insert({"name": name, "value": value}),
  );

  Future<ResponseHandler<dynamic>> updateConfig({
    required dynamic id,
    required String value,
  }) async => ResponseHandler(
    supabase
        .from("m_configurations")
        .update({"value": value})
        .eq("id", id)
        .select(),
  );
}
