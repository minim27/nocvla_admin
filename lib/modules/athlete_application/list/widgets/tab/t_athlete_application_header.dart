import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_text.dart';

class TAthleteApplicationHeader extends StatelessWidget {
  const TAthleteApplicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: "Athlete Applications",
      fontSize: 22,
      fontFamily: MyFonts.libreBaskerville,
    );
  }
}
