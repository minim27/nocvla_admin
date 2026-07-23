import 'package:get/get.dart';

import 'athlete_detail_controller.dart';

class AthleteDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AthleteDetailController>(
      () => AthleteDetailController(),
      fenix: true,
    );
  }
}
