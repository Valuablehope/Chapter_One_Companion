import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chapter_one_companion/screens/profile_screen.dart';
import 'package:chapter_one_companion/theme/app_theme.dart';
import 'package:chapter_one_companion/theme/app_themes.dart';
import 'package:chapter_one_companion/theme/theme_controller.dart';
import 'package:chapter_one_companion/theme/theme_scope.dart';
import 'package:chapter_one_companion/widgets/page_banner.dart';

Widget _wrap(ThemeController controller, Widget child) {
  return ThemeScope(
    controller: controller,
    child: AnimatedBuilder(
      animation: controller,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.themed(controller.scheme),
        home: child,
      ),
    ),
  );
}

void main() {
  testWidgets('tapping a theme swatch on Profile re-skins the app', (tester) async {
    final controller = ThemeController();
    expect(controller.id, AppThemeId.classic);

    await tester.pumpWidget(_wrap(controller, const ProfileScreen()));
    await tester.pumpAndSettle();

    // The PageBanner gradient should start out as Classic's navy-to-blue gradient.
    Container bannerContainer = tester.widget(find.descendant(
      of: find.byType(PageBanner),
      matching: find.byType(Container).first,
    ));
    LinearGradient bannerGradient = (bannerContainer.decoration as BoxDecoration).gradient as LinearGradient;
    expect(bannerGradient.colors.last, themeDefFor(AppThemeId.classic).scheme.brand500);

    // Tap the "Emerald" swatch.
    await tester.tap(find.text('Emerald'));
    await tester.pumpAndSettle();

    expect(controller.id, AppThemeId.emerald);

    // The whole app — including the already-built PageBanner — should now
    // reflect Emerald's gradient, proving the InheritedNotifier propagated
    // the change rather than requiring a fresh widget tree.
    bannerContainer = tester.widget(find.descendant(
      of: find.byType(PageBanner),
      matching: find.byType(Container).first,
    ));
    bannerGradient = (bannerContainer.decoration as BoxDecoration).gradient as LinearGradient;
    expect(bannerGradient.colors.last, themeDefFor(AppThemeId.emerald).scheme.brand500);
    expect(bannerGradient.colors.last, isNot(themeDefFor(AppThemeId.classic).scheme.brand500));

    // Tap "Blossom" — the one theme with light chrome, so on-brand text
    // flips from white to deep rose. Confirms the derived tokens (not just
    // the brand ramp) are reactive too.
    await tester.tap(find.text('Blossom'));
    await tester.pumpAndSettle();
    expect(controller.id, AppThemeId.pink);

    final titleText = tester.widget<Text>(find.descendant(
      of: find.byType(PageBanner),
      matching: find.text('Profile'),
    ));
    expect(titleText.style!.color, themeDefFor(AppThemeId.pink).scheme.onBrandFg);
    expect(titleText.style!.color, isNot(Colors.white));
  });
}
