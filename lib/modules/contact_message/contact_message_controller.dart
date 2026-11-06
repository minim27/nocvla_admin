import 'package:get/get.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/contact/contact_message_model.dart';
import '../../shared/utils/my_utility.dart';
import '../dashboard/dashboard_controller.dart';

class ContactMessageController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var resMessages = <ContactMessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await contactRepo.listMessages();
    await req.responseHandler(
      res: (res) => resMessages.value = (res as List)
          .map((e) => ContactMessageModel.fromJson(e))
          .toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Future<void> markRead({required ContactMessageModel item}) async {
    isLoadingAction.value = true;
    var isSaved = false;

    final req = await contactRepo.updateMessageStatus(
      id: item.id,
      status: "read",
    );
    await req.responseHandler(
      res: (res) {
        isSaved = (res as List).isNotEmpty;
        if (!isSaved) {
          showErrSnackbar(
            msg: "Pesan belum bisa diubah: akun ini tidak punya izin.",
          );
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    if (isSaved) {
      item.status = "read";
      resMessages.refresh();
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchUnreadCount();
      }
    }

    isLoadingAction.value = false;
  }
}
