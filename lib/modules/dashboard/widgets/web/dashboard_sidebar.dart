import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_colors.dart';
import 'package:nocvla_admin/shared/utils/my_fonts.dart';
import 'package:nocvla_admin/shared/utils/my_images.dart';
import 'package:nocvla_admin/shared/widgets/my_icon_button.dart';
import 'package:nocvla_admin/shared/widgets/my_image.dart';
import 'package:nocvla_admin/shared/widgets/my_text.dart';

import '../../dashboard_controller.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: MyColors.primary90,
        border: Border(right: BorderSide(color: MyColors.line)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(vertical: 24, horizontal: 20),
            child: Row(
              spacing: 10,
              children: [
                SizedBox(
                  height: 34,
                  child: MyImageAssets(
                    assets: MyImages.imgNocvla,
                    fit: .contain,
                  ),
                ),
                Container(
                  padding: const .symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(border: .all(color: MyColors.line)),
                  child: MyText(
                    text: "ADMIN",
                    color: MyColors.primary60,
                    fontFamily: MyFonts.archivoNarrow,
                    fontSize: 11,
                    fontWeight: .w600,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const .symmetric(horizontal: 12),
            child: Obx(
              () => Column(
                children: List.generate(controller.menu.length, (index) {
                  final item = controller.menu[index];
                  final isActive = controller.isMenuActive(item);
                  final badge = switch (item["hasBadge"]) {
                    true => controller.pendingCount.value,
                    "message" => controller.unreadCount.value,
                    _ => 0,
                  };

                  return Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            controller.changeRoute(route: item["route"]),
                        child: Container(
                          height: 44,
                          padding: const .symmetric(horizontal: 12),
                          color: isActive ? MyColors.selected : null,
                          child: Row(
                            spacing: 12,
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                color: isActive ? MyColors.red : null,
                              ),
                              Expanded(
                                child: MyText(
                                  text: item["name"],
                                  color: isActive
                                      ? MyColors.secondary
                                      : MyColors.primary60,
                                  fontWeight: isActive ? .w600 : .w500,
                                ),
                              ),
                              if (badge > 0)
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 22,
                                  ),
                                  height: 22,
                                  padding: const .symmetric(horizontal: 6),
                                  alignment: .center,
                                  color: MyColors.red,
                                  child: MyText(
                                    text: "$badge",
                                    color: MyColors.white,
                                    fontSize: 12,
                                    fontWeight: .w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (isActive)
                        for (final child in (item["children"] as List?) ?? [])
                          InkWell(
                            onTap: () =>
                                controller.changeRoute(route: child["route"]),
                            child: Container(
                              height: 36,
                              width: double.infinity,
                              padding: const .only(left: 39),
                              alignment: .centerLeft,
                              child: MyText(
                                text: child["name"],
                                fontSize: 13,
                                color:
                                    controller.myRoutes.value == child["route"]
                                    ? MyColors.secondary
                                    : MyColors.primary60,
                                fontWeight:
                                    controller.myRoutes.value == child["route"]
                                    ? .w600
                                    : .w500,
                              ),
                            ),
                          ),
                    ],
                  );
                }),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: const .all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: MyColors.line)),
            ),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: .center,
                  color: MyColors.line,
                  child: MyText(
                    text: controller.userEmail[0].toUpperCase(),
                    fontFamily: MyFonts.archivoNarrow,
                    fontWeight: .w700,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      MyText(
                        text: controller.userEmail,
                        fontSize: 13,
                        fontWeight: .w600,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                      MyText(
                        text: "Admin",
                        color: MyColors.primary60,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                MyIconButton(
                  icon: Icons.logout,
                  tooltip: "Keluar",
                  size: 36,
                  iconSize: 16,
                  color: MyColors.primary60,
                  onTap: () => controller.logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
