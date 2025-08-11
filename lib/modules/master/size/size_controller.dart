import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/data/models/master/Size_model.dart';
import 'package:nocvla_admin/shared/widgets/my_button.dart';
import 'package:nocvla_admin/shared/widgets/my_text_form_field.dart';

import '../../../app/core/base_controller.dart';
import '../../../shared/utils/my_colors.dart';
import '../../../shared/utils/my_utility.dart';

class SizeController extends BaseController {
  var res = <SizeModel>[];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    if (isRefresh) res.clear();

    var req = await sizeRepo.list();
    await req.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          this.res.add(SizeModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );
    isLoading.value = false;
  }

  add() async => await showDialog(
    context: Get.context!,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.all(24),
        color: MyColors.primary,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormField(
              controller: txtName,
              label: "Name",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            SizedBox(),
            MyButton(
              text: "SAVE",
              onTap: () async {
                isLoadingAction.value = true;
                var req = await sizeRepo.add(
                  data: {"name": txtName.text, "active": true},
                );
                await req.responseHandler(
                  res: (res) {
                    Get.back();
                    fetchApi(isRefresh: true);
                  },
                  err: (err) => showErrSnackbar(msg: err),
                );
                isLoadingAction.value = false;
              },
            ),
          ],
        ),
      ),
    ),
  );

  edit({required int id}) async {
    
    var reqBank = await sizeRepo.list(id: id);
    await reqBank.responseHandler(
      res: (res) async {
        List<SizeModel> result = [];
        result.add(SizeModel.fromJson(res["data"]));

        txtName.text = result[0].name;

        await showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.all(24),
              color: MyColors.primary,
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextFormField(
                    controller: txtName,
                    label: "Name",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  MyButton(
                    text: "SAVE",
                    onTap: () async {
                      isLoadingAction.value = true;
                      var req = await sizeRepo.update(
                        id: id,
                        data: {"name": txtName.text, "active": true},
                      );
                      await req.responseHandler(
                        res: (res) {
                          Get.back();
                          fetchApi(isRefresh: true);
                        },
                        err: (err) => showErrSnackbar(msg: err),
                      );
                      isLoadingAction.value = false;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      err: (err) => showErrSnackbar(msg: err),
    );
  }

  delete({required int id}) async {
    isLoadingAction.value = true;
    var req = await sizeRepo.remove(id: id);
    await req.responseHandler(
      res: (res) => fetchApi(isRefresh: true),
      err: (err) => showErrSnackbar(msg: err),
    );
    isLoadingAction.value = false;
  }
}
