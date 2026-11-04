import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/dashboard/widgets/dashboard_shell.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_page_header.dart';
import '../../../shared/widgets/my_scaffold.dart';
import '../../../shared/widgets/my_tab_bar.dart';
import '../../../shared/widgets/my_text.dart';
import 'product_detail_controller.dart';
import 'widgets/mobile/m_pd_prodinfo.dart';
import 'widgets/mobile/m_pd_prodmarket.dart';
import 'widgets/mobile/m_pd_prodphoto.dart';
import 'widgets/mobile/m_pd_prodvar.dart';
import 'widgets/tab/t_pd_prodinfo.dart';
import 'widgets/tab/t_pd_prodmarket.dart';
import 'widgets/tab/t_pd_prodphoto.dart';
import 'widgets/tab/t_pd_prodvar.dart';
import 'widgets/web/pd_prodinfo.dart';
import 'widgets/web/pd_prodmarket.dart';
import 'widgets/web/pd_prodphoto.dart';
import 'widgets/web/pd_prodvar.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          body: DashboardShell(
            child: Obx(() {
              if (controller.isLoading.value) return MyLoading();

              final width = MediaQuery.sizeOf(context).width;
              final isDesktop = width >= 1280;
              final isTab = width >= 768;

              final List<Widget> sections;
              if (isDesktop) {
                sections = [
                  PDProdInfo(controller: controller),
                  PDProdVar(controller: controller),
                  PDProdPhoto(controller: controller),
                  PDProdMarket(controller: controller),
                ];
              } else if (isTab) {
                sections = [
                  TPDProdInfo(controller: controller),
                  TPDProdVar(controller: controller),
                  TPDProdPhoto(controller: controller),
                  TPDProdMarket(controller: controller),
                ];
              } else {
                sections = [
                  MPDProdInfo(controller: controller),
                  MPDProdVar(controller: controller),
                  MPDProdPhoto(controller: controller),
                  MPDProdMarket(controller: controller),
                ];
              }

              final horizontal = isDesktop ? 40.0 : 16.0;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: .fromLTRB(
                        horizontal,
                        isDesktop ? 32 : 20,
                        horizontal,
                        24,
                      ),
                      children: [
                        Align(
                          alignment: .centerLeft,
                          child: MyBackLink(
                            text: "Produk & Stok",
                            onTap: () => Get.back(),
                          ),
                        ),
                        SizedBox(height: 16),
                        MyPageHeader(
                          title: controller.isEditing
                              ? controller.txtName.text
                              : controller.isDuplicating
                              ? "Duplikat produk"
                              : "Produk baru",
                          titleSize: isTab ? 40 : 32,
                        ),
                        SizedBox(height: 20),
                        MyTabBar(
                          items: List.generate(
                            ProductDetailController.tabs.length,
                            (index) => MyTabItem(
                              label:
                                  "${index + 1}. ${ProductDetailController.tabs[index]}",
                            ),
                          ),
                          selectedIndex: controller.currentTab.value,
                          onTap: (index) => controller.changeTab(index: index),
                        ),
                        SizedBox(height: 20),
                        sections[controller.currentTab.value],
                      ],
                    ),
                  ),
                  Container(
                    padding: .symmetric(horizontal: horizontal, vertical: 16),
                    decoration: const BoxDecoration(
                      color: MyColors.primary,
                      border: Border(top: BorderSide(color: MyColors.line)),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: isTab
                              ? MyText(
                                  text:
                                      "Perubahan tersimpan setelah menekan Simpan.",
                                  color: MyColors.primary60,
                                  fontSize: 13,
                                )
                              : SizedBox(),
                        ),
                        if (controller.currentTab.value > 0)
                          MyButton(
                            text: "Sebelumnya",
                            color: Colors.transparent,
                            textColor: MyColors.secondary,
                            borderColor: MyColors.border,
                            fontSize: 13,
                            onTap: () => controller.prevTab(),
                          ),
                        if (controller.currentTab.value <
                            ProductDetailController.tabs.length - 1)
                          MyButton(
                            text: "Lanjut",
                            color: Colors.transparent,
                            textColor: MyColors.secondary,
                            borderColor: MyColors.border,
                            fontSize: 13,
                            onTap: () => controller.nextTab(),
                          ),
                        MyButton(
                          text: "Simpan",
                          fontSize: 13,
                          onTap: () => controller.save(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
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
