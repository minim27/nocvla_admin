// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../utils/my_colors.dart';
// import '../utils/my_fonts.dart';
// import '../utils/my_icons.dart';
// import 'my_image_assets.dart';
// import 'my_text.dart';

// class MyDropdown extends StatefulWidget {
//   const MyDropdown({
//     super.key,
//     this.selectedItem,
//     this.label,
//     this.labelFontSize = 12,
//     this.labelFontWeight = FontWeight.w400,
//     this.hintText = "Pilih",
//     this.hintTextSearch,
//     this.items,
//     this.onChanged,
//     this.onTap,
//     this.valid = true,
//     this.showSearchBox = false,
//     this.icon = Icons.keyboard_arrow_down,
//     this.itemAsString,
//   });

//   final dynamic selectedItem;
//   final String hintText;
//   final String? hintTextSearch, label;
//   final double labelFontSize;
//   final FontWeight labelFontWeight;
//   final DropdownSearchOnFind? items;
//   final ValueChanged? onChanged;
//   final VoidCallback? onTap;
//   final bool? valid, showSearchBox;
//   final IconData? icon;
//   final DropdownSearchItemAsString<dynamic>? itemAsString;

//   @override
//   State<MyDropdown> createState() => _MyDropdownState();
// }

// class _MyDropdownState extends State<MyDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Visibility(
//           visible: widget.label != null,
//           child: Column(
//             children: [
//               MyText(text: widget.label ?? "", color: MyColors.bwGray),
//               SizedBox(height: 8)
//             ],
//           ),
//         ),
//         Container(
//           height: 48,
//           decoration: BoxDecoration(
//             color: MyColors.bwWhite.withValues(alpha: 0.03),
//             borderRadius: BorderRadius.all(Radius.circular(4)),
//           ),
//           child: SizedBox(
//             height: 24,
//             child: DropdownSearch(
//               items: widget.items,
//               compareFn: (item1, item2) => item1,
//               itemAsString: widget.itemAsString,
//               selectedItem: widget.selectedItem,
//               popupProps: PopupProps.menu(
//                 showSearchBox: widget.showSearchBox!,
//                 fit: FlexFit.loose,
//                 // menuProps: MenuProps(backgroundColor: MyColors.bwBlack),
//                 searchFieldProps: TextFieldProps(
//                   cursorColor: MyColors.primaryDefault,
//                   style: const TextStyle(
//                     color: MyColors.bwWhite,
//                     fontSize: 14,
//                     fontFamily: MyFonts.roboto,
//                   ),
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.search,
//                   decoration: InputDecoration(
//                     hintText: (widget.hintTextSearch == null)
//                         ? ""
//                         : widget.hintTextSearch!.tr,
//                     hintStyle: const TextStyle(
//                       color: MyColors.bwBlack,
//                       fontSize: 14,
//                       fontFamily: MyFonts.roboto,
//                     ),
//                     prefixIcon: const MyImageAssets(assets: MyIcons.icSearch),
//                     contentPadding: const EdgeInsets.only(left: 14, top: 12),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     disabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                   ),
//                 ),
//               ),
//               dropdownBuilder: (context, selectedItem) => MyText(
//                   text: widget.selectedItem ?? "", color: MyColors.bwWhite),
//               decoratorProps: DropDownDecoratorProps(
//                   decoration: InputDecoration(
//                 hintText: (widget.selectedItem ?? widget.hintText.tr),
//                 hintStyle: const TextStyle(
//                   fontSize: 14,
//                   fontFamily: MyFonts.roboto,
//                   color: MyColors.bwGray,
//                 ),
//                 contentPadding: const EdgeInsets.only(left: 14, top: 14),
//                 border: InputBorder.none,
//               )),
//               suffixProps: DropdownSuffixProps(
//                 dropdownButtonProps: DropdownButtonProps(
//                   iconClosed: MyImageAssets(assets: MyIcons.icDropdown),
//                   iconOpened: MyImageAssets(assets: MyIcons.icDropdown),
//                 ),
//               ),
//               onChanged: widget.onChanged,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class MyDropdown2 extends StatefulWidget {
//   const MyDropdown2({
//     super.key,
//     this.selectedItem,
//     this.label,
//     this.labelFontSize = 14,
//     this.labelFontWeight = FontWeight.w400,
//     this.hintTextSearch,
//     this.items,
//     this.onChanged,
//     this.onTap,
//     this.valid = true,
//     this.showSearchBox = false,
//     this.required = true,
//     this.icon = Icons.keyboard_arrow_down,
//     this.itemAsString,
//   });

