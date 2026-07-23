import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';
import 'package:nocvla_admin/shared/utils/my_utility.dart';
import 'package:nocvla_admin/shared/widgets/my_confirm_dialog.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/athlete/athlete_model.dart';

class AthleteController extends BaseController {
  final res = <AthleteModel>[].obs;

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    final req = await athleteRepo.listAthletes();
    req.responseHandler(
      res: (res) {
        this.res.value = (res as List)
            .map((e) => AthleteModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  add() async {
    await Get.toNamed(MyRoutes.athleteDetail);
    fetchApi(isRefresh: true);
  }

  edit({required String id}) async {
    await Get.toNamed(MyRoutes.athleteDetail, parameters: {"id": "$id"});
    fetchApi(isRefresh: true);
  }

  delete({required String id}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Athlete?");
    if (!confirmed) return;

    isLoadingAction.value = true;

    final req = await athleteRepo.deleteAthlete(id: id);
    await req.responseHandler(
      res: (res) => fetchApi(isRefresh: true),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }
}
