import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_dashed_button.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../about_content_controller.dart';

class TAboutContentForm extends StatelessWidget {
  const TAboutContentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AboutContentController>();

    return Obx(() {
      if (controller.isLoading.value) return SizedBox(height: 200);

      final texts = controller.texts;

      return Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          MyText(
            text: "Bagian yang dikosongkan tidak tampil di halaman Tentang.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Hero"),
                picture(controller, "ABOUT_IMAGE", "+ Pilih foto banner"),
                MyTextFormField(
                  controller: texts["ABOUT_EYEBROW"],
                  label: "Eyebrow",
                  hintText: "TENTANG NOCVLA TEMPLE",
                ),
                MyTextFormField(
                  controller: texts["ABOUT_TITLE"],
                  label: "Judul",
                  maxLines: 2,
                ),
                MyTextFormField(
                  controller: texts["ABOUT_DESCRIPTION"],
                  label: "Deskripsi",
                  maxLines: 4,
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Our Story"),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    picture(controller, "ABOUT_STORY_IMAGE_1", "+ Foto kiri"),
                    picture(controller, "ABOUT_STORY_IMAGE_2", "+ Foto kanan"),
                  ],
                ),
                MyTextFormField(
                  controller: texts["ABOUT_STORY_EYEBROW"],
                  label: "Eyebrow",
                  hintText: "OUR STORY",
                ),
                MyTextFormField(
                  controller: texts["ABOUT_STORY_TITLE"],
                  label: "Judul",
                  maxLines: 2,
                ),
                MyTextFormField(
                  controller: texts["ABOUT_STORY_BODY"],
                  label: "Cerita (pisahkan paragraf dengan satu baris kosong)",
                  maxLines: 8,
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Misi, Visi, Nilai"),
                MyTextFormField(
                  controller: texts["ABOUT_MISSION"],
                  label: "Misi",
                  maxLines: 2,
                ),
                MyTextFormField(
                  controller: texts["ABOUT_VISION"],
                  label: "Visi",
                  maxLines: 2,
                ),
                MyTextFormField(
                  controller: texts["ABOUT_VALUES"],
                  label: "Nilai",
                  maxLines: 2,
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Craft"),
                MyTextFormField(
                  controller: texts["ABOUT_CRAFT_EYEBROW"],
                  label: "Eyebrow",
                  hintText: "CRAFT",
                ),
                MyTextFormField(
                  controller: texts["ABOUT_CRAFT_TITLE"],
                  label: "Judul",
                ),
                for (var i = 1; i <= 4; i++) ...[
                  MyTextFormField(
                    controller: texts["ABOUT_CRAFT_${i}_TITLE"],
                    label: "Poin $i",
                    hintText: "Elastane 240gsm",
                  ),
                  MyTextFormField(
                    controller: texts["ABOUT_CRAFT_${i}_DESC"],
                    label: "Keterangan poin $i",
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Penutup"),
                MyTextFormField(
                  controller: texts["ABOUT_CTA_TITLE"],
                  label:
                      "Judul (tombol Lihat Koleksi dan Jadi Atlet tampil kalau judul diisi)",
                  hintText: "Built Different. Train Nocvla.",
                ),
              ],
            ),
          ),
          Align(
            alignment: .centerLeft,
            child: MyButton(
              text: "Simpan halaman Tentang",
              onTap: controller.save,
            ),
          ),
        ],
      );
    });
  }

  Widget picture(AboutContentController controller, String key, String hint) {
    final image = controller.images[key]!;
    final bytes = image.newBytes.value;
    final path = image.path.value;

    return MyDashedButton(
      width: 200,
      height: 120,
      onTap: () => controller.pickImage(key),
      child: bytes != null
          ? Image.memory(bytes, fit: .cover, width: double.infinity)
          : path != null
          ? MyImage(path)
          : MyText(text: hint, color: MyColors.primary60, fontSize: 12),
    );
  }
}
