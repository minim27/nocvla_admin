import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_parsing_currency.dart';
import '../../../../shared/utils/my_utility.dart';
import '../../../../shared/widgets/my_empty_state.dart';
import '../../../../shared/widgets/my_loading.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_status_badge.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../order_controller.dart';

class TOrderTable extends StatelessWidget {
  const TOrderTable({super.key});

  Widget _badge(OrderController controller, dynamic status) {
    final label = controller.statusLabel(status);

    return switch (status) {
      "new" => MyStatusBadge(
        text: label,
        color: MyColors.redText,
        borderColor: MyColors.red,
      ),
      "awaiting_payment" => MyStatusBadge(text: label, color: MyColors.yellow),
      "paid" || "shipped" => MyStatusBadge(text: label, color: MyColors.green),
      _ => MyStatusBadge(text: label, borderColor: MyColors.line),
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return MyPanel(
      padding: .zero,
      child: Obx(() {
        if (controller.isLoading.value && controller.res.isEmpty) {
          return SizedBox(height: 160, child: MyLoading());
        }

        final selectedId = controller.selected.value?.id;

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .symmetric(vertical: 12, horizontal: 16),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(flex: 3, child: MyTableLabel(text: "Order")),
                  Expanded(flex: 4, child: MyTableLabel(text: "Item")),
                  Expanded(flex: 2, child: MyTableLabel(text: "Kode atlet")),
                  Expanded(flex: 2, child: MyTableLabel(text: "Subtotal")),
                  Expanded(flex: 3, child: MyTableLabel(text: "Status")),
                ],
              ),
            ),
            if (!controller.isTableReady.value)
              MyEmptyState(
                text: "Data order muncul setelah tabel t_wa_orders aktif.",
              )
            else if (controller.res.isEmpty)
              MyEmptyState(text: "Belum ada order.")
            else
              ...controller.res.map((items) {
                final isSelected = items.id == selectedId;

                return InkWell(
                  onTap: () => controller.selectOrder(item: items),
                  child: Container(
                    padding: const .symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? MyColors.selected : null,
                      border: Border(
                        top: const BorderSide(color: MyColors.lineSoft),
                        left: BorderSide(
                          color: isSelected ? MyColors.red : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: .start,
                            spacing: 3,
                            children: [
                              MyText(text: "#${items.code}", fontWeight: .w600),
                              MyText(
                                text:
                                    "${items.customerName ?? "-"} · ${formatDate(val: items.createdAt)}",
                                color: MyColors.primary60,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: MyText(text: items.itemSummary, fontSize: 13),
                        ),
                        Expanded(
                          flex: 2,
                          child: MyText(
                            text: "${items.athleteCode ?? "—"}",
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: MyText(
                            text: parsingCurrency(items.subtotal ?? 0),
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: .centerLeft,
                            child: _badge(controller, items.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      }),
    );
  }
}
