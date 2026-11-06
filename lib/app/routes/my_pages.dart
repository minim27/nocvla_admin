import 'package:get/get.dart';
import 'package:nocvla_admin/modules/about_content/about_content_binding.dart';
import 'package:nocvla_admin/modules/about_content/about_content_page.dart';
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
import 'package:nocvla_admin/modules/featured/featured_page.dart';
import 'package:nocvla_admin/modules/home_content/home_content_binding.dart';
import 'package:nocvla_admin/modules/home_content/home_hero_page.dart';
import 'package:nocvla_admin/modules/home_content/home_series_page.dart';
import 'package:nocvla_admin/modules/featured/featured_binding.dart';
import 'package:nocvla_admin/modules/login/login_binding.dart';
import 'package:nocvla_admin/modules/login/login_page.dart';
import 'package:nocvla_admin/modules/master_data/master_data_binding.dart';
import 'package:nocvla_admin/modules/master_data/master_data_page.dart';
import 'package:nocvla_admin/modules/master_data/training_focus_page.dart';
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

import 'my_middleware.dart';
import 'my_routes.dart';

class MyPages {
  static final routes = [
    GetPage(
      name: MyRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.dashboard,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.overview,
      page: () => OverviewPage(),
      binding: OverviewBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.order,
      page: () => OrderPage(),
      binding: OrderBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.masterData,
      page: () => MasterDataPage(),
      binding: MasterDataBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.masterDataFocus,
      page: () => TrainingFocusPage(),
      binding: MasterDataBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.setting,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.product,
      page: () => ProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.productDetail,
      page: () => ProductDetailPage(),
      bindings: [DashboardBinding(), ProductDetailBinding()],
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.athlete,
      page: () => AthletePage(),
      bindings: [AthleteBinding(), AthleteApplicationBinding()],
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.athleteDetail,
      page: () => AthleteDetailPage(),
      bindings: [DashboardBinding(), AthleteDetailBinding()],
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.athleteApplicationDetail,
      page: () => AthleteApplicationDetailPage(),
      bindings: [DashboardBinding(), AthleteApplicationDetailBinding()],
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.earlyAccess,
      page: () => EarlyAccessPage(),
      binding: EarlyAccessBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.contentHero,
      page: () => HomeHeroPage(),
      binding: HomeContentBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.contentFeatured,
      page: () => FeaturedPage(),
      binding: FeaturedBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.contentSeries,
      page: () => HomeSeriesPage(),
      binding: HomeContentBinding(),
    ),
    GetPage(
      middlewares: [MyAuthMiddleware()],
      name: MyRoutes.contentAbout,
      page: () => AboutContentPage(),
      binding: AboutContentBinding(),
    ),
  ];
}
