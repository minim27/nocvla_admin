import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_controller.dart';

class ProductFilter extends StatelessWidget {
  const ProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        MyTextFormField(
          controller: controller.txtSearchName,
          hintText: "Cari nama produk atau warna",
          keyboardType: .text,
          textInputAction: .search,
          prefixIcon: Icon(Icons.search, size: 18, color: MyColors.primary60),
          onChanged: (value) => controller.search(query: value),
        ),
        Obx(
          () => Wrap(
            spacing: 6,
            runSpacing: 6,
            children: controller.filterOptions.map((option) {
              final isActive = controller.selectedFilter.value == option["id"];

              return MyButton(
                text: option["label"]!,
                fontSize: 13,
                color: isActive ? MyColors.secondary : Colors.transparent,
                textColor: isActive ? MyColors.primary : MyColors.secondary,
                borderColor: isActive ? null : MyColors.line,
                onTap: () => controller.selectFilter(id: option["id"]!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
