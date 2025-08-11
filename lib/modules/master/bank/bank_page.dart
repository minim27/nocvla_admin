import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/master/bank/bank_controller.dart';
import 'package:nocvla_admin/shared/widgets/my_button.dart';
import 'package:nocvla_admin/shared/widgets/my_image.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/utils/my_fonts.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import '../../../shared/widgets/my_text.dart';

class BankPage extends GetView<BankController> {
  const BankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          body: Obx(() {
            if (controller.isLoading.value &&
                controller.resType.isEmpty &&
                controller.res.isEmpty) {
              return MyLoading();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "BANK",
                        fontSize: 24,
                        fontFamily: MyFonts.libreBaskerville,
                      ),
                      MyButton(
                        width: 100,
                        text: "Add",
                        onTap: () => controller.add(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...List.generate(
                        controller.resType.length,
                        (index) => GestureDetector(
                          onTap: () => controller.selectType(
                            res: controller.resType[index],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (controller.selectedType.value !=
                                      controller.resType[index].name)
                                  ? null
                                  : MyColors.secondary,
                              border: Border.all(color: MyColors.secondary),
                            ),
                            child: MyText(
                              text: controller.resType[index].name,
                              color:
                                  (controller.selectedType.value !=
                                      controller.resType[index].name)
                                  ? MyColors.secondary
                                  : MyColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: MyColors.secondary),
                    child: Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MyText(
                            text: "Image",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            text: "Type",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            text: "Code",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            text: "Name",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            text: "Active",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            text: "Action",
                            color: MyColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: (controller.isLoading.value)
                        ? MyLoading()
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.secondary),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(12),
                              itemBuilder: (context, index) => Row(
                                spacing: 12,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      color: MyColors.secondary,
                                      child: MyImage(
                                        image: controller.res[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      text: controller.res[index].type,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      text: controller.res[index].bankCode,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      text: controller.res[index].name,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      text: "${controller.res[index].active}",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        GestureDetector(
                                          onTap: () => controller.edit(
                                            id: controller.res[index].id,
                                          ),
                                          child: Icon(
                                            Icons.edit_document,
                                            color: MyColors.secondary,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => controller.delete(
                                            id: controller.res[index].id,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: MyColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: controller.res.length,
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
        Obx(
          () => Visibility(
            visible: controller.isLoadingAction.value,
            child: const MyLoading(isStack: true),
          ),
        ),
      ],
    );
  }
}
