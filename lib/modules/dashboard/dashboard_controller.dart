import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../../app/core/base_controller.dart';

class DashboardController extends BaseController {
  List<Map<String, dynamic>> menu = [
    {"name": "Produk & Stok", "route": MyRoutes.product},
    {"name": "Atlet & Pendaftar", "route": MyRoutes.athlete, "hasBadge": true},
    {"name": "Konten & Drop", "route": MyRoutes.earlyAccess},
  ];

  var myRoutes = MyRoutes.product.obs;
  var pendingCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingCount();
  }

  fetchPendingCount() async {
    final req = await athleteApplicationRepo.listApplications(
      status: "pending",
    );
    await req.responseHandler(
      res: (res) => pendingCount.value = (res as List).length,
      err: (err) => showErrSnackbar(msg: err),
    );
  }

  void changeRoute({required String route}) {
    myRoutes.value = route;
    if (Get.currentRoute == MyRoutes.dashboard) return;

    Get.until((route) => route.isFirst);
    if (Get.currentRoute != MyRoutes.dashboard) {
      Get.offAllNamed(MyRoutes.dashboard);
    }
  }
}
