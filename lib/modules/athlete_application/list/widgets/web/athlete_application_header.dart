import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_text.dart';

class AthleteApplicationHeader extends StatelessWidget {
  const AthleteApplicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: "Athlete Applications",
      fontSize: 24,
      fontFamily: MyFonts.libreBaskerville,
    );
  }
}
