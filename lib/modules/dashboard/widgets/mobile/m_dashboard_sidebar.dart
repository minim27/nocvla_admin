import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_colors.dart';
import 'package:nocvla_admin/shared/utils/my_fonts.dart';
import 'package:nocvla_admin/shared/utils/my_images.dart';
import 'package:nocvla_admin/shared/widgets/my_icon_button.dart';
import 'package:nocvla_admin/shared/widgets/my_image.dart';
import 'package:nocvla_admin/shared/widgets/my_tab_bar.dart';
import 'package:nocvla_admin/shared/widgets/my_text.dart';

import '../../dashboard_controller.dart';

class MDashboardSidebar extends StatelessWidget {
  const MDashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: MyColors.primary90,
        border: Border(bottom: BorderSide(color: MyColors.line)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .fromLTRB(16, 12, 16, 12),
            child: Row(
              spacing: 10,
              children: [
                SizedBox(
                  height: 28,
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
                Spacer(),
                MyIconButton(
                  icon: Icons.logout,
                  tooltip: "Keluar",
                  size: 32,
                  iconSize: 15,
                  color: MyColors.primary60,
                  onTap: () => controller.logout(),
                ),
              ],
            ),
          ),
          ScrollConfiguration(
            behavior: const MyDragScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 8),
              child: Obx(
                () => Row(
                  children: List.generate(controller.menu.length, (index) {
                    final item = controller.menu[index];
                    final isActive = controller.myRoutes.value == item["route"];
                    final badge = item["hasBadge"] == true
                        ? controller.pendingCount.value
                        : 0;

                    return InkWell(
                      onTap: () => controller.changeRoute(route: item["route"]),
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
                            MyText(
                              text: item["name"],
                              color: isActive
                                  ? MyColors.secondary
                                  : MyColors.primary60,
                              fontWeight: isActive ? .w600 : .w500,
                            ),
                            if (badge > 0)
                              Container(
                                constraints: const BoxConstraints(minWidth: 22),
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
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
