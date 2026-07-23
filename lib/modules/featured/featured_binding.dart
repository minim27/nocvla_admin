import 'package:get/get.dart';

import 'featured_controller.dart';

class FeaturedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeaturedController>(() => FeaturedController(), fenix: true);
  }
}
