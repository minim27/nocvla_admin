import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/data/models/products/product_list_model.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../../app/core/base_controller.dart';

class ProductController extends BaseController {
  var res = <ProductModel>[];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    if (isRefresh) res.clear();

    var req = await productRepo.list();
    await req.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          this.res.add(ProductModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  add() async {
    await Get.toNamed(MyRoutes.productDetail);
    fetchApi(isRefresh: true);
  }

  edit({required String slug}) async {
    await Get.toNamed(MyRoutes.productDetail, parameters: {"slug": slug});
    fetchApi(isRefresh: true);
  }

  delete({required int id}) async {
    isLoadingAction.value = true;

    var req = await productRepo.remove(id: id);
    await req.responseHandler(
      res: (res) => fetchApi(isRefresh: true),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }
}
