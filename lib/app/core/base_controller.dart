import 'package:get/get.dart';
import 'package:nocvla_admin/data/repositories/athlete_repo.dart';
import 'package:nocvla_admin/data/repositories/products_repo.dart';

class BaseController extends GetxController {
  ProductsRepo productsRepo = ProductsRepo();
  AthleteRepo athleteRepo = AthleteRepo();
}
