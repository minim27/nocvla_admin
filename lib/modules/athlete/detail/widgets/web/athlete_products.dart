import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_dashed_button.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../athlete_detail_controller.dart';

class AthleteProducts extends StatelessWidget {
  const AthleteProducts({super.key, required this.controller});

  final AthleteDetailController controller;

  Widget _product({required int index, required AthleteAssignmentRow row}) {
    return Obx(
      () => MyDropdown(
        showSearchBox: true,
        items: (filter, loadProps) => controller.productOptions,
        itemAsString: (item) => item.name,
        selectedItem: row.selectedProduct.value?.name,
        onChanged: (value) =>
            controller.selectAssignmentProduct(index: index, product: value),
      ),
    );
  }

  Widget _link(TextEditingController txt, String hint, {String? label}) {
    return MyTextFormField(
      controller: txt,
      label: label,
      hintText: hint,
      keyboardType: .url,
      textInputAction: .next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 14,
        children: [
          MySectionTitle(text: "Produk & link affiliate"),
          Obx(
            () => Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                if (controller.assignments.isNotEmpty)
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(flex: 2, child: MyTableLabel(text: "Produk")),
                      Expanded(child: MyTableLabel(text: "Shopee")),
                      Expanded(child: MyTableLabel(text: "TikTok Shop")),
                      Expanded(child: MyTableLabel(text: "Tokopedia")),
                      SizedBox(width: 40),
                    ],
                  ),
                ...List.generate(controller.assignments.length, (index) {
                  final row = controller.assignments[index];

                  return Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _product(index: index, row: row),
                      ),
                      Expanded(child: _link(row.shopee, "Tempel link Shopee")),
                      Expanded(child: _link(row.tiktok, "Tempel link TikTok")),
                      Expanded(
                        child: _link(row.tokped, "Tempel link Tokopedia"),
                      ),
                      MyIconButton(
                        icon: Icons.close,
                        tooltip: "Hapus produk",
                        color: MyColors.primary60,
                        onTap: () =>
                            controller.removeAssignmentRow(index: index),
                      ),
                    ],
                  );
                }),
                MyDashedButton(
                  width: 150,
                  text: "+ Tambah produk",
                  onTap: () => controller.addAssignmentRow(),
                ),
              ],
            ),
          ),
          MyText(
            text: "Link kosong otomatis memakai link toko NOCVLA.",
            color: MyColors.primary80,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
