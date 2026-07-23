import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_controller.dart';

class AthleteData extends StatelessWidget {
  const AthleteData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      return Expanded(
        child: Container(
          decoration: BoxDecoration(border: .all(color: MyColors.secondary)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: .all(12),
            itemBuilder: (context, index) {
              final items = controller.res[index];

              return Row(
                spacing: 12,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: items.picture != null
                        ? Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              border: .all(color: MyColors.secondary),
                            ),
                            child: MyImage(items.picture),
                          )
                        : SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: MyText(text: items.name, fontWeight: .w500),
                  ),
                  Expanded(
                    child: MyText(text: items.code, fontWeight: .w500),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 12,
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
