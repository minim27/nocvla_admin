import 'package:get/get.dart';

import 'contact_message_controller.dart';

class ContactMessageBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<ContactMessageController>()) {
      Future.microtask(Get.find<ContactMessageController>().fetchApi);
      return;
    }

    Get.put<ContactMessageController>(
      ContactMessageController(),
      permanent: true,
    );
  }
}
