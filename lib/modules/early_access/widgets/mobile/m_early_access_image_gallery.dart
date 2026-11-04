import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_dashed_button.dart';
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
      spacing: 8,
      children: [
        MyText(text: "Gambar teaser", color: MyColors.primary60, fontSize: 13),
        SizedBox(
          height: 100,
          child: Obx(
            () => Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ReorderableListView(
                    scrollDirection: .horizontal,
                    buildDefaultDragHandles: false,
                    onReorderItem: (oldIndex, newIndex) => controller
                        .reorderImages(oldIndex: oldIndex, newIndex: newIndex),
                    children: List.generate(controller.images.length, (index) {
                      final image = controller.images[index];

                      return ReorderableDragStartListener(
                        key: ValueKey(image),
                        index: index,
                        child: Padding(
                          padding: const .only(right: 10),
                          child: Stack(
                            children: [
                              Container(
                                width: 76,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: .all(color: MyColors.line),
                                ),
                                child: image.existingPath != null
                                    ? MyImage(image.existingPath!)
                                    : Image.memory(
                                        image.newBytes!,
                                        fit: .cover,
                                      ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: InkWell(
                                  onTap: () =>
                                      controller.removeImage(index: index),
                                  child: Container(
                                    padding: const .all(3),
                                    color: MyColors.primary,
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
                MyDashedButton(
                  width: 76,
                  height: 100,
                  onTap: controller.pickImages,
                  child: MyText(
                    text: "+ Tambah",
                    color: MyColors.primary60,
                    fontSize: 12,
                    textAlign: .center,
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
