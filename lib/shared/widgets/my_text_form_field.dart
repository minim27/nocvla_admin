import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.borderRadius = 6,
    this.label,
    this.hintText,
    this.maxLines = 1,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.labelFontSize = 14,
    this.labelFontWeight = FontWeight.w400,
    this.textColor = MyColors.primary,
    this.labelColor = MyColors.secondary,
    this.borderColor = MyColors.secondary,
    this.isPassword = false,
    this.obscureText = true,
    this.required = false,
    this.icPassOnTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.tapped = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
  });

  final TextEditingController? controller;
  final int maxLines;
  final String? label, errorText, hintText;
  final double borderRadius, labelFontSize;
  final FontWeight labelFontWeight;
  final Color textColor, labelColor, borderColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword, obscureText;
  final VoidCallback? icPassOnTap;
  final ValueChanged<String>? onChanged, onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled, tapped, required;
  final Widget? prefixIcon, suffixIcon;
  final VoidCallback? onTap;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.label != null,
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: (widget.label == null) ? "" : widget.label!.tr,
                      style: TextStyle(
                        color: widget.labelColor,
                        fontFamily: MyFonts.montserrat,
                        fontSize: widget.labelFontSize,
                        fontWeight: widget.labelFontWeight,
                      ),
                    ),
                    TextSpan(
                      text: (widget.required) ? " *" : "",
                      style: TextStyle(
                        color: MyColors.red,
                        fontFamily: MyFonts.montserrat,
                        fontSize: widget.labelFontSize,
                        fontWeight: widget.labelFontWeight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: widget.enabled
                  ? MyColors.secondary
                  : MyColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              enabled: (widget.tapped) ? false : widget.enabled,
              obscureText: widget.isPassword ? widget.obscureText : false,
              keyboardType: widget.isPassword
                  ? TextInputType.visiblePassword
                  : widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: TextStyle(
                fontSize: 14,
                fontFamily: MyFonts.montserrat,
                color: widget.textColor,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 14,
                  top:
                      (widget.isPassword ||
                          widget.suffixIcon != null ||
                          widget.prefixIcon != null)
                      ? 14
                      : 0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: (widget.hintText != null)
                    ? widget.hintText!.tr
                    : "".tr,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: MyFonts.montserrat,
                  color: MyColors.primary60,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                prefixIcon: widget.prefixIcon,
                suffixIcon: (widget.isPassword)
                    ? InkWell(
                        onTap: widget.icPassOnTap,
                        child: Icon(
                          (widget.obscureText)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MyColors.primary,
                        ),
                      )
                    : widget.suffixIcon,
              ),
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}

class MyTextFormFieldNoBorder extends StatelessWidget {
  const MyTextFormFieldNoBorder({
    super.key,
    required this.controller,
    this.textAlign = TextAlign.center,
    this.textColor = MyColors.primary,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  });

  final TextEditingController controller;
  final TextAlign textAlign;
  final Color textColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: MyFonts.montserrat,
        color: textColor,
        fontWeight: fontWeight,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: onChanged,
    );
  }
}

// class MyTextFormField2 extends StatefulWidget {
//   const MyTextFormField2({
//     super.key,
//     this.controller,
//     this.label,
//     this.hintText,
//     this.maxLines = 1,
//     this.errorText,
//     this.keyboardType,
//     this.textInputAction,
//     this.labelFontSize = 14,
//     this.labelFontWeight = FontWeight.w400,
//     this.textColor = MyColors.primary,
//     this.labelColor = MyColors.secondary,
//     this.isPassword = false,
//     this.obscureText = true,
//     this.required = true,
//     this.icPassOnTap,
//     this.onChanged,
//     this.onFieldSubmitted,
//     this.inputFormatters,
//     this.enabled = true,
//     this.tapped = false,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.onTap,
//   });

