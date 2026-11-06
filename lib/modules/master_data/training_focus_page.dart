import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/master_data/widgets/mobile/m_training_focus_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/tab/t_training_focus_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/web/training_focus_list.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'master_data_controller.dart';

class TrainingFocusPage extends GetView<MasterDataController> {
  const TrainingFocusPage({super.key});

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
                MyPageHeader(
                  title: "Fokus Latihan",
                  titleSize: isTab ? 44 : 36,
                ),
                SizedBox(height: 20),
                if (isDesktop)
                  TrainingFocusList()
                else if (isTab)
                  TTrainingFocusList()
                else
                  MTrainingFocusList(),
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
