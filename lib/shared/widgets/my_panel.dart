import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import 'my_text.dart';

class MyPanel extends StatelessWidget {
  const MyPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: MyColors.primary90,
        border: .all(color: MyColors.line),
      ),
      child: child,
    );
  }
}

class MySectionTitle extends StatelessWidget {
  const MySectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: text.toUpperCase(),
      fontFamily: MyFonts.archivoNarrow,
      fontSize: 15,
      fontWeight: .w700,
      letterSpacing: 2.4,
    );
  }
}

class MyTableLabel extends StatelessWidget {
  const MyTableLabel({super.key, required this.text, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: text.toUpperCase(),
      color: MyColors.primary60,
      fontSize: 12,
      fontWeight: .w600,
      letterSpacing: 1.2,
      textAlign: textAlign,
    );
  }
}
