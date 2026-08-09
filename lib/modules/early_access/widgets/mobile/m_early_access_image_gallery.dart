import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../early_access_controller.dart';

class MEarlyAccessImageGallery extends StatelessWidget {
  const MEarlyAccessImageGallery({super.key, required this.controller});

  final EarlyAccessController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(text: "GAMBAR TEASER", fontSize: 20, fontFamily: MyFonts.libreBaskerville),
        SizedBox(height: 8),
        MyText(text: "Drag untuk mengubah urutan gambar teaser."),
        SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: ReorderableListView(
                    scrollDirection: .horizontal,
                    buildDefaultDragHandles: false,
                    onReorderItem: (oldIndex, newIndex) => controller.reorderImages(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                    children: List.generate(controller.images.length, (index) {
                      final image = controller.images[index];

                      return ReorderableDragStartListener(
                        key: ValueKey(image),
                        index: index,
                        child: Padding(
                          padding: const .only(right: 12),
                          child: Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  border: .all(color: MyColors.secondary),
                                ),
                                child: image.existingPath != null
                                    ? MyImage(image.existingPath!)
                                    : Image.memory(image.newBytes!, fit: .cover),
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
                GestureDetector(
                  onTap: controller.pickImages,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(border: .all(color: MyColors.secondary)),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 16,
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
        ),
      ],
    );
  }
}
