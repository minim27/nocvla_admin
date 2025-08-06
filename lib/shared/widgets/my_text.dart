import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.text,
    this.fontFamily = MyFonts.montserrat,
    this.textAlign,
    this.color = MyColors.secondary,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
    this.namedArgs,
  });

  final String text;
  final String fontFamily;
  final TextAlign? textAlign;
  final Color color;
  final double fontSize;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final Map<String, String>? namedArgs;

  @override
  Widget build(BuildContext context) {
    return Text(
      (namedArgs == null) ? text.tr : text.tr.trParams(namedArgs!),
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        overflow: overflow,
        color: color,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        fontStyle: fontStyle,
        decorationColor: color,
      ),
    );
  }
}

TextSpan myTextSpan({
  required String text,
  Color color = MyColors.secondary,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  double? letterSpacing,
  String fontFamily = MyFonts.montserrat,
  TextDecoration? decoration,
  FontStyle? fontStyle,
  Map<String, String>? namedArgs,
  void Function()? onTap,
}) {
  return TextSpan(
    text: (namedArgs == null) ? text.tr : text.trParams(namedArgs),
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
      decoration: decoration,
      fontStyle: fontStyle,
      decorationColor: color,
    ),
    recognizer: onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null,
  );
}
