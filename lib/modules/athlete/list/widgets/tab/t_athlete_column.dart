import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_text.dart';

class TAthleteColumn extends StatelessWidget {
  const TAthleteColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: MyColors.secondary),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 8,
        children: [
          Expanded(
            child: MyText(
              text: "Photo",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            flex: 2,
            child: MyText(
              text: "Name",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            child: MyText(
              text: "Code",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            child: MyText(
              text: "Action",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }
}
