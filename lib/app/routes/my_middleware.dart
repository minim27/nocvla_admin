import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repo.dart';
import 'my_routes.dart';

class MyAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      AuthRepo().isAdmin ? null : const RouteSettings(name: MyRoutes.login);
}
