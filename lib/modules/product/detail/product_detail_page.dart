import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/product/detail/widget/pd_prodvar.dart';

import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'product_detail_controller.dart';
import 'widget/pd_prodinfo.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.isLoading.value) return MyLoading();

          return MyScaffold(
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                PDProdInfo(controller: controller),
                SizedBox(height: 36),
                PDProdVar(controller: controller),
                SizedBox(height: 36),
                MyButton(text: "Save", onTap: () => controller.save()),
              ],
            ),
          );
        }),
        Obx(
          () => Visibility(
            visible: controller.isLoadingAction.value,
            child: const MyLoading(isStack: true),
          ),
        ),
      ],
    );
  }
}
