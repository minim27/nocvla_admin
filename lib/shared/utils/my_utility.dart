import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/my_text.dart';
import 'my_colors.dart';
import 'my_fonts.dart';

void showSnackbar({required String msg}) => Get.rawSnackbar(
  backgroundColor: MyColors.primary90,
  duration: const Duration(milliseconds: 2500),
  messageText: MyText(
    color: MyColors.secondary,
    text: msg,
    fontFamily: MyFonts.archivo,
  ),
);

void showErrSnackbar({required String msg}) => Get.rawSnackbar(
  backgroundColor: MyColors.red,
  duration: const Duration(milliseconds: 2500),
  messageText: MyText(
    color: MyColors.white,
    text: msg,
    fontFamily: MyFonts.archivo,
  ),
);

copy({required String val}) {
  Clipboard.setData(ClipboardData(text: val));
  showSnackbar(msg: "Salin teks berhasil!");
}

formatDate({required dynamic val, bool isString = true}) =>
    DateFormat("dd MMM yyyy").format((isString) ? DateTime.parse(val) : val);

String? marketplaceUrlError({required String type, required String url}) {
  final value = url.trim().toLowerCase();
  if (value.isEmpty) return null;

  final isTokopedia = value.contains("tokopedia.com");

  switch (type) {
    case "shopee":
      if (value.contains("shopee.co.id") || value.contains("shp.ee")) {
        return null;
      }
      return "Ini bukan link Shopee. Masukkan link dari shopee.co.id atau shp.ee.";
    case "tiktok":
      if (value.contains("tiktok.com") || value.contains("vt.tokopedia.com")) {
        return null;
      }
      return isTokopedia
          ? "Ini link Tokopedia. Masukkan link dari TikTok Shop (tiktok.com atau vt.tokopedia.com)."
          : "Ini bukan link TikTok Shop. Masukkan link dari tiktok.com atau vt.tokopedia.com.";
    default:
      if (isTokopedia) return null;
      return "Ini bukan link Tokopedia. Masukkan link dari tokopedia.com.";
  }
}
