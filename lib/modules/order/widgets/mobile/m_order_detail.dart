import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/utils/my_parsing_currency.dart';
import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_dropdown.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../order_controller.dart';

class MOrderDetail extends StatelessWidget {
  const MOrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    Widget summary(String label, String value) => Row(
      mainAxisAlignment: .spaceBetween,
      spacing: 12,
      children: [
        MyText(text: label, color: MyColors.primary60, fontSize: 13),
        Flexible(
          child: MyText(text: value, fontSize: 13, textAlign: .right),
        ),
      ],
    );

    return MyPanel(
      padding: const .all(20),
      child: Obx(() {
        final order = controller.selected.value;
        final isActive = order != null;
        final isClosed =
            order?.status == "done" || order?.status == "cancelled";

        return Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            MyText(
              text: isActive ? "#${order.code}" : "Detail order",
              fontFamily: MyFonts.grenzeGotisch,
              fontSize: 28,
              fontWeight: .w500,
            ),
            if (!isActive)
              MyText(
                text: "Pilih order dari tabel untuk melihat detailnya.",
                color: MyColors.primary60,
                fontSize: 13,
              )
            else ...[
              MyText(
                text: controller.statusLabel(order.status),
                color: MyColors.primary60,
                fontSize: 13,
              ),
              MyText(text: order.itemSummary),
              MyText(
                text:
                    "${order.customerName ?? "-"} · ${order.customerPhone ?? "-"}\n${order.address ?? "-"}",
                color: MyColors.primary60,
                fontSize: 13,
              ),
            ],
            Row(
              crossAxisAlignment: .start,
              spacing: 10,
              children: [
                Expanded(
                  child: MyTextFormField(
                    controller: controller.txtShippingFee,
                    label: "Ongkir",
                    hintText: "Rp",
                    keyboardType: .number,
                    enabled: isActive && !isClosed,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                Expanded(
                  child: MyDropdown(
                    label: "Kurir",
                    enabled: isActive && !isClosed,
                    items: (filter, loadProps) => OrderController.couriers,
                    selectedItem: controller.selectedCourier.value,
                    onChanged: (value) =>
                        controller.selectCourier(value: value),
                  ),
                ),
              ],
            ),
            MyTextFormField(
              controller: controller.txtAwb,
              label: "Nomor resi",
              hintText: "Diisi saat dikirim",
              keyboardType: .text,
              enabled: isActive && !isClosed,
            ),
            Container(
              padding: const .symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: MyColors.line),
                  bottom: BorderSide(color: MyColors.line),
                ),
              ),
              child: Column(
                spacing: 8,
                children: [
                  summary(
                    "Subtotal",
                    isActive ? parsingCurrency(order.subtotal ?? 0) : "—",
                  ),
                  if (isActive && ((order.discount ?? 0) as num) > 0)
                    summary("Diskon", "- ${parsingCurrency(order.discount)}"),
                  summary(
                    "Ongkir",
                    order?.shippingFee == null
                        ? "—"
                        : parsingCurrency(order!.shippingFee),
                  ),
                  summary(
                    "Atlet",
                    order?.athleteCode == null
                        ? "—"
                        : "${order!.athleteName} (${order.athleteCode})",
                  ),
                  if (isActive) summary("Total", parsingCurrency(order.total)),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MyButton(
                  text: "Kirim total ke pembeli",
                  fontSize: 13,
                  color: MyColors.red,
                  textColor: MyColors.white,
                  enable: isActive && !isClosed,
                  onTap: () => controller.sendTotal(),
                ),
                if (!isActive ||
                    order.status == "new" ||
                    order.status == "awaiting_payment")
                  MyButton(
                    text: "Tandai dibayar",
                    fontSize: 13,
                    enable: isActive,
                    onTap: () => controller.markPaid(),
                  ),
                if (order?.status == "paid")
                  MyButton(
                    text: "Tandai dikirim",
                    fontSize: 13,
                    onTap: () => controller.markShipped(),
                  ),
                if (order?.status == "shipped")
                  MyButton(
                    text: "Tandai selesai",
                    fontSize: 13,
                    onTap: () => controller.markDone(),
                  ),
                if (isActive && !isClosed) ...[
                  MyButton(
                    text: "Simpan",
                    fontSize: 13,
                    color: Colors.transparent,
                    textColor: MyColors.secondary,
                    borderColor: MyColors.border,
                    onTap: () => controller.save(),
                  ),
                  MyButton(
                    text: "Batalkan",
                    fontSize: 13,
                    color: Colors.transparent,
                    textColor: MyColors.redText,
                    borderColor: MyColors.line,
                    onTap: () => controller.cancel(),
                  ),
                ],
              ],
            ),
          ],
        );
      }),
    );
  }
}