//   final dynamic selectedItem;
//   final String? hintTextSearch, label;
//   final double labelFontSize;
//   final FontWeight labelFontWeight;
//   final DropdownSearchOnFind? items;
//   final ValueChanged? onChanged;
//   final VoidCallback? onTap;
//   final bool required;
//   final bool? valid, showSearchBox;
//   final IconData? icon;
//   final DropdownSearchItemAsString<dynamic>? itemAsString;

//   @override
//   State<MyDropdown2> createState() => _MyDropdown2State();
// }

// class _MyDropdown2State extends State<MyDropdown2> {
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
//                         color: MyColors.bwWhite,
//                         fontFamily: MyFonts.roboto,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                     TextSpan(
//                       text: (widget.required) ? " *" : "",
//                       style: TextStyle(
//                         color: MyColors.red,
//                         fontFamily: MyFonts.roboto,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8)
//             ],
//           ),
//         ),
//         Container(
//           height: 48,
//           decoration: BoxDecoration(
//             color: MyColors.bwWhite.withValues(alpha: 0.03),
//             border: Border.all(color: MyColors.bwGrayDark),
//             borderRadius: BorderRadius.all(Radius.circular(4)),
//           ),
//           child: Theme(
//             data: ThemeData(
//               fontFamily: MyFonts.roboto,
//               textTheme: const TextTheme(
//                 titleMedium: TextStyle(fontSize: 14, color: MyColors.bwWhite),
//               ),
//             ),
//             child: DropdownSearch(
//               items: widget.items,
//               compareFn: (item1, item2) => item1,
//               itemAsString: widget.itemAsString,
//               selectedItem: widget.selectedItem,
//               popupProps: PopupProps.menu(
//                 showSearchBox: widget.showSearchBox!,
//                 fit: FlexFit.loose,
//                 menuProps: MenuProps(backgroundColor: MyColors.bwBlack),
//                 searchFieldProps: TextFieldProps(
//                   cursorColor: MyColors.primaryDefault,
//                   style: const TextStyle(
//                     color: MyColors.bwWhite,
//                     fontSize: 14,
//                     fontFamily: MyFonts.roboto,
//                   ),
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.search,
//                   decoration: InputDecoration(
//                     hintText: (widget.hintTextSearch == null)
//                         ? ""
//                         : widget.hintTextSearch!.tr,
//                     hintStyle: const TextStyle(
//                       color: MyColors.bwGray,
//                       fontSize: 14,
//                       fontFamily: MyFonts.roboto,
//                     ),
//                     prefixIcon: const MyImageAssets(assets: MyIcons.icSearch),
//                     contentPadding: const EdgeInsets.only(left: 14, top: 12),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     disabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                   ),
//                 ),
//               ),
//               dropdownBuilder: (context, selectedItem) => MyText(
//                   text: widget.selectedItem ?? "", color: MyColors.bwWhite),
//               decoratorProps: DropDownDecoratorProps(
//                 decoration: InputDecoration(
//                   hintText: (widget.selectedItem ?? "Pilih".tr),
//                   hintStyle: const TextStyle(
//                     fontSize: 14,
//                     fontFamily: MyFonts.roboto,
//                     color: MyColors.bwGray,
//                   ),
//                   contentPadding: const EdgeInsets.only(left: 14, top: 11),
//                   border: InputBorder.none,
//                 ),
//               ),
//               suffixProps: DropdownSuffixProps(
//                 dropdownButtonProps: DropdownButtonProps(
//                   iconClosed: MyImageAssets(assets: MyIcons.icDropdown),
//                   iconOpened: MyImageAssets(assets: MyIcons.icDropdown),
//                 ),
//               ),
//               onChanged: widget.onChanged,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class MyDropdown3 extends StatefulWidget {
//   const MyDropdown3({
//     super.key,
//     this.selectedItem,
//     this.label,
//     this.labelFontSize = 14,
//     this.labelFontWeight = FontWeight.w400,
//     this.hintTextSearch,
//     this.items,
//     this.onChanged,
//     this.onTap,
//     this.valid = true,
//     this.showSearchBox = false,
//     this.required = true,
//     this.icon = Icons.keyboard_arrow_down,
//     this.itemAsString,
//   });

