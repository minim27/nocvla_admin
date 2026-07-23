import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/featured/widgets/mobile/m_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/tab/t_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/web/featured_data.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'featured_controller.dart';

class FeaturedPage extends GetView<FeaturedController> {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          body: Padding(
            padding: const .symmetric(vertical: 24, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1280;
                final isTab = constraints.maxWidth >= 768;

                if (isDesktop) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [FeaturedData()],
                  );
                }

                if (isTab) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [TFeaturedData()],
                  );
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [MFeaturedData()],
                );
              },
            ),
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
