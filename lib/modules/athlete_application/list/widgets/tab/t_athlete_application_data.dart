import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_empty_state.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_status_badge.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_application_controller.dart';

class TAthleteApplicationData extends StatelessWidget {
  const TAthleteApplicationData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteApplicationController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      final data = controller.filtered;

      return Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.primary90,
            border: .all(color: MyColors.line),
          ),
          child: data.isEmpty
              ? MyEmptyState(text: "Belum ada data di tab ini.")
              : ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final items = data[index];
                    final badge = switch (items.status) {
                      "approved" => MyStatusBadge(
                        text: "Diterima",
                        color: MyColors.green,
                      ),
                      "rejected" => MyStatusBadge(
                        text: "Ditolak",
                        color: MyColors.redText,
                      ),
                      _ => MyStatusBadge(
                        text: "Pending",
                        color: MyColors.yellow,
                      ),
                    };

                    return InkWell(
                      onTap: () => controller.viewDetail(id: items.id),
                      child: Padding(
                        padding: const .symmetric(vertical: 14, horizontal: 20),
                        child: Row(
                          spacing: 14,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 3,
                                children: [
                                  MyText(
                                    text: "${items.name ?? "-"}",
                                    fontSize: 15,
                                    fontWeight: .w600,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                  MyText(
                                    text:
                                        "${items.city ?? "-"} · ${formatDate(val: items.createdAt)}",
                                    color: MyColors.primary60,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                            ),
                            badge,
                            MyIconButton(
                              icon: Icons.chevron_right,
                              tooltip: "Lihat detail",
                              onTap: () => controller.viewDetail(id: items.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
