import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_parsing_currency.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_controller.dart';

class ProductData extends StatelessWidget {
  const ProductData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: Container(
          decoration: BoxDecoration(border: .all(color: MyColors.secondary)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: .all(12),
            itemBuilder: (context, index) {
              final items = controller.res[index];
              final mainImage = items.images!.isEmpty
                  ? null
                  : items.images!.first;

              return Column(
                children: [
                  Row(
                    spacing: 12,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          spacing: 12,
                          children: [
                            if (mainImage != null)
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: .all(color: MyColors.secondary),
                                ),
                                child: MyImage(mainImage.imageUrl!),
                              ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  MyText(text: items.name, fontWeight: .w500),
                                  MyText(
                                    text: "- ${items.color}",
                                    fontWeight: .w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Expanded(child: SizedBox()),
                      Expanded(child: SizedBox()),
                      Expanded(
                        child: Row(
                          spacing: 20,
                          children: [
                            GestureDetector(
                              onTap: () => controller.edit(id: items.id),
                              child: Icon(
                                Icons.edit_document,
                                color: MyColors.secondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.duplicate(id: items.id),
                              child: Icon(
                                Icons.copy,
                                color: MyColors.secondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.delete(id: items.id),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: MyColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (items.variation!.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: .all(12),
                      itemBuilder: (context, indexx) {
                        final varItems = items.variation![indexx];

                        return Row(
                          spacing: 12,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: MyText(
                                text: varItems.size,
                                fontWeight: .w500,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: MyText(
                                  text: "-",
                                  fontWeight: .w500,
                                  textAlign: .center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: MyText(
                                  text: parsingCurrency(varItems.price),
                                  fontWeight: .w500,
                                  textAlign: .center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: MyText(
                                  text: varItems.qty.toString(),
                                  fontWeight: .w500,
                                  textAlign: .center,
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: items.variation!.length,
                    ),
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.res.length,
          ),
        ),
      );
    });
  }
}
