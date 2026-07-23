import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/product/list/widgets/mobile/m_product_data.dart';
import 'package:nocvla_admin/modules/product/list/widgets/mobile/m_product_filter.dart';
import 'package:nocvla_admin/modules/product/list/widgets/mobile/m_product_header.dart';
import 'package:nocvla_admin/modules/product/list/widgets/tab/t_product_column.dart';
import 'package:nocvla_admin/modules/product/list/widgets/tab/t_product_data.dart';
import 'package:nocvla_admin/modules/product/list/widgets/tab/t_product_filter.dart';
import 'package:nocvla_admin/modules/product/list/widgets/tab/t_product_header.dart';
import 'package:nocvla_admin/modules/product/list/widgets/web/product_column.dart';
import 'package:nocvla_admin/modules/product/list/widgets/web/product_data.dart';
import 'package:nocvla_admin/modules/product/list/widgets/web/product_filter.dart';
import 'package:nocvla_admin/modules/product/list/widgets/web/product_header.dart';

import '../../../shared/widgets/my_loading.dart';
import '../../../shared/widgets/my_scaffold.dart';
import 'product_controller.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyScaffold(
          body: Padding(
            padding: const .symmetric(vertical: 24, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1280;
                final isTab = constraints.maxWidth >= 768;

                if (isDesktop) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      ProductHeader(),
                      SizedBox(height: 24),
                      ProductFilter(),
                      SizedBox(height: 24),
                      ProductColumn(),
                      ProductData(),
                    ],
                  );
                }

                if (isTab) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      TProductHeader(),
                      SizedBox(height: 24),
                      TProductFilter(),
                      SizedBox(height: 24),
                      TProductColumn(),
                      TProductData(),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    MProductHeader(),
                    SizedBox(height: 24),
                    MProductFilter(),
                    SizedBox(height: 24),
                    MProductData(),
                  ],
                );
              },
            ),
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
