import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_images.dart';
import 'package:nocvla_admin/shared/widgets/my_image.dart';
import 'package:nocvla_admin/shared/widgets/my_text.dart';

import '../../dashboard_controller.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: 220,
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Center(
            child: Padding(
              padding: const .symmetric(vertical: 16),
              child: SizedBox(
                width: 160,
                child: MyImageAssets(assets: MyImages.imgNocvla),
              ),
            ),
          ),
          Obx(
            () => Column(
              crossAxisAlignment: .start,
              children: List.generate(controller.menu.length, (index) {
                final isActive =
                    controller.myRoutes.value ==
                    controller.menu[index]["route"];

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    GestureDetector(
                      onTap: () => controller.menu[index]["route"] == null
                          ? null
                          : controller.changeRoute(
                              route: controller.menu[index]["route"],
                            ),
                      child: Container(
                        padding: .symmetric(horizontal: 16),
                        width: 220,
                        height: 40,
                        color: isActive ? Colors.grey[800] : null,
                        child: Align(
                          alignment: .centerLeft,
                          child: MyText(
                            text: controller.menu[index]["name"],
                            fontWeight: isActive ? .w600 : .w400,
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(
                      controller.menu[index]["children"].length,
                      (indexx) {
                        final childRoute =
                            controller.menu[index]["children"][indexx]["route"];
                        final isChildActive =
                            controller.myRoutes.value == childRoute;

                        return GestureDetector(
                          onTap: () =>
                              controller.changeRoute(route: childRoute),
                          child: Container(
                            padding: .symmetric(horizontal: 24),
                            width: 220,
                            height: 40,
                            color: isChildActive ? Colors.grey[800] : null,
                            child: Align(
                              alignment: .centerLeft,
                              child: MyText(
                                text: controller
                                    .menu[index]["children"][indexx]["name"],
                                fontWeight: isChildActive ? .w600 : .w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
