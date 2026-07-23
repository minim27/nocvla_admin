import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../product_controller.dart';

class MProductHeader extends StatelessWidget {
  const MProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        MyText(
          text: "Product",
          fontSize: 20,
          fontFamily: MyFonts.libreBaskerville,
        ),
        MyButton(width: 100, text: "Add", onTap: () => controller.add()),
      ],
    );
  }
}
