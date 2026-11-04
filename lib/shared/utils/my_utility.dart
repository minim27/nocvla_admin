import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

void showMyErrAPISnackbar(dynamic err) {
  print(err);
  print(err["errors"] == null);

  Get.snackbar(
    (err["errors"] == null) ? "Oopsss..." : err["message"],
    (err["errors"] == null)
        ? (err["message"] ?? err["detail"])
        : "${err["errors"].first["field"]} ${err["errors"].first["message"]}",
    titleText: MyText(
      text: (err["errors"] == null) ? "Oopsss..." : err["message"],
      color: MyColors.white,
    ),
    messageText: MyText(
      text: (err["errors"] == null)
          ? (err["message"] ?? err["detail"])
          : "${err["errors"].first["field"]} ${err["errors"].first["message"]}",
      color: MyColors.white,
    ),
    backgroundColor: MyColors.red,
  );
}

Color hexToColor({required String hex}) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse('0x$hex'));
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatDuration(Duration d) {
  final days = twoDigits(d.inDays);
  final hours = twoDigits(d.inHours.remainder(24));
  final minutes = twoDigits(d.inMinutes.remainder(60));
  final seconds = twoDigits(d.inSeconds.remainder(60));
  return "$days:$hours:$minutes:$seconds";
}

changeStatusBool({required RxBool val}) => val.value = !val.value;

copy({required String val}) {
  Clipboard.setData(ClipboardData(text: val));
  showSnackbar(msg: "Salin teks berhasil!");
}

formatDate({required dynamic val, bool isString = true}) =>
    DateFormat("dd MMM yyyy").format((isString) ? DateTime.parse(val) : val);

List<XFile>? fpFile;
dynamic bytes;
late String img64;

set imageFile(XFile? value) {
  fpFile = value == null ? null : [value];
  bytes = File(fpFile![0].path).readAsBytesSync();
  img64 = base64Encode(bytes);
}

// Future changePict({
//   required RxString variable,
//   required RxBool isLoading,
// }) async {
//   await showModalBottomSheet(
//     context: Get.context!,
//     useSafeArea: true,
//     builder: (context) => Container(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//       width: Get.size.width,
//       decoration: const BoxDecoration(
//         color: MyColors.black,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () => selectImageFrom(
//               variable: variable,
//               isLoading: isLoading,
//               gallery: true,
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: MyColors.primaryDefault.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.image_outlined,
//                     color: MyColors.primaryDefault,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const MyText(
//                   text: "Select from gallery",
//                   color: MyColors.bwWhite,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ],
//             ),
//           ),
//           const Divider(color: MyColors.bwDivider),
//           GestureDetector(
//             onTap: () => selectImageFrom(
//               variable: variable,
//               isLoading: isLoading,
//               camera: true,
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: MyColors.primaryDefault.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.camera_alt_outlined,
//                     color: MyColors.primaryDefault,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const MyText(
//                   text: "Take from camera",
//                   color: MyColors.bwWhite,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// selectImageFrom({
//   required RxString variable,
//   required RxBool isLoading,
//   bool camera = false,
//   bool gallery = false,
// }) async {
//   isLoading.value = true;

//   if (kIsWeb) {
//     // Flutter Web
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//       withData: true,
//     );

//     if (result != null && result.files.single.bytes != null) {
//       Uint8List fileBytes = result.files.single.bytes!;
//       String fileName = result.files.single.name;

//       final formData = dio.FormData.fromMap({
//         "file": dio.MultipartFile.fromBytes(fileBytes, filename: fileName),
//       });

//       final req = await MiscRepository().upload(data: formData);
//       await req.responseHandler(
//         res: (res) {
//           var data = <UploadModel>[];
//           data.add(UploadModel.fromJson(res["data"]));

//           print(data[0].url);
//           variable.value = data[0].url;
//           print(variable.value);
//         },
//         err: (err) => showErrSnackbar(msg: err),
//       );
//     }
//   } else {
//     ImagePicker picker = ImagePicker();
//     XFile? pickedFile;
//     if (gallery) {
//       pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     } else if (camera) {
//       pickedFile = await picker.pickImage(source: ImageSource.camera);
//     }

//     if (pickedFile != null) {
//       imageFile = pickedFile;

//       var formData = dio.FormData.fromMap({
//         "file": await dio.MultipartFile.fromFile(fpFile![0].path),
//       });

//       var req = await MiscRepository().upload(data: formData);
//       await req.responseHandler(
//         res: (res) {
//           var data = <UploadModel>[];
//           data.add(UploadModel.fromJson(res["data"]));

//           variable.value = data[0].url;
//         },
//         err: (err) => showErrSnackbar(msg: err),
//       );

//       Get.back();
//     }
//   }

//   isLoading.value = false;
// }

String formatHex(String input) {
  input = input.trim();
  if (!input.startsWith('#')) return '#$input';

  return input;
}

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
