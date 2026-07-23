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

class PDProdInfo extends StatelessWidget {
  const PDProdInfo({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "PRODUCT INFORMATION",
          fontSize: 24,
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
        SizedBox(height: 24),
        MyText(text: "Product Image (drag to reorder, first = main image)"),
        SizedBox(height: 8),
        SizedBox(
          height: 96,
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

                      return ReorderableDragStartListener(
                        key: ValueKey(image),
                        index: index,
                        child: Padding(
                          padding: const .only(right: 12),
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
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
                                      size: 14,
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: .all(color: MyColors.secondary),
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 20,
                        color: MyColors.secondary,
                      ),
                      MyText(
                        text: "Add Image",
                        fontSize: 10,
                        textAlign: .center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Row(
          spacing: 24,
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
        SizedBox(height: 24),
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
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtUrlShopee,
          label: "URL Shopee",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtUrlTiktokShop,
          label: "URL TikTok Shop",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 24),
        MyTextFormField(
          controller: controller.txtUrlTokped,
          label: "URL Tokopedia",
          keyboardType: .url,
          textInputAction: .next,
        ),
        SizedBox(height: 24),
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
          height: 400,
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
