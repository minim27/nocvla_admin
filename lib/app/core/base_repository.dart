import 'package:supabase_flutter/supabase_flutter.dart';

class BaseRepository {
  SupabaseClient get supabase => Supabase.instance.client;
}

class ResponseHandler<T> {
  final Future<T> _response;

  ResponseHandler(this._response);

  Future responseHandler({
    required Function(T res) res,
    required Function(dynamic err) err,
  }) async {
    try {
      final response = await _response;
      res(response);
    } catch (e) {
      err(e.toString());
    }
  }
}
