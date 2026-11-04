import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import 'my_text.dart';

class MyPageHeader extends StatelessWidget {
  const MyPageHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.titleSize = 44,
    this.actions = const [],
  });

  final String? eyebrow;
  final String title;
  final double titleSize;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: .spaceBetween,
        crossAxisAlignment: .end,
        spacing: 16,
        runSpacing: 16,
        children: [
          Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            spacing: 6,
            children: [
              if (eyebrow != null)
                MyText(text: eyebrow!, color: MyColors.primary60),
              MyText(
                text: title,
                fontFamily: MyFonts.grenzeGotisch,
                fontSize: titleSize,
                fontWeight: .w600,
              ),
            ],
          ),
          if (actions.isNotEmpty)
            Row(mainAxisSize: .min, spacing: 8, children: actions),
        ],
      ),
    );
  }
}

class MyBackLink extends StatelessWidget {
  const MyBackLink({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Icon(Icons.chevron_left, size: 18, color: MyColors.primary60),
          MyText(text: text, color: MyColors.primary60),
        ],
      ),
    );
  }
}
