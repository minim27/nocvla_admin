import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/featured/widgets/mobile/m_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/tab/t_featured_data.dart';
import 'package:nocvla_admin/modules/featured/widgets/web/featured_data.dart';

import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_panel.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'early_access_controller.dart';
import 'widgets/mobile/m_early_access_image_gallery.dart';
import 'widgets/mobile/m_early_access_settings_form.dart';
import 'widgets/tab/t_early_access_image_gallery.dart';
import 'widgets/tab/t_early_access_settings_form.dart';
import 'widgets/web/early_access_image_gallery.dart';
import 'widgets/web/early_access_settings_form.dart';

class EarlyAccessPage extends GetView<EarlyAccessController> {
  const EarlyAccessPage({super.key});

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
              MyPageHeader(title: "Konten & Drop", titleSize: isTab ? 44 : 36),
              SizedBox(height: 20),
              if (isDesktop)
                Row(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: [
                    Expanded(child: FeaturedData()),
                    Expanded(child: _earlyAccess(isDesktop, isTab)),
                  ],
                )
              else ...[
                isTab ? TFeaturedData() : MFeaturedData(),
                SizedBox(height: 16),
                _earlyAccess(isDesktop, isTab),
              ],
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

  Widget _earlyAccess(bool isDesktop, bool isTab) {
    return MyPanel(
      child: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(height: 200, child: MyLoading());
        }

        return Column(
          crossAxisAlignment: .start,
          spacing: 20,
          children: [
            if (isDesktop) ...[
              EarlyAccessSettingsForm(controller: controller),
              EarlyAccessImageGallery(controller: controller),
            ] else if (isTab) ...[
              TEarlyAccessSettingsForm(controller: controller),
              TEarlyAccessImageGallery(controller: controller),
            ] else ...[
              MEarlyAccessSettingsForm(controller: controller),
              MEarlyAccessImageGallery(controller: controller),
            ],
            MyButton(text: "Simpan", onTap: () => controller.save()),
          ],
        );
      }),
    );
  }
}
