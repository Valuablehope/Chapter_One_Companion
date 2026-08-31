import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';

class LowStockTile extends StatelessWidget {
  final LowStockItem item;

  const LowStockTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final critical = item.severity <= 0.25;
    final accent = critical ? AppColors.error : AppColors.warning;
    final accentBg = critical ? AppColors.errorBg : AppColors.warningBg;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: accentBg, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: HeroIcon(HeroIcons.cube, color: accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 2),
                Text(item.sku, style: AppTextStyles.small(context)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.qtyOnHand} left',
                style: AppTextStyles.bodyMedium.copyWith(color: accent),
              ),
              const SizedBox(height: 2),
              Text('min ${item.minThreshold}', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
