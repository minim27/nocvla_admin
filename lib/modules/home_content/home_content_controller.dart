import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../shared/utils/my_utility.dart';

class HomeContentController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var resProducts = <Map<String, dynamic>>[].obs;

  dynamic heroId;
  var txtEyebrow = TextEditingController();
  var txtTitle = TextEditingController();
  var txtDesc = TextEditingController();
  var heroPath = RxnString();
  var heroBytes = Rxn<Uint8List>();
  String? heroFileName;
  var heroProduct = Rxn<Map<String, dynamic>>();

  var series = <SeriesItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  Future<void> fetchApi() async {
    isLoading.value = true;

    final reqProducts = await productsRepo.listProductNames();
    await reqProducts.responseHandler(
      res: (res) => resProducts.value = List<Map<String, dynamic>>.from(res),
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqHero = await homeContentRepo.getHero();
    await reqHero.responseHandler(
      res: (res) {
        if (res == null) return;

        heroId = res["id"];
        txtEyebrow.text = res["eyebrow"] ?? "";
        txtTitle.text = res["title"] ?? "";
        txtDesc.text = res["description"] ?? "";
        heroPath.value = res["image_url"];
        heroBytes.value = null;
        heroProduct.value = findProduct(res["cta_product_id"]);
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqSeries = await homeContentRepo.listSeries();
    await reqSeries.responseHandler(
      res: (res) => series.value = (res as List).map((e) {
        return SeriesItem(
          label: e["label"],
          title: e["title"],
          desc: e["description"],
          path: e["image_url"],
          product: findProduct(e["product_id"]),
          isActive: e["is_active"] == true,
        );
      }).toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Map<String, dynamic>? findProduct(dynamic id) =>
      resProducts.firstWhereOrNull((e) => e["id"] == id);

  Future<PlatformFile?> pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    return result?.files.firstOrNull;
  }

  Future<void> pickHeroImage() async {
    final file = await pickImage();
    if (file?.bytes == null) return;

    heroBytes.value = file!.bytes;
    heroFileName = file.name;
  }

  Future<void> pickSeriesImage({required SeriesItem item}) async {
    final file = await pickImage();
    if (file?.bytes == null) return;

    item.newBytes = file!.bytes;
    item.newFileName = file.name;
    series.refresh();
  }

  void addSeries() => series.add(SeriesItem());

  void removeSeries({required int index}) => series.removeAt(index);

  void selectSeriesProduct({required SeriesItem item, dynamic value}) {
    item.product = value;
    series.refresh();
  }

  void toggleSeries({required SeriesItem item, required bool value}) {
    item.isActive = value;
    series.refresh();
  }

  Future<String?> upload(Uint8List bytes, String name) async {
    String? path;

    final req = await homeContentRepo.uploadImage(
      bytes: bytes,
      fileName: "${DateTime.now().millisecondsSinceEpoch}_$name",
    );
    await req.responseHandler(
      res: (res) => path = res,
      err: (err) => showErrSnackbar(msg: err),
    );

    return path;
  }

  Future<void> save() async {
    if (txtTitle.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Judul hero wajib diisi");
    }
    if (heroPath.value == null && heroBytes.value == null) {
      return showErrSnackbar(msg: "Foto hero wajib diisi");
    }
    if (series.any((e) => e.txtTitle.text.trim().isEmpty)) {
      return showErrSnackbar(msg: "Judul seri wajib diisi");
    }

    isLoadingAction.value = true;
    final saved = await saveHero() && await saveSeries();
    isLoadingAction.value = false;

    if (!saved) return;

    await fetchApi();
    showSnackbar(msg: "Konten Home berhasil disimpan");
  }

  Future<bool> saveHero() async {
    var path = heroPath.value;

    if (heroBytes.value != null) {
      path = await upload(heroBytes.value!, heroFileName!);
      if (path == null) return false;
    }

    final body = {
      "eyebrow": txtEyebrow.text.trim(),
      "title": txtTitle.text.trim(),
      "description": txtDesc.text.trim(),
      "image_url": path,
      "cta_product_id": heroProduct.value?["id"],
    };

    final req = heroId == null
        ? await homeContentRepo.addHero(
            body: {
              ...body,
              "is_active": true,
              "sort_order": 0,
              "start_date": DateTime.now().toUtc().toIso8601String(),
              "end_date": "2099-12-31",
            },
          )
        : await homeContentRepo.updateHero(id: heroId, body: body);

    var isSuccess = true;
    await req.responseHandler(
      res: (res) => heroId = res["id"],
      err: (err) {
        isSuccess = false;
        showErrSnackbar(msg: err);
      },
    );

    return isSuccess;
  }

  Future<bool> saveSeries() async {
    final rows = <Map<String, dynamic>>[];

    for (var i = 0; i < series.length; i++) {
      final item = series[i];
      var path = item.path;

      if (item.newBytes != null) {
        path = await upload(item.newBytes!, item.newFileName!);
        if (path == null) return false;
      }

      rows.add({
        "label": item.txtLabel.text.trim(),
        "title": item.txtTitle.text.trim(),
        "description": item.txtDesc.text.trim(),
        "image_url": path,
        "product_id": item.product?["id"],
        "is_active": item.isActive,
        "sort_order": i,
      });
    }

    var isSuccess = true;

    final reqDelete = await homeContentRepo.deleteAllSeries();
    await reqDelete.responseHandler(
      res: (res) {},
      err: (err) {
        isSuccess = false;
        showErrSnackbar(msg: err);
      },
    );

    if (!isSuccess || rows.isEmpty) return isSuccess;

    final reqAdd = await homeContentRepo.addSeries(body: rows);
    await reqAdd.responseHandler(
      res: (res) {},
      err: (err) {
        isSuccess = false;
        showErrSnackbar(msg: err);
      },
    );

    return isSuccess;
  }
}

class SeriesItem {
  SeriesItem({
    String? label,
    String? title,
    String? desc,
    this.path,
    this.product,
    this.isActive = true,
  }) {
    txtLabel.text = label ?? "";
    txtTitle.text = title ?? "";
    txtDesc.text = desc ?? "";
  }

  final txtLabel = TextEditingController();
  final txtTitle = TextEditingController();
  final txtDesc = TextEditingController();
  String? path;
  Uint8List? newBytes;
  String? newFileName;
  Map<String, dynamic>? product;
  bool isActive;
}
