import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_application_controller.dart';

class MAthleteApplicationData extends StatelessWidget {
  const MAthleteApplicationData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteApplicationController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          padding: .symmetric(vertical: 12),
          itemBuilder: (context, index) {
            final items = controller.res[index];

            return GestureDetector(
              onTap: () => controller.viewDetail(id: items.id),
              child: Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  border: .all(color: MyColors.secondary),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          MyText(text: items.name, fontWeight: .w500),
                          MyText(text: items.city ?? "-"),
                          MyText(text: formatDate(val: items.createdAt)),
                        ],
                      ),
                    ),
                    Icon(Icons.visibility_outlined, color: MyColors.secondary),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: controller.res.length,
        ),
      );
    });
  }
}
