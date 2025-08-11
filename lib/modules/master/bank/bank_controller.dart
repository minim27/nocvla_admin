import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/data/models/master/bank/bank_list_model.dart';
import 'package:nocvla_admin/data/models/master/bank/bank_type_model.dart';
import 'package:nocvla_admin/shared/utils/my_colors.dart';
import 'package:nocvla_admin/shared/widgets/my_button.dart';
import 'package:nocvla_admin/shared/widgets/my_dropdown.dart';
import 'package:nocvla_admin/shared/widgets/my_image.dart';
import 'package:nocvla_admin/shared/widgets/my_text_form_field.dart';

import '../../../app/core/base_controller.dart';
import '../../../shared/utils/my_utility.dart';

class BankController extends BaseController {
  var resType = <BankTypeModel>[];
  var res = <BankListModel>[];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var selectedType = "ALL".obs;

  var txtCode = TextEditingController();
  var txtName = TextEditingController();

  var pict = "".obs;
  var txtType = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi(isFirst: true);
  }

  fetchApi({bool isRefresh = false, bool isFirst = false}) async {
    isLoading.value = true;

    if (isRefresh) res.clear();

    if (isFirst) {
      var reqType = await bankRepo.type();
      await reqType.responseHandler(
        res: (res) {
          resType.add(BankTypeModel.fromJson({"id": 0, "name": "ALL"}));
          for (var data in res["data"]) {
            resType.add(BankTypeModel.fromJson(data));
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    var reqBank = await bankRepo.list(
      type: (selectedType.value == "ALL") ? "" : selectedType.value,
    );
    await reqBank.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          this.res.add(BankListModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );
    isLoading.value = false;
  }

  selectType({required BankTypeModel res}) {
    selectedType.value = res.name;
    fetchApi(isRefresh: true);
  }

  add() async => await showDialog(
    context: Get.context!,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.all(24),
        color: MyColors.primary,
        child: Row(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => pict.value == ""
                      ? Icon(Icons.image, size: 200, color: MyColors.primary60)
                      : SizedBox(
                          width: 200,
                          height: 200,
                          child: MyImage(
                            image: pict.value,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                MyButton(
                  width: 200,
                  text: "Upload Image",
                  onTap: () => selectImageFrom(
                    variable: pict,
                    isLoading: isLoading,
                    gallery: true,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyDropdown(
                    label: "Type",
                    items: (filter, loadProps) => resType,
                    itemAsString: (item) => item.name,
                    selectedItem: txtType.value,
                    onChanged: (value) => chooseType(value: value),
                  ),
                  MyTextFormField(
                    controller: txtCode,
                    label: "Code",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  MyTextFormField(
                    controller: txtName,
                    label: "Name",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(),
                  MyButton(
                    text: "SAVE",
                    onTap: () async {
                      isLoadingAction.value = true;
                      var req = await bankRepo.add(
                        data: {
                          "image": pict.value,
                          "type": txtType.value,
                          "bank_code": txtCode.text,
                          "name": txtName.text,
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
          ],
        ),
      ),
    ),
  );

  Future<void> chooseType({required BankTypeModel value}) async {
    FocusScope.of(Get.context!).unfocus();

    isLoadingAction.value = true;
    txtType.value = value.name;
    isLoadingAction.value = false;
  }

  edit({required int id}) async {
    var reqBank = await bankRepo.list(id: id);
    await reqBank.responseHandler(
      res: (res) async {
        List<BankListModel> result = [];
        result.add(BankListModel.fromJson(res["data"]));

        pict.value = result[0].image;
        txtType.value = result[0].type;
        txtCode.text = result[0].bankCode;
        txtName.text = result[0].name;

        await showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.all(24),
              color: MyColors.primary,
              child: Row(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => pict.value == ""
                            ? Icon(
                                Icons.image,
                                size: 200,
                                color: MyColors.primary60,
                              )
                            : SizedBox(
                                width: 200,
                                height: 200,
                                child: MyImage(
                                  image: pict.value,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      MyButton(
                        width: 200,
                        text: "Upload Image",
                        onTap: () => selectImageFrom(
                          variable: pict,
                          isLoading: isLoading,
                          gallery: true,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyDropdown(
                          label: "Type",
                          items: (filter, loadProps) => resType,
                          itemAsString: (item) => item.name,
                          selectedItem: txtType.value,
                          onChanged: (value) => chooseType(value: value),
                        ),
                        MyTextFormField(
                          controller: txtCode,
                          label: "Code",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                        ),
                        MyTextFormField(
                          controller: txtName,
                          label: "Name",
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(),
                        MyButton(
                          text: "SAVE",
                          onTap: () async {
                            isLoadingAction.value = true;
                            var req = await bankRepo.update(
                              id: id,
                              data: {
                                "image": pict.value,
                                "type": txtType.value,
                                "bank_code": txtCode.text,
                                "name": txtName.text,
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
    var req = await bankRepo.remove(id: id);
    await req.responseHandler(
      res: (res) => fetchApi(isRefresh: true),
      err: (err) => showErrSnackbar(msg: err),
    );
    isLoadingAction.value = false;
  }

  // openDetail({required BankListModel res}) =>
  //     Get.toNamed(MyRoutes.myOrderDetail, parameters: {"id": "${res.id}"});
}
