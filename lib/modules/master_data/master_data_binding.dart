import 'package:get/get.dart';

import 'master_data_controller.dart';

class MasterDataBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<MasterDataController>()) {
      Future.microtask(Get.find<MasterDataController>().fetchApi);
      return;
    }

    Get.put<MasterDataController>(MasterDataController(), permanent: true);
  }
}
