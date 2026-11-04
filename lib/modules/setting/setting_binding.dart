import 'package:get/get.dart';

import 'setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<SettingController>()) {
      Get.find<SettingController>().fetchApi();
      return;
    }

    Get.put<SettingController>(SettingController(), permanent: true);
  }
}
