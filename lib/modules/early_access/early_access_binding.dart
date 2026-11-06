import 'package:get/get.dart';

import 'early_access_controller.dart';

class EarlyAccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarlyAccessController>(
      () => EarlyAccessController(),
      fenix: true,
    );
  }
}
