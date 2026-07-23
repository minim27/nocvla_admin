import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_dropdown.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_controller.dart';

class MProductFilter extends StatelessWidget {
  const MProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Column(
      crossAxisAlignment: .start,
      children: [
        MyTextFormField(
          controller: controller.txtSearchName,
          label: "Product Name",
          hintText: "Search by name",
          keyboardType: .text,
          textInputAction: .search,
          onFieldSubmitted: (_) => controller.search(),
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: .end,
          spacing: 12,
          children: [
            Expanded(
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
            MyButton(
              width: 90,
              text: "Search",
              onTap: () => controller.search(),
            ),
          ],
        ),
      ],
    );
  }
}
