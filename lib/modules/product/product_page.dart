import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/my_scaffold.dart';
import '../../shared/utils/my_fonts.dart';
import '../../shared/widgets/my_button.dart';
import '../../shared/widgets/my_text.dart';
import 'product_controller.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: "Product",
                fontSize: 24,
                fontFamily: MyFonts.libreBaskerville,
              ),
              MyButton(width: 100, text: "Add", onTap: () => controller.add()),
            ],
          ),
          SizedBox(height: 24),
          Expanded(child: ListView(shrinkWrap: true, children: [])),
        ],
      ),
    );
  }
}
