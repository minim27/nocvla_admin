import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/master_data/widgets/mobile/m_contact_topic_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/tab/t_contact_topic_list.dart';
import 'package:nocvla_admin/modules/master_data/widgets/web/contact_topic_list.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'master_data_controller.dart';

class ContactTopicPage extends GetView<MasterDataController> {
  const ContactTopicPage({super.key});

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
                MyPageHeader(title: "Topik Pesan", titleSize: isTab ? 44 : 36),
                SizedBox(height: 20),
                if (isDesktop)
                  ContactTopicList()
                else if (isTab)
                  TContactTopicList()
                else
                  MContactTopicList(),
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
