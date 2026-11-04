import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/my_colors.dart';
import '../../../../shared/utils/my_fonts.dart';
import '../../../../shared/widgets/my_text.dart';
import '../../order_controller.dart';

class MOrderPipeline extends StatelessWidget {
  const MOrderPipeline({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 2;
        final width = (constraints.maxWidth - 2 - (columns - 1)) / columns;
        final entries = OrderController.statuses.entries.toList();

        return Obx(
          () => Container(
            width: double.infinity,
            color: MyColors.line,
            padding: const .all(1),
            child: Wrap(
              spacing: 1,
              runSpacing: 1,
              children: List.generate(entries.length, (index) {
                final rest = entries.length % columns;
                final span = index == entries.length - 1 && rest != 0
                    ? columns - rest + 1
                    : 1;

                return Container(
                  width: width * span + span - 1,
                  padding: const .all(16),
                  decoration: BoxDecoration(
                    color: MyColors.primary90,
                    border: Border(
                      top: BorderSide(
                        color: index == 0 ? MyColors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 6,
                    children: [
                      MyText(
                        text: entries[index].value.toUpperCase(),
                        color: MyColors.primary60,
                        fontSize: 12,
                        fontWeight: .w600,
                        letterSpacing: 1.2,
                      ),
                      MyText(
                        text: controller.isTableReady.value
                            ? "${controller.countOf(status: entries[index].key)}"
                            : "—",
                        fontFamily: MyFonts.grenzeGotisch,
                        fontSize: 36,
                        fontWeight: .w500,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
