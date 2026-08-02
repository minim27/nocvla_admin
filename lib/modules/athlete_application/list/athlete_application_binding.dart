import 'package:get/get.dart';

import 'athlete_application_controller.dart';

class AthleteApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AthleteApplicationController>(
      () => AthleteApplicationController(),
      fenix: true,
    );
  }
}
