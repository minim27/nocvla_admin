import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/products/product_type_model.dart';
import '../../shared/utils/my_utility.dart';
import '../../shared/widgets/my_confirm_dialog.dart';
import '../product/list/product_controller.dart';
import 'widgets/master_data_form_dialog.dart';

class MasterDataController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var resTypes = <ProductTypeModel>[].obs;

  var txtName = TextEditingController();

  static const _noWriteAccess =
      "Kategori belum bisa disimpan: akun ini tidak punya izin menulis.";

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    await _fetchTypes();

    isLoading.value = false;
  }

  Future<void> _fetchTypes() async {
    final req = await productsRepo.listAllProductTypes();
    await req.responseHandler(
      res: (res) {
        resTypes.value = (res as List)
            .map((e) => ProductTypeModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );
  }

  Future<void> _afterChange() async {
    await _fetchTypes();

    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().fetchTypes();
    }
  }

  void openForm({ProductTypeModel? type}) {
    txtName.text = type?.name ?? "";
    Get.dialog(MasterDataFormDialog(type: type));
  }

  Future<void> saveType({ProductTypeModel? type}) async {
    if (isLoadingAction.value) return;

    final name = txtName.text.trim().toUpperCase();
    final value = name
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
        .replaceAll(RegExp(r"^_+|_+$"), "");

    if (value.isEmpty) {
      return showErrSnackbar(msg: "Nama kategori wajib diisi");
    }
    if (resTypes.any((e) => e.id != type?.id && e.name == name)) {
      return showErrSnackbar(msg: "Kategori $name sudah ada");
    }

    isLoadingAction.value = true;
    var hasError = false;

    final lastOrder = resTypes.fold<int>(
      -1,
      (last, e) => (e.sortOrder ?? 0) > last ? e.sortOrder ?? 0 : last,
    );
    final req = type == null
        ? await productsRepo.addProductType(
            body: {"name": name, "value": value, "sort_order": lastOrder + 1},
          )
        : await productsRepo.updateProductType(
            id: type.id,
            body: {"name": name, "value": value},
          );
    await req.responseHandler(
      res: (res) {
        if ((res as List).isEmpty) {
          hasError = true;
          showErrSnackbar(msg: _noWriteAccess);
        }
      },
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (!hasError) {
      await _afterChange();
      Get.back();
      showSnackbar(msg: "Kategori berhasil disimpan");
    }

    isLoadingAction.value = false;
  }

  Future<void> toggleActive({
    required ProductTypeModel type,
    required bool value,
  }) async {
    isLoadingAction.value = true;
    var isSaved = false;

    final req = await productsRepo.updateProductType(
      id: type.id,
      body: {"is_active": value},
    );
    await req.responseHandler(
      res: (res) {
        isSaved = (res as List).isNotEmpty;
        if (!isSaved) showErrSnackbar(msg: _noWriteAccess);
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    if (isSaved) await _afterChange();

    isLoadingAction.value = false;
  }

  Future<void> deleteType({required ProductTypeModel type}) async {
    if (type.productCount > 0) {
      return showErrSnackbar(
        msg:
            "${type.name} masih dipakai ${type.productCount} produk. Nonaktifkan saja, atau pindahkan dulu produknya.",
      );
    }

    final confirmed = await showMyConfirmDialog(
      title: "Hapus kategori ${type.name}?",
    );
    if (!confirmed) return;

    isLoadingAction.value = true;
    var isDeleted = false;

    final req = await productsRepo.deleteProductType(id: type.id);
    await req.responseHandler(
      res: (res) {
        isDeleted = (res as List).isNotEmpty;
        if (!isDeleted) showErrSnackbar(msg: _noWriteAccess);
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    if (isDeleted) {
      await _afterChange();
      showSnackbar(msg: "Kategori berhasil dihapus");
    }

    isLoadingAction.value = false;
  }

  Future<void> reorderTypes({
    required int oldIndex,
    required int newIndex,
  }) async {
    final previous = [...resTypes];

    final item = resTypes.removeAt(oldIndex);
    resTypes.insert(newIndex, item);

    final req = await productsRepo.updateProductTypeOrders(
      body: [
        for (final (index, type) in resTypes.indexed)
          {"id": type.id, "sort_order": index},
      ],
    );
    var isSaved = false;
    await req.responseHandler(
      res: (res) => isSaved = true,
      err: (err) {
        resTypes.value = previous;
        showErrSnackbar(msg: err);
      },
    );

    if (isSaved) await _afterChange();
  }
}
