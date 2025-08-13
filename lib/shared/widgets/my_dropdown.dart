import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import 'my_text.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({
    super.key,
    this.selectedItem,
    this.label,
    this.labelFontSize = 14,
    this.labelFontWeight = FontWeight.w400,
    this.textColor = MyColors.primary,
    this.labelColor = MyColors.secondary,
    this.borderColor = MyColors.secondary,
    this.hintText = "Pilih",
    this.hintTextSearch,
    this.items,
    this.onChanged,
    this.onTap,
    this.valid = true,
    this.showSearchBox = false,
    this.required = false,
    this.icon = Icons.keyboard_arrow_down,
    this.itemAsString,
    this.borderRadius = 6,
    this.enabled = true,
  });

  final dynamic selectedItem;
  final String hintText;
  final String? hintTextSearch, label;
  final double borderRadius, labelFontSize;
  final FontWeight labelFontWeight;
  final Color textColor, labelColor, borderColor;
  final DropdownSearchOnFind? items;
  final ValueChanged? onChanged;
  final VoidCallback? onTap;
  final bool? valid, showSearchBox;
  final bool enabled, required;
  final IconData? icon;
  final DropdownSearchItemAsString<dynamic>? itemAsString;

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
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
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: widget.enabled
                ? MyColors.secondary
                : MyColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
          ),
          child: SizedBox(
            height: 24,
            child: DropdownSearch(
              items: widget.items,
              compareFn: (item1, item2) => item1,
              itemAsString: widget.itemAsString,
              selectedItem: widget.selectedItem,
              popupProps: PopupProps.menu(
                showSearchBox: widget.showSearchBox!,
                fit: FlexFit.loose,
                menuProps: MenuProps(backgroundColor: MyColors.secondary),
                searchFieldProps: TextFieldProps(
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: MyFonts.montserrat,
                    color: widget.textColor,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: (widget.hintTextSearch == null)
                        ? ""
                        : widget.hintTextSearch!.tr,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontFamily: MyFonts.montserrat,
                      color: MyColors.primary60,
                    ),
                    // prefixIcon: const MyImageAssets(assets: MyIcons.icSearch),
                    contentPadding: const EdgeInsets.only(left: 14, top: 12),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
              dropdownBuilder: (context, selectedItem) => MyText(
                text: widget.selectedItem ?? "",
                color: MyColors.primary,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: (widget.selectedItem ?? widget.hintText.tr),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: MyFonts.montserrat,
                    color: widget.textColor,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14, top: 14),
                  border: InputBorder.none,
                ),
              ),
              // suffixProps: DropdownSuffixProps(
              //   dropdownButtonProps: DropdownButtonProps(
              //     iconClosed: MyImageAssets(assets: MyIcons.icDropdown),
              //     iconOpened: MyImageAssets(assets: MyIcons.icDropdown),
              //   ),
              // ),
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
