import 'package:get/get.dart';

import 'about_content_controller.dart';

class AboutContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutContentController>(
      () => AboutContentController(),
      fenix: true,
    );
  }
}
