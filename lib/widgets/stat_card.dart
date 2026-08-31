import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final HeroIcons icon;
  final Color? accent;
  final String? delta;
  final bool deltaPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
    this.delta,
    this.deltaPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedAccent = accent ?? context.colors.brand500;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: resolvedAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: HeroIcon(icon, size: 18, color: resolvedAccent),
              ),
              if (delta != null)
                Row(
                  children: [
                    HeroIcon(
                      deltaPositive ? HeroIcons.arrowUp : HeroIcons.arrowDown,
                      size: 12,
                      color: deltaPositive ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      delta!,
                      style: AppTextStyles.caption.copyWith(
                        color: deltaPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTextStyles.statValue),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.statLabel(context)),
        ],
      ),
    );
  }
}
