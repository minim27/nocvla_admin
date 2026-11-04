import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyStockCell extends StatelessWidget {
  const MyStockCell({super.key, required this.qty});

  final int? qty;

  @override
  Widget build(BuildContext context) {
    final color = switch (qty) {
      null => MyColors.primary80,
      0 => MyColors.redText,
      <= 2 => MyColors.yellow,
      _ => MyColors.green,
    };

    return Container(
      width: 46,
      height: 30,
      alignment: .center,
      decoration: BoxDecoration(border: .all(color: MyColors.line)),
      child: MyText(
        text: qty == null ? "-" : "$qty",
        color: color,
        fontSize: 13,
        fontWeight: .w700,
      ),
    );
  }
}
