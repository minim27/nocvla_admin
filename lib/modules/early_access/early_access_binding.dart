import 'package:get/get.dart';

import '../home_content/home_content_controller.dart';
import 'early_access_controller.dart';

class EarlyAccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarlyAccessController>(
      () => EarlyAccessController(),
      fenix: true,
    );
    Get.lazyPut<HomeContentController>(
      () => HomeContentController(),
      fenix: true,
    );
  }
}
