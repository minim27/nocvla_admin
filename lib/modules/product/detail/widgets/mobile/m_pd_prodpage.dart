import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_dashed_button.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class MPDProdPage extends StatelessWidget {
  const MPDProdPage({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bytes = controller.sizeChartBytes.value;
      final path = controller.sizeChartPath.value;

      return Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          MyText(
            text:
                "Tampil di halaman detail produk Katalog. Bagian yang kosong tidak ditampilkan.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Info tambahan"),
                MyTextFormField(
                  controller: controller.txtMaterial,
                  label: "Material (tampil setelah tipe di atas nama produk)",
                  hintText: "Heavyweight Cotton 16s",
                ),
                MyTextFormField(
                  controller: controller.txtCare,
                  label: "Perawatan (satu baris = satu poin)",
                  maxLines: 4,
                ),
                MyText(
                  text: "Size chart",
                  color: MyColors.primary60,
                  fontSize: 13,
                ),
                Row(
                  spacing: 12,
                  children: [
                    MyDashedButton(
                      width: 160,
                      height: 160,
                      onTap: controller.pickSizeChart,
                      child: bytes != null
                          ? Image.memory(bytes, fit: .contain)
                          : path != null
                          ? MyImage(path, fit: .contain)
                          : MyText(
                              text: "+ Pilih size chart",
                              color: MyColors.primary60,
                              fontSize: 12,
                            ),
                    ),
                    if (bytes != null || path != null)
                      InkWell(
                        onTap: controller.removeSizeChart,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: MyColors.primary60,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Fitur (kotak di bawah harga)"),
                for (var i = 0; i < controller.features.length; i++) feature(i),
                MyDashedButton(
                  width: double.infinity,
                  height: 44,
                  onTap: controller.addFeature,
                  child: MyText(
                    text: "+ Tambah fitur",
                    color: MyColors.primary60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          MyPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                MySectionTitle(text: "Detail warna"),
                for (final tag in controller.colorTags)
                  MyTextFormField(
                    controller: tag.txtDesc,
                    label:
                        "${tag.txtName.text.isEmpty ? "Warna tanpa nama" : tag.txtName.text} (satu baris = satu poin)",
                    maxLines: 3,
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget feature(int index) {
    final item = controller.features[index];

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
              Expanded(child: MyText(text: "Fitur ${index + 1}", fontSize: 13)),
              InkWell(
                onTap: () => controller.moveFeature(index: index, offset: -1),
                child: Icon(
                  Icons.arrow_upward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              InkWell(
                onTap: () => controller.moveFeature(index: index, offset: 1),
                child: Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
              InkWell(
                onTap: () => controller.removeFeature(index: index),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: MyColors.primary60,
                ),
              ),
            ],
          ),
          MyDropdown(
            label: "Ikon",
            items: (filter, loadProps) =>
                ProductDetailController.featureIcons.keys.toList(),
            itemAsString: (value) =>
                ProductDetailController.featureIcons[value] ?? "$value",
            selectedItem: item.icon,
            onChanged: (value) =>
                controller.selectFeatureIcon(item: item, icon: value),
          ),
          MyTextFormField(
            controller: item.txtTitle,
            label: "Judul",
            hintText: "Heavyweight 16s",
            required: true,
          ),
          MyTextFormField(
            controller: item.txtDesc,
            label: "Keterangan",
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
