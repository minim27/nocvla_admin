import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_text.dart';

class MAthleteApplicationHeader extends StatelessWidget {
  const MAthleteApplicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: "Athlete Applications",
      fontSize: 20,
      fontFamily: MyFonts.libreBaskerville,
    );
  }
}
