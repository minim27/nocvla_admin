import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/products/product_type_model.dart';
import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_icon_button.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_switch.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../master_data_controller.dart';

class MMasterDataList extends StatelessWidget {
  const MMasterDataList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MasterDataController>();

    return MyPanel(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MySectionTitle(text: "Kategori produk"),
          SizedBox(height: 6),
          MyText(
            text:
                "Geser ikon di kiri untuk mengubah urutan. Urutan ini juga dipakai di katalog.",
            color: MyColors.primary60,
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.resTypes.isEmpty) {
              return MyEmptyState(text: "Belum ada kategori");
            }

            return ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (oldIndex, newIndex) => controller.reorderTypes(
                oldIndex: oldIndex,
                newIndex: newIndex,
              ),
              children: List.generate(controller.resTypes.length, (index) {
                final type = controller.resTypes[index];

                return KeyedSubtree(
                  key: ValueKey(type.id),
                  child: row(controller, type, index),
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
    ProductTypeModel type,
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
            child: Column(
              crossAxisAlignment: .start,
              spacing: 2,
              children: [
                MyText(text: "${type.name}", fontWeight: .w600),
                MyText(
                  text: "${type.productCount} produk",
                  color: MyColors.primary60,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          MySwitch(
            value: type.isActive == true,
            onChanged: (value) =>
                controller.toggleActive(type: type, value: value),
          ),
          MyIconButton(
            icon: Icons.edit_outlined,
            tooltip: "Ubah",
            size: 36,
            onTap: () => controller.openForm(type: type),
          ),
          MyIconButton(
            icon: Icons.delete_outline,
            tooltip: "Hapus",
            size: 36,
            color: MyColors.primary60,
            onTap: () => controller.deleteType(type: type),
          ),
        ],
      ),
    );
  }
}
