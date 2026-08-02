import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../athlete_application_detail_controller.dart';

class AthleteApplicationApproveDialog extends StatelessWidget {
  const AthleteApplicationApproveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AthleteApplicationDetailController>();

    return Dialog(
      backgroundColor: MyColors.primary,
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            MyText(
              text: "Approve Application",
              fontSize: 16,
              fontWeight: .w600,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                MyText(text: "Photo"),
                MyText(text: " *", color: MyColors.red),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              final picture = controller.approvePicture.value;

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => controller.pickApprovePicture(),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: .all(color: MyColors.secondary),
                      ),
                      child: picture == null
                          ? Column(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 24,
                                  color: MyColors.secondary,
                                ),
                                MyText(text: "Add Photo", fontSize: 10),
                              ],
                            )
                          : Image.memory(picture.newBytes!, fit: .cover),
                    ),
                  ),
                  if (picture != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeApprovePicture(),
                        child: Container(
                          padding: .all(2),
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            shape: .circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: MyColors.secondary,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 16),
            MyTextFormField(
              controller: controller.txtApproveCode,
              label: "Code",
              required: true,
              keyboardType: .text,
              textInputAction: .done,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: .end,
              spacing: 12,
              children: [
                MyButton(
                  width: 100,
                  text: "Cancel",
                  color: MyColors.primary80,
                  textColor: MyColors.secondary,
                  onTap: () => Get.back(),
                ),
                MyButton(
                  width: 100,
                  text: "Approve",
                  color: MyColors.secondary,
                  textColor: MyColors.primary,
                  onTap: () => controller.submitApprove(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
