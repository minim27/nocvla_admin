import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/dashboard_shell.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_page_header.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'athlete_detail_controller.dart';
import 'widgets/mobile/m_athlete_form.dart';
import 'widgets/mobile/m_athlete_products.dart';
import 'widgets/tab/t_athlete_form.dart';
import 'widgets/tab/t_athlete_products.dart';
import 'widgets/web/athlete_form.dart';
import 'widgets/web/athlete_products.dart';

class AthleteDetailPage extends GetView<AthleteDetailController> {
  const AthleteDetailPage({super.key});

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

              final Widget form;
              final Widget products;

              if (isDesktop) {
                form = AthleteForm(controller: controller);
                products = AthleteProducts(controller: controller);
              } else if (isTab) {
                form = TAthleteForm(controller: controller);
                products = TAthleteProducts(controller: controller);
              } else {
                form = MAthleteForm(controller: controller);
                products = MAthleteProducts(controller: controller);
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
                          title: controller.params.id == null
                              ? "Atlet baru"
                              : controller.txtName.text,
                          titleSize: isTab ? 40 : 32,
                        ),
                        SizedBox(height: 20),
                        form,
                        SizedBox(height: 20),
                        products,
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
                        MyButton(
                          text: "Batal",
                          color: Colors.transparent,
                          textColor: MyColors.secondary,
                          borderColor: MyColors.border,
                          fontSize: 13,
                          onTap: () => Get.back(),
                        ),
                        MyButton(
                          text: "Simpan",
                          fontSize: 13,
                          onTap: () => controller.save(),
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
