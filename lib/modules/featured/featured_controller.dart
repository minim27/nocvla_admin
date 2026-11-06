import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/products/list_products_model.dart';

class FeaturedController extends BaseController {
  final res = <ListProductsModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  static const maxFeatured = 4;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
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

    isLoading.value = false;
  }

  List<ListProductsModel> get products {
    final seen = <dynamic>{};
    return res.where((e) => seen.add(e.productId)).toList();
  }

  List<ListProductsModel> get featured =>
      products.where((e) => e.isFeatured == true).toList()..sort(
        (a, b) => ((a.featuredSortOrder ?? maxFeatured) as int).compareTo(
          (b.featuredSortOrder ?? maxFeatured) as int,
        ),
      );

  List<ListProductsModel> get others =>
      products.where((e) => e.isFeatured != true).toList();

  int colorCount({required ListProductsModel item}) =>
      res.where((e) => e.productId == item.productId).length;

  Future<void> toggleFeatured({required ListProductsModel item}) async {
    final newValue = !(item.isFeatured == true);
    final current = featured;

    if (newValue && current.length >= maxFeatured) {
      return showErrSnackbar(
        msg: "Maksimal $maxFeatured produk featured. Matikan salah satu dulu.",
      );
    }

    final sortOrder = newValue
        ? current.fold<int>(
                -1,
                (last, e) => (e.featuredSortOrder ?? 0) > last
                    ? e.featuredSortOrder ?? 0
                    : last,
              ) +
              1
        : null;

    isLoadingAction.value = true;

    final req = await productsRepo.updateProduct(
      id: item.productId,
      body: {"is_featured": newValue, "featured_sort_order": sortOrder},
    );
    await req.responseHandler(
      res: (res) {
        for (final row in this.res) {
          if (row.productId == item.productId) {
            row.isFeatured = newValue;
            row.featuredSortOrder = sortOrder;
          }
        }
        this.res.refresh();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }

  Future<void> reorderFeatured({
    required int oldIndex,
    required int newIndex,
  }) async {
    final items = featured;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    _applyOrders(items);

    final req = await productsRepo.updateFeaturedOrders(
      body: [
        for (final (index, e) in items.indexed)
          {"id": e.productId, "featured_sort_order": index},
      ],
    );
    await req.responseHandler(
      res: (res) {},
      err: (err) {
        showErrSnackbar(msg: err);
        fetchApi();
      },
    );
  }

  void _applyOrders(List<ListProductsModel> items) {
    for (final (index, e) in items.indexed) {
      for (final row in res) {
        if (row.productId == e.productId) row.featuredSortOrder = index;
      }
    }
    res.refresh();
  }
}
