import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_dashed_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_detail_controller.dart';

class TPDProdPhoto extends StatelessWidget {
  const TPDProdPhoto({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MySectionTitle(text: "Foto per warna"),
          SizedBox(height: 8),
          MyText(
            text: "Geser untuk mengurutkan. Foto pertama menjadi foto utama.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
          SizedBox(height: 16),
          Obx(
            () => Column(
              children: List.generate(controller.colorTags.length, (
                colorIndex,
              ) {
                final tag = controller.colorTags[colorIndex];

                return Container(
                  width: double.infinity,
                  padding: const .symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: MyColors.lineSoft)),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 10,
                    children: [
                      ListenableBuilder(
                        listenable: tag.txtName,
                        builder: (context, _) => Obx(
                          () => MyText(
                            text:
                                "${tag.txtName.text.isEmpty ? "Warna ${colorIndex + 1}" : tag.txtName.text} · ${tag.gallery.length} foto",
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: Row(
                          spacing: 10,
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
                                  children: List.generate(tag.gallery.length, (
                                    imageIndex,
                                  ) {
                                    final image = tag.gallery[imageIndex];

                                    return ReorderableDragStartListener(
                                      key: ValueKey(image),
                                      index: imageIndex,
                                      child: Padding(
                                        padding: const .only(right: 10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                border: .all(
                                                  color: imageIndex == 0
                                                      ? MyColors.secondary
                                                      : MyColors.line,
                                                ),
                                              ),
                                              child: image.existingPath != null
                                                  ? MyImage(image.existingPath!)
                                                  : Image.memory(
                                                      image.newBytes!,
                                                      fit: .cover,
                                                    ),
                                            ),
                                            if (imageIndex == 0)
                                              Positioned(
                                                left: 6,
                                                top: 6,
                                                child: Container(
                                                  padding: const .symmetric(
                                                    vertical: 3,
                                                    horizontal: 6,
                                                  ),
                                                  color: MyColors.secondary,
                                                  child: MyText(
                                                    text: "UTAMA",
                                                    color: MyColors.primary,
                                                    fontFamily:
                                                        MyFonts.archivoNarrow,
                                                    fontSize: 10,
                                                    fontWeight: .w700,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: InkWell(
                                                onTap: () =>
                                                    controller.removeImage(
                                                      colorIndex: colorIndex,
                                                      imageIndex: imageIndex,
                                                    ),
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
                            ),
                            MyDashedButton(
                              width: 120,
                              height: 120,
                              onTap: () =>
                                  controller.pickImage(colorIndex: colorIndex),
                              child: Column(
                                mainAxisAlignment: .center,
                                spacing: 6,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 18,
                                    color: MyColors.primary60,
                                  ),
                                  MyText(
                                    text: "Tambah",
                                    color: MyColors.primary60,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  }
}
