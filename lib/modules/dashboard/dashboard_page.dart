import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/mobile/m_dashboard_sidebar.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/tab/t_dashboard_sidebar.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/web/dashboard_sidebar.dart';

import '../../shared/widgets/my_scaffold.dart';
import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1280;
        final isTab = constraints.maxWidth >= 768;

        if (isDesktop) {
          return MyScaffold(
            body: Row(
              children: [
                DashboardSidebar(),
                Expanded(
                  child: Obx(
                    () => GetRouterOutlet(
                      initialRoute: controller.myRoutes.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return MyScaffold(
          appBar: AppBar(),
          drawer: Drawer(
            child: isTab ? TDashboardSidebar() : MDashboardSidebar(),
          ),
          body: Obx(
            () => GetRouterOutlet(initialRoute: controller.myRoutes.value),
          ),
        );
      },
    );
  }
}
