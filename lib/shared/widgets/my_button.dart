import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.width,
    this.height = 40,
    required this.text,
    this.color = MyColors.secondary,
    this.textColor = MyColors.primary,
    this.fontSize = 14,
    this.borderRadius = 6,
    this.fontWeight = FontWeight.w600,
    this.namedArgs,
    this.enable = true,
    required this.onTap,
  });

  final bool enable;
  final double? width;
  final double height, fontSize, borderRadius;
  final String text;
  final Color color, textColor;
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
        decoration: BoxDecoration(
          color: enable ? color : MyColors.primary80,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: MyText(
            textAlign: TextAlign.center,
            text: text.tr,
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            namedArgs: namedArgs,
          ),
        ),
      ),
    );
  }
}

// class MyIconButton extends StatelessWidget {
//   const MyIconButton({
//     super.key,
//     this.width,
//     this.height = 40,
//     required this.icon,
//     required this.text,
//     this.color = MyColors.primaryDefault,
//     this.textColor = MyColors.bwWhite,
//     this.fontSize = 14,
//     this.borderRadius = 6,
//     this.fontWeight = FontWeight.w600,
//     this.namedArgs,
//     this.enable = true,
//     required this.onTap,
//   });

//   final bool enable;
//   final double? width;
//   final double height, fontSize, borderRadius;
//   final String text, icon;
//   final Color color, textColor;
//   final FontWeight fontWeight;
//   final Map<String, String>? namedArgs;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: enable ? onTap : null,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: enable ? color : MyColors.bwGrayDark,
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 6,
//           children: [
//             MyImageAssets(assets: icon),
//             MyText(
//               text: text.tr,
//               color: textColor,
//               fontSize: fontSize,
//               fontWeight: fontWeight,
//               namedArgs: namedArgs,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyButtonBorder extends StatelessWidget {
//   const MyButtonBorder({
//     super.key,
//     this.borderRadius = 6,
//     this.height = 40,
//     this.color = MyColors.primaryDefault,
//     required this.text,
//     required this.onTap,
//     this.fontSize = 14,
//     this.namedArgs,
//     this.fontWeight = FontWeight.w600,
//   });

//   final Color color;
//   final double borderRadius, fontSize, height;
//   final String text;
//   final FontWeight fontWeight;
//   final Map<String, String>? namedArgs;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius),
//           border: Border.all(color: color),
//         ),
//         child: Center(
//           child: MyText(
//             text: text,
//             color: color,
//             fontSize: fontSize,
//             fontWeight: fontWeight,
//             namedArgs: namedArgs,
//           ),
//         ),
//       ),
//     );
//   }
// }
