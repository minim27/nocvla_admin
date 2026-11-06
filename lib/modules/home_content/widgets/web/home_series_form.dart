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

class HomeSeriesForm extends StatelessWidget {
  const HomeSeriesForm({super.key});

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
            MySectionTitle(text: "The Scriptures"),
            for (var i = 0; i < controller.series.length; i++)
              seriesItem(controller, i),
            MyDashedButton(
              width: double.infinity,
              height: 44,
              onTap: controller.addSeries,
              child: MyText(
                text: "+ Tambah seri",
                color: MyColors.primary60,
                fontSize: 13,
              ),
            ),
            MyButton(text: "Simpan seri", onTap: controller.saveHomeSeries),
          ],
        );
      }),
    );
  }

  Widget seriesItem(HomeContentController controller, int index) {
    final item = controller.series[index];

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
              Expanded(child: MyText(text: "Seri ${index + 1}", fontSize: 13)),
              MySwitch(
                value: item.isActive,
                onChanged: (value) =>
                    controller.toggleSeries(item: item, value: value),
              ),
              InkWell(
                onTap: () => controller.removeSeries(index: index),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
            ],
          ),
          MyTextFormField(
            controller: item.txtLabel,
            label: "Label",
            hintText: "OVERSIZE · HEAVYWEIGHT",
          ),
          MyTextFormField(
            controller: item.txtTitle,
            label: "Judul",
            required: true,
          ),
          MyTextFormField(
            controller: item.txtDesc,
            label: "Deskripsi",
            maxLines: 3,
          ),
          MyDropdown(
            label: "Produk",
            items: (filter, loadProps) => controller.resProducts,
            itemAsString: (value) => value["name"],
            selectedItem: item.product?["name"],
            onChanged: (value) =>
                controller.selectSeriesProduct(item: item, value: value),
          ),
          picture(
            path: item.path,
            bytes: item.newBytes,
            onTap: () => controller.pickSeriesImage(item: item),
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
      width: 200,
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
