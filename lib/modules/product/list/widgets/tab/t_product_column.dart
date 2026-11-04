import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_panel.dart';

class TProductColumn extends StatelessWidget {
  const TProductColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: MyColors.primary90,
        border: .all(color: MyColors.line),
      ),
      child: Row(
        spacing: 12,
        children: [
          SizedBox(width: 28),
          Expanded(child: MyTableLabel(text: "Produk")),
          SizedBox(
            width: 88,
            child: MyTableLabel(text: "Aksi", textAlign: .right),
          ),
        ],
      ),
    );
  }
}
