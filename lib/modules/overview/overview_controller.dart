import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_controller.dart';
import 'package:nocvla_admin/modules/product/list/product_controller.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';
import 'package:nocvla_admin/shared/widgets/my_confirm_dialog.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/athlete/athlete_model.dart';
import '../../data/models/athlete_application/athlete_application_model.dart';
import '../../data/models/products/list_products_model.dart';

class OverviewController extends BaseController {
  final resProducts = <ListProductsModel>[].obs;
  final resAthletes = <AthleteModel>[].obs;
  final resApplications = <AthleteApplicationModel>[].obs;

  var orderWeekCount = RxnInt();

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  List<ProductGroup> get groups => ProductGroup.fromColors(resProducts);

  bool _isSoldOut(ListProductsModel color) =>
      (color.variation ?? []).every((e) => (e.qty ?? 0) == 0);

  List<ListProductsModel> get soldOutColors =>
      resProducts.where(_isSoldOut).toList();

  List<AthleteApplicationModel> get pendingApplications =>
      resApplications.where((e) => e.status == "pending").toList();

  AthleteApplicationModel? get latestPending =>
      pendingApplications.isEmpty ? null : pendingApplications.first;

  List<StockRow> get stockRows {
    final rows = <StockRow>[];

    for (final group in groups) {
      for (final color in group.colors) {
        if ((color.variation ?? []).any((e) => (e.qty ?? 0) <= 2)) {
          rows.add(StockRow(group: group, color: color));
        }
      }
    }

    rows.sort((a, b) => a.total.compareTo(b.total));
    return rows.take(5).toList();
  }

  List<String> get stockSizes =>
      ProductGroup.sortSizes(stockRows.expand((row) => row.group.sizes));

  List<OverviewAlert> get alerts {
    final result = <OverviewAlert>[];

    final wrongLinks = groups.where((group) {
      final first = group.first;
      return marketplaceUrlError(
                type: "shopee",
                url: "${first.shopeeUrl ?? ""}",
              ) !=
              null ||
          marketplaceUrlError(
                type: "tiktok",
                url: "${first.tiktokUrl ?? ""}",
              ) !=
              null ||
          marketplaceUrlError(
                type: "tokopedia",
                url: "${first.tokopediaUrl ?? ""}",
              ) !=
              null;
    }).toList();
    if (wrongLinks.isNotEmpty) {
      result.add(
        OverviewAlert(
          title: "Link marketplace salah domain",
          description: wrongLinks.map((e) => e.name).join(", "),
          cta: "Perbaiki",
          isDanger: true,
          onTap: () => openProduct(id: wrongLinks.first.id),
        ),
      );
    }

    final incomplete = resAthletes.where(
      (e) => "${e.picture ?? ""}".isEmpty || (e.assignedProducts ?? []).isEmpty,
    );
    if (incomplete.isNotEmpty) {
      result.add(
        OverviewAlert(
          title: "Profil atlet belum lengkap",
          description:
              "${incomplete.map((e) => e.name).join(", ")} belum punya foto atau produk.",
          cta: "Lengkapi",
          onTap: () => openMenu(route: MyRoutes.athlete),
        ),
      );
    }

    final sorted = [...groups]
      ..sort(
        (a, b) => "${b.first.productCreatedAt}".compareTo(
          "${a.first.productCreatedAt}",
        ),
      );
    if (sorted.isNotEmpty && !sorted.first.isFeatured) {
      result.add(
        OverviewAlert(
          title: "Featured belum memuat drop terbaru",
          description: "${sorted.first.name} belum tampil di Home.",
          cta: "Atur",
          onTap: () => openMenu(route: MyRoutes.earlyAccess),
        ),
      );
    }

    return result;
  }

  String get todayLabel {
    const days = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    final now = DateTime.now();
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    final reqProducts = await productsRepo.listProducts();
    await reqProducts.responseHandler(
      res: (res) => resProducts.value = (res as List)
          .map((e) => ListProductsModel.fromJson(e))
          .toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqAthletes = await athleteRepo.listAthletes();
    await reqAthletes.responseHandler(
      res: (res) => resAthletes.value = (res as List)
          .map((e) => AthleteModel.fromJson(e))
          .toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqApplications = await athleteApplicationRepo.listAllApplications();
    await reqApplications.responseHandler(
      res: (res) => resApplications.value = (res as List)
          .map((e) => AthleteApplicationModel.fromJson(e))
          .toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    final reqOrders = await orderRepo.listOrders();
    await reqOrders.responseHandler(
      res: (res) {
        final since = DateTime.now().subtract(const Duration(days: 7));
        orderWeekCount.value = (res as List)
            .where((e) => DateTime.parse(e["created_at"]).isAfter(since))
            .length;
      },
      err: (err) => orderWeekCount.value = null,
    );

    isLoading.value = false;
  }

  void openMenu({required String route}) =>
      Get.find<DashboardController>().changeRoute(route: route);

  addProduct() async {
    await Get.toNamed(MyRoutes.productDetail);
    fetchApi();
  }

  openProduct({required String id}) async {
    await Get.toNamed(MyRoutes.productDetail, parameters: {"id": id});
    fetchApi();
  }

  acceptApplication({required String id}) async {
    await Get.toNamed(
      MyRoutes.athleteApplicationDetail,
      parameters: {"id": id},
    );
    fetchApi();
    Get.find<DashboardController>().fetchPendingCount();
  }

  Future<void> rejectApplication({required String id}) async {
    final confirmed = await showMyConfirmDialog(
      title: "Tolak Pendaftar?",
      message: "Status pendaftaran akan diubah menjadi ditolak.",
      confirmText: "Tolak",
    );
    if (!confirmed) return;

    isLoadingAction.value = true;

    final req = await athleteApplicationRepo.updateStatus(
      id: id,
      status: "rejected",
    );
    await req.responseHandler(
      res: (res) {
        fetchApi();
        Get.find<DashboardController>().fetchPendingCount();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }
}

class StockRow {
  final ProductGroup group;
  final ListProductsModel color;

  StockRow({required this.group, required this.color});

  int get total =>
      (color.variation ?? []).fold(0, (sum, e) => sum + ((e.qty as int?) ?? 0));
}

class OverviewAlert {
  final String title, description, cta;
  final bool isDanger;
  final void Function() onTap;

  OverviewAlert({
    required this.title,
    required this.description,
    required this.cta,
    this.isDanger = false,
    required this.onTap,
  });
}
