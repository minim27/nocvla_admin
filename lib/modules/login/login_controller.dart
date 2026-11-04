import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/app/routes/my_routes.dart';

import '../../app/core/base_controller.dart';
import '../../shared/utils/my_utility.dart';

class LoginController extends BaseController {
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    if (isLoading.value) return;

    if (txtEmail.text.trim().isEmpty || txtPassword.text.isEmpty) {
      return showErrSnackbar(msg: "Email dan kata sandi wajib diisi");
    }

    isLoading.value = true;
    var hasError = false;

    final req = await authRepo.signIn(
      email: txtEmail.text.trim(),
      password: txtPassword.text,
    );
    await req.responseHandler(
      res: (res) {},
      err: (err) {
        hasError = true;
        showErrSnackbar(
          msg: "$err".contains("Invalid login")
              ? "Email atau kata sandi salah"
              : err,
        );
      },
    );

    if (!hasError && !authRepo.isAdmin) {
      hasError = true;
      final reqSignOut = await authRepo.signOut();
      await reqSignOut.responseHandler(res: (res) {}, err: (err) {});
      showErrSnackbar(msg: "Akun ini tidak punya akses admin");
    }

    isLoading.value = false;

    if (hasError) return;

    txtPassword.clear();
    Get.offAllNamed(MyRoutes.dashboard);
  }
}
