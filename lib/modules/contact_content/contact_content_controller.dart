import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../shared/utils/my_utility.dart';

class ContactContentController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  final texts = {
    "CONTACT_EYEBROW": TextEditingController(),
    "CONTACT_TITLE": TextEditingController(),
    "CONTACT_DESCRIPTION": TextEditingController(),
  };

  var faqs = <FaqItem>[].obs;

  final _ids = <String, dynamic>{};

  static const _noWriteAccess =
      "Halaman Kontak belum bisa disimpan: akun ini tidak punya izin menulis.";

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
          if (!texts.containsKey(name)) continue;

          texts[name]!.text = "${row["value"] ?? ""}";
          _ids[name] = row["id"];
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqFaq = await contactRepo.listFaqs();
    await reqFaq.responseHandler(
      res: (res) => faqs.value = [
        for (final e in (res as List))
          FaqItem(
            question: e["question"],
            answer: e["answer"],
            isActive: e["is_active"] ?? true,
          ),
      ],
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  void addFaq() => faqs.add(FaqItem());

  void removeFaq({required int index}) => faqs.removeAt(index);

  void moveFaq({required int index, required int offset}) {
    final target = index + offset;
    if (target < 0 || target >= faqs.length) return;

    final item = faqs.removeAt(index);
    faqs.insert(target, item);
  }

  void toggleFaq({required FaqItem item, required bool value}) {
    item.isActive = value;
    faqs.refresh();
  }

  Future<void> save() async {
    if (faqs.any((e) => e.txtQuestion.text.trim().isEmpty)) {
      return showErrSnackbar(msg: "Pertanyaan wajib diisi");
    }

    isLoadingAction.value = true;
    var hasError = false;

    for (final field in texts.entries) {
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

    if (!hasError) {
      final reqDelete = await contactRepo.deleteAllFaqs();
      await reqDelete.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (!hasError && faqs.isNotEmpty) {
      final reqAdd = await contactRepo.addFaqs(
        body: [
          for (final (i, item) in faqs.indexed)
            {
              "question": item.txtQuestion.text.trim(),
              "answer": item.txtAnswer.text.trim(),
              "is_active": item.isActive,
              "sort_order": i,
            },
        ],
      );
      await reqAdd.responseHandler(
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
    showSnackbar(msg: "Halaman Kontak berhasil disimpan");
  }
}

class FaqItem {
  FaqItem({String? question, String? answer, this.isActive = true}) {
    txtQuestion.text = question ?? "";
    txtAnswer.text = answer ?? "";
  }

  final txtQuestion = TextEditingController();
  final txtAnswer = TextEditingController();
  bool isActive;
}
