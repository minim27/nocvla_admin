import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/athlete_application/training_focus_model.dart';
import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_panel.dart';
import '../../../shared/widgets/my_text_form_field.dart';
import '../master_data_controller.dart';

class TrainingFocusFormDialog extends StatelessWidget {
  const TrainingFocusFormDialog({super.key, this.focus});

  final TrainingFocusModel? focus;

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
              text: focus == null
                  ? "Tambah fokus latihan"
                  : "Ubah fokus latihan",
            ),
            MyTextFormField(
              controller: controller.txtFocusName,
              label: "Nama fokus latihan",
              hintText: "Contoh: Bodybuilding",
              required: true,
              keyboardType: .text,
              onFieldSubmitted: (_) => controller.saveFocus(focus: focus),
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
                  onTap: () => controller.saveFocus(focus: focus),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
