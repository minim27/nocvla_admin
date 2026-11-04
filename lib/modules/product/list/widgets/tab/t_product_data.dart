import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/products/list_products_model.dart';
import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_parsing_currency.dart';
import '../../../../../shared/widgets/my_empty_state.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_stock_cell.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_controller.dart';

class TProductData extends StatelessWidget {
  const TProductData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      final groups = controller.groups;
      final expandedId = controller.expandedId.value;

      return Expanded(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: MyColors.primary90,
            border: Border(
              left: BorderSide(color: MyColors.line),
              right: BorderSide(color: MyColors.line),
              bottom: BorderSide(color: MyColors.line),
              top: BorderSide(color: MyColors.line),
            ),
          ),
          child: groups.isEmpty
              ? MyEmptyState(text: "Belum ada produk yang cocok.")
              : ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final isOpen = expandedId == group.id;
                    final image = (group.first.images ?? []).isEmpty
                        ? null
                        : group.first.images!.first.imageUrl;

                    return Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        InkWell(
                          onTap: () => controller.toggleExpand(id: group.id),
                          child: Padding(
                            padding: const .symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  isOpen
                                      ? Icons.expand_more
                                      : Icons.chevron_right,
                                  size: 18,
                                  color: MyColors.primary60,
                                ),
                                MyThumbnail(image: image),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    spacing: 3,
                                    children: [
                                      MyText(
                                        text: group.name,
                                        fontWeight: .w700,
                                        maxLines: 1,
                                        overflow: .ellipsis,
                                      ),
                                      MyText(
                                        text:
                                            "${group.typeName} · ${group.colors.length} warna · ${group.totalStock} pcs",
                                        color: MyColors.primary60,
                                        fontSize: 12,
                                      ),
                                      MyText(
                                        text: group.minPrice == null
                                            ? "-"
                                            : parsingCurrency(group.minPrice),
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                                MyIconButton(
                                  icon: Icons.edit_outlined,
                                  tooltip: "Edit",
                                  onTap: () => controller.edit(id: group.id),
                                ),
                                MyIconButton(
                                  icon: Icons.copy,
                                  tooltip: "Duplikat",
                                  onTap: () =>
                                      controller.duplicate(id: group.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isOpen)
                          _TProductMatrix(group: group, controller: controller),
                      ],
                    );
                  },
                ),
        ),
      );
    });
  }
}

class _TProductMatrix extends StatelessWidget {
  const _TProductMatrix({required this.group, required this.controller});

  final ProductGroup group;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    final sizes = group.sizes;

    return LayoutBuilder(
      builder: (context, constraints) {
        final free =
            (constraints.maxWidth - 60 - 200 - 30) /
            (sizes.isEmpty ? 1 : sizes.length);
        final cellWidth = free < 90 ? 90.0 : free;

        return Padding(
          padding: const .fromLTRB(44, 0, 16, 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SingleChildScrollView(
                scrollDirection: .horizontal,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Padding(
                      padding: const .only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: MyTableLabel(text: "Warna"),
                          ),
                          ...sizes.map(
                            (size) => SizedBox(
                              width: cellWidth,
                              child: MyTableLabel(text: size),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...group.colors.map(
                      (color) => _row(color, sizes, cellWidth),
                    ),
                  ],
                ),
              ),
              if (sizes.isNotEmpty) ...[
                SizedBox(height: 14),
                MyText(
                  text: group.priceSummary,
                  color: MyColors.primary60,
                  fontSize: 12,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _row(ListProductsModel color, List<String> sizes, double cellWidth) {
    final image = (color.images ?? []).isEmpty
        ? null
        : color.images!.first.imageUrl;

    return Container(
      padding: const .symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: MyColors.lineSoft)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Row(
              spacing: 10,
              children: [
                MyThumbnail(image: image, size: 32),
                Expanded(
                  child: MyText(
                    text: "${color.colorName ?? "-"}",
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ...sizes.map(
            (size) => SizedBox(
              width: cellWidth,
              child: Align(
                alignment: .centerLeft,
                child: MyStockCell(
                  qty: group.qtyOf(color: color, size: size),
                ),
              ),
            ),
          ),
          MyIconButton(
            icon: Icons.delete_outline_rounded,
            tooltip: "Hapus warna",
            size: 30,
            iconSize: 15,
            color: MyColors.primary60,
            onTap: () => controller.delete(item: color),
          ),
        ],
      ),
    );
  }
}
