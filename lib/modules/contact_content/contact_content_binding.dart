import 'package:get/get.dart';

import 'contact_content_controller.dart';

class ContactContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactContentController>(
      () => ContactContentController(),
      fenix: true,
    );
  }
}
