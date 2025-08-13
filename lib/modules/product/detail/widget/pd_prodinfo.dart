import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_dropdown.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../product_detail_controller.dart';

class PDProdInfo extends StatelessWidget {
  const PDProdInfo({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "PRODUCT INFORMATION",
          fontSize: 24,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 24),
        MyText(text: "Product Image"),
        SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...List.generate(
                controller.txtGallery.length,
                (index) => GestureDetector(
                  onTap: () => controller.addImage(index: index),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.secondary),
                    ),
                    child: controller.txtGallery[index].value == ""
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 20,
                                color: MyColors.secondary,
                              ),
                              MyText(
                                text:
                                    "Add Image (${controller.txtGallery.length}/10)",
                                fontSize: 10,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 80,
                            height: 80,
                            child: MyImage(
                              image: controller.txtGallery[index].value,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtName,
          label: "Product Name",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtIdentity,
          label: "Identity",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 24),
        Obx(
          () => MyDropdown(
            label: "Gender",
            items: (filter, loadProps) => controller.gender,
            itemAsString: (item) => item["name"],
            selectedItem: controller.selectedGender["name"],
            onChanged: (value) => controller.selectGender(val: value),
          ),
        ),
        SizedBox(height: 24),
        Obx(
          () => MyDropdown(
            label: "Type",
            items: (filter, loadProps) => controller.resType,
            itemAsString: (item) => item.title,
            selectedItem: controller.selectedType["title"],
            onChanged: (value) => controller.selectType(res: value),
          ),
        ),
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtDescription,
          label: "Description",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 10,
        ),
      ],
    );
  }
}
