import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/master_data/widgets/mobile/m_master_data_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/tab/t_master_data_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/web/master_data_list.dart';

import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'master_data_controller.dart';

class MasterDataPage extends GetView<MasterDataController> {
  const MasterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: Obx(() {
            if (controller.isLoading.value) return MyLoading();

            return ListView(
              padding: isDesktop
                  ? const .symmetric(vertical: 32, horizontal: 40)
                  : const .symmetric(vertical: 20, horizontal: 16),
              children: [
                MyPageHeader(
                  title: "Kategori Produk",
                  titleSize: isTab ? 44 : 36,
                  actions: [
                    MyButton(
                      text: "+ Tambah kategori",
                      fontSize: 13,
                      onTap: () => controller.openForm(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (isDesktop)
                  MasterDataList()
                else if (isTab)
                  TMasterDataList()
                else
                  MMasterDataList(),
              ],
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
