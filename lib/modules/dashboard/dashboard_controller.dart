import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../../app/core/base_controller.dart';

class DashboardController extends BaseController {
  List<Map<String, dynamic>> menu = [
    // {
    //   "name": "Master",
    //   "route": null,
    //   "children": [
    //     {"name": "Bank", "route": MyRoutes.bank},
    //     {"name": "Color", "route": MyRoutes.colors},
    //     {"name": "Size", "route": MyRoutes.size},
    //   ],
    // },
    {"name": "Products", "route": MyRoutes.product, "children": []},
    {"name": "Athlete", "route": MyRoutes.athlete, "children": []},
    {
      "name": "Athlete Applications",
      "route": MyRoutes.athleteApplication,
      "children": [],
    },
    {"name": "Featured", "route": MyRoutes.featured, "children": []},
  ];

  var myRoutes = MyRoutes.product.obs;

  void changeRoute({required String route}) => myRoutes.value = route;
}
