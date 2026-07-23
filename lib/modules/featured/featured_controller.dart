import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/products/list_products_model.dart';

class FeaturedController extends BaseController {
  final res = <ListProductsModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await productsRepo.listProducts();
    req.responseHandler(
      res: (res) {
        this.res.value = (res as List)
            .map((e) => ListProductsModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Future<void> toggleFeatured({required int index}) async {
    final item = res[index];
    final newValue = !(item.isFeatured == true);

    isLoadingAction.value = true;

    final req = await productsRepo.updateProduct(
      id: item.id,
      body: {"is_featured": newValue},
    );
    await req.responseHandler(
      res: (res) {
        item.isFeatured = newValue;
        this.res.refresh();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }
}
