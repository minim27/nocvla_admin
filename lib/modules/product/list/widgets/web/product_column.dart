import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_text.dart';

class ProductColumn extends StatelessWidget {
  const ProductColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: MyColors.secondary),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 12,
        children: [
          Expanded(
            flex: 2,
            child: MyText(
              text: "Product",
              color: MyColors.primary,
              fontWeight: .w500,
            ),
          ),
          Expanded(
            child: Center(
              child: MyText(
                text: "Sold",
                color: MyColors.primary,
                fontWeight: .w500,
                textAlign: .center,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MyText(
                text: "Price",
                color: MyColors.primary,
                fontWeight: .w500,
                textAlign: .center,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MyText(
                text: "Stock",
                color: MyColors.primary,
                fontWeight: .w500,
                textAlign: .center,
              ),
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
