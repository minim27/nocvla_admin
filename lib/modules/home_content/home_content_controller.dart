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

  var heroes = <HeroItem>[].obs;
  final _deletedHeroIds = <dynamic>[];

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

    final reqHeroes = await homeContentRepo.listHeroes();
    await reqHeroes.responseHandler(
      res: (res) {
        _deletedHeroIds.clear();
        heroes.value = (res as List).map((e) {
          return HeroItem(
            id: e["id"],
            eyebrow: e["eyebrow"],
            title: e["title"],
            desc: e["description"],
            path: e["image_url"],
            product: findProduct(e["cta_product_id"]),
            isActive: e["is_active"] == true,
          );
        }).toList();
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

  Future<void> pickHeroImage({required HeroItem item}) async {
    final file = await pickImage();
    if (file?.bytes == null) return;

    item.newBytes = file!.bytes;
    item.newFileName = file.name;
    heroes.refresh();
  }

  void addHero() => heroes.add(HeroItem());

  void removeHero({required int index}) {
    final item = heroes.removeAt(index);
    if (item.id != null) _deletedHeroIds.add(item.id);
  }

  void moveHero({required int index, required int offset}) {
    final target = index + offset;
    if (target < 0 || target >= heroes.length) return;

    heroes.insert(target, heroes.removeAt(index));
  }

  void selectHeroProduct({required HeroItem item, dynamic value}) {
    item.product = value;
    heroes.refresh();
  }

  void toggleHero({required HeroItem item, required bool value}) {
    item.isActive = value;
    heroes.refresh();
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

  Future<void> saveHomeHero() async {
    if (heroes.any((e) => e.txtTitle.text.trim().isEmpty)) {
      return showErrSnackbar(msg: "Judul hero wajib diisi");
    }
    if (heroes.any((e) => e.path == null && e.newBytes == null)) {
      return showErrSnackbar(msg: "Foto hero wajib diisi");
    }

    isLoadingAction.value = true;
    final saved = await saveHero();
    isLoadingAction.value = false;

    if (!saved) return;

    await fetchApi();
    showSnackbar(msg: "Hero Home berhasil disimpan");
  }

  Future<void> saveHomeSeries() async {
    if (series.any((e) => e.txtTitle.text.trim().isEmpty)) {
      return showErrSnackbar(msg: "Judul seri wajib diisi");
    }

    isLoadingAction.value = true;
    final saved = await saveSeries();
    isLoadingAction.value = false;

    if (!saved) return;

    await fetchApi();
    showSnackbar(msg: "The Scriptures berhasil disimpan");
  }

  Future<bool> saveHero() async {
    var isSuccess = true;

    for (final id in _deletedHeroIds) {
      final req = await homeContentRepo.deleteHero(id: id);
      await req.responseHandler(
        res: (res) {},
        err: (err) {
          isSuccess = false;
          showErrSnackbar(msg: err);
        },
      );
      if (!isSuccess) return false;
    }

    for (var i = 0; i < heroes.length; i++) {
      final item = heroes[i];
      var path = item.path;

      if (item.newBytes != null) {
        path = await upload(item.newBytes!, item.newFileName!);
        if (path == null) return false;
      }

      final body = {
        "eyebrow": item.txtEyebrow.text.trim(),
        "title": item.txtTitle.text.trim(),
        "description": item.txtDesc.text.trim(),
        "image_url": path,
        "cta_product_id": item.product?["id"],
        "is_active": item.isActive,
        "sort_order": i,
      };

      final req = item.id == null
          ? await homeContentRepo.addHero(
              body: {
                ...body,
                "start_date": DateTime.now().toUtc().toIso8601String(),
                "end_date": "2099-12-31",
              },
            )
          : await homeContentRepo.updateHero(id: item.id, body: body);

      await req.responseHandler(
        res: (res) => item.id = res["id"],
        err: (err) {
          isSuccess = false;
          showErrSnackbar(msg: err);
        },
      );
      if (!isSuccess) return false;
    }

    return true;
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

class HeroItem {
  HeroItem({
    this.id,
    String? eyebrow,
    String? title,
    String? desc,
    this.path,
    this.product,
    this.isActive = true,
  }) {
    txtEyebrow.text = eyebrow ?? "";
    txtTitle.text = title ?? "";
    txtDesc.text = desc ?? "";
  }

  dynamic id;
  final txtEyebrow = TextEditingController();
  final txtTitle = TextEditingController();
  final txtDesc = TextEditingController();
  String? path;
  Uint8List? newBytes;
  String? newFileName;
  Map<String, dynamic>? product;
  bool isActive;
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
