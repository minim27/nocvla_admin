import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../overview_controller.dart';

class MOverviewKpis extends StatelessWidget {
  const MOverviewKpis({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverviewController>();

    const columns = 2;
    final soldOut = controller.soldOutColors;
    final pending = controller.pendingApplications.length;
    final items = [
      _Kpi(
        label: "Produk aktif",
        value: "${controller.groups.length}",
        note: "${controller.resProducts.length} colorway",
      ),
      _Kpi(
        label: "Colorway habis",
        value: "${soldOut.length}",
        valueColor: soldOut.isEmpty ? MyColors.secondary : MyColors.redText,
        note: soldOut.isEmpty
            ? "Semua colorway ada stok"
            : soldOut.map((e) => e.colorName).join(", "),
      ),
      _Kpi(
        label: "Pendaftar atlet pending",
        value: "$pending",
        note: "Tinjau sekarang",
        onTap: () => controller.openMenu(route: MyRoutes.athlete),
      ),
      _Kpi(
        label: "Order WhatsApp minggu ini",
        value: controller.orderWeekCount.value == null
            ? "[—]"
            : "${controller.orderWeekCount.value}",
        valueColor: controller.orderWeekCount.value == null
            ? MyColors.primary80
            : MyColors.secondary,
        note: controller.orderWeekCount.value == null
            ? "Aktif setelah log order dipasang"
            : "Tinjau sekarang",
        onTap: controller.orderWeekCount.value == null
            ? null
            : () => controller.openMenu(route: MyRoutes.order),
      ),
    ];

    return Column(
      spacing: 16,
      children: [
        for (var i = 0; i < items.length; i += columns)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: .stretch,
              spacing: 16,
              children: items
                  .sublist(i, i + columns)
                  .map((item) => Expanded(child: item))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.label,
    required this.value,
    required this.note,
    this.valueColor = MyColors.secondary,
    this.onTap,
  });

  final String label, value, note;
  final Color valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(20),
      decoration: BoxDecoration(
        color: MyColors.primary90,
        border: .all(color: MyColors.line),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          MyText(text: label, color: MyColors.primary60, fontSize: 13),
          MyText(
            text: value,
            color: valueColor,
            fontFamily: MyFonts.grenzeGotisch,
            fontSize: 44,
            fontWeight: .w500,
          ),
          InkWell(
            onTap: onTap,
            child: MyText(
              text: note,
              color: MyColors.primary60,
              fontSize: 13,
              maxLines: 4,
              overflow: .ellipsis,
              decoration: onTap == null ? null : TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
