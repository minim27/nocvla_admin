import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../early_access_controller.dart';

class TEarlyAccessSettingsForm extends StatelessWidget {
  const TEarlyAccessSettingsForm({super.key, required this.controller});

  final EarlyAccessController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "Early Access Settings",
          fontSize: 22,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 16),
        Obx(
          () => Row(
            children: [
              Switch(
                value: controller.isEarlyAccess.value,
                activeThumbColor: MyColors.green,
                onChanged: (value) =>
                    controller.toggleEarlyAccess(value: value),
              ),
              SizedBox(width: 8),
              MyText(text: "Aktifkan Early Access Gate"),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: MyTextFormField(
            controller: controller.txtEndAt,
            label: "Countdown End At",
            hintText: "Pilih tanggal & waktu",
            tapped: true,
            onTap: controller.pickEndDate,
            suffixIcon: Icon(Icons.calendar_month_outlined),
          ),
        ),
        SizedBox(height: 16),
        Obx(
          () => SizedBox(
            width: 280,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  crossAxisAlignment: .end,
                  children: [
                    Expanded(
                      child: MyTextFormField(
                        controller: controller.txtPassword,
                        label: "Password",
                        hintText: controller.hasPasswordSet.value
                            ? "Kosongkan jika tidak ingin mengganti password"
                            : "Password untuk dibagikan ke customer",
                        keyboardType: .text,
                        isPassword: true,
                        obscureText: controller.obscurePassword.value,
                        icPassOnTap: controller.togglePasswordVisibility,
                      ),
                    ),
                    IconButton(
                      tooltip: "Generate Password",
                      onPressed: controller.generatePassword,
                      icon: Icon(Icons.autorenew),
                    ),
                    IconButton(
                      tooltip: "Copy Password",
                      onPressed: controller.copyPassword,
                      icon: Icon(Icons.copy_outlined),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                MyText(
                  text: controller.hasPasswordSet.value
                      ? "Password sudah diset."
                      : "Password belum diset.",
                  fontSize: 12,
                  color: MyColors.primary60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
