import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/shared/utils/my_parsing_currency.dart';
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
  var searchQuery = "".obs;
  var selectedFilter = filterAll.obs;
  var expandedId = "".obs;

  static const filterAll = "all";
  static const filterLowStock = "low_stock";

  List<Map<String, String>> get filterOptions => [
    {"id": filterAll, "label": "Semua"},
    ...resTypes.map((e) => {"id": "${e.name}", "label": "${e.name}"}),
    {"id": filterLowStock, "label": "Stok menipis"},
  ];

  List<ProductGroup> get allGroups => ProductGroup.fromColors(res);

  List<ProductGroup> get groups {
    final query = searchQuery.value.trim().toLowerCase();

    return allGroups.where((group) {
      final matchesFilter = switch (selectedFilter.value) {
        filterAll => true,
        filterLowStock => group.hasLowStock,
        final type => group.typeName == type,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;

      return group.name.toLowerCase().contains(query) ||
          group.colors.any(
            (color) => "${color.colorName}".toLowerCase().contains(query),
          );
    }).toList();
  }

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

    final req = await productsRepo.listProducts();
    await req.responseHandler(
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

    if (expandedId.value.isEmpty && res.isNotEmpty) {
      expandedId.value = groups.isEmpty ? "" : groups.first.id;
    }

    isLoading.value = false;
  }

  void search({required String query}) => searchQuery.value = query;

  void selectFilter({required String id}) => selectedFilter.value = id;

  void toggleExpand({required String id}) =>
      expandedId.value = expandedId.value == id ? "" : id;

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

class ProductGroup {
  final ListProductsModel first;
  final colors = <ListProductsModel>[];

  ProductGroup({required this.first});

  static List<ProductGroup> fromColors(List<ListProductsModel> items) {
    final grouped = <String, ProductGroup>{};

    for (final item in items) {
      grouped
          .putIfAbsent(item.productId, () => ProductGroup(first: item))
          .colors
          .add(item);
    }

    return grouped.values.toList();
  }

  static List<String> sortSizes(Iterable<String> labels) {
    const rank = ["XS", "S", "M", "L", "XL", "XXL", "XXXL", "3XL"];

    int rankOf(String label) {
      final index = rank.indexOf(label.toUpperCase());
      return index < 0 ? rank.length : index;
    }

    return labels.toSet().toList()
      ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
  }

  String get id => first.productId;
  String get name => "${first.name ?? "-"}";
  String get typeName => "${first.type ?? "-"}";
  bool get isFeatured => first.isFeatured == true;

  List<ProductVariationModel> get _variations => colors
      .expand((color) => color.variation ?? <ProductVariationModel>[])
      .toList();

  List<String> get sizes =>
      sortSizes(_variations.map((e) => "${e.size ?? "-"}"));

  int? qtyOf({required ListProductsModel color, required String size}) {
    for (final variation in color.variation ?? <ProductVariationModel>[]) {
      if ("${variation.size ?? "-"}" == size) return variation.qty;
    }
    return null;
  }

  num? get minPrice {
    final prices = _variations.map((e) => e.price as num? ?? 0).toList();
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  int get totalStock =>
      _variations.fold(0, (total, e) => total + ((e.qty as int?) ?? 0));

  bool get hasLowStock => _variations.any((e) => ((e.qty as int?) ?? 0) <= 2);

  String get priceSummary {
    final parts = sizes.map((size) {
      final price = _variations
          .firstWhere((e) => "${e.size ?? "-"}" == size)
          .price;
      return "$size ${parsingCurrency(price)}";
    });
    return "Harga: ${parts.join(" · ")}. Klik edit untuk ubah stok sekaligus di matriks.";
  }
}
