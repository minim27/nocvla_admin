import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_dashed_button.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../early_access_controller.dart';

class MEarlyAccessSettingsForm extends StatelessWidget {
  const MEarlyAccessSettingsForm({super.key, required this.controller});

  final EarlyAccessController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 16,
      children: [
        Obx(
          () => Row(
            spacing: 10,
            children: [
              Expanded(child: MySectionTitle(text: "Early access gate")),
              MySwitch(
                value: controller.isEarlyAccess.value,
                onChanged: (value) =>
                    controller.toggleEarlyAccess(value: value),
              ),
              MyText(
                text: controller.isEarlyAccess.value ? "Aktif" : "Nonaktif",
                fontSize: 13,
              ),
            ],
          ),
        ),
        MyTextFormField(
          controller: controller.txtEndAt,
          label: "Gate dibuka pada",
          hintText: "Pilih tanggal & waktu",
          tapped: true,
          onTap: controller.pickEndDate,
          suffixIcon: Icon(
            Icons.calendar_month_outlined,
            size: 18,
            color: MyColors.primary60,
          ),
        ),
        Obx(
          () => Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              MyTextFormField(
                controller: controller.txtPassword,
                label: "Kata sandi",
                hintText: controller.hasPasswordSet.value
                    ? "Kosongkan jika tidak ingin mengganti"
                    : "Kata sandi untuk dibagikan ke customer",
                keyboardType: .text,
                isPassword: true,
                obscureText: controller.obscurePassword.value,
                icPassOnTap: controller.togglePasswordVisibility,
              ),
              Row(
                spacing: 8,
                children: [
                  MyButton(
                    text: "Buat acak",
                    fontSize: 13,
                    color: Colors.transparent,
                    textColor: MyColors.secondary,
                    borderColor: MyColors.border,
                    onTap: controller.generatePassword,
                  ),
                  MyButton(
                    text: "Salin",
                    fontSize: 13,
                    color: Colors.transparent,
                    textColor: MyColors.secondary,
                    borderColor: MyColors.border,
                    onTap: controller.copyPassword,
                  ),
                ],
              ),
              MyText(
                text: controller.hasPasswordSet.value
                    ? "Kata sandi sudah diset. Disimpan sebagai hash dan dicek di server."
                    : "Kata sandi belum diset.",
                color: MyColors.primary60,
                fontSize: 12,
              ),
            ],
          ),
        ),
        MySectionTitle(text: "Halaman gate"),
        Obx(() {
          final bytes = controller.background.newBytes.value;
          final path = controller.background.path.value;

          return MyDashedButton(
            width: 200,
            height: 120,
            onTap: controller.pickBackground,
            child: bytes != null
                ? Image.memory(bytes, fit: .cover, width: double.infinity)
                : path != null
                ? MyImage(path)
                : MyText(
                    text: "Gambar latar",
                    color: MyColors.primary60,
                    fontSize: 12,
                  ),
          );
        }),
        MyTextFormField(
          controller: controller.texts["EARLY_ACCESS_EYEBROW"],
          label: "Eyebrow",
          hintText: "Early access · Drop berikutnya",
        ),
        MyTextFormField(
          controller: controller.texts["EARLY_ACCESS_TITLE"],
          label: "Judul",
          hintText: "The Gate Opens Soon",
        ),
        MyTextFormField(
          controller: controller.texts["EARLY_ACCESS_DESCRIPTION"],
          label: "Deskripsi",
          hintText: "Akses lebih awal hanya untuk yang punya kata sandi.",
          maxLines: 3,
          keyboardType: .multiline,
        ),
      ],
    );
  }
}
