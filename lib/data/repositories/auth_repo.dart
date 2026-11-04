import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/core/base_repository.dart';

class AuthRepo extends BaseRepository {
  User? get currentUser => supabase.auth.currentUser;

  bool get isAdmin => currentUser?.appMetadata["role"] == "admin";

  Future<ResponseHandler<AuthResponse>> signIn({
    required String email,
    required String password,
  }) async => ResponseHandler(
    supabase.auth.signInWithPassword(email: email, password: password),
  );

  Future<ResponseHandler<void>> signOut() async =>
      ResponseHandler(supabase.auth.signOut());
}
