import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/overview/widgets/mobile/m_overview_alerts.dart';
import 'package:nocvla_admin/modules/overview/widgets/mobile/m_overview_applicant.dart';
import 'package:nocvla_admin/modules/overview/widgets/mobile/m_overview_kpis.dart';
import 'package:nocvla_admin/modules/overview/widgets/mobile/m_overview_stock.dart';
import 'package:nocvla_admin/modules/overview/widgets/tab/t_overview_alerts.dart';
import 'package:nocvla_admin/modules/overview/widgets/tab/t_overview_applicant.dart';
import 'package:nocvla_admin/modules/overview/widgets/tab/t_overview_kpis.dart';
import 'package:nocvla_admin/modules/overview/widgets/tab/t_overview_stock.dart';
import 'package:nocvla_admin/modules/overview/widgets/web/overview_alerts.dart';
import 'package:nocvla_admin/modules/overview/widgets/web/overview_applicant.dart';
import 'package:nocvla_admin/modules/overview/widgets/web/overview_kpis.dart';
import 'package:nocvla_admin/modules/overview/widgets/web/overview_stock.dart';

import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'overview_controller.dart';

class OverviewPage extends GetView<OverviewController> {
  const OverviewPage({super.key});

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
                  eyebrow: controller.todayLabel,
                  title: "Dashboard",
                  titleSize: isTab ? 44 : 36,
                  actions: [
                    MyButton(
                      text: "+ Produk baru",
                      onTap: () => controller.addProduct(),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                if (isDesktop) ...[
                  OverviewKpis(),
                  SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      Expanded(child: OverviewStock()),
                      Expanded(
                        child: Column(
                          spacing: 16,
                          children: [OverviewAlerts(), OverviewApplicant()],
                        ),
                      ),
                    ],
                  ),
                ] else if (isTab) ...[
                  TOverviewKpis(),
                  SizedBox(height: 20),
                  TOverviewStock(),
                  SizedBox(height: 16),
                  TOverviewAlerts(),
                  SizedBox(height: 16),
                  TOverviewApplicant(),
                ] else ...[
                  MOverviewKpis(),
                  SizedBox(height: 20),
                  MOverviewStock(),
                  SizedBox(height: 16),
                  MOverviewAlerts(),
                  SizedBox(height: 16),
                  MOverviewApplicant(),
                ],
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
