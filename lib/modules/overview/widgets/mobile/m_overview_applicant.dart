import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_utility.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../overview_controller.dart';

class MOverviewApplicant extends StatelessWidget {
  const MOverviewApplicant({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverviewController>();
    final latest = controller.latestPending;

    return MyPanel(
      padding: .zero,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                MySectionTitle(text: "Pendaftar terbaru"),
                InkWell(
                  onTap: () => controller.openMenu(route: MyRoutes.athlete),
                  child: MyText(
                    text: "Semua",
                    color: MyColors.primary60,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          if (latest == null)
            MyEmptyState(text: "Belum ada pendaftar baru.")
          else
            Padding(
              padding: const .symmetric(vertical: 16, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: .spaceBetween,
                  crossAxisAlignment: .center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      spacing: 4,
                      children: [
                        MyText(
                          text: "${latest.name ?? "-"}",
                          fontWeight: .w600,
                        ),
                        MyText(
                          text:
                              "${latest.city ?? "-"} · ${formatDate(val: latest.createdAt)}",
                          color: MyColors.primary60,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        MyButton(
                          text: "Tolak",
                          height: 40,
                          fontSize: 13,
                          color: Colors.transparent,
                          textColor: MyColors.secondary,
                          borderColor: MyColors.border,
                          onTap: () =>
                              controller.rejectApplication(id: latest.id),
                        ),
                        MyButton(
                          text: "Terima",
                          height: 40,
                          fontSize: 13,
                          onTap: () =>
                              controller.acceptApplication(id: latest.id),
                        ),
                      ],
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
