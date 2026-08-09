import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/athlete_application/athlete_application_model.dart';
import '../../../shared/utils/my_utility.dart';
import '../../../shared/widgets/my_confirm_dialog.dart';
import '../../athlete/detail/athlete_detail_controller.dart' show AthletePicture;
import 'athlete_application_detail_params.dart';
import 'widgets/athlete_application_approve_dialog.dart';

class AthleteApplicationDetailController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var application = Rxn<AthleteApplicationModel>();

  var txtApproveCode = TextEditingController();
  var approvePicture = Rxn<AthletePicture>();

  AthleteApplicationDetailParams get params =>
      AthleteApplicationDetailParams.fromMap(Get.parameters);

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    txtApproveCode.dispose();
    super.onClose();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await athleteApplicationRepo.detailApplication(id: params.id);
    await req.responseHandler(
      res: (res) => application.value = AthleteApplicationModel.fromJson(res),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoading.value = false;
  }

  Future<void> openInstagram() async {
    final username = application.value?.instagramUsername;
    if (username == null || username.toString().trim().isEmpty) return;

    await launchUrl(
      Uri.parse("https://instagram.com/$username"),
      webOnlyWindowName: "_blank",
    );
  }

  Future<void> openTiktok() async {
    final username = application.value?.tiktokUsername;
    if (username == null || username.toString().trim().isEmpty) return;

    await launchUrl(
      Uri.parse("https://www.tiktok.com/@$username"),
      webOnlyWindowName: "_blank",
    );
  }

  Future<void> reject() async {
    final confirmed = await showMyConfirmDialog(
      title: "Reject Application?",
      message: "Status pendaftaran akan diubah menjadi rejected.",
      confirmText: "Reject",
    );
    if (!confirmed) return;

    isLoadingAction.value = true;

    final req = await athleteApplicationRepo.updateStatus(
      id: params.id,
      status: "rejected",
    );
    await req.responseHandler(
      res: (res) => Get.back(),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;
  }

  Future<void> approve() async {
    txtApproveCode.clear();
    approvePicture.value = null;

    await Get.dialog(
      const AthleteApplicationApproveDialog(),
      barrierDismissible: false,
    );
  }

  Future<void> pickApprovePicture() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    approvePicture.value = AthletePicture(
      newBytes: result.files.single.bytes,
      newFileName: result.files.single.name,
    );
  }

  void removeApprovePicture() => approvePicture.value = null;

  Future<void> submitApprove() async {
    if (approvePicture.value?.newBytes == null) {
      return showErrSnackbar(msg: "Foto athlete wajib diisi");
    }
    if (txtApproveCode.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Code wajib diisi");
    }

    isLoadingAction.value = true;

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${approvePicture.value!.newFileName!}";
    final reqUpload = await athleteRepo.uploadPicture(
      bytes: approvePicture.value!.newBytes!,
      fileName: fileName,
    );

    var hasError = false;
    String? picturePath;

    await reqUpload.responseHandler(
      res: (res) => picturePath = res,
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    final reqAddAthlete = await athleteRepo.addAthlete(
      body: {
        "name": application.value?.name,
        "picture": picturePath,
        "code": txtApproveCode.text,
      },
    );
    await reqAddAthlete.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    final reqUpdateStatus = await athleteApplicationRepo.updateStatus(
      id: params.id,
      status: "approved",
    );
    await reqUpdateStatus.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(msg: err);
      },
    );

    isLoadingAction.value = false;

    if (hasError) return;

    Get.back();
    Get.back();
    showSnackbar(msg: "Application berhasil di-approve");
  }
}
