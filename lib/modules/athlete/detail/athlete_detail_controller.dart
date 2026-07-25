import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/athlete/athlete_model.dart';
import '../../../data/models/products/product_name_model.dart';
import '../../../shared/utils/my_utility.dart';
import '../../../shared/widgets/my_confirm_dialog.dart';
import 'athlete_detail_params.dart';

class AthleteDetailController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtCode = TextEditingController();
  var txtName = TextEditingController();

  var picture = Rxn<AthletePicture>();

  var productOptions = <ProductNameModel>[].obs;
  var assignments = <AthleteAssignmentRow>[].obs;

  AthleteDetailParams get params => AthleteDetailParams.fromMap(Get.parameters);

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    txtCode.dispose();
    txtName.dispose();
    for (final row in assignments) {
      row.dispose();
    }
    super.onClose();
  }

  fetchApi() async {
    isLoading.value = true;

    final reqProducts = await productsRepo.listProductNames();
    await reqProducts.responseHandler(
      res: (res) {
        productOptions.value = (res as List)
            .map((e) => ProductNameModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    if (params.id != null) {
      final req = await athleteRepo.detailAthlete(id: params.id);
      await req.responseHandler(
        res: (res) {
          final athlete = AthleteModel.fromJson(res);
          txtCode.text = athlete.code ?? "";
          txtName.text = athlete.name ?? "";
          if (athlete.picture != null) {
            picture.value = AthletePicture(existingPath: athlete.picture);
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );

      final reqAssignments = await athleteRepo.listAssignments(
        athleteId: params.id,
      );
      await reqAssignments.responseHandler(
        res: (res) {
          for (final row in (res as List)) {
            final assignment = AthleteAssignmentRow();

            if (row["product"] != null) {
              assignment.selectedProduct.value = ProductNameModel(
                id: row["product"]["id"],
                name: row["product"]["name"],
              );
            }
            assignment.shopee.text = row["link_aff_shopee"] ?? "";
            assignment.tiktok.text = row["link_aff_tktkshop"] ?? "";
            assignment.tokped.text = row["link_aff_tokped"] ?? "";

            assignments.add(assignment);
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    isLoading.value = false;
  }

  Future<void> pickPicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    picture.value = AthletePicture(
      newBytes: result.files.single.bytes,
      newFileName: result.files.single.name,
    );
  }

  Future<void> removePicture() async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Foto?");
    if (!confirmed) return;

    picture.value = null;
  }

  void addAssignmentRow() => assignments.add(AthleteAssignmentRow());

  Future<void> removeAssignmentRow({required int index}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Produk Ini?");
    if (!confirmed) return;

    assignments[index].dispose();
    assignments.removeAt(index);
  }

  void selectAssignmentProduct({
    required int index,
    required ProductNameModel product,
  }) => assignments[index].selectedProduct.value = product;

  Future<void> save() async {
    if (picture.value == null) {
      return showErrSnackbar(msg: "Foto athlete wajib diisi");
    }
    if (txtName.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Nama athlete wajib diisi");
    }
    if (txtCode.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Code wajib diisi");
    }

    final selectedProductIds = assignments
        .where((row) => row.selectedProduct.value != null)
        .map((row) => row.selectedProduct.value!.id)
        .toList();

    if (selectedProductIds.length != selectedProductIds.toSet().length) {
      return showErrSnackbar(msg: "Satu produk hanya boleh dipilih sekali");
    }

    isLoadingAction.value = true;

    String? picturePath = picture.value?.existingPath;

    if (picture.value?.newBytes != null) {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${picture.value!.newFileName!}";
      final reqUpload = await athleteRepo.uploadPicture(
        bytes: picture.value!.newBytes!,
        fileName: fileName,
      );

      var uploadFailed = false;
      await reqUpload.responseHandler(
        res: (res) => picturePath = res,
        err: (err) {
          uploadFailed = true;
          showErrSnackbar(msg: err);
        },
      );

      if (uploadFailed) {
        isLoadingAction.value = false;
        return;
      }
    }

    final body = {
      "code": txtCode.text,
      "name": txtName.text,
      "picture": picturePath,
    };

    var hasError = false;
    String? athleteId = params.id;

    if (athleteId == null) {
      final req = await athleteRepo.addAthlete(body: body);
      await req.responseHandler(
        res: (res) => athleteId = AthleteModel.fromJson(res).id,
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    } else {
      final req = await athleteRepo.updateAthlete(id: athleteId, body: body);
      await req.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (hasError || athleteId == null) {
      isLoadingAction.value = false;
      return;
    }

    if (params.id != null) {
      final reqDelete = await athleteRepo.deleteAssignments(
        athleteId: athleteId!,
      );
      await reqDelete.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    final assignmentBody = assignments
        .where((row) => row.selectedProduct.value != null)
        .map(
          (row) => {
            "athlete_id": athleteId,
            "product_id": row.selectedProduct.value!.id,
            "link_aff_shopee": row.shopee.text,
            "link_aff_tktkshop": row.tiktok.text,
            "link_aff_tokped": row.tokped.text,
          },
        )
        .toList();

    if (assignmentBody.isNotEmpty) {
      final reqAssignments = await athleteRepo.addAssignments(
        body: assignmentBody,
      );
      await reqAssignments.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    isLoadingAction.value = false;

    if (hasError) return;

    Get.back();
    showSnackbar(msg: "Athlete berhasil disimpan");
  }
}

class AthletePicture {
  final String? existingPath;
  final Uint8List? newBytes;
  final String? newFileName;

  AthletePicture({this.existingPath, this.newBytes, this.newFileName});
}

class AthleteAssignmentRow {
  var selectedProduct = Rxn<ProductNameModel>();
  var shopee = TextEditingController();
  var tiktok = TextEditingController();
  var tokped = TextEditingController();

  void dispose() {
    shopee.dispose();
    tiktok.dispose();
    tokped.dispose();
  }
}
