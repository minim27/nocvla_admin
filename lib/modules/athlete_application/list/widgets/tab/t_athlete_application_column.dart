import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_text.dart';

class TAthleteApplicationColumn extends StatelessWidget {
  const TAthleteApplicationColumn({super.key});

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
            flex: 2,
            child: MyText(
              text: "Name",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            child: MyText(
              text: "City",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            child: MyText(
              text: "Created At",
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
