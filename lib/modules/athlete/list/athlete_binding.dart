import 'package:get/get.dart';

import 'athlete_controller.dart';

class AthleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AthleteController>(() => AthleteController());
  }
}
