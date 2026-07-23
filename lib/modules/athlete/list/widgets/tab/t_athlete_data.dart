import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_controller.dart';

class TAthleteData extends StatelessWidget {
  const TAthleteData({super.key});

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
            padding: .all(8),
            itemBuilder: (context, index) {
              final items = controller.res[index];

              return Column(
                children: [
                  Row(
                    spacing: 8,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: items.picture != null
                            ? Align(
                                alignment: .centerLeft,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: .all(color: MyColors.secondary),
                                  ),
                                  child: MyImage(items.picture),
                                ),
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
                          spacing: 14,
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
                  ),

                  if ((items.assignedProducts ?? []).isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: .all(8),
                      itemBuilder: (context, indexx) {
                        final productName = items.assignedProducts![indexx];

                        return Row(
                          spacing: 8,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Expanded(child: SizedBox()),
                            Expanded(
                              flex: 2,
                              child: MyText(
                                text: productName,
                                fontWeight: .w500,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Expanded(child: SizedBox()),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: items.assignedProducts!.length,
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
