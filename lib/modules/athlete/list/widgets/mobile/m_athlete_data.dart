import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_controller.dart';

class MAthleteData extends StatelessWidget {
  const MAthleteData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          padding: .symmetric(vertical: 12),
          itemBuilder: (context, index) {
            final items = controller.res[index];

            return Container(
              padding: .all(12),
              decoration: BoxDecoration(
                border: .all(color: MyColors.secondary),
              ),
              child: Row(
                spacing: 12,
                children: [
                  if (items.picture != null)
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: .all(color: MyColors.secondary),
                      ),
                      child: MyImage(items.picture),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        MyText(text: items.name, fontWeight: .w500),
                        MyText(text: items.code),
                        if ((items.assignedProducts ?? []).isNotEmpty) ...[
                          SizedBox(height: 8),
                          ...items.assignedProducts!.map(
                            (productName) => Padding(
                              padding: .only(bottom: 4),
                              child: MyText(text: productName),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      GestureDetector(
                        onTap: () => controller.edit(id: items.id),
                        child: Icon(
                          Icons.edit_document,
                          color: MyColors.secondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.delete(id: items.id),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: MyColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
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
