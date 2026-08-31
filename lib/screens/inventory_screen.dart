import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/low_stock_tile.dart';
import '../widgets/snapshot_view.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      body: SafeArea(
        child: SnapshotView(
          builder: (context, snapshot) {
            final colors = context.colors;
            final items = snapshot.lowStockItems;
            final critical = items.where((i) => i.severity <= 0.25).length;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const PageBanner(
                  icon: HeroIcons.bookOpen,
                  title: 'Inventory',
                  subtitle: 'Items that need restocking soon',
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
                      _summaryStat(context, '${items.length}', 'Low stock', AppColors.warning),
                      Container(width: 1, height: 32, color: AppColors.border),
                      _summaryStat(context, '$critical', 'Critical', AppColors.error),
                      Container(width: 1, height: 32, color: AppColors.border),
                      _summaryStat(context, '${items.length - critical}', 'Watch', colors.brand500),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('All Alerts', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.md),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                    child: Center(
                      child: Text('Nothing low on stock right now.', style: AppTextStyles.body.copyWith(color: colors.navMuted)),
                    ),
                  )
                else
                  ...items.map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: LowStockTile(item: i),
                      )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryStat(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.statValue.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.statLabel(context)),
        ],
      ),
    );
  }
}
