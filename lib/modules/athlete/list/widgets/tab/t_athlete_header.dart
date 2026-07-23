import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_controller.dart';

class TAthleteHeader extends StatelessWidget {
  const TAthleteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteController>();

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        MyText(
          text: "Athlete",
          fontSize: 22,
          fontFamily: MyFonts.libreBaskerville,
        ),
        MyButton(width: 100, text: "Add", onTap: () => controller.add()),
      ],
    );
  }
}
