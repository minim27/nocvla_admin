import 'package:get/get.dart';

import '../../../app/core/base_controller.dart';

class ProductController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {}

  add() async => null;

  edit({required int id}) => null;

  delete({required int id}) async => null;
}
