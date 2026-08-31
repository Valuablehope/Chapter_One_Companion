import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';

class SaleListTile extends StatelessWidget {
  final Sale sale;
  final VoidCallback? onTap;

  const SaleListTile({super.key, required this.sale, this.onTap});

  ({Color fg, Color bg, String label}) get _statusStyle {
    switch (sale.status) {
      case SaleStatus.paid:
        return (fg: AppColors.success, bg: AppColors.successBg, label: 'Paid');
      case SaleStatus.open:
        return (fg: AppColors.warning, bg: AppColors.warningBg, label: 'Open');
      case SaleStatus.voided:
        return (fg: AppColors.error, bg: AppColors.errorBg, label: 'Void');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = _statusStyle;
    final currency = NumberFormat.currency(symbol: '\$');
    final time = DateFormat('h:mm a').format(sale.createdAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
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
              decoration: BoxDecoration(
                color: colors.brand50,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: HeroIcon(HeroIcons.receiptPercent, color: colors.brand500, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sale.customerName, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    '${sale.receiptNumber} · ${sale.itemCount} items · $time',
                    style: AppTextStyles.small(context),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currency.format(sale.total), style: AppTextStyles.bodyMedium),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: status.bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status.label,
                    style: AppTextStyles.caption.copyWith(color: status.fg),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
