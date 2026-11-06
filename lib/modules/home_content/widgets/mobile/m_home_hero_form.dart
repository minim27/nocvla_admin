import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_dashed_button.dart';
import '../../../../shared/widgets/my_dropdown.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../home_content_controller.dart';

class MHomeHeroForm extends StatelessWidget {
  const MHomeHeroForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeContentController>();

    return MyPanel(
      child: Obx(() {
        if (controller.isLoading.value) return SizedBox(height: 200);

        return Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            MySectionTitle(text: "Hero Home"),
            for (var i = 0; i < controller.heroes.length; i++)
              heroItem(controller, i),
            MyDashedButton(
              width: double.infinity,
              height: 44,
              onTap: controller.addHero,
              child: MyText(
                text: "+ Tambah hero",
                color: MyColors.primary60,
                fontSize: 13,
              ),
            ),
            MyButton(text: "Simpan hero", onTap: controller.saveHomeHero),
          ],
        );
      }),
    );
  }

  Widget heroItem(HomeContentController controller, int index) {
    final item = controller.heroes[index];

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
              Expanded(child: MyText(text: "Hero ${index + 1}", fontSize: 13)),
              InkWell(
                onTap: () => controller.moveHero(index: index, offset: -1),
                child: Icon(
                  Icons.arrow_upward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              InkWell(
                onTap: () => controller.moveHero(index: index, offset: 1),
                child: Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              MySwitch(
                value: item.isActive,
                onChanged: (value) =>
                    controller.toggleHero(item: item, value: value),
              ),
              InkWell(
                onTap: () => controller.removeHero(index: index),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
            ],
          ),
          MyTextFormField(
            controller: item.txtEyebrow,
            label: "Eyebrow",
            hintText: "NEW DROP — FALLENSERAPH™",
          ),
          MyTextFormField(
            controller: item.txtTitle,
            label: "Judul",
            maxLines: 2,
            required: true,
          ),
          MyTextFormField(
            controller: item.txtDesc,
            label: "Deskripsi",
            maxLines: 3,
          ),
          MyDropdown(
            label: "Produk tombol Shop the Drop",
            items: (filter, loadProps) => controller.resProducts,
            itemAsString: (value) => value["name"],
            selectedItem: item.product?["name"],
            onChanged: (value) =>
                controller.selectHeroProduct(item: item, value: value),
          ),
          picture(
            path: item.path,
            bytes: item.newBytes,
            onTap: () => controller.pickHeroImage(item: item),
          ),
        ],
      ),
    );
  }

  Widget picture({
    required String? path,
    required dynamic bytes,
    required VoidCallback onTap,
  }) {
    return MyDashedButton(
      width: double.infinity,
      height: 120,
      onTap: onTap,
      child: bytes != null
          ? Image.memory(bytes, fit: .cover, width: double.infinity)
          : path != null
          ? MyImage(path)
          : MyText(
              text: "+ Pilih foto",
              color: MyColors.primary60,
              fontSize: 12,
            ),
    );
  }
}
