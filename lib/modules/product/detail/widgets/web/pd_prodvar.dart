import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/utils/my_input_formatters.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class PDProdVar extends StatelessWidget {
  const PDProdVar({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(text: "UKURAN", fontSize: 24, fontFamily: MyFonts.libreBaskerville),
        SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...List.generate(controller.sizeTags.length, (index) {
                return SizedBox(
                  width: 160,
                  child: Row(
                    spacing: 4,
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          controller: controller.sizeTags[index],
                          label: "Ukuran ${index + 1}",
                          keyboardType: .text,
                          textInputAction: .next,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            controller.removeSizeTag(index: index),
                        icon: Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                );
              }),
              MyButton(
                width: 120,
                height: 48,
                text: "Add Ukuran",
                onTap: () => controller.addSizeTag(),
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        MyText(text: "WARNA & STOK", fontSize: 24, fontFamily: MyFonts.libreBaskerville),
        SizedBox(height: 16),
        Obx(
          () => Column(
            crossAxisAlignment: .start,
            children: [
              ...List.generate(controller.colorTags.length, (colorIndex) {
                final tag = controller.colorTags[colorIndex];

                return Container(
                  margin: .only(bottom: 16),
                  padding: .all(16),
                  decoration: BoxDecoration(
                    border: .all(color: MyColors.secondary),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: MyTextFormField(
                              controller: tag.txtName,
                              label: "Color Name",
                              required: true,
                              keyboardType: .text,
                              textInputAction: .next,
                            ),
                          ),
                          IconButton(
                            onPressed: controller.colorTags.length > 1
                                ? () =>
                                      controller.removeColorTag(index: colorIndex)
                                : null,
                            icon: Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      MyText(
                        text: "Color Image (drag to reorder, first = main image)",
                      ),
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
                                  onReorderItem: (oldIndex, newIndex) =>
                                      controller.reorderGallery(
                                        colorIndex: colorIndex,
                                        oldIndex: oldIndex,
                                        newIndex: newIndex,
                                      ),
                                  children: List.generate(
                                    tag.gallery.length,
                                    (imageIndex) {
                                      final image = tag.gallery[imageIndex];

                                      return ReorderableDragStartListener(
                                        key: ValueKey(image),
                                        index: imageIndex,
                                        child: Padding(
                                          padding: const .only(right: 12),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  border: .all(
                                                    color: imageIndex == 0
                                                        ? MyColors.red
                                                        : MyColors.secondary,
                                                    width: imageIndex == 0
                                                        ? 2
                                                        : 1,
                                                  ),
                                                ),
                                                child:
                                                    image.existingPath != null
                                                    ? MyImage(
                                                        image.existingPath!,
                                                      )
                                                    : Image.memory(
                                                        image.newBytes!,
                                                        fit: .cover,
                                                      ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeImage(
                                                        colorIndex: colorIndex,
                                                        imageIndex: imageIndex,
                                                      ),
                                                  child: Container(
                                                    padding: .all(2),
                                                    decoration: BoxDecoration(
                                                      color: MyColors.primary,
                                                      shape: .circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 14,
                                                      color:
                                                          MyColors.secondary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  controller.pickImage(colorIndex: colorIndex),
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
                      SizedBox(height: 16),
                      MyText(text: "Stock"),
                      SizedBox(height: 8),
                      Obx(
                        () => Column(
                          crossAxisAlignment: .start,
                          children: List.generate(tag.stockCells.length, (
                            cellIndex,
                          ) {
                            final cell = tag.stockCells[cellIndex];

                            return Padding(
                              padding: .only(bottom: 12),
                              child: Row(
                                spacing: 12,
                                crossAxisAlignment: .end,
                                children: [
                                  if (controller.sizeTags.isNotEmpty)
                                    SizedBox(
                                      width: 100,
                                      child: ListenableBuilder(
                                        listenable:
                                            controller.sizeTags[cellIndex],
                                        builder: (context, _) => MyText(
                                          text: controller
                                              .sizeTags[cellIndex]
                                              .text,
                                          fontWeight: .w500,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: 180,
                                    child: MyTextFormField(
                                      controller: cell.price,
                                      label: "Price",
                                      required: true,
                                      keyboardType: .number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                        NoLeadingZeroTextInputFormatter(),
                                      ],
                                      textInputAction: .next,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: MyTextFormField(
                                      controller: cell.qty,
                                      label: "Stock",
                                      required: true,
                                      keyboardType: .number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                        NoLeadingZeroTextInputFormatter(),
                                      ],
                                      textInputAction: .next,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              MyButton(
                width: 140,
                text: "Add Warna",
                onTap: () => controller.addColorTag(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
