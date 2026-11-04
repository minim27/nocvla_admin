import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_empty_state.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_status_badge.dart';
import '../../../../../shared/widgets/my_switch.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_controller.dart';

class AthleteData extends StatelessWidget {
  const AthleteData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.primary90,
            border: .all(color: MyColors.line),
          ),
          child: controller.res.isEmpty
              ? MyEmptyState(text: "Belum ada atlet.")
              : ListView.separated(
                  itemCount: controller.res.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final items = controller.res[index];
                    final products = items.assignedProducts ?? [];
                    final hasPicture = "${items.picture ?? ""}".isNotEmpty;
                    final isIncomplete = !hasPicture || products.isEmpty;

                    final thumb = hasPicture
                        ? MyThumbnail(image: items.picture, size: 52)
                        : Container(
                            width: 52,
                            height: 52,
                            alignment: .center,
                            color: MyColors.line,
                            child: MyText(
                              text: "${items.name ?? "-"}"[0],
                              fontFamily: MyFonts.grenzeGotisch,
                              fontSize: 24,
                              fontWeight: .w600,
                            ),
                          );
                    final info = Column(
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
                              "Kode ${items.code ?? "-"} · ${products.isEmpty ? "belum ada produk" : "${products.length} produk"}",
                          color: MyColors.primary60,
                          fontSize: 13,
                        ),
                      ],
                    );
                    final badge = items.isActive == true
                        ? (isIncomplete
                              ? MyStatusBadge(
                                  text: "Belum lengkap",
                                  color: MyColors.yellow,
                                )
                              : MyStatusBadge(
                                  text: "Aktif",
                                  color: MyColors.green,
                                ))
                        : MyStatusBadge(
                            text: "Nonaktif",
                            borderColor: MyColors.line,
                          );
                    final actions = Row(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        MySwitch(
                          value: items.isActive == true,
                          onChanged: (value) =>
                              controller.toggleActive(index: index),
                        ),
                        MyIconButton(
                          icon: Icons.edit_outlined,
                          tooltip: "Edit",
                          onTap: () => controller.edit(id: items.id),
                        ),
                        MyIconButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: "Hapus",
                          color: MyColors.primary60,
                          onTap: () => controller.delete(id: items.id),
                        ),
                      ],
                    );

                    return Padding(
                      padding: const .symmetric(vertical: 14, horizontal: 20),
                      child: Row(
                        spacing: 14,
                        children: [
                          thumb,
                          Expanded(child: info),
                          badge,
                          actions,
                        ],
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
