import 'package:get/get.dart';
import 'package:nocvla_admin/modules/master/bank/bank_binding.dart';
import 'package:nocvla_admin/modules/master/bank/bank_page.dart';
import 'package:nocvla_admin/modules/master/colors/colors_binding.dart';
import 'package:nocvla_admin/modules/master/colors/colors_page.dart';
import 'package:nocvla_admin/modules/master/size/size_binding.dart';
import 'package:nocvla_admin/modules/master/size/size_page.dart';

import 'my_routes.dart';

class MyPages {
  static final routes = [
    GetPage(
      name: MyRoutes.bank,
      page: () => BankPage(),
      binding: BankBinding(),
    ),
    GetPage(
      name: MyRoutes.colors,
      page: () => ColorsPage(),
      binding: ColorsBinding(),
    ),
    GetPage(
      name: MyRoutes.size,
      page: () => SizePage(),
      binding: SizeBinding(),
    ),
  ];
}
