import '../../app/core/base_repository.dart';

class ContactRepo extends BaseRepository {
  Future<ResponseHandler<dynamic>> listAllContactTopic() async =>
      ResponseHandler(
        supabase
            .from("m_contact_topic")
            .select()
            .order("sort_order", ascending: true)
            .order("name", ascending: true),
      );

  Future<ResponseHandler<dynamic>> addContactTopic({
    required Map<String, dynamic> body,
  }) async =>
      ResponseHandler(supabase.from("m_contact_topic").insert(body).select());

  Future<ResponseHandler<dynamic>> updateContactTopic({
    required String id,
    required Map<String, dynamic> body,
  }) async => ResponseHandler(
    supabase.from("m_contact_topic").update(body).eq("id", id).select(),
  );

  Future<ResponseHandler<dynamic>> updateContactTopicOrders({
    required List<Map<String, dynamic>> body,
  }) async =>
      ResponseHandler(supabase.from("m_contact_topic").upsert(body).select());

  Future<ResponseHandler<dynamic>> deleteContactTopic({
    required String id,
  }) async => ResponseHandler(
    supabase.from("m_contact_topic").delete().eq("id", id).select(),
  );

  Future<ResponseHandler<dynamic>> listFaqs() async => ResponseHandler(
    supabase.from("m_faq").select().order("sort_order", ascending: true),
  );

  Future<ResponseHandler<dynamic>> deleteAllFaqs() async => ResponseHandler(
    supabase
        .from("m_faq")
        .delete()
        .neq("id", "00000000-0000-0000-0000-000000000000"),
  );

  Future<ResponseHandler<dynamic>> addFaqs({
    required List<Map<String, dynamic>> body,
  }) async => ResponseHandler(supabase.from("m_faq").insert(body).select());

  Future<ResponseHandler<dynamic>> listMessages() async => ResponseHandler(
    supabase
        .from("t_contact_messages")
        .select()
        .order("created_at", ascending: false),
  );

  Future<ResponseHandler<dynamic>> listUnreadMessages() async =>
      ResponseHandler(
        supabase.from("t_contact_messages").select("id").eq("status", "unread"),
      );

  Future<ResponseHandler<dynamic>> updateMessageStatus({
    required String id,
    required String status,
  }) async => ResponseHandler(
    supabase
        .from("t_contact_messages")
        .update({"status": status})
        .eq("id", id)
        .select(),
  );
}
