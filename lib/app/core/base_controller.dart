import 'package:get/get.dart';
import 'package:nocvla_admin/data/repositories/bank_repo.dart';
import 'package:nocvla_admin/data/repositories/colors_repo.dart';
import 'package:nocvla_admin/data/repositories/misc_repo.dart';
import 'package:nocvla_admin/data/repositories/product_repo.dart';
import 'package:nocvla_admin/data/repositories/size_repo.dart';
import 'package:nocvla_admin/data/repositories/type_repo.dart';

class BaseController extends GetxController {
  late BankRepository bankRepo = BankRepository();
  late ColorsRepository colorsRepo = ColorsRepository();
  late SizeRepository sizeRepo = SizeRepository();
  late TypeRepository typeRepo = TypeRepository();
  late MiscRepository miscRepo = MiscRepository();
  late ProductRepository productRepo = ProductRepository();
}
