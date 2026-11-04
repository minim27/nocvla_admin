import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_page_header.dart';
import '../../product_controller.dart';

class TProductHeader extends StatelessWidget {
  const TProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(
      () => MyPageHeader(
        eyebrow:
            "${controller.allGroups.length} produk · ${controller.res.length} colorway",
        title: "Produk & Stok",
        titleSize: 44,
        actions: [
          MyButton(text: "+ Produk baru", onTap: () => controller.add()),
        ],
      ),
    );
  }
}
