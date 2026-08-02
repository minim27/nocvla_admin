import 'package:get/get.dart';

import 'athlete_application_detail_controller.dart';

class AthleteApplicationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AthleteApplicationDetailController>(
      () => AthleteApplicationDetailController(),
      fenix: true,
    );
  }
}
