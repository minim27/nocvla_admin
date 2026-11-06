import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/about_content/widgets/mobile/m_about_content_form.dart';
import 'package:nocvla_admin/modules/about_content/widgets/tab/t_about_content_form.dart';
import 'package:nocvla_admin/modules/about_content/widgets/web/about_content_form.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'about_content_controller.dart';

class AboutContentPage extends GetView<AboutContentController> {
  const AboutContentPage({super.key});

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
              MyPageHeader(
                title: "Halaman Tentang",
                titleSize: isTab ? 44 : 36,
              ),
              SizedBox(height: 20),
              isDesktop
                  ? AboutContentForm()
                  : isTab
                  ? TAboutContentForm()
                  : MAboutContentForm(),
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