//   final dynamic selectedItem;
//   final String? hintTextSearch, label;
//   final double labelFontSize;
//   final FontWeight labelFontWeight;
//   final DropdownSearchOnFind? items;
//   final ValueChanged? onChanged;
//   final VoidCallback? onTap;
//   final bool required;
//   final bool? valid, showSearchBox;
//   final IconData? icon;
//   final DropdownSearchItemAsString<dynamic>? itemAsString;

//   @override
//   State<MyDropdown3> createState() => _MyDropdown3State();
// }

// class _MyDropdown3State extends State<MyDropdown3> {
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
//                         color: MyColors.bwWhite,
//                         fontFamily: MyFonts.roboto,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                     TextSpan(
//                       text: (widget.required) ? " *" : "",
//                       style: TextStyle(
//                         color: MyColors.red,
//                         fontFamily: MyFonts.roboto,
//                         fontSize: widget.labelFontSize,
//                         fontWeight: widget.labelFontWeight,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8)
//             ],
//           ),
//         ),
//         Container(
//           height: 48,
//           decoration: BoxDecoration(
//             color: MyColors.bwWhite.withValues(alpha: 0.03),
//             border: Border.all(color: MyColors.bwGrayDark),
//             borderRadius: BorderRadius.all(Radius.circular(4)),
//           ),
//           child: Theme(
//             data: ThemeData(
//               fontFamily: MyFonts.roboto,
//               textTheme: const TextTheme(
//                 titleMedium: TextStyle(fontSize: 14, color: MyColors.bwWhite),
//               ),
//             ),
//             child: DropdownSearch(
//               items: widget.items,
//               compareFn: (item1, item2) => item1,
//               itemAsString: widget.itemAsString,
//               selectedItem: widget.selectedItem,
//               popupProps: PopupProps.menu(
//                 showSearchBox: widget.showSearchBox!,
//                 fit: FlexFit.loose,
//                 menuProps: MenuProps(backgroundColor: MyColors.bwBlack),
//                 searchFieldProps: TextFieldProps(
//                   cursorColor: MyColors.primaryDefault,
//                   style: const TextStyle(
//                     color: MyColors.bwWhite,
//                     fontSize: 14,
//                     fontFamily: MyFonts.roboto,
//                   ),
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.search,
//                   decoration: InputDecoration(
//                     hintText: (widget.hintTextSearch == null)
//                         ? ""
//                         : widget.hintTextSearch!.tr,
//                     hintStyle: const TextStyle(
//                       color: MyColors.bwGray,
//                       fontSize: 14,
//                       fontFamily: MyFonts.roboto,
//                     ),
//                     prefixIcon: const MyImageAssets(assets: MyIcons.icSearch),
//                     contentPadding: const EdgeInsets.only(left: 14, top: 12),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     disabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyColors.bwGrayDark),
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                   ),
//                 ),
//               ),
//               dropdownBuilder: (context, selectedItem) => MyText(
//                   text: widget.selectedItem ?? "", color: MyColors.bwWhite),
//               decoratorProps: DropDownDecoratorProps(
//                 decoration: InputDecoration(
//                   hintText: (widget.selectedItem ?? "Pilih".tr),
//                   hintStyle: const TextStyle(
//                     fontSize: 14,
//                     fontFamily: MyFonts.roboto,
//                     color: MyColors.bwGray,
//                   ),
//                   contentPadding: const EdgeInsets.only(left: 14, top: 11),
//                   border: InputBorder.none,
//                 ),
//               ),
//               suffixProps: DropdownSuffixProps(
//                 dropdownButtonProps: DropdownButtonProps(
//                   iconClosed: MyImageAssets(assets: MyIcons.icDropdown2),
//                   iconOpened: MyImageAssets(assets: MyIcons.icDropdown2),
//                 ),
//               ),
//               onChanged: widget.onChanged,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
