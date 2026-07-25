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

class TPDProdVar extends StatelessWidget {
  const TPDProdVar({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(text: "UKURAN", fontSize: 22, fontFamily: MyFonts.libreBaskerville),
        SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...List.generate(controller.sizeTags.length, (index) {
                return SizedBox(
                  width: 140,
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
                        icon: Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                );
              }),
              MyButton(
                width: 110,
                height: 48,
                text: "Add Ukuran",
                onTap: () => controller.addSizeTag(),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
        MyText(
          text: "WARNA & STOK",
          fontSize: 22,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 12),
        Obx(
          () => Column(
            crossAxisAlignment: .start,
            children: [
              ...List.generate(controller.colorTags.length, (colorIndex) {
                final tag = controller.colorTags[colorIndex];

                return Container(
                  margin: .only(bottom: 12),
                  padding: .all(12),
                  decoration: BoxDecoration(
                    border: .all(color: MyColors.secondary),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        spacing: 8,
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
                      SizedBox(height: 12),
                      MyText(
                        text:
                            "Color Image (tekan lama untuk drag, foto pertama = main)",
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

                                      return ReorderableDelayedDragStartListener(
                                        key: ValueKey(image),
                                        index: imageIndex,
                                        child: Padding(
                                          padding: const .only(right: 8),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 64,
                                                height: 64,
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
                                                      size: 12,
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
                                    MyText(
                                      text: "Add",
                                      fontSize: 9,
                                      textAlign: .center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
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
                              padding: .only(bottom: 8),
                              child: Row(
                                spacing: 8,
                                crossAxisAlignment: .end,
                                children: [
                                  if (controller.sizeTags.isNotEmpty)
                                    SizedBox(
                                      width: 90,
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
                                    width: 160,
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
                                    width: 160,
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
