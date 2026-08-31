import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color_scheme.dart';
import 'app_themes.dart';

/// Runtime theme switching, mirroring the mother app's `useTheme.ts`
/// (persisted under the same `pos-theme` key, just in SharedPreferences
/// instead of localStorage).
class ThemeController extends ChangeNotifier {
  static const _prefsKey = 'pos-theme';

  AppThemeId _id = AppThemeId.classic;

  AppThemeId get id => _id;
  AppColorScheme get scheme => themeDefFor(_id).scheme;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    final match = AppThemeId.values.where((e) => e.name == saved);
    if (match.isNotEmpty && match.first != _id) {
      _id = match.first;
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeId id) async {
    if (id == _id) return;
    _id = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, id.name);
  }
}

/// Single app-wide instance — the companion app has no auth/DI layer to
/// thread a theme service through, so this mirrors the mother app's single
/// module-level `applyTheme()`/`getStoredTheme()` pair in `useTheme.ts`.
final appThemeController = ThemeController();
