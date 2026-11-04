import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/products/list_products_model.dart';
import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_parsing_currency.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_empty_state.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_image.dart';
import '../../../../../shared/widgets/my_loading.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_stock_cell.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_controller.dart';

class ProductData extends StatelessWidget {
  const ProductData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      if (controller.isLoading.value) return Expanded(child: MyLoading());

      final groups = controller.groups;

      return Expanded(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: MyColors.primary90,
            border: Border(
              left: BorderSide(color: MyColors.line),
              right: BorderSide(color: MyColors.line),
              bottom: BorderSide(color: MyColors.line),
            ),
          ),
          child: groups.isEmpty
              ? MyEmptyState(text: "Belum ada produk yang cocok.")
              : ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final isOpen = controller.expandedId.value == group.id;
                    final image = (group.first.images ?? []).isEmpty
                        ? null
                        : group.first.images!.first.imageUrl;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => controller.toggleExpand(id: group.id),
                          child: Padding(
                            padding: const .symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Row(
                              spacing: 12,
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: Icon(
                                    isOpen
                                        ? Icons.expand_more
                                        : Icons.chevron_right,
                                    size: 18,
                                    color: MyColors.primary60,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    spacing: 14,
                                    children: [
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
                                                  "${group.typeName} · ${group.isFeatured ? "Featured" : "Belum featured"}",
                                              color: MyColors.primary60,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    spacing: 4,
                                    children: [
                                      ...group.colors.take(4).map((color) {
                                        final swatch =
                                            (color.images ?? []).isEmpty
                                            ? null
                                            : color.images!.first.imageUrl;

                                        return ClipOval(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            color: MyColors.selected,
                                            child: swatch == null
                                                ? null
                                                : MyImage(swatch),
                                          ),
                                        );
                                      }),
                                      SizedBox(width: 4),
                                      Flexible(
                                        child: MyText(
                                          text: "${group.colors.length} warna",
                                          color: MyColors.primary60,
                                          fontSize: 12,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: MyText(
                                    text: group.minPrice == null
                                        ? "-"
                                        : parsingCurrency(group.minPrice),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: MyText(
                                    text: "${group.totalStock} pcs",
                                    fontWeight: .w600,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    spacing: 6,
                                    children: [
                                      _MarketChip(
                                        label: "S",
                                        url: group.first.shopeeUrl,
                                        type: "shopee",
                                      ),
                                      _MarketChip(
                                        label: "T",
                                        url: group.first.tiktokUrl,
                                        type: "tiktok",
                                      ),
                                      _MarketChip(
                                        label: "Tp",
                                        url: group.first.tokopediaUrl,
                                        type: "tokopedia",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 88,
                                  child: Row(
                                    mainAxisAlignment: .end,
                                    spacing: 8,
                                    children: [
                                      MyIconButton(
                                        icon: Icons.edit_outlined,
                                        tooltip: "Edit",
                                        onTap: () =>
                                            controller.edit(id: group.id),
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
                              ],
                            ),
                          ),
                        ),
                        if (isOpen)
                          _ProductMatrix(group: group, controller: controller),
                      ],
                    );
                  },
                ),
        ),
      );
    });
  }
}

class _MarketChip extends StatelessWidget {
  const _MarketChip({required this.label, this.url, required this.type});

  final String label;
  final dynamic url;
  final String type;

  @override
  Widget build(BuildContext context) {
    final value = "${url ?? ""}";
    final isError = marketplaceUrlError(type: type, url: value) != null;

    return Container(
      constraints: const BoxConstraints(minWidth: 28),
      height: 24,
      alignment: .center,
      decoration: BoxDecoration(
        border: .all(color: isError ? MyColors.redText : MyColors.line),
      ),
      child: MyText(
        text: label,
        color: isError
            ? MyColors.redText
            : value.isEmpty
            ? MyColors.primary80
            : MyColors.secondary,
        fontSize: 11,
        fontWeight: .w700,
      ),
    );
  }
}

class _ProductMatrix extends StatelessWidget {
  const _ProductMatrix({required this.group, required this.controller});

  final ProductGroup group;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    final sizes = group.sizes;

    return Padding(
      padding: const .fromLTRB(82, 0, 20, 20),
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
                      SizedBox(width: 240, child: MyTableLabel(text: "Warna")),
                      ...sizes.map(
                        (size) => SizedBox(
                          width: 130,
                          child: MyTableLabel(text: size),
                        ),
                      ),
                    ],
                  ),
                ),
                ...group.colors.map((color) => _row(color, sizes)),
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
  }

  Widget _row(ListProductsModel color, List<String> sizes) {
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
            width: 240,
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
              width: 130,
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
