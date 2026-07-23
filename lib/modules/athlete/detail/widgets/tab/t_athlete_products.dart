import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../athlete_detail_controller.dart';

class TAthleteProducts extends StatelessWidget {
  const TAthleteProducts({super.key, required this.controller});

  final AthleteDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "ASSIGNED PRODUCTS",
          fontSize: 22,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 20),
        Obx(
          () => Column(
            crossAxisAlignment: .start,
            children: [
              ...List.generate(controller.assignments.length, (index) {
                final row = controller.assignments[index];

                return Padding(
                  padding: .only(bottom: 12),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => MyDropdown(
                            label: "Product",
                            showSearchBox: true,
                            items: (filter, loadProps) =>
                                controller.productOptions,
                            itemAsString: (item) => item.name,
                            selectedItem: row.selectedProduct.value?.name,
                            onChanged: (value) =>
                                controller.selectAssignmentProduct(
                                  index: index,
                                  product: value,
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MyTextFormField(
                          controller: row.shopee,
                          label: "URL Shopee",
                          keyboardType: .url,
                          textInputAction: .next,
                        ),
                      ),
                      Expanded(
                        child: MyTextFormField(
                          controller: row.tiktok,
                          label: "URL TikTok Shop",
                          keyboardType: .url,
                          textInputAction: .next,
                        ),
                      ),
                      Expanded(
                        child: MyTextFormField(
                          controller: row.tokped,
                          label: "URL Tokopedia",
                          keyboardType: .url,
                          textInputAction: .next,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            controller.removeAssignmentRow(index: index),
                        icon: Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                );
              }),
              MyButton(
                width: 160,
                text: "Add Product",
                onTap: () => controller.addAssignmentRow(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
