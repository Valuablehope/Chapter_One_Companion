import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_snapshot.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/section_header.dart';
import '../widgets/snapshot_view.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      body: SafeArea(
        child: SnapshotView(builder: _buildContent),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardSnapshot snapshot) {
    final colors = context.colors;
    final summary = snapshot.weeklySummary;
    final payments = snapshot.paymentBreakdown;
    final products = snapshot.topProductsWeek;
    final maxRevenue = summary.isEmpty
        ? 1.0
        : summary.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);
    final paymentColors = [colors.brand500, AppColors.info, AppColors.warning, AppColors.success];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const PageBanner(
          icon: HeroIcons.presentationChartBar,
          title: 'Reports',
          subtitle: 'Performance over the last 7 days',
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Revenue Trend'),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: summary.isEmpty
              ? Center(child: Text('No sales in the last 7 days.', style: AppTextStyles.small(context)))
              : BarChart(
                  BarChartData(
                    maxY: maxRevenue * 1.25,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= summary.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(DateFormat('E').format(summary[i].date), style: AppTextStyles.caption),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < summary.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: summary[i].totalRevenue,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                              color: i == summary.length - 1 ? colors.brand500 : colors.brand200,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(title: 'Payment Methods'),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: payments.isEmpty
              ? Center(child: Text('No payments in the last 7 days.', style: AppTextStyles.small(context)))
              : Row(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 32,
                          sections: [
                            for (int i = 0; i < payments.length; i++)
                              PieChartSectionData(
                                value: payments[i].share,
                                color: paymentColors[i % paymentColors.length],
                                showTitle: false,
                                radius: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < payments.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: paymentColors[i % paymentColors.length],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(payments[i].method, style: AppTextStyles.body)),
                                  Text('${(payments[i].share * 100).toStringAsFixed(0)}%', style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(title: 'Top Products'),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: products.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text('No products sold in the last 7 days.', style: AppTextStyles.small(context)),
                )
              : Column(
                  children: [
                    for (int i = 0; i < products.length; i++)
                      Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 0),
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: colors.brand50,
                              child: Text('${i + 1}', style: AppTextStyles.caption.copyWith(color: colors.brand600)),
                            ),
                            title: Text(products[i].name, style: AppTextStyles.bodyMedium),
                            subtitle: Text('${products[i].unitsSold} units sold', style: AppTextStyles.small(context)),
                            trailing: Text(
                              NumberFormat.currency(symbol: '\$').format(products[i].revenue),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          if (i != products.length - 1) const Divider(height: 1),
                        ],
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
