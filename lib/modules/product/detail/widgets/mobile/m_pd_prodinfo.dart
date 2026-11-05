import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class MPDProdInfo extends StatelessWidget {
  const MPDProdInfo({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final name = MyTextFormField(
      controller: controller.txtName,
      label: "Nama produk",
      required: true,
      keyboardType: .text,
      textInputAction: .next,
    );
    final type = Obx(
      () => MyDropdown(
        label: "Kategori",
        required: true,
        items: (filter, loadProps) => controller.resTypes,
        itemAsString: (item) => item.name,
        selectedItem: controller.selectedType.value?.name,
        onChanged: (value) => controller.selectType(res: value),
      ),
    );

    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MySectionTitle(text: "Informasi produk"),
          if (controller.isDuplicating) ...[
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const .symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(border: .all(color: MyColors.yellow)),
              child: MyText(
                text:
                    "Ini duplikat produk. Seluruh warna, foto, ukuran, stok, dan harga ikut tersalin sebagai produk baru saat disimpan.",
                color: MyColors.yellow,
                fontSize: 13,
              ),
            ),
          ],
          SizedBox(height: 20),
          name,
          SizedBox(height: 16),
          type,
          SizedBox(height: 20),
          MyTextFormField(
            controller: controller.txtSubtitle,
            label: "Subtitle (tampil di header Collection)",
            keyboardType: .text,
            textInputAction: .next,
          ),
          SizedBox(height: 20),
          MyTextFormField(
            controller: controller.txtBadge,
            label: "Badge (opsional)",
            hintText: "NEW DROP",
            keyboardType: .text,
            textInputAction: .next,
          ),
          SizedBox(height: 20),
          MyText(text: "Deskripsi", color: MyColors.primary60, fontSize: 13),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.primary,
              border: .all(color: MyColors.border),
            ),
            child: QuillSimpleToolbar(
              controller: controller.quillController,
              config: const QuillSimpleToolbarConfig(),
            ),
          ),
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: MyColors.primary,
              border: Border(
                left: BorderSide(color: MyColors.border),
                right: BorderSide(color: MyColors.border),
                bottom: BorderSide(color: MyColors.border),
              ),
            ),
            child: QuillEditor.basic(
              controller: controller.quillController,
              config: const QuillEditorConfig(
                padding: EdgeInsetsGeometry.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
