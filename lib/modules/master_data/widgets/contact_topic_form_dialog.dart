import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/contact/contact_topic_model.dart';
import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_panel.dart';
import '../../../shared/widgets/my_text_form_field.dart';
import '../master_data_controller.dart';

class ContactTopicFormDialog extends StatelessWidget {
  const ContactTopicFormDialog({super.key, this.topic});

  final ContactTopicModel? topic;

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
              text: topic == null ? "Tambah topik pesan" : "Ubah topik pesan",
            ),
            MyTextFormField(
              controller: controller.txtTopicName,
              label: "Nama topik pesan",
              hintText: "Contoh: Pertanyaan produk",
              required: true,
              keyboardType: .text,
              onFieldSubmitted: (_) => controller.saveTopic(topic: topic),
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
                  onTap: () => controller.saveTopic(topic: topic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
