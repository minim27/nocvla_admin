import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_dashed_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_switch.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../athlete_detail_controller.dart';

class MAthleteForm extends StatelessWidget {
  const MAthleteForm({super.key, required this.controller});

  final AthleteDetailController controller;

  @override
  Widget build(BuildContext context) {
    final photo = Obx(() {
      final picture = controller.picture.value;

      if (picture == null) {
        return MyDashedButton(
          width: 120,
          height: 120,
          onTap: () => controller.pickPicture(),
          child: Column(
            mainAxisAlignment: .center,
            spacing: 6,
            children: [
              Icon(Icons.add, size: 18, color: MyColors.primary60),
              MyText(
                text: "Foto wajib",
                color: MyColors.primary60,
                fontSize: 12,
              ),
            ],
          ),
        );
      }

      return Stack(
        children: [
          InkWell(
            onTap: () => controller.pickPicture(),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(border: .all(color: MyColors.line)),
              child: picture.existingPath != null
                  ? MyImage(picture.existingPath!)
                  : Image.memory(picture.newBytes!, fit: .cover),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: () => controller.removePicture(),
              child: Container(
                padding: const .all(3),
                color: MyColors.primary,
                child: Icon(Icons.close, size: 14, color: MyColors.secondary),
              ),
            ),
          ),
        ],
      );
    });
    final name = MyTextFormField(
      controller: controller.txtName,
      label: "Nama",
      required: true,
      keyboardType: .text,
      textInputAction: .next,
    );
    final code = MyTextFormField(
      controller: controller.txtCode,
      label: "Kode atlet (unik)",
      required: true,
      keyboardType: .text,
      textInputAction: .next,
    );
    final active = Obx(
      () => Row(
        spacing: 10,
        children: [
          MySwitch(
            value: controller.isActive.value,
            onChanged: (value) => controller.toggleActive(value: value),
          ),
          MyText(
            text: controller.isActive.value
                ? "Tampil di website"
                : "Disembunyikan dari website",
          ),
        ],
      ),
    );

    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [photo, name, code, active],
      ),
    );
  }
}
