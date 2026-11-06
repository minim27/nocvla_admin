import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../shared/utils/my_utility.dart';

class AboutContentController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  final texts = {
    "ABOUT_EYEBROW": TextEditingController(),
    "ABOUT_TITLE": TextEditingController(),
    "ABOUT_DESCRIPTION": TextEditingController(),
    "ABOUT_STORY_EYEBROW": TextEditingController(),
    "ABOUT_STORY_TITLE": TextEditingController(),
    "ABOUT_STORY_BODY": TextEditingController(),
    "ABOUT_MISSION": TextEditingController(),
    "ABOUT_VISION": TextEditingController(),
    "ABOUT_VALUES": TextEditingController(),
    "ABOUT_CRAFT_EYEBROW": TextEditingController(),
    "ABOUT_CRAFT_TITLE": TextEditingController(),
    for (var i = 1; i <= 4; i++) ...{
      "ABOUT_CRAFT_${i}_TITLE": TextEditingController(),
      "ABOUT_CRAFT_${i}_DESC": TextEditingController(),
    },
    "ABOUT_CTA_TITLE": TextEditingController(),
  };

  final images = <String, AboutImage>{
    "ABOUT_IMAGE": AboutImage(),
    "ABOUT_STORY_IMAGE_1": AboutImage(),
    "ABOUT_STORY_IMAGE_2": AboutImage(),
  };

  final _ids = <String, dynamic>{};

  static const _noWriteAccess =
      "Halaman Tentang belum bisa disimpan: akun ini tidak punya izin menulis.";

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    for (final txt in texts.values) {
      txt.dispose();
    }
    super.onClose();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await configRepo.listConfigs();
    await req.responseHandler(
      res: (res) {
        for (final row in (res as List)) {
          final name = row["name"];
          final value = "${row["value"] ?? ""}";

          if (texts.containsKey(name)) {
            texts[name]!.text = value;
          } else if (images.containsKey(name)) {
            images[name]!.path.value = value.isEmpty ? null : value;
          } else {
            continue;
          }
          _ids[name] = row["id"];
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Future<void> pickImage(String key) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final file = result?.files.firstOrNull;
    if (file?.bytes == null) return;

    images[key]!.newFileName = file!.name;
    images[key]!.newBytes.value = file.bytes;
  }

  Future<void> save() async {
    isLoadingAction.value = true;
    var hasError = false;

    final fields = {for (final e in texts.entries) e.key: e.value.text.trim()};

    for (final e in images.entries) {
      if (hasError) break;

      var path = e.value.path.value;
      final bytes = e.value.newBytes.value;
      if (bytes != null) {
        final req = await homeContentRepo.uploadImage(
          bytes: bytes,
          fileName:
              "${DateTime.now().millisecondsSinceEpoch}_${e.value.newFileName}",
        );
        await req.responseHandler(
          res: (res) => path = res,
          err: (err) {
            hasError = true;
            showErrSnackbar(msg: err);
          },
        );
      }
      fields[e.key] = path ?? "";
    }

    for (final field in fields.entries) {
      if (hasError) break;

      final id = _ids[field.key];
      if (id == null && field.value.isEmpty) continue;

      final req = id == null
          ? await configRepo.addConfig(name: field.key, value: field.value)
          : await configRepo.updateConfig(id: id, value: field.value);
      await req.responseHandler(
        res: (res) {
          if (id != null && (res as List).isEmpty) {
            hasError = true;
            showErrSnackbar(msg: _noWriteAccess);
          }
        },
        err: (err) {
          hasError = true;
          showErrSnackbar(
            msg: "$err".contains("row-level security") ? _noWriteAccess : err,
          );
        },
      );
    }

    isLoadingAction.value = false;

    if (hasError) return;

    for (final image in images.values) {
      image.newBytes.value = null;
    }
    await fetchApi();
    showSnackbar(msg: "Halaman Tentang berhasil disimpan");
  }
}

class AboutImage {
  final path = RxnString();
  final newBytes = Rxn<Uint8List>();
  String? newFileName;
}
