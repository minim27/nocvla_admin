import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/contact/contact_message_model.dart';
import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_utility.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_loading.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_status_badge.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../contact_message_controller.dart';

class ContactMessageList extends StatelessWidget {
  const ContactMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactMessageController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(height: 200, child: MyLoading());
      }
      if (controller.resMessages.isEmpty) {
        return MyPanel(child: MyEmptyState(text: "Belum ada pesan masuk."));
      }

      return Column(
        crossAxisAlignment: .stretch,
        spacing: 12,
        children: [
          for (final item in controller.resMessages)
            MyPanel(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 12,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(child: info(item)),
                      badge(item),
                    ],
                  ),
                  MyText(text: "${item.message ?? "-"}"),
                  if (item.status == "unread")
                    MyButton(
                      text: "Tandai sudah dibaca",
                      fontSize: 13,
                      onTap: () => controller.markRead(item: item),
                    ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget info(ContactMessageModel item) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        MyText(text: "${item.name ?? "-"}", fontWeight: .w600),
        MyText(
          text: [
            "${item.contact ?? "-"}",
            if ("${item.topic ?? ""}".isNotEmpty) "${item.topic}",
            if (item.createdAt != null) formatDate(val: item.createdAt),
          ].join(" · "),
          color: MyColors.primary60,
          fontSize: 13,
        ),
      ],
    );
  }

  Widget badge(ContactMessageModel item) {
    return item.status == "unread"
        ? MyStatusBadge(text: "Baru", color: MyColors.yellow)
        : MyStatusBadge(text: "Dibaca", color: MyColors.green);
  }
}
