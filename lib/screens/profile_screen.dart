import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_themes.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/section_header.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeThemeId = ThemeScope.of(context).id;
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const PageBanner(
              icon: HeroIcons.user,
              title: 'Profile',
              subtitle: 'Account and app preferences',
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.brand500,
                    child: Text(
                      user.fullName.substring(0, 1),
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: AppTextStyles.h3),
                        const SizedBox(height: 2),
                        Text('@${user.username}', style: AppTextStyles.small(context)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.brand50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(color: colors.brand600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Store Theme'),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  for (final themeDef in kAppThemes)
                    _themeSwatch(context, themeDef, selected: themeDef.id == activeThemeId),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _menuTile(context, HeroIcons.bell, 'Notifications'),
            _menuTile(context, HeroIcons.shieldCheck, 'Security'),
            _menuTile(context, HeroIcons.questionMarkCircle, 'Help & Support'),
            _menuTile(context, HeroIcons.informationCircle, 'About Chapter One'),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                ),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
                icon: const HeroIcon(HeroIcons.arrowRightOnRectangle, size: 18),
                label: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeSwatch(BuildContext context, AppThemeDef themeDef, {required bool selected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ThemeScope.of(context).setTheme(themeDef.id),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: themeDef.swatchMid,
                shape: BoxShape.circle,
                border: selected ? Border.all(color: AppColors.textPrimary, width: 2) : null,
              ),
              child: selected ? const HeroIcon(HeroIcons.check, color: Colors.white, size: 18) : null,
            ),
            const SizedBox(height: 6),
            Text(themeDef.name, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, HeroIcons icon, String label) {
    final navMuted = context.colors.navMuted;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: HeroIcon(icon, color: navMuted, size: 20),
        title: Text(label, style: AppTextStyles.bodyMedium),
        trailing: HeroIcon(HeroIcons.chevronRight, color: navMuted, size: 18),
      ),
    );
  }
}
