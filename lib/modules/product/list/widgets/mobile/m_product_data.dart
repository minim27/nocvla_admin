import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_parsing_currency.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_controller.dart';

class MProductData extends StatelessWidget {
  const MProductData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          padding: .symmetric(vertical: 12),
          itemBuilder: (context, index) {
            final items = controller.res[index];
            final mainImage = items.images!.isEmpty
                ? null
                : items.images!.first;

            return Container(
              padding: .all(12),
              decoration: BoxDecoration(
                border: .all(color: MyColors.secondary),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (mainImage != null)
                    SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: MyImage(mainImage.imageUrl!),
                    ),
                  SizedBox(height: 12),
                  MyText(text: items.name, fontWeight: .w500),
                  MyText(text: "- ${items.colorName}", fontWeight: .w500),
                  if (items.variation!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    ...items.variation!.map(
                      (varItems) => Padding(
                        padding: .only(bottom: 4),
                        child: MyText(
                          text:
                              "${varItems.size} - ${parsingCurrency(varItems.price)} - Stock: ${varItems.qty}",
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: .end,
                    spacing: 20,
                    children: [
                      GestureDetector(
                        onTap: () => controller.edit(id: items.productId),
                        child: Icon(
                          Icons.edit_document,
                          color: MyColors.secondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            controller.duplicate(id: items.productId),
                        child: Icon(Icons.copy, color: MyColors.secondary),
                      ),
                      GestureDetector(
                        onTap: () => controller.delete(item: items),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: MyColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: controller.res.length,
        ),
      );
    });
  }
}
