import 'package:get/get.dart';
import 'package:nocvla_admin/modules/athlete/detail/athlete_detail_binding.dart';
import 'package:nocvla_admin/modules/athlete/detail/athlete_detail_page.dart';
import 'package:nocvla_admin/modules/athlete/list/athlete_binding.dart';
import 'package:nocvla_admin/modules/athlete/list/athlete_page.dart';
import 'package:nocvla_admin/modules/athlete_application/detail/athlete_application_detail_binding.dart';
import 'package:nocvla_admin/modules/athlete_application/detail/athlete_application_detail_page.dart';
import 'package:nocvla_admin/modules/athlete_application/list/athlete_application_binding.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_binding.dart';
import 'package:nocvla_admin/modules/dashboard/dashboard_page.dart';
import 'package:nocvla_admin/modules/early_access/early_access_binding.dart';
import 'package:nocvla_admin/modules/early_access/early_access_page.dart';
import 'package:nocvla_admin/modules/featured/featured_binding.dart';
import 'package:nocvla_admin/modules/order/order_binding.dart';
import 'package:nocvla_admin/modules/order/order_page.dart';
import 'package:nocvla_admin/modules/overview/overview_binding.dart';
import 'package:nocvla_admin/modules/overview/overview_page.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_binding.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_page.dart';
import 'package:nocvla_admin/modules/product/list/product_binding.dart';
import 'package:nocvla_admin/modules/product/list/product_page.dart';
import 'package:nocvla_admin/modules/setting/setting_binding.dart';
import 'package:nocvla_admin/modules/setting/setting_page.dart';

import 'my_routes.dart';

class MyPages {
  static final routes = [
    GetPage(
      name: MyRoutes.dashboard,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: MyRoutes.overview,
      page: () => OverviewPage(),
      binding: OverviewBinding(),
    ),
    GetPage(
      name: MyRoutes.order,
      page: () => OrderPage(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: MyRoutes.setting,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: MyRoutes.product,
      page: () => ProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: MyRoutes.productDetail,
      page: () => ProductDetailPage(),
      bindings: [DashboardBinding(), ProductDetailBinding()],
    ),
    GetPage(
      name: MyRoutes.athlete,
      page: () => AthletePage(),
      bindings: [AthleteBinding(), AthleteApplicationBinding()],
    ),
    GetPage(
      name: MyRoutes.athleteDetail,
      page: () => AthleteDetailPage(),
      bindings: [DashboardBinding(), AthleteDetailBinding()],
    ),
    GetPage(
      name: MyRoutes.athleteApplicationDetail,
      page: () => AthleteApplicationDetailPage(),
      bindings: [DashboardBinding(), AthleteApplicationDetailBinding()],
    ),
    GetPage(
      name: MyRoutes.earlyAccess,
      page: () => EarlyAccessPage(),
      bindings: [EarlyAccessBinding(), FeaturedBinding()],
    ),
  ];
}
