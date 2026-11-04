import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_loading.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../featured_controller.dart';

class TFeaturedData extends StatelessWidget {
  const TFeaturedData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeaturedController>();

    return MyPanel(
      child: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(height: 200, child: MyLoading());
        }

        final products = controller.products;

        return Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            MySectionTitle(text: "Featured di home"),
            SizedBox(height: 8),
            ...List.generate(products.length, (index) {
              final items = products[index];
              final mainImage = (items.images ?? []).isEmpty
                  ? null
                  : items.images!.first.imageUrl;

              return Container(
                padding: const .all(10),
                decoration: BoxDecoration(border: .all(color: MyColors.line)),
                child: Row(
                  spacing: 12,
                  children: [
                    MyText(
                      text: "${index + 1}",
                      color: MyColors.primary60,
                      fontFamily: MyFonts.grenzeGotisch,
                      fontSize: 20,
                      fontWeight: .w600,
                    ),
                    MyThumbnail(image: mainImage, size: 44),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 2,
                        children: [
                          MyText(
                            text: "${items.name ?? "-"}",
                            fontWeight: .w600,
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                          MyText(
                            text: "${controller.colorCount(item: items)} warna",
                            color: MyColors.primary60,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    MySwitch(
                      value: items.isFeatured == true,
                      onChanged: (value) =>
                          controller.toggleFeatured(item: items),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 4),
            MyText(
              text:
                  "Featured dipilih per produk, warna tampil sebagai titik di kartu.",
              color: MyColors.primary60,
              fontSize: 12,
            ),
          ],
        );
      }),
    );
  }
}
