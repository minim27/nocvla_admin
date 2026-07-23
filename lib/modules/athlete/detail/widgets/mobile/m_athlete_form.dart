import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../athlete_detail_controller.dart';

class MAthleteForm extends StatelessWidget {
  const MAthleteForm({super.key, required this.controller});

  final AthleteDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "ATHLETE INFORMATION",
          fontSize: 20,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            MyText(text: "Photo"),
            MyText(text: " *", color: MyColors.red),
          ],
        ),
        SizedBox(height: 8),
        Obx(() {
          final picture = controller.picture.value;

          return Stack(
            children: [
              GestureDetector(
                onTap: () => controller.pickPicture(),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: .all(color: MyColors.secondary),
                  ),
                  child: picture == null
                      ? Column(
                          mainAxisAlignment: .center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 22,
                              color: MyColors.secondary,
                            ),
                            MyText(text: "Add Photo", fontSize: 9),
                          ],
                        )
                      : picture.existingPath != null
                      ? MyImage(picture.existingPath!)
                      : Image.memory(picture.newBytes!, fit: .cover),
                ),
              ),
              if (picture != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.removePicture(),
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
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtName,
          label: "Name",
          required: true,
          keyboardType: .text,
          textInputAction: .next,
        ),
        SizedBox(height: 16),
        MyTextFormField(
          controller: controller.txtCode,
          label: "Code",
          required: true,
          keyboardType: .text,
          textInputAction: .next,
        ),
      ],
    );
  }
}
