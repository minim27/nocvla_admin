import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/utils/my_images.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../login_controller.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: MyPanel(
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            Row(
              spacing: 10,
              children: [
                SizedBox(
                  height: 34,
                  child: MyImageAssets(
                    assets: MyImages.imgNocvla,
                    fit: .contain,
                  ),
                ),
                Container(
                  padding: const .symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(border: .all(color: MyColors.line)),
                  child: MyText(
                    text: "ADMIN",
                    color: MyColors.primary60,
                    fontFamily: MyFonts.archivoNarrow,
                    fontSize: 11,
                    fontWeight: .w600,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
            MyText(
              text: "Masuk",
              fontFamily: MyFonts.grenzeGotisch,
              fontSize: 40,
              fontWeight: .w600,
            ),
            MyTextFormField(
              controller: controller.txtEmail,
              label: "Email",
              keyboardType: .emailAddress,
              textInputAction: .next,
            ),
            Obx(
              () => MyTextFormField(
                controller: controller.txtPassword,
                label: "Kata sandi",
                keyboardType: .text,
                textInputAction: .done,
                isPassword: true,
                obscureText: controller.obscurePassword.value,
                icPassOnTap: controller.togglePasswordVisibility,
                onFieldSubmitted: (_) => controller.login(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MyButton(text: "Masuk", onTap: () => controller.login()),
            ),
          ],
        ),
      ),
    );
  }
}
