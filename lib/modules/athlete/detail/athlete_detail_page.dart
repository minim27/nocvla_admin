import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/utils/my_colors.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'athlete_detail_controller.dart';
import 'widgets/mobile/m_athlete_form.dart';
import 'widgets/mobile/m_athlete_products.dart';
import 'widgets/tab/t_athlete_form.dart';
import 'widgets/tab/t_athlete_products.dart';
import 'widgets/web/athlete_form.dart';
import 'widgets/web/athlete_products.dart';

class AthleteDetailPage extends GetView<AthleteDetailController> {
  const AthleteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          appBar: AppBar(),
          body: Obx(() {
            if (controller.isLoading.value) return MyLoading();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1280;
                final isTab = constraints.maxWidth >= 768;

                final Widget form;
                final Widget products;

                if (isDesktop) {
                  form = AthleteForm(controller: controller);
                  products = AthleteProducts(controller: controller);
                } else if (isTab) {
                  form = TAthleteForm(controller: controller);
                  products = TAthleteProducts(controller: controller);
                } else {
                  form = MAthleteForm(controller: controller);
                  products = MAthleteProducts(controller: controller);
                }

                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: MyColors.secondary,
                        unselectedLabelColor: MyColors.primary80,
                        indicatorColor: MyColors.secondary,
                        tabs: [
                          Tab(text: "Bio Data"),
                          Tab(text: "Assigned Products"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              padding: .symmetric(horizontal: 16, vertical: 24),
                              child: form,
                            ),
                            SingleChildScrollView(
                              padding: .symmetric(horizontal: 16, vertical: 24),
                              child: products,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: .symmetric(horizontal: 16, vertical: 16),
                        child: MyButton(
                          text: "Save",
                          onTap: () => controller.save(),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
