import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../../app/core/base_controller.dart';

class DashboardController extends BaseController {
  List<Map<String, dynamic>> menu = [
    {
      "name": "Master",
      "route": null,
      "children": [
        {"name": "Bank", "route": MyRoutes.bank},
        {"name": "Color", "route": MyRoutes.colors},
        {"name": "Size", "route": MyRoutes.size},
      ],
    },
    {"name": "Products", "route": MyRoutes.product, "children": []},
  ];

  var myRoutes = MyRoutes.bank.obs;

  void changeRoute({required String route}) => myRoutes.value = route;
}
