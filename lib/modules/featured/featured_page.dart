import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/featured/widgets/mobile/m_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/tab/t_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/web/featured_data.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'featured_controller.dart';

class FeaturedPage extends GetView<FeaturedController> {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: ListView(
            padding: isDesktop
                ? const .symmetric(vertical: 32, horizontal: 40)
                : const .symmetric(vertical: 20, horizontal: 16),
            children: [
              MyPageHeader(title: "Featured", titleSize: isTab ? 44 : 36),
              SizedBox(height: 20),
              isDesktop
                  ? FeaturedData()
                  : isTab
                  ? TFeaturedData()
                  : MFeaturedData(),
            ],
          ),
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
