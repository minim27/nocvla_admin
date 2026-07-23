import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_controller.dart';

class TProductFilter extends StatelessWidget {
  const TProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Row(
      crossAxisAlignment: .end,
      spacing: 12,
      children: [
        Expanded(
          child: MyTextFormField(
            controller: controller.txtSearchName,
            label: "Product Name",
            hintText: "Search by name",
            keyboardType: .text,
            textInputAction: .search,
            onFieldSubmitted: (_) => controller.search(),
          ),
        ),
        SizedBox(
          width: 180,
          child: Obx(
            () => MyDropdown(
              label: "Type",
              items: (filter, loadProps) => controller.resTypes,
              itemAsString: (item) => item.name,
              selectedItem: controller.selectedType.value?.name,
              onChanged: (value) => controller.selectType(res: value),
            ),
          ),
        ),
        MyButton(width: 90, text: "Search", onTap: () => controller.search()),
      ],
    );
  }
}
