import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import 'my_text.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.width,
    this.height = 44,
    required this.text,
    this.color = MyColors.secondary,
    this.textColor = MyColors.primary,
    this.borderColor,
    this.fontSize = 14,
    this.borderRadius = 0,
    this.fontWeight = FontWeight.w700,
    this.namedArgs,
    this.enable = true,
    required this.onTap,
  });

  final bool enable;
  final double? width;
  final double height, fontSize, borderRadius;
  final String text;
  final Color color, textColor;
  final Color? borderColor;
  final FontWeight fontWeight;
  final Map<String, String>? namedArgs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      child: Container(
        width: width,
        height: height,
        padding: const .symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: enable ? color : MyColors.border,
          border: (borderColor == null) ? null : .all(color: borderColor!),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          widthFactor: 1,
          child: MyText(
            textAlign: TextAlign.center,
            text: (namedArgs == null)
                ? text.tr.toUpperCase()
                : text.tr.trParams(namedArgs!).toUpperCase(),
            color: enable ? textColor : MyColors.secondary,
            fontFamily: MyFonts.archivoNarrow,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: fontSize * 0.12,
          ),
        ),
      ),
    );
  }
}
