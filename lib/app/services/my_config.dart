import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyConfig {
  static const bool prod = true;
  static const bool build = true;

  static String get apiUrl => dotenv.env[prod ? "API_URL" : "API_URL_STAGING"]!;
  static String get supabaseKey =>
      dotenv.env[prod ? "SUPABASE_KEY" : "SUPABASE_KEY_STAGING"]!;

  static const String keyLocale = "locale";
  static const String keyAccessToken = "accessToken";
  static const String keyRefreshToken = "refreshToken";
  static const String keyEmail = "email";
}
