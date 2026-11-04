import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../shared/utils/my_utility.dart';

class SettingController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtWaNumber = TextEditingController();
  var txtWaTemplate = TextEditingController();
  var txtInstagram = TextEditingController();
  var txtTiktok = TextEditingController();
  var txtEmail = TextEditingController();
  var txtDiscord = TextEditingController();
  var txtMarketplace = TextEditingController();

  static const _noWriteAccess =
      "Pengaturan belum bisa disimpan: izin tulis m_configurations belum aktif.";

  final _ids = <String, dynamic>{};

  Map<String, TextEditingController> get _fields => {
    "WA_NUMBER": txtWaNumber,
    "WA_TEMPLATE": txtWaTemplate,
    "INSTAGRAM": txtInstagram,
    "TIKTOK": txtTiktok,
    "CONTACT_EMAIL": txtEmail,
    "LINK_DISCORD": txtDiscord,
    "DEFAULT_MARKETPLACE_URL": txtMarketplace,
  };

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await configRepo.listConfigs();
    await req.responseHandler(
      res: (res) {
        for (final row in (res as List)) {
          final txt = _fields[row["name"]];
          if (txt == null) continue;
          txt.text = row["value"] ?? "";
          _ids[row["name"]] = row["id"];
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Future<void> save() async {
    isLoadingAction.value = true;
    var hasError = false;

    for (final field in _fields.entries) {
      final id = _ids[field.key];
      final value = field.value.text.trim();
      if (id == null && value.isEmpty) continue;

      final req = id == null
          ? await configRepo.addConfig(name: field.key, value: value)
          : await configRepo.updateConfig(id: id, value: value);
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

      if (hasError) break;
    }

    isLoadingAction.value = false;

    if (hasError) return;

    await fetchApi();
    showSnackbar(msg: "Pengaturan berhasil disimpan");
  }
}
