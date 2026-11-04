import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_image.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_stock_cell.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../overview_controller.dart';

class MOverviewStock extends StatelessWidget {
  const MOverviewStock({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverviewController>();
    final rows = controller.stockRows;
    final sizes = controller.stockSizes;

    return MyPanel(
      padding: .zero,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                MySectionTitle(text: "Stok perlu diisi"),
                InkWell(
                  onTap: () => controller.openMenu(route: MyRoutes.product),
                  child: MyText(
                    text: "Lihat semua",
                    color: MyColors.primary60,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          if (rows.isEmpty)
            MyEmptyState(text: "Semua colorway stoknya aman.")
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const nameWidth = 180.0;
                final free =
                    (constraints.maxWidth - nameWidth - 40) /
                    (sizes.isEmpty ? 1 : sizes.length);
                final cellWidth = free < 54 ? 54.0 : free;

                return SingleChildScrollView(
                  scrollDirection: .horizontal,
                  padding: const .symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: const .symmetric(vertical: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: nameWidth,
                              child: MyTableLabel(text: "Colorway"),
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
                      ...rows.map((row) {
                        final images = row.color.images ?? [];

                        return Container(
                          padding: const .symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: MyColors.lineSoft),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: nameWidth,
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    MyThumbnail(
                                      image: images.isEmpty
                                          ? null
                                          : images.first.imageUrl,
                                      size: 40,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        spacing: 2,
                                        children: [
                                          MyText(
                                            text: "${row.color.colorName}",
                                            fontWeight: .w600,
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                          ),
                                          MyText(
                                            text: row.group.name,
                                            color: MyColors.primary60,
                                            fontSize: 12,
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                          ),
                                        ],
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
                                      qty: row.group.qtyOf(
                                        color: row.color,
                                        size: size,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
