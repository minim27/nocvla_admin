import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/early_access/early_access_image_model.dart';
import '../../data/models/early_access/early_access_settings_model.dart';
import '../../shared/utils/my_utility.dart';
import '../../shared/widgets/my_confirm_dialog.dart';

class EarlyAccessController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  dynamic settingsId;
  var isEarlyAccess = false.obs;
  var endAt = Rxn<DateTime>();
  var txtEndAt = TextEditingController();
  var txtPassword = TextEditingController();
  var hasPasswordSet = false.obs;
  var obscurePassword = true.obs;

  var images = <EarlyAccessImageItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  Future<void> fetchApi() async {
    isLoading.value = true;

    final reqSettings = await earlyAccessRepo.getSettings();
    await reqSettings.responseHandler(
      res: (res) {
        final settings = EarlyAccessSettingsModel.fromJson(res);
        settingsId = settings.id;
        isEarlyAccess.value = settings.isEarlyAccess == true;
        hasPasswordSet.value = (settings.earlyAccessPassword ?? "").isNotEmpty;
        txtPassword.clear();
        endAt.value = settings.earlyAccessEndAt == null
            ? null
            : DateTime.parse(settings.earlyAccessEndAt);
        txtEndAt.text = endAt.value == null
            ? ""
            : DateFormat("dd MMM yyyy HH:mm").format(endAt.value!);
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqImages = await earlyAccessRepo.listImages();
    await reqImages.responseHandler(
      res: (res) {
        images.value = (res as List)
            .map((e) => EarlyAccessImageModel.fromJson(e))
            .map((e) => EarlyAccessImageItem(existingPath: e.imageUrl))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  void toggleEarlyAccess({required bool value}) => isEarlyAccess.value = value;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void generatePassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    txtPassword.text = List.generate(
      24,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  void copyPassword() => copy(val: txtPassword.text);

  Future<void> pickEndDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: endAt.value ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: endAt.value == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(endAt.value!),
    );
    if (pickedTime == null) return;

    endAt.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    txtEndAt.text = DateFormat("dd MMM yyyy HH:mm").format(endAt.value!);
  }

  Future<void> pickImages() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.bytes == null) continue;
      images.add(
        EarlyAccessImageItem(newBytes: file.bytes, newFileName: file.name),
      );
    }
  }

  Future<void> removeImage({required int index}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Gambar?");
    if (!confirmed) return;

    images.removeAt(index);
  }

  void reorderImages({required int oldIndex, required int newIndex}) {
    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);
  }

  Future<void> save() async {
    if (isEarlyAccess.value) {
      if (endAt.value == null) {
        return showErrSnackbar(msg: "Tanggal akhir countdown wajib diisi");
      }
      if (!hasPasswordSet.value && txtPassword.text.trim().isEmpty) {
        return showErrSnackbar(msg: "Password wajib diisi");
      }
      if (images.isEmpty) {
        return showErrSnackbar(msg: "Gambar wajib diisi minimal 1");
      }
    }

    isLoadingAction.value = true;
    var hasError = false;

    final settingsBody = {
      "is_early_access": isEarlyAccess.value,
      "early_access_end_at": endAt.value?.toIso8601String(),
    };

    final reqSettings = await earlyAccessRepo.updateSettings(
      id: settingsId,
      body: settingsBody,
    );
    await reqSettings.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    if (txtPassword.text.trim().isNotEmpty) {
      final reqPassword = await earlyAccessRepo.setPassword(
        newPassword: txtPassword.text.trim(),
      );
      await reqPassword.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    final imageRows = <Map<String, dynamic>>[];
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      String? path = image.existingPath;

      if (path == null && image.newBytes != null) {
        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${image.newFileName!}";
        final reqUpload = await earlyAccessRepo.uploadImage(
          bytes: image.newBytes!,
          fileName: fileName,
        );
        await reqUpload.responseHandler(
          res: (res) => path = res,
          err: (err) {
            hasError = true;
            showErrSnackbar(msg: err);
          },
        );
      }

      if (path != null) {
        imageRows.add({"image_url": path, "sort_order": i});
      }
    }

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    final reqDeleteImages = await earlyAccessRepo.deleteAllImages();
    await reqDeleteImages.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    if (imageRows.isNotEmpty) {
      final reqAddImages = await earlyAccessRepo.addImages(body: imageRows);
      await reqAddImages.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    isLoadingAction.value = false;

    if (hasError) return;

    await fetchApi();
    showSnackbar(msg: "Early Access Settings berhasil disimpan");
  }
}

class EarlyAccessImageItem {
  final String? existingPath;
  final Uint8List? newBytes;
  final String? newFileName;

  EarlyAccessImageItem({this.existingPath, this.newBytes, this.newFileName});
}
