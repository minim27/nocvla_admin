import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import 'my_button.dart';
import 'my_text.dart';

Future<bool> showMyConfirmDialog({
  required String title,
  String message = "Data yang sudah dihapus tidak bisa dikembalikan.",
  String confirmText = "Delete",
}) async {
  final result = await Get.dialog<bool>(
    Dialog(
      backgroundColor: MyColors.primary90,
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            MyText(
              text: title,
              color: MyColors.secondary,
              fontSize: 16,
              fontWeight: .w600,
            ),
            const SizedBox(height: 8),
            MyText(text: message, color: MyColors.primary60),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: .end,
              spacing: 12,
              children: [
                MyButton(
                  width: 100,
                  text: "Cancel",
                  color: Colors.transparent,
                  textColor: MyColors.secondary,
                  borderColor: MyColors.border,
                  onTap: () => Get.back(result: false),
                ),
                MyButton(
                  width: 100,
                  text: confirmText,
                  color: MyColors.red,
                  textColor: MyColors.white,
                  onTap: () => Get.back(result: true),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return result ?? false;
}
