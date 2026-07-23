import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_loading.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../featured_controller.dart';

class TFeaturedData extends StatelessWidget {
  const TFeaturedData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeaturedController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            MyText(
              text: "Featured Products",
              fontSize: 22,
              fontFamily: MyFonts.libreBaskerville,
            ),
            SizedBox(height: 8),
            MyText(
              text:
                  "Pilih produk yang ingin ditampilkan sebagai rekomendasi di halaman awal.",
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: .all(color: MyColors.secondary),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: .all(8),
                  itemBuilder: (context, index) {
                    final items = controller.res[index];
                    final mainImage = items.images!.isEmpty
                        ? null
                        : items.images!.first;

                    return Row(
                      spacing: 8,
                      children: [
                        if (mainImage != null)
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              border: .all(color: MyColors.secondary),
                            ),
                            child: MyImage(mainImage.imageUrl!),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              MyText(text: items.name, fontWeight: .w500),
                              MyText(text: "- ${items.color}"),
                            ],
                          ),
                        ),
                        Switch(
                          value: items.isFeatured == true,
                          activeThumbColor: MyColors.green,
                          onChanged: (value) =>
                              controller.toggleFeatured(index: index),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: controller.res.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