//   final TextEditingController? controller;
//   final int maxLines;
//   final String? label, errorText, hintText;
//   final double labelFontSize;
//   final FontWeight labelFontWeight;
//   final Color textColor, labelColor;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final bool isPassword, obscureText, required;
//   final VoidCallback? icPassOnTap;
//   final ValueChanged<String>? onChanged, onFieldSubmitted;
//   final List<TextInputFormatter>? inputFormatters;
//   final bool enabled, tapped;
//   final Widget? prefixIcon, suffixIcon;
//   final VoidCallback? onTap;

//   @override
//   State<MyTextFormField2> createState() => _MyTextFormField2State();
// }

// class _MyTextFormField2State extends State<MyTextFormField2> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Visibility(
//           visible: widget.label != null,
//           child: Column(
//             children: [
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: (widget.label == null) ? "" : widget.label!.tr,
//                       style: TextStyle(
//                         color: widget.labelColor,
//                         fontFamily: MyFonts.montserrat,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                     TextSpan(
//                       text: (widget.required) ? " *" : "",
//                       style: TextStyle(
//                         color: MyColors.red,
//                         fontFamily: MyFonts.montserrat,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8),
//             ],
//           ),
//         ),
//         InkWell(
//           onTap: widget.onTap,
//           child: Container(
//             decoration: BoxDecoration(
//               color: widget.enabled
//                   ? MyColors.bwWhite.withValues(alpha: 0.03)
//                   : MyColors.bwWhite.withValues(alpha: 0.1),
//               border: Border.all(color: MyColors.bwGrayDark),
//               borderRadius: BorderRadius.all(Radius.circular(4)),
//             ),
//             child: TextFormField(
//               controller: widget.controller,
//               maxLines: widget.maxLines,
//               enabled: (widget.tapped) ? false : widget.enabled,
//               obscureText: widget.isPassword ? widget.obscureText : false,
//               keyboardType: widget.isPassword
//                   ? TextInputType.visiblePassword
//                   : widget.keyboardType,
//               textInputAction: widget.textInputAction,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontFamily: MyFonts.montserrat,
//                 color: widget.textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.only(
//                   left: 14,
//                   top: (widget.isPassword || widget.suffixIcon != null)
//                       ? 12
//                       : 0,
//                 ),
//                 floatingLabelBehavior: FloatingLabelBehavior.always,
//                 hintText: (widget.hintText != null)
//                     ? widget.hintText!.tr
//                     : "".tr,
//                 hintStyle: const TextStyle(
//                   fontSize: 14,
//                   fontFamily: MyFonts.montserrat,
//                   color: MyColors.bwGray,
//                 ),
//                 border: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 focusedErrorBorder: InputBorder.none,
//                 prefixIcon: widget.prefixIcon,
//                 suffixIcon: (widget.isPassword)
//                     ? InkWell(
//                         onTap: widget.icPassOnTap,
//                         child: MyImageAssets(
//                           assets: (widget.obscureText)
//                               ? MyIcons.icObscure2True
//                               : MyIcons.icObscure2False,
//                         ),
//                       )
//                     : widget.suffixIcon,
//               ),
//               inputFormatters: widget.inputFormatters,
//               onChanged: widget.onChanged,
//               onFieldSubmitted: widget.onFieldSubmitted,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // class MyTextFormFieldOTP extends StatelessWidget {
// //   const MyTextFormFieldOTP({
// //     super.key,
// //     this.controller,
// //   });

// //   final TextEditingController? controller;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         border: Border.all(color: MyColors.blackDivider),
// //         borderRadius: const BorderRadius.all(Radius.circular(6)),
// //       ),
// //       child: Center(
// //         child: TextFormField(
// //           enabled: false,
// //           controller: controller,
// //           style: const TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.w700,
// //             fontFamily: MyFonts.inter,
// //             color: MyColors.primaryDark,
// //           ),
// //           textAlign: TextAlign.center,
// //           decoration: const InputDecoration(
// //             border: InputBorder.none,
// //             contentPadding: EdgeInsets.only(left: 3, bottom: 3),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
