import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/mobile/m_athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/mobile/m_athlete_header.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/tab/t_athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/tab/t_athlete_header.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/web/athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/web/athlete_header.dart';
import 'package:nocvla_admin/modules/athlete_application/list/athlete_application_controller.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/mobile/m_athlete_application_data.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/tab/t_athlete_application_data.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/web/athlete_application_data.dart';

import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import '../../../shared/widgets/my_tab_bar.dart';
import 'athlete_controller.dart';

class AthletePage extends GetView<AthleteController> {
  const AthletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final application = Get.find<AthleteApplicationController>();
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: Padding(
            padding: isDesktop
                ? const .symmetric(vertical: 32, horizontal: 40)
                : const .symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                if (isDesktop)
                  AthleteHeader()
                else if (isTab)
                  TAthleteHeader()
                else
                  MAthleteHeader(),
                SizedBox(height: 20),
                Obx(
                  () => MyTabBar(
                    selectedIndex: controller.selectedTab.value,
                    onTap: (index) => controller.changeTab(index: index),
                    items: [
                      MyTabItem(label: "Atlet", count: controller.res.length),
                      MyTabItem(
                        label: "Pending",
                        count: application.countOf(status: "pending"),
                        isAlert: true,
                      ),
                      MyTabItem(
                        label: "Diterima",
                        count: application.countOf(status: "approved"),
                      ),
                      MyTabItem(
                        label: "Ditolak",
                        count: application.countOf(status: "rejected"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (controller.selectedTab.value == 0) {
                    if (isDesktop) return AthleteData();
                    if (isTab) return TAthleteData();
                    return MAthleteData();
                  }

                  if (isDesktop) return AthleteApplicationData();
                  if (isTab) return TAthleteApplicationData();
                  return MAthleteApplicationData();
                }),
              ],
            ),
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
