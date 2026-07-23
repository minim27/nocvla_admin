import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import 'my_button.dart';
import 'my_text.dart';

Future<bool> showMyConfirmDialog({
  required String title,
  String message = "Data yang sudah dihapus tidak bisa dikembalikan.",
}) async {
  final result = await Get.dialog<bool>(
    Dialog(
      backgroundColor: MyColors.secondary,
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            MyText(
              text: title,
              color: MyColors.primary,
              fontSize: 16,
              fontWeight: .w600,
            ),
            const SizedBox(height: 8),
            MyText(text: message, color: MyColors.primary),
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
                  onTap: () => Get.back(result: false),
                ),
                MyButton(
                  width: 100,
                  text: "Delete",
                  color: MyColors.red,
                  textColor: MyColors.secondary,
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
