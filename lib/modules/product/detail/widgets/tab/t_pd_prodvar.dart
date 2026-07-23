import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/utils/my_input_formatters.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class TPDProdVar extends StatelessWidget {
  const TPDProdVar({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "STOCK",
          fontSize: 22,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 20),
        Obx(
          () => Column(
            crossAxisAlignment: .start,
            children: [
              ...List.generate(controller.stockRows.length, (index) {
                final row = controller.stockRows[index];

                return Padding(
                  padding: .only(bottom: 12),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          controller: row["size"],
                          label: "Size",
                          keyboardType: .text,
                          textInputAction: .next,
                        ),
                      ),
                      Expanded(
                        child: MyTextFormField(
                          controller: row["qty"],
                          label: "Stock",
                          keyboardType: .number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NoLeadingZeroTextInputFormatter(),
                          ],
                          textInputAction: .next,
                        ),
                      ),
                      Expanded(
                        child: MyTextFormField(
                          controller: row["price"],
                          label: "Price",
                          keyboardType: .number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NoLeadingZeroTextInputFormatter(),
                          ],
                          textInputAction: .next,
                        ),
                      ),
                      IconButton(
                        onPressed: controller.stockRows.length > 1
                            ? () => controller.removeStockRow(index: index)
                            : null,
                        icon: Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                );
              }),
              MyButton(
                width: 140,
                text: "Add Size",
                onTap: () => controller.addStockRow(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
