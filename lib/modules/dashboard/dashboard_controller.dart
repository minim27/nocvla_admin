import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/modules/master_data/master_data_controller.dart';
import 'package:nocvla_admin/modules/order/order_controller.dart';
import 'package:nocvla_admin/modules/setting/setting_controller.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';
import 'package:nocvla_admin/shared/widgets/my_confirm_dialog.dart';

import '../../../app/core/base_controller.dart';

class DashboardController extends BaseController {
  List<Map<String, dynamic>> menu = [
    {"name": "Dashboard", "route": MyRoutes.overview},
    {"name": "Produk & Stok", "route": MyRoutes.product},
    {"name": "Atlet & Pendaftar", "route": MyRoutes.athlete, "hasBadge": true},
    {"name": "Order WhatsApp", "route": MyRoutes.order},
    {
      "name": "Konten & Drop",
      "route": MyRoutes.contentHero,
      "children": [
        {"name": "Hero Home", "route": MyRoutes.contentHero},
        {"name": "Featured", "route": MyRoutes.contentFeatured},
        {"name": "The Scriptures", "route": MyRoutes.contentSeries},
        {"name": "Halaman Tentang", "route": MyRoutes.contentAbout},
        {"name": "Early Access", "route": MyRoutes.earlyAccess},
      ],
    },
    {
      "name": "Master Data",
      "route": MyRoutes.masterData,
      "children": [
        {"name": "Kategori Produk", "route": MyRoutes.masterData},
        {"name": "Fokus Latihan", "route": MyRoutes.masterDataFocus},
      ],
    },
    {"name": "Pengaturan", "route": MyRoutes.setting},
  ];

  var myRoutes = MyRoutes.overview.obs;
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

  String get userEmail => authRepo.currentUser?.email ?? "-";

  Future<void> logout() async {
    final confirmed = await showMyConfirmDialog(
      title: "Keluar dari Admin?",
      message: "Anda perlu masuk lagi untuk mengelola data.",
      confirmText: "Keluar",
    );
    if (!confirmed) return;

    final req = await authRepo.signOut();
    await req.responseHandler(
      res: (res) {},
      err: (err) => showErrSnackbar(msg: err),
    );

    await Get.offAllNamed(MyRoutes.login);
    Get.delete<OrderController>(force: true);
    Get.delete<SettingController>(force: true);
    Get.delete<MasterDataController>(force: true);
    myRoutes.value = MyRoutes.overview;
  }

  bool isMenuActive(Map<String, dynamic> item) =>
      myRoutes.value == item["route"] ||
      ((item["children"] as List?) ?? []).any(
        (e) => e["route"] == myRoutes.value,
      );

  List<Map<String, dynamic>> get activeChildren => [
    for (final item in menu)
      if (isMenuActive(item)) ...?item["children"] as List?,
  ].cast<Map<String, dynamic>>();

  void changeRoute({required String route}) {
    myRoutes.value = route;
    if (Get.currentRoute == MyRoutes.dashboard) return;

    Get.until((route) => route.isFirst);
    if (Get.currentRoute != MyRoutes.dashboard) {
      Get.offAllNamed(MyRoutes.dashboard);
    }
  }
}
