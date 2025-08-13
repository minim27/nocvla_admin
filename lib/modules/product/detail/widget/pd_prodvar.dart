import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/shared/utils/my_input_formatters.dart';

import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../product_detail_controller.dart';

class PDProdVar extends StatelessWidget {
  const PDProdVar({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "PRODUCT VARIATION",
          fontSize: 24,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 24),
        MyText(text: "Size", fontSize: 16, fontWeight: FontWeight.w700),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(
              controller.resSize.length,
              (index) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.resSize[index].selected.value,
                      onChanged: (value) => controller.selectSize(index: index),
                    ),
                  ),
                  MyText(text: controller.resSize[index].name),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        MyText(text: "Color", fontSize: 16, fontWeight: FontWeight.w700),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(
              controller.resColor.length,
              (index) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.resColor[index].selected.value,
                      onChanged: (value) =>
                          controller.selectColor(index: index),
                    ),
                  ),
                  MyText(text: controller.resColor[index].name),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        SizedBox(
          width: Get.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Size",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 6),
                          SizedBox(
                            width: 100,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Color",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 20),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Print P Color",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 20),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Print S Color",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 20),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Regular Price",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 20),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Discount Price",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          VerticalDivider(width: 20),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Center(
                              child: MyText(
                                text: "Stock",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      width: Get.size.width,
                    ),
                    SizedBox(
                      width: 1800,
                      child: Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Center(
                                  child: MyText(
                                    text: controller.selectedSize[index],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                color: Colors.grey,
                                width: 1,
                                height: 112,
                              ),
                              SizedBox(
                                width: Get.size.width,
                                child: Obx(
                                  () => ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, indexx) {
                                      final color =
                                          controller.selectedColor[indexx];
                                      final hex = color['hex']!;
                                      final k = controller.keyFor(
                                        controller.selectedSize[index],
                                        hex,
                                      );

                                      return SingleChildScrollView(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: Center(
                                                child: MyText(
                                                  text: controller
                                                      .selectedColor[indexx]["name"],
                                                ),
                                              ),
                                            ),
                                            VerticalDivider(width: 20),
                                            SizedBox(
                                              width: 200,
                                              child: MyTextFormField(
                                                controller: controller
                                                    .printPrimaryCtrls[k],
                                                hintText: "#000000",
                                              ),
                                            ),
                                            VerticalDivider(width: 20),
                                            SizedBox(
                                              width: 200,
                                              child: MyTextFormField(
                                                controller: controller
                                                    .printSecondaryCtrls[k],
                                                hintText: "#000000",
                                              ),
                                            ),
                                            VerticalDivider(width: 20),
                                            SizedBox(
                                              width: 200,
                                              child: MyTextFormField(
                                                controller:
                                                    controller.regPriceCtrls[k],
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  NoLeadingZeroTextInputFormatter(),
                                                ],
                                              ),
                                            ),
                                            VerticalDivider(width: 20),
                                            SizedBox(
                                              width: 200,
                                              child: MyTextFormField(
                                                controller: controller
                                                    .discPriceCtrls[k],
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  NoLeadingZeroTextInputFormatter(),
                                                ],
                                              ),
                                            ),
                                            VerticalDivider(width: 20),
                                            SizedBox(
                                              width: 200,
                                              child: MyTextFormField(
                                                controller:
                                                    controller.stockCtrls[k],
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  NoLeadingZeroTextInputFormatter(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: controller.selectedColor.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: controller.selectedSize.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
