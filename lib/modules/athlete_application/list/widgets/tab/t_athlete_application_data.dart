import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_application_controller.dart';

class TAthleteApplicationData extends StatelessWidget {
  const TAthleteApplicationData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteApplicationController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: Container(
          decoration: BoxDecoration(border: .all(color: MyColors.secondary)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: .all(8),
            itemBuilder: (context, index) {
              final items = controller.res[index];

              return Row(
                spacing: 8,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: MyText(text: items.name, fontWeight: .w500),
                  ),
                  Expanded(child: MyText(text: items.city ?? "-")),
                  Expanded(
                    child: MyText(text: formatDate(val: items.createdAt)),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.viewDetail(id: items.id),
                      child: Icon(
                        Icons.visibility_outlined,
                        color: MyColors.secondary,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.res.length,
          ),
        ),
      );
    });
  }
}
