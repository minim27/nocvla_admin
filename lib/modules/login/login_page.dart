import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/login/widgets/mobile/m_login_form.dart';
import 'package:nocvla_admin/modules/login/widgets/tab/t_login_form.dart';
import 'package:nocvla_admin/modules/login/widgets/web/login_form.dart';

import '../../shared/widgets/my_loading.dart';
import '../../shared/widgets/my_scaffold.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1280;
    final isTab = width >= 768;

    return Stack(
      children: [
        MyScaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const .all(16),
              child: isDesktop
                  ? LoginForm()
                  : isTab
                  ? TLoginForm()
                  : MLoginForm(),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isLoading.value,
            child: const MyLoading(isStack: true),
          ),
        ),
      ],
    );
  }
}
