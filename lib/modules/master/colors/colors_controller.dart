import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/data/models/master/colors_model.dart';
import 'package:nocvla_admin/shared/utils/my_colors.dart';
import 'package:nocvla_admin/shared/widgets/my_button.dart';
import 'package:nocvla_admin/shared/widgets/my_text_form_field.dart';

import '../../../app/core/base_controller.dart';
import '../../../shared/utils/my_utility.dart';

class ColorsController extends BaseController {
  var res = <ColorsModel>[];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();
  var txtHex = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi({bool isRefresh = false}) async {
    isLoading.value = true;

    if (isRefresh) res.clear();

    var req = await colorsRepo.list();
    await req.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          this.res.add(ColorsModel.fromJson(data));
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
            MyTextFormField(
              controller: txtHex,
              label: "Hex",
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
            ),
            SizedBox(),
            MyButton(
              text: "SAVE",
              onTap: () async {
                isLoadingAction.value = true;
                var req = await colorsRepo.add(
                  data: {
                    "name": txtName.text,
                    "hex": txtHex.text,
                    "active": true,
                  },
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
    var reqBank = await colorsRepo.list(id: id);
    await reqBank.responseHandler(
      res: (res) async {
        List<ColorsModel> result = [];
        result.add(ColorsModel.fromJson(res["data"]));

        txtName.text = result[0].name;
        txtHex.text = result[0].hex;

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
                  MyTextFormField(
                    controller: txtHex,
                    label: "Hex",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(),
                  MyButton(
                    text: "SAVE",
                    onTap: () async {
                      isLoadingAction.value = true;
                      var req = await colorsRepo.update(
                        id: id,
                        data: {
                          "name": txtName.text,
                          "hex": txtHex.text,
                          "active": true,
                        },
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
    var req = await colorsRepo.remove(id: id);
    await req.responseHandler(
      res: (res) => fetchApi(isRefresh: true),
      err: (err) => showErrSnackbar(msg: err),
    );
    isLoadingAction.value = false;
  }
}
