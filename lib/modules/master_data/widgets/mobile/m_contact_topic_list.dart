import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/contact/contact_topic_model.dart';
import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_icon_button.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../master_data_controller.dart';

class MContactTopicList extends StatelessWidget {
  const MContactTopicList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MasterDataController>();

    return MyPanel(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              MySectionTitle(text: "Topik pesan"),
              MyButton(
                text: "+ Tambah",
                fontSize: 13,
                onTap: () => controller.openTopicForm(),
              ),
            ],
          ),
          SizedBox(height: 6),
          MyText(
            text:
                "Pilihan Topik di form Kirim pesan halaman Kontak. Geser ikon di kiri untuk mengubah urutan.",
            color: MyColors.primary60,
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.resTopics.isEmpty) {
              return MyEmptyState(text: "Belum ada topik pesan");
            }

            return ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (oldIndex, newIndex) => controller.reorderTopics(
                oldIndex: oldIndex,
                newIndex: newIndex,
              ),
              children: List.generate(controller.resTopics.length, (index) {
                final topic = controller.resTopics[index];

                return KeyedSubtree(
                  key: ValueKey(topic.id),
                  child: row(controller, topic, index),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget row(
    MasterDataController controller,
    ContactTopicModel topic,
    int index,
  ) {
    return Container(
      padding: const .symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.primary90,
        border: Border(top: BorderSide(color: MyColors.line)),
      ),
      child: Row(
        spacing: 8,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Icon(
              Icons.drag_indicator,
              size: 24,
              color: MyColors.primary60,
            ),
          ),
          Expanded(
            child: MyText(text: "${topic.name}", fontWeight: .w600),
          ),
          MySwitch(
            value: topic.isActive == true,
            onChanged: (value) =>
                controller.toggleTopicActive(topic: topic, value: value),
          ),
          MyIconButton(
            icon: Icons.edit_outlined,
            tooltip: "Ubah",
            size: 36,
            onTap: () => controller.openTopicForm(topic: topic),
          ),
          MyIconButton(
            icon: Icons.delete_outline,
            tooltip: "Hapus",
            size: 36,
            color: MyColors.primary60,
            onTap: () => controller.deleteTopic(topic: topic),
          ),
        ],
      ),
    );
  }
}
