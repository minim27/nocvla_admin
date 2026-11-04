import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_panel.dart';

class ProductColumn extends StatelessWidget {
  const ProductColumn({super.key});

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
          Expanded(flex: 5, child: MyTableLabel(text: "Produk")),
          Expanded(flex: 3, child: MyTableLabel(text: "Colorway")),
          Expanded(flex: 2, child: MyTableLabel(text: "Harga")),
          Expanded(flex: 2, child: MyTableLabel(text: "Stok")),
          Expanded(flex: 2, child: MyTableLabel(text: "Marketplace")),
          SizedBox(
            width: 88,
            child: MyTableLabel(text: "Aksi", textAlign: .right),
          ),
        ],
      ),
    );
  }
}
