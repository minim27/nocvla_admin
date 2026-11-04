import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_controller.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/athlete_application/athlete_application_model.dart';

class AthleteApplicationController extends BaseController {
  static const statusTabs = ["pending", "approved", "rejected"];

  final res = <AthleteApplicationModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var selectedStatus = "pending".obs;

  List<AthleteApplicationModel> get filtered =>
      res.where((e) => e.status == selectedStatus.value).toList();

  int countOf({required String status}) =>
      res.where((e) => e.status == status).length;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    final req = await athleteApplicationRepo.listAllApplications();
    await req.responseHandler(
      res: (res) {
        this.res.value = (res as List)
            .map((e) => AthleteApplicationModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  changeStatus({required String status}) => selectedStatus.value = status;

  viewDetail({required String id}) async {
    await Get.toNamed(
      MyRoutes.athleteApplicationDetail,
      parameters: {"id": id},
    );
    fetchApi(isRefresh: true);
    Get.find<DashboardController>().fetchPendingCount();
  }
}
