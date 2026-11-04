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

class TMasterDataList extends StatelessWidget {
  const TMasterDataList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MasterDataController>();

    return MyPanel(
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
          Padding(
            padding: const .symmetric(vertical: 8),
            child: Row(
              spacing: 12,
              children: [
                SizedBox(width: 24),
                Expanded(child: MyTableLabel(text: "Nama")),
                SizedBox(width: 72, child: MyTableLabel(text: "Produk")),
                SizedBox(width: 64, child: MyTableLabel(text: "Aktif")),
                SizedBox(width: 88, child: MyTableLabel(text: "Aksi")),
              ],
            ),
          ),
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
        spacing: 12,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Icon(
                Icons.drag_indicator,
                size: 24,
                color: MyColors.primary60,
              ),
            ),
          ),
          Expanded(
            child: MyText(text: "${type.name}", fontWeight: .w600),
          ),
          SizedBox(
            width: 72,
            child: MyText(
              text: "${type.productCount}",
              color: MyColors.primary60,
            ),
          ),
          SizedBox(
            width: 64,
            child: Align(
              alignment: .centerLeft,
              child: MySwitch(
                value: type.isActive == true,
                onChanged: (value) =>
                    controller.toggleActive(type: type, value: value),
              ),
            ),
          ),
          MyIconButton(
            icon: Icons.edit_outlined,
            tooltip: "Ubah",
            onTap: () => controller.openForm(type: type),
          ),
          MyIconButton(
            icon: Icons.delete_outline,
            tooltip: "Hapus",
            color: MyColors.primary60,
            onTap: () => controller.deleteType(type: type),
          ),
        ],
      ),
    );
  }
}
