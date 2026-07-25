import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';
import 'package:nocvla_admin/shared/widgets/my_confirm_dialog.dart';

import '../../../../app/core/base_controller.dart';
import '../../../data/models/products/list_products_model.dart';
import '../../../data/models/products/product_type_model.dart';

class ProductController extends BaseController {
  final res = <ListProductsModel>[].obs;
  var resTypes = <ProductTypeModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  final txtSearchName = TextEditingController();
  var selectedType = Rxn<ProductTypeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchTypes();
    fetchApi();
  }

  @override
  void onClose() {
    txtSearchName.dispose();
    super.onClose();
  }

  fetchTypes() async {
    final req = await productsRepo.listProductTypes();
    await req.responseHandler(
      res: (res) {
        resTypes.value = (res as List)
            .map((e) => ProductTypeModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    final req = await productsRepo.listProducts(
      name: txtSearchName.text,
      typeId: selectedType.value?.id,
    );
    req.responseHandler(
      res: (res) {
        this.res.value =
            (res as List).map((e) => ListProductsModel.fromJson(e)).toList()
              ..sort((a, b) {
                final byName = (a.name ?? "").toString().compareTo(
                  (b.name ?? "").toString(),
                );
                if (byName != 0) return byName;
                return (a.colorName ?? "").toString().compareTo(
                  (b.colorName ?? "").toString(),
                );
              });
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  search() => fetchApi();

  selectType({ProductTypeModel? res}) => selectedType.value = res;

  add() async {
    await Get.toNamed(MyRoutes.productDetail);
    fetchApi(isRefresh: true);
  }

  edit({required String id}) async {
    await Get.toNamed(MyRoutes.productDetail, parameters: {"id": "$id"});
    fetchApi(isRefresh: true);
  }

  duplicate({required String id}) async {
    await Get.toNamed(
      MyRoutes.productDetail,
      parameters: {"duplicateId": "$id"},
    );
    fetchApi(isRefresh: true);
  }

  delete({required ListProductsModel item}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Warna Ini?");
    if (!confirmed) return;

    isLoadingAction.value = true;
    var hasError = false;

    final reqDeleteImages = await productsRepo.deleteProductImages(
      productColorId: item.id,
    );
    await reqDeleteImages.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    final reqDeleteStocks = await productsRepo.deleteProductStocks(
      productColorId: item.id,
    );
    await reqDeleteStocks.responseHandler(
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

    final reqDeleteColor = await productsRepo.deleteColor(id: item.id);
    await reqDeleteColor.responseHandler(
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

    var remainingColors = [];
    final reqRemaining = await productsRepo.listProductColorIds(
      productId: item.productId,
    );
    await reqRemaining.responseHandler(
      res: (res) => remainingColors = res as List,
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    if (remainingColors.isEmpty) {
      final reqDeleteProduct = await productsRepo.deleteProduct(
        id: item.productId,
      );
      await reqDeleteProduct.responseHandler(
        res: (res) {},
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    isLoadingAction.value = false;
    fetchApi(isRefresh: true);
  }
}
