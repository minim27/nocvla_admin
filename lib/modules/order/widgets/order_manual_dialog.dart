import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_dashed_button.dart';
import '../../../shared/widgets/my_dropdown.dart';
import '../../../shared/widgets/my_icon_button.dart';
import '../../../shared/widgets/my_panel.dart';
import '../../../shared/widgets/my_text_form_field.dart';
import '../order_controller.dart';

class OrderManualDialog extends StatelessWidget {
  const OrderManualDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Dialog(
      backgroundColor: MyColors.primary90,
      constraints: const BoxConstraints(maxWidth: 560),
      child: SingleChildScrollView(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 14,
          children: [
            MySectionTitle(text: "Catat order manual"),
            MyTextFormField(
              controller: controller.txtManualName,
              label: "Nama pembeli",
              required: true,
              keyboardType: .text,
            ),
            MyTextFormField(
              controller: controller.txtManualPhone,
              label: "Nomor WhatsApp",
              required: true,
              keyboardType: .phone,
            ),
            MyTextFormField(
              controller: controller.txtManualAddress,
              label: "Alamat",
              keyboardType: .text,
            ),
            MyTextFormField(
              controller: controller.txtManualCode,
              label: "Kode atlet (opsional)",
              keyboardType: .text,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: .start,
                spacing: 10,
                children: [
                  ...List.generate(controller.manualRows.length, (index) {
                    final row = controller.manualRows[index];

                    return Obx(() {
                      final color = row.color.value;
                      final sizes = (color?.variation ?? [])
                          .map((e) => "${e.size ?? ""}")
                          .toList();

                      return Column(
                        spacing: 8,
                        children: [
                          MyDropdown(
                            label: "Produk & warna",
                            showSearchBox: true,
                            items: (filter, loadProps) =>
                                controller.productOptions,
                            itemAsString: (item) =>
                                "${item.name} — ${item.colorName}",
                            selectedItem: color == null
                                ? null
                                : "${color.name} — ${color.colorName}",
                            onChanged: (value) => controller.selectManualColor(
                              index: index,
                              value: value,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: .end,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: MyDropdown(
                                  label: "Ukuran",
                                  items: (filter, loadProps) => sizes,
                                  selectedItem: row.size.value,
                                  onChanged: (value) =>
                                      controller.selectManualSize(
                                        index: index,
                                        value: value,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: MyTextFormField(
                                  controller: row.txtQty,
                                  label: "Jumlah",
                                  keyboardType: .number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              MyIconButton(
                                icon: Icons.close,
                                size: 44,
                                color: MyColors.primary60,
                                onTap: controller.manualRows.length > 1
                                    ? () => controller.removeManualRow(
                                        index: index,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                  }),
                  MyDashedButton(
                    width: 150,
                    text: "+ Tambah item",
                    onTap: () => controller.addManualRow(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: .end,
              spacing: 8,
              children: [
                MyButton(
                  text: "Batal",
                  fontSize: 13,
                  color: Colors.transparent,
                  textColor: MyColors.secondary,
                  borderColor: MyColors.border,
                  onTap: () => Get.back(),
                ),
                MyButton(
                  text: "Catat order",
                  fontSize: 13,
                  onTap: () => controller.submitManual(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
