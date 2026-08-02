import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/mobile/m_athlete_application_data.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/mobile/m_athlete_application_header.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/mobile/m_athlete_application_tabs.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/tab/t_athlete_application_column.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/tab/t_athlete_application_data.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/tab/t_athlete_application_header.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/tab/t_athlete_application_tabs.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/web/athlete_application_column.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/web/athlete_application_data.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/web/athlete_application_header.dart';
import 'package:nocvla_admin/modules/athlete_application/list/widgets/web/athlete_application_tabs.dart';

import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'athlete_application_controller.dart';

class AthleteApplicationPage extends GetView<AthleteApplicationController> {
  const AthleteApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          body: Padding(
            padding: const .symmetric(vertical: 24, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1280;
                final isTab = constraints.maxWidth >= 768;

                if (isDesktop) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      AthleteApplicationHeader(),
                      SizedBox(height: 24),
                      AthleteApplicationTabs(),
                      SizedBox(height: 24),
                      AthleteApplicationColumn(),
                      AthleteApplicationData(),
                    ],
                  );
                }

                if (isTab) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      TAthleteApplicationHeader(),
                      SizedBox(height: 24),
                      TAthleteApplicationTabs(),
                      SizedBox(height: 24),
                      TAthleteApplicationColumn(),
                      TAthleteApplicationData(),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    MAthleteApplicationHeader(),
                    SizedBox(height: 24),
                    MAthleteApplicationTabs(),
                    SizedBox(height: 24),
                    MAthleteApplicationData(),
                  ],
                );
              },
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
