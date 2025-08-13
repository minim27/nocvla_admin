import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/shared/widgets/my_text.dart';

import '../../../shared/widgets/my_scaffold.dart';
import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  controller.menu.length,
                  (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => controller.menu[index]["route"] == null
                            ? null
                            : controller.changeRoute(
                                route: controller.menu[index]["route"],
                              ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: 220,
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: MyText(text: controller.menu[index]["name"]),
                          ),
                        ),
                      ),
                      ...List.generate(
                        controller.menu[index]["children"].length,
                        (indexx) => GestureDetector(
                          onTap: () => controller.changeRoute(
                            route: controller
                                .menu[index]["children"][indexx]["route"],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            width: 220,
                            height: 40,
                            child: MyText(
                              text: controller
                                  .menu[index]["children"][indexx]["name"],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Konten kanan
          Expanded(
            child: Obx(
              () => GetRouterOutlet(initialRoute: controller.myRoutes.value),
            ),
          ),
        ],
      ),
    );
  }
}
