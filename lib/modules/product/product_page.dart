import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/my_scaffold.dart';
import '../../shared/utils/my_colors.dart';
import '../../shared/utils/my_fonts.dart';
import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_image.dart';
import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_text.dart';
import 'product_controller.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Obx(() {
        if (controller.isLoading.value) return MyLoading();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Product",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: MyColors.secondary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyText(
                        text: "Product",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      child: MyImage(
                                        image: controller.res[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Flexible(
                                      child: MyText(
                                        text: controller.res[index].aliasName,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    GestureDetector(
                                      onTap: () => controller.edit(
                                        slug: controller.res[index].slug,
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
    );
  }
}
