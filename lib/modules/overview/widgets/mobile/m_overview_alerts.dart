import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../overview_controller.dart';

class MOverviewAlerts extends StatelessWidget {
  const MOverviewAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverviewController>();
    final alerts = controller.alerts;

    return MyPanel(
      padding: .zero,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(vertical: 18, horizontal: 20),
            child: MySectionTitle(text: "Perlu perhatian"),
          ),
          Divider(height: 1),
          if (alerts.isEmpty)
            MyEmptyState(text: "Tidak ada yang perlu perhatian.")
          else
            ...alerts.map(
              (alert) => Container(
                padding: const .symmetric(vertical: 14, horizontal: 20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: MyColors.lineSoft)),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  spacing: 14,
                  children: [
                    Padding(
                      padding: const .only(top: 5),
                      child: Container(
                        width: 8,
                        height: 8,
                        color: alert.isDanger
                            ? MyColors.redText
                            : MyColors.yellow,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          MyText(text: alert.title, fontWeight: .w600),
                          MyText(
                            text: alert.description,
                            color: MyColors.primary60,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: alert.onTap,
                      child: MyText(
                        text: alert.cta,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
