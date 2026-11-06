import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/products/list_products_model.dart';
import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_empty_state.dart';
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

        final featured = controller.featured;
        final others = controller.others;

        return Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            MySectionTitle(
              text:
                  "Featured di home (${featured.length}/${FeaturedController.maxFeatured})",
            ),
            MyText(
              text:
                  "Geser ikon di kiri untuk mengubah urutan. Maksimal ${FeaturedController.maxFeatured} produk.",
              color: MyColors.primary60,
              fontSize: 12,
            ),
            SizedBox(height: 4),
            if (featured.isEmpty)
              MyEmptyState(text: "Belum ada produk featured")
            else
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorderItem: (oldIndex, newIndex) => controller
                    .reorderFeatured(oldIndex: oldIndex, newIndex: newIndex),
                children: List.generate(featured.length, (index) {
                  final items = featured[index];

                  return Padding(
                    key: ValueKey(items.productId),
                    padding: const .only(bottom: 8),
                    child: row(controller, items, index),
                  );
                }),
              ),
            if (others.isNotEmpty) ...[
              SizedBox(height: 12),
              MySectionTitle(text: "Produk lain"),
              SizedBox(height: 4),
              for (final items in others) row(controller, items, null),
            ],
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

  Widget row(
    FeaturedController controller,
    ListProductsModel items,
    int? index,
  ) {
    final mainImage = (items.images ?? []).isEmpty
        ? null
        : items.images!.first.imageUrl;

    return Container(
      padding: const .all(10),
      decoration: BoxDecoration(
        color: MyColors.primary90,
        border: .all(color: MyColors.line),
      ),
      child: Row(
        spacing: 12,
        children: [
          if (index != null) ...[
            ReorderableDragStartListener(
              index: index,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Icon(
                  Icons.drag_indicator,
                  size: 22,
                  color: MyColors.primary60,
                ),
              ),
            ),
            MyText(
              text: "${index + 1}",
              color: MyColors.primary60,
              fontFamily: MyFonts.grenzeGotisch,
              fontSize: 20,
              fontWeight: .w600,
            ),
          ],
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
            onChanged: (value) => controller.toggleFeatured(item: items),
          ),
        ],
      ),
    );
  }
}
