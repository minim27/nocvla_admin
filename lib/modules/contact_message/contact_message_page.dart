import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/contact_message/widgets/mobile/m_contact_message_list.dart';
import 'package:nocvla_admin/modules/contact_message/widgets/tab/t_contact_message_list.dart';
import 'package:nocvla_admin/modules/contact_message/widgets/web/contact_message_list.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'contact_message_controller.dart';

class ContactMessagePage extends GetView<ContactMessageController> {
  const ContactMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: ListView(
            padding: isDesktop
                ? const .symmetric(vertical: 32, horizontal: 40)
                : const .symmetric(vertical: 20, horizontal: 16),
            children: [
              MyPageHeader(title: "Pesan Masuk", titleSize: isTab ? 44 : 36),
              SizedBox(height: 20),
              isDesktop
                  ? ContactMessageList()
                  : isTab
                  ? TContactMessageList()
                  : MContactMessageList(),
            ],
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
