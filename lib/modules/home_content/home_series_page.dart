import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/home_content/widgets/mobile/m_home_series_form.dart';
import 'package:nocvla_admin/modules/home_content/widgets/tab/t_home_series_form.dart';
import 'package:nocvla_admin/modules/home_content/widgets/web/home_series_form.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'home_content_controller.dart';

class HomeSeriesPage extends GetView<HomeContentController> {
  const HomeSeriesPage({super.key});

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
              MyPageHeader(title: "The Scriptures", titleSize: isTab ? 44 : 36),
              SizedBox(height: 20),
              isDesktop
                  ? HomeSeriesForm()
                  : isTab
                  ? THomeSeriesForm()
                  : MHomeSeriesForm(),
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
