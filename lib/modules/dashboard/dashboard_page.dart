import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/dashboard_shell.dart';

import '../../shared/widgets/my_scaffold.dart';
import 'dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: DashboardShell(
        child: Obx(
          () => GetRouterOutlet(initialRoute: controller.myRoutes.value),
        ),
      ),
    );
  }
}
