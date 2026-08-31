import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_scope.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appThemeController.restore();
  runApp(const ChapterOneCompanionApp());
}

class ChapterOneCompanionApp extends StatelessWidget {
  const ChapterOneCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: appThemeController,
      child: AnimatedBuilder(
        animation: appThemeController,
        builder: (context, _) => MaterialApp(
          title: 'Chapter One Companion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themed(appThemeController.scheme),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
