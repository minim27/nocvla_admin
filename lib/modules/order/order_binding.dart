import 'package:get/get.dart';

import 'order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<OrderController>()) {
      Get.find<OrderController>().fetchApi();
      return;
    }

    Get.put<OrderController>(OrderController(), permanent: true);
  }
}
