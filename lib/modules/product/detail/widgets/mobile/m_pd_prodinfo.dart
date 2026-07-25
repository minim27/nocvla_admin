import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class MPDProdInfo extends StatelessWidget {
  const MPDProdInfo({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "PRODUCT INFORMATION",
          fontSize: 20,
          fontFamily: MyFonts.libreBaskerville,
        ),
        if (controller.isDuplicating) ...[
          SizedBox(height: 8),
          Container(
            padding: .symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.yellow,
              borderRadius: .circular(6),
            ),
            child: MyText(
              text:
                  "Ini duplikat produk — seluruh warna, foto, ukuran, stok & harga akan ikut tersalin sebagai produk baru saat disimpan.",
              color: MyColors.primary,
              fontWeight: .w600,
              fontSize: 12,
            ),
          ),
        ],
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtName,
          label: "Product Name",
          required: true,
          keyboardType: .text,
          textInputAction: .next,
        ),
        SizedBox(height: 16),
        Obx(
          () => MyDropdown(
            label: "Type",
            required: true,
            items: (filter, loadProps) => controller.resTypes,
            itemAsString: (item) => item.name,
            selectedItem: controller.selectedType.value?.name,
            onChanged: (value) => controller.selectType(res: value),
          ),
        ),
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtUrlShopee,
          label: "URL Shopee",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtUrlTiktokShop,
          label: "URL TikTok Shop",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtUrlTokped,
          label: "URL Tokopedia",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 16),
        MyText(text: "Description"),
        SizedBox(height: 8),
        Container(
          color: MyColors.secondary,
          child: QuillSimpleToolbar(
            controller: controller.quillController,
            config: const QuillSimpleToolbarConfig(),
          ),
        ),
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: MyColors.secondary,
            borderRadius: .all(.circular(6)),
          ),
          child: QuillEditor.basic(
            controller: controller.quillController,
            config: const QuillEditorConfig(
              padding: EdgeInsetsGeometry.all(12),
            ),
          ),
        ),
      ],
    );
  }
}
