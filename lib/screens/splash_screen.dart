import 'package:flutter/material.dart';
import '../services/session_store.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    final session = await SessionStore.loadSession();
    // Not a real auth check -- just avoids re-prompting for a session that's
    // obviously stale. /mobile/dashboard still enforces this server-side and
    // bounces to login on a 401 regardless of what's cached locally.
    final hasLikelyValidSession = session != null && !session.isExpired;

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => hasLikelyValidSession ? const MainShell() : const LoginScreen(),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.brandGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.onBrandOverlay,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 24),
                Text('Chapter One', style: AppTextStyles.splashTitle.copyWith(color: colors.onBrandFg)),
                const SizedBox(height: 6),
                Text(
                  'POS Companion',
                  style: AppTextStyles.body.copyWith(color: colors.onBrandFgMuted),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(colors.onBrandFg.withValues(alpha: 0.85)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
