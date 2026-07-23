import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class TPDProdInfo extends StatelessWidget {
  const TPDProdInfo({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "PRODUCT INFORMATION",
          fontSize: 22,
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
                  "Ini duplikat — akan tersimpan sebagai produk baru saat disimpan.",
              color: MyColors.primary,
              fontWeight: .w600,
              fontSize: 12,
            ),
          ),
        ],
        SizedBox(height: 20),
        MyText(
          text: "Product Image (tekan lama untuk drag, foto pertama = main)",
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => ReorderableListView(
                    scrollDirection: .horizontal,
                    buildDefaultDragHandles: false,
                    onReorderItem: (oldIndex, newIndex) => controller
                        .reorderGallery(oldIndex: oldIndex, newIndex: newIndex),
                    children: List.generate(controller.gallery.length, (index) {
                      final image = controller.gallery[index];

                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(image),
                        index: index,
                        child: Padding(
                          padding: const .only(right: 8),
                          child: Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  border: .all(
                                    color: index == 0
                                        ? MyColors.red
                                        : MyColors.secondary,
                                    width: index == 0 ? 2 : 1,
                                  ),
                                ),
                                child: image.existingPath != null
                                    ? MyImage(image.existingPath!)
                                    : Image.memory(
                                        image.newBytes!,
                                        fit: .cover,
                                      ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeImage(index: index),
                                  child: Container(
                                    padding: .all(2),
                                    decoration: BoxDecoration(
                                      color: MyColors.primary,
                                      shape: .circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 12,
                                      color: MyColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    border: .all(color: MyColors.secondary),
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 18,
                        color: MyColors.secondary,
                      ),
                      MyText(text: "Add", fontSize: 9, textAlign: .center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: MyTextFormField(
                controller: controller.txtName,
                label: "Product Name",
                required: true,
                keyboardType: .text,
                textInputAction: .next,
              ),
            ),
            Expanded(
              child: MyTextFormField(
                controller: controller.txtColor,
                label: "Color",
                required: true,
                keyboardType: .text,
                textInputAction: .next,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
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
        SizedBox(height: 20),
        MyTextFormField(
          controller: controller.txtUrlShopee,
          label: "URL Shopee",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 20),
        MyTextFormField(
          controller: controller.txtUrlTiktokShop,
          label: "URL TikTok Shop",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 20),
        MyTextFormField(
          controller: controller.txtUrlTokped,
          label: "URL Tokopedia",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 20),
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
          height: 320,
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
