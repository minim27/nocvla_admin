import 'package:get/get.dart';
import 'package:nocvla_admin/data/repositories/athlete_application_repo.dart';
import 'package:nocvla_admin/data/repositories/athlete_repo.dart';
import 'package:nocvla_admin/data/repositories/early_access_repo.dart';
import 'package:nocvla_admin/data/repositories/products_repo.dart';

class BaseController extends GetxController {
  ProductsRepo productsRepo = ProductsRepo();
  AthleteRepo athleteRepo = AthleteRepo();
  AthleteApplicationRepo athleteApplicationRepo = AthleteApplicationRepo();
  EarlyAccessRepo earlyAccessRepo = EarlyAccessRepo();
}
