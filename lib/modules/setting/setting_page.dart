import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/setting/widgets/mobile/m_setting_form.dart';
import 'package:nocvla_admin/modules/setting/widgets/tab/t_setting_form.dart';
import 'package:nocvla_admin/modules/setting/widgets/web/setting_form.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'setting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: Obx(() {
            if (controller.isLoading.value) return MyLoading();

            return ListView(
              padding: isDesktop
                  ? const .symmetric(vertical: 32, horizontal: 40)
                  : const .symmetric(vertical: 20, horizontal: 16),
              children: [
                MyPageHeader(title: "Pengaturan", titleSize: isTab ? 44 : 36),
                SizedBox(height: 20),
                if (isDesktop)
                  SettingForm(controller: controller)
                else if (isTab)
                  TSettingForm(controller: controller)
                else
                  MSettingForm(controller: controller),
              ],
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
