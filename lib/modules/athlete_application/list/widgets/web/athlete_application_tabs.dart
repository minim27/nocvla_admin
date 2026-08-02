import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../athlete_application_controller.dart';

class AthleteApplicationTabs extends StatelessWidget {
  const AthleteApplicationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteApplicationController>();

    return DefaultTabController(
      length: AthleteApplicationController.statusTabs.length,
      child: TabBar(
        labelColor: MyColors.secondary,
        unselectedLabelColor: MyColors.primary80,
        indicatorColor: MyColors.secondary,
        onTap: (index) => controller.changeStatus(
          status: AthleteApplicationController.statusTabs[index],
        ),
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Approved"),
          Tab(text: "Rejected"),
        ],
      ),
    );
  }
}
