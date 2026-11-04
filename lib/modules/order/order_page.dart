import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/order/widgets/mobile/m_order_detail.dart';
import 'package:nocvla_admin/modules/order/widgets/mobile/m_order_pipeline.dart';
import 'package:nocvla_admin/modules/order/widgets/mobile/m_order_table.dart';
import 'package:nocvla_admin/modules/order/widgets/tab/t_order_detail.dart';
import 'package:nocvla_admin/modules/order/widgets/tab/t_order_pipeline.dart';
import 'package:nocvla_admin/modules/order/widgets/tab/t_order_table.dart';
import 'package:nocvla_admin/modules/order/widgets/web/order_detail.dart';
import 'package:nocvla_admin/modules/order/widgets/web/order_pipeline.dart';
import 'package:nocvla_admin/modules/order/widgets/web/order_table.dart';

import '../../shared/utils/my_colors.dart';
import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_page_header.dart';
import '../../shared/widgets/my_scaffold.dart';
import '../../shared/widgets/my_text.dart';
import 'order_controller.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: ListView(
            padding: isDesktop
                ? const .symmetric(vertical: 32, horizontal: 40)
                : const .symmetric(vertical: 20, horizontal: 16),
            children: [
              MyPageHeader(
                title: "Order WhatsApp",
                titleSize: isTab ? 44 : 36,
                actions: [
                  Obx(
                    () => MyButton(
                      text: "+ Catat order manual",
                      fontSize: 13,
                      color: Colors.transparent,
                      textColor: MyColors.secondary,
                      borderColor: MyColors.border,
                      enable: controller.isTableReady.value,
                      onTap: () => controller.openManual(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              MyText(
                text:
                    "Tercatat otomatis saat pembeli menekan \"Kirim ke WhatsApp\". Admin melengkapi ongkir, pembayaran, dan resi dari sini. Stok berkurang saat status Dibayar.",
                color: MyColors.primary60,
              ),
              SizedBox(height: 20),
              if (isDesktop) ...[
                OrderPipeline(),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: [
                    Expanded(flex: 16, child: OrderTable()),
                    Expanded(flex: 10, child: OrderDetail()),
                  ],
                ),
              ] else if (isTab) ...[
                TOrderPipeline(),
                SizedBox(height: 20),
                TOrderTable(),
                SizedBox(height: 16),
                TOrderDetail(),
              ] else ...[
                MOrderPipeline(),
                SizedBox(height: 20),
                MOrderTable(),
                SizedBox(height: 16),
                MOrderDetail(),
              ],
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isLoadingAction.value,
            child: const MyLoading(isStack: true),
          ),
        ),
      ],
    );
  }
}
