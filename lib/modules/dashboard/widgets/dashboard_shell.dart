import 'package:flutter/material.dart';

import 'mobile/m_dashboard_sidebar.dart';
import 'tab/t_dashboard_sidebar.dart';
import 'web/dashboard_sidebar.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1280;
        final isTab = constraints.maxWidth >= 768;

        if (isDesktop) {
          return Row(
            children: [
              DashboardSidebar(),
              Expanded(child: child),
            ],
          );
        }

        return Column(
          children: [
            isTab ? TDashboardSidebar() : MDashboardSidebar(),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
