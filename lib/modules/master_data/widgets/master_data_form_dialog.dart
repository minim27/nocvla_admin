import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/products/product_type_model.dart';
import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_panel.dart';
import '../../../shared/widgets/my_text_form_field.dart';
import '../master_data_controller.dart';

class MasterDataFormDialog extends StatelessWidget {
  const MasterDataFormDialog({super.key, this.type});

  final ProductTypeModel? type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MasterDataController>();

    return Dialog(
      backgroundColor: MyColors.primary90,
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 14,
          children: [
            MySectionTitle(
              text: type == null ? "Tambah kategori" : "Ubah kategori",
            ),
            MyTextFormField(
              controller: controller.txtName,
              label: "Nama kategori",
              hintText: "Contoh: CARGO PANTS",
              required: true,
              keyboardType: .text,
              onFieldSubmitted: (_) => controller.saveType(type: type),
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
                  text: "Simpan",
                  fontSize: 13,
                  onTap: () => controller.saveType(type: type),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
