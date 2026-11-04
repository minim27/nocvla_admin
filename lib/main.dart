import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/my_pages.dart';
import 'app/routes/my_routes.dart';
import 'app/services/my_config.dart';
import 'shared/utils/my_colors.dart';
import 'shared/utils/my_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  await Supabase.initialize(
    url: MyConfig.apiUrl,
    publishableKey: MyConfig.supabaseKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: MyFonts.archivo,
        colorScheme: const .dark(
          primary: MyColors.secondary,
          onPrimary: MyColors.primary,
          secondary: MyColors.secondary,
          onSecondary: MyColors.primary,
          surface: MyColors.primary90,
          onSurface: MyColors.secondary,
          error: MyColors.redText,
        ),
        scaffoldBackgroundColor: MyColors.primary,
        dividerTheme: const DividerThemeData(color: MyColors.line),
        dialogTheme: const DialogThemeData(
          backgroundColor: MyColors.primary90,
          surfaceTintColor: MyColors.primary90,
          shape: RoundedRectangleBorder(),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MyColors.secondary,
          selectionColor: MyColors.red.withValues(alpha: 0.4),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: MyColors.primary,
          surfaceTintColor: MyColors.primary,
          foregroundColor: MyColors.secondary,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: MyColors.primary,
          surfaceTintColor: MyColors.primary,
        ),
      ),
      initialRoute: MyRoutes.dashboard,
      getPages: MyPages.routes,
    );
  }
}
