import 'package:get/get.dart';
import 'package:nocvla_admin/modules/athlete/detail/athlete_detail_binding.dart';
import 'package:nocvla_admin/modules/athlete/detail/athlete_detail_page.dart';
import 'package:nocvla_admin/modules/athlete/list/athlete_binding.dart';
import 'package:nocvla_admin/modules/athlete/list/athlete_page.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_binding.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_page.dart';
import 'package:nocvla_admin/modules/featured/featured_binding.dart';
import 'package:nocvla_admin/modules/featured/featured_page.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_binding.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_page.dart';
import 'package:nocvla_admin/modules/product/list/product_binding.dart';
import 'package:nocvla_admin/modules/product/list/product_page.dart';

import 'my_routes.dart';

class MyPages {
  static final routes = [
    GetPage(
      name: MyRoutes.dashboard,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: MyRoutes.product,
      page: () => ProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: MyRoutes.productDetail,
      page: () => ProductDetailPage(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: MyRoutes.athlete,
      page: () => AthletePage(),
      binding: AthleteBinding(),
    ),
    GetPage(
      name: MyRoutes.athleteDetail,
      page: () => AthleteDetailPage(),
      binding: AthleteDetailBinding(),
    ),
    GetPage(
      name: MyRoutes.featured,
      page: () => FeaturedPage(),
      binding: FeaturedBinding(),
    ),
  ];
}
