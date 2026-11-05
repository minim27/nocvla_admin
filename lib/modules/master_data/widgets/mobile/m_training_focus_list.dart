import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/athlete_application/training_focus_model.dart';
import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_icon_button.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../master_data_controller.dart';

class MTrainingFocusList extends StatelessWidget {
  const MTrainingFocusList({super.key});

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
              MySectionTitle(text: "Fokus latihan"),
              MyButton(
                text: "+ Tambah",
                fontSize: 13,
                onTap: () => controller.openFocusForm(),
              ),
            ],
          ),
          SizedBox(height: 6),
          MyText(
            text:
                "Pilihan di form Join Nocvla Athlete. Geser ikon di kiri untuk mengubah urutan.",
            color: MyColors.primary60,
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.resFocuses.isEmpty) {
              return MyEmptyState(text: "Belum ada fokus latihan");
            }

            return ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (oldIndex, newIndex) => controller.reorderFocuses(
                oldIndex: oldIndex,
                newIndex: newIndex,
              ),
              children: List.generate(controller.resFocuses.length, (index) {
                final focus = controller.resFocuses[index];

                return KeyedSubtree(
                  key: ValueKey(focus.id),
                  child: row(controller, focus, index),
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
    TrainingFocusModel focus,
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
            child: MyText(text: "${focus.name}", fontWeight: .w600),
          ),
          MySwitch(
            value: focus.isActive == true,
            onChanged: (value) =>
                controller.toggleFocusActive(focus: focus, value: value),
          ),
          MyIconButton(
            icon: Icons.edit_outlined,
            tooltip: "Ubah",
            size: 36,
            onTap: () => controller.openFocusForm(focus: focus),
          ),
          MyIconButton(
            icon: Icons.delete_outline,
            tooltip: "Hapus",
            size: 36,
            color: MyColors.primary60,
            onTap: () => controller.deleteFocus(focus: focus),
          ),
        ],
      ),
    );
  }
}
