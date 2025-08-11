import 'package:get/get.dart';

import 'size_controller.dart';

class SizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SizeController>(() => SizeController());
  }
}
