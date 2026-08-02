import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'athlete_application_detail_controller.dart';
import 'widgets/mobile/m_athlete_application_detail_view.dart';
import 'widgets/tab/t_athlete_application_detail_view.dart';
import 'widgets/web/athlete_application_detail_view.dart';

class AthleteApplicationDetailPage
    extends GetView<AthleteApplicationDetailController> {
  const AthleteApplicationDetailPage({super.key});

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

                final Widget detail;

                if (isDesktop) {
                  detail = AthleteApplicationDetailView(controller: controller);
                } else if (isTab) {
                  detail = TAthleteApplicationDetailView(
                    controller: controller,
                  );
                } else {
                  detail = MAthleteApplicationDetailView(
                    controller: controller,
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: .symmetric(horizontal: 16, vertical: 24),
                        child: detail,
                      ),
                    ),
                    Padding(
                      padding: .symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        spacing: 12,
                        children: [
                          if (controller.application.value?.status !=
                              "rejected")
                            Expanded(
                              child: MyButton(
                                text: "Reject",
                                color: MyColors.red,
                                textColor: MyColors.secondary,
                                onTap: () => controller.reject(),
                              ),
                            ),
                          if (controller.application.value?.status !=
                              "approved")
                            Expanded(
                              child: MyButton(
                                text: "Approve",
                                onTap: () => controller.approve(),
                              ),
                            ),
                        ],
                      ),
                    ),
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
