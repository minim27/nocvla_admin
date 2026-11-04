import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/dashboard_shell.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_page_header.dart';
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
          body: DashboardShell(
            child: Obx(() {
              if (controller.isLoading.value) return MyLoading();

              final width = MediaQuery.sizeOf(context).width;
              final isDesktop = width >= 1280;
              final isTab = width >= 768;

              final Widget detail;

              if (isDesktop) {
                detail = AthleteApplicationDetailView(controller: controller);
              } else if (isTab) {
                detail = TAthleteApplicationDetailView(controller: controller);
              } else {
                detail = MAthleteApplicationDetailView(controller: controller);
              }

              final horizontal = isDesktop ? 40.0 : 16.0;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: .fromLTRB(
                        horizontal,
                        isDesktop ? 32 : 20,
                        horizontal,
                        24,
                      ),
                      children: [
                        Align(
                          alignment: .centerLeft,
                          child: MyBackLink(
                            text: "Atlet & Pendaftar",
                            onTap: () => Get.back(),
                          ),
                        ),
                        SizedBox(height: 16),
                        MyPageHeader(
                          title: "${controller.application.value?.name ?? "-"}",
                          titleSize: isTab ? 40 : 32,
                        ),
                        SizedBox(height: 20),
                        detail,
                      ],
                    ),
                  ),
                  Container(
                    padding: .symmetric(horizontal: horizontal, vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: MyColors.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: .end,
                      spacing: 8,
                      children: [
                        if (controller.application.value?.status != "rejected")
                          MyButton(
                            text: "Tolak",
                            color: Colors.transparent,
                            textColor: MyColors.secondary,
                            borderColor: MyColors.border,
                            fontSize: 13,
                            onTap: () => controller.reject(),
                          ),
                        if (controller.application.value?.status != "approved")
                          MyButton(
                            text: "Terima & buat atlet",
                            fontSize: 13,
                            onTap: () => controller.approve(),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
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
