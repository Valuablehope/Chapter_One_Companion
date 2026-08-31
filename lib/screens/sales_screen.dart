import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/sale_list_tile.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  SaleStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final sales = MockData.recentSales().where((s) {
      final matchesFilter = _filter == null || s.status == _filter;
      final matchesQuery = _query.isEmpty ||
          s.customerName.toLowerCase().contains(_query.toLowerCase()) ||
          s.receiptNumber.toLowerCase().contains(_query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const PageBanner(
              icon: HeroIcons.creditCard,
              title: 'Sales',
              subtitle: 'Track transactions across the store',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search by customer or receipt #',
                prefixIcon: HeroIcon(HeroIcons.magnifyingGlass, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Paid',
                    selected: _filter == SaleStatus.paid,
                    onTap: () => setState(() => _filter = SaleStatus.paid),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Open',
                    selected: _filter == SaleStatus.open,
                    onTap: () => setState(() => _filter = SaleStatus.open),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Void',
                    selected: _filter == SaleStatus.voided,
                    onTap: () => setState(() => _filter = SaleStatus.voided),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (sales.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                child: Center(
                  child: Text('No sales match your filters', style: AppTextStyles.body.copyWith(color: context.colors.navMuted)),
                ),
              )
            else
              ...sales.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SaleListTile(sale: s, onTap: () => _showSaleDetail(context, s)),
                  )),
          ],
        ),
      ),
    );
  }

  void _showSaleDetail(BuildContext context, Sale sale) {
    final currency = NumberFormat.currency(symbol: '\$');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(sale.receiptNumber, style: AppTextStyles.h2),
            const SizedBox(height: 4),
            Text(sale.customerName, style: AppTextStyles.body.copyWith(color: sheetContext.colors.navMuted)),
            const SizedBox(height: AppSpacing.lg),
            _detailRow(sheetContext, 'Total', currency.format(sale.total)),
            _detailRow(sheetContext, 'Items', '${sale.itemCount}'),
            _detailRow(sheetContext, 'Payment method', sale.paymentMethod),
            _detailRow(sheetContext, 'Date', DateFormat('MMM d, y · h:mm a').format(sale.createdAt)),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const HeroIcon(HeroIcons.xMark, size: 18),
                label: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: context.colors.navMuted)),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final brand500 = context.colors.brand500;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? brand500 : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? brand500 : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
        ),
      ),
    );
  }
}
