import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_page_header.dart';
import '../../product_controller.dart';

class MProductHeader extends StatelessWidget {
  const MProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(
      () => MyPageHeader(
        eyebrow:
            "${controller.allGroups.length} produk · ${controller.res.length} colorway",
        title: "Produk & Stok",
        titleSize: 36,
        actions: [
          MyButton(text: "+ Produk baru", onTap: () => controller.add()),
        ],
      ),
    );
  }
}
