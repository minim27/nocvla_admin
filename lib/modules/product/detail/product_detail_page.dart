import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'product_detail_controller.dart';
import 'widgets/mobile/m_pd_prodinfo.dart';
import 'widgets/mobile/m_pd_prodvar.dart';
import 'widgets/tab/t_pd_prodinfo.dart';
import 'widgets/tab/t_pd_prodvar.dart';
import 'widgets/web/pd_prodinfo.dart';
import 'widgets/web/pd_prodvar.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          appBar: AppBar(),
          body: Obx(() {
            if (controller.isLoading.value) return MyLoading();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1280;
                final isTab = constraints.maxWidth >= 768;

                final Widget prodInfo;
                final Widget prodVar;

                if (isDesktop) {
                  prodInfo = PDProdInfo(controller: controller);
                  prodVar = PDProdVar(controller: controller);
                } else if (isTab) {
                  prodInfo = TPDProdInfo(controller: controller);
                  prodVar = TPDProdVar(controller: controller);
                } else {
                  prodInfo = MPDProdInfo(controller: controller);
                  prodVar = MPDProdVar(controller: controller);
                }

                return ListView(
                  padding: .symmetric(horizontal: 16, vertical: 24),
                  children: [
                    prodInfo,
                    SizedBox(height: 36),
                    prodVar,
                    SizedBox(height: 36),
                    MyButton(text: "Save", onTap: () => controller.save()),
                  ],
                );
              },
            );
          }),
        ),
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
