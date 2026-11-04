import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyEmptyState extends StatelessWidget {
  const MyEmptyState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: MyText(
          text: text,
          color: MyColors.primary60,
          textAlign: .center,
        ),
      ),
    );
  }
}
