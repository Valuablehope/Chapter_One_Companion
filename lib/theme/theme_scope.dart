import 'package:flutter/widgets.dart';
import 'app_color_scheme.dart';
import 'theme_controller.dart';

/// Makes the live [ThemeController] available to descendants and rebuilds
/// any widget that reads `context.colors` whenever the active theme changes
/// — regardless of where that widget sits in the navigation stack.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope.of() called with no ThemeScope ancestor');
    return scope!.notifier!;
  }
}

extension ThemeScopeContext on BuildContext {
  /// The color tokens that vary by theme (brand ramp, nav chrome, gradients).
  /// Tokens that never vary (status colors, text/border colors) stay on
  /// [AppColors] and don't need a BuildContext.
  AppColorScheme get colors => ThemeScope.of(this).scheme;
}
