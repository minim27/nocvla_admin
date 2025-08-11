import 'package:get/get.dart';

import 'colors_controller.dart';

class ColorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ColorsController>(() => ColorsController());
  }
}
