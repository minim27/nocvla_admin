import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_page_header.dart';
import '../../athlete_controller.dart';

class TAthleteHeader extends StatelessWidget {
  const TAthleteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteController>();

    return MyPageHeader(
      title: "Atlet & Pendaftar",
      titleSize: 44,
      actions: [
        MyButton(text: "+ Atlet manual", onTap: () => controller.add()),
      ],
    );
  }
}
