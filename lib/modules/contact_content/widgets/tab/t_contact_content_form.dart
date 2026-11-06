import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_dashed_button.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../contact_content_controller.dart';

class TContactContentForm extends StatelessWidget {
  const TContactContentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactContentController>();

    return Obx(() {
      if (controller.isLoading.value) return SizedBox(height: 200);

      final texts = controller.texts;

      return Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          MyText(
            text:
                "Bagian yang dikosongkan tidak tampil di halaman Kontak. Kanal WhatsApp, Email, Instagram, dan TikTok diatur di Pengaturan.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Judul halaman"),
                MyTextFormField(
                  controller: texts["CONTACT_EYEBROW"],
                  label: "Eyebrow",
                  hintText: "KONTAK",
                ),
                MyTextFormField(
                  controller: texts["CONTACT_TITLE"],
                  label: "Judul",
                  hintText: "Speak to the Temple",
                ),
                MyTextFormField(
                  controller: texts["CONTACT_DESCRIPTION"],
                  label: "Deskripsi",
                  maxLines: 3,
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Pertanyaan umum"),
                for (var i = 0; i < controller.faqs.length; i++)
                  faqItem(controller, i),
                MyDashedButton(
                  width: double.infinity,
                  height: 44,
                  onTap: controller.addFaq,
                  child: MyText(
                    text: "+ Tambah pertanyaan",
                    color: MyColors.primary60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: .centerLeft,
            child: MyButton(
              text: "Simpan halaman Kontak",
              onTap: controller.save,
            ),
          ),
        ],
      );
    });
  }

  Widget faqItem(ContactContentController controller, int index) {
    final item = controller.faqs[index];

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(border: .all(color: MyColors.line)),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: MyText(text: "Pertanyaan ${index + 1}", fontSize: 13),
              ),
              InkWell(
                onTap: () => controller.moveFaq(index: index, offset: -1),
                child: Icon(
                  Icons.arrow_upward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              InkWell(
                onTap: () => controller.moveFaq(index: index, offset: 1),
                child: Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              MySwitch(
                value: item.isActive,
                onChanged: (value) =>
                    controller.toggleFaq(item: item, value: value),
              ),
              InkWell(
                onTap: () => controller.removeFaq(index: index),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
            ],
          ),
          MyTextFormField(
            controller: item.txtQuestion,
            label: "Pertanyaan",
            required: true,
          ),
          MyTextFormField(
            controller: item.txtAnswer,
            label: "Jawaban",
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
