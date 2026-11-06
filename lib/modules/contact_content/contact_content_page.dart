import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/contact_content/widgets/mobile/m_contact_content_form.dart';
import 'package:nocvla_admin/modules/contact_content/widgets/tab/t_contact_content_form.dart';
import 'package:nocvla_admin/modules/contact_content/widgets/web/contact_content_form.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'contact_content_controller.dart';

class ContactContentPage extends GetView<ContactContentController> {
  const ContactContentPage({super.key});

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
              MyPageHeader(title: "Halaman Kontak", titleSize: isTab ? 44 : 36),
              SizedBox(height: 20),
              isDesktop
                  ? ContactContentForm()
                  : isTab
                  ? TContactContentForm()
                  : MContactContentForm(),
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
