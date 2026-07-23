import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/mobile/m_athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/mobile/m_athlete_header.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/tab/t_athlete_column.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/tab/t_athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/tab/t_athlete_header.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/web/athlete_column.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/web/athlete_data.dart';
import 'package:nocvla_admin/modules/athlete/list/widgets/web/athlete_header.dart';

import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'athlete_controller.dart';

class AthletePage extends GetView<AthleteController> {
  const AthletePage({super.key});

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
                      AthleteHeader(),
                      SizedBox(height: 24),
                      AthleteColumn(),
                      AthleteData(),
                    ],
                  );
                }

                if (isTab) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      TAthleteHeader(),
                      SizedBox(height: 24),
                      TAthleteColumn(),
                      TAthleteData(),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    MAthleteHeader(),
                    SizedBox(height: 24),
                    MAthleteData(),
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
