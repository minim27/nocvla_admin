import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/athlete_application/athlete_application_model.dart';

class AthleteApplicationController extends BaseController {
  static const statusTabs = ["pending", "approved", "rejected"];

  final res = <AthleteApplicationModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var selectedStatus = "pending".obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    final req = await athleteApplicationRepo.listApplications(
      status: selectedStatus.value,
    );
    req.responseHandler(
      res: (res) {
        this.res.value = (res as List)
            .map((e) => AthleteApplicationModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  changeStatus({required String status}) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    fetchApi();
  }

  viewDetail({required String id}) async {
    await Get.toNamed(MyRoutes.athleteApplicationDetail, parameters: {"id": "$id"});
    fetchApi(isRefresh: true);
  }
}
