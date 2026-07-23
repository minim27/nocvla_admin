import 'package:get_storage/get_storage.dart';

import '../../app/services/my_config.dart';

class MyGetStorage {
  static final GetStorage _storage = GetStorage();

  static setValue({required String key, required dynamic value}) async {
    if (value == null) {
      _storage.remove(key);
    } else {
      _storage.write(key, value);
    }
  }

  static getInt({required String key}) async => _storage.read<int>(key);

  static getString({required String key}) async => _storage.read<String>(key);

  static getBool({required String key}) async => _storage.read<bool>(key);

  static clearAll() async {
    // await FirebaseMessaging.instance.deleteToken();

    MyGetStorage.clearByKey(key: MyConfig.keyAccessToken);
    MyGetStorage.clearByKey(key: MyConfig.keyRefreshToken);
    MyGetStorage.clearByKey(key: MyConfig.keyEmail);
  }

  static clearByKey({required String key}) async => _storage.remove(key);
}
