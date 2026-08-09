import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_loading.dart';
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

                final Widget settingsForm;
                final Widget imageGallery;

                if (isDesktop) {
                  settingsForm = EarlyAccessSettingsForm(controller: controller);
                  imageGallery = EarlyAccessImageGallery(controller: controller);
                } else if (isTab) {
                  settingsForm = TEarlyAccessSettingsForm(controller: controller);
                  imageGallery = TEarlyAccessImageGallery(controller: controller);
                } else {
                  settingsForm = MEarlyAccessSettingsForm(controller: controller);
                  imageGallery = MEarlyAccessImageGallery(controller: controller);
                }

                return ListView(
                  padding: .symmetric(horizontal: 16, vertical: 24),
                  children: [
                    settingsForm,
                    SizedBox(height: 36),
                    imageGallery,
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
