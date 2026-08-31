import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sale_list_tile.dart';
import '../widgets/low_stock_tile.dart';
import 'sales_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currency = NumberFormat.currency(symbol: '\$');
    final recentSales = MockData.recentSales().take(3).toList();
    final lowStock = MockData.lowStock().take(3).toList();
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 18 ? 'Good afternoon' : 'Good evening');

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => Future.delayed(const Duration(milliseconds: 600)),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              PageBanner(
                icon: HeroIcons.home,
                title: '$greeting, ${MockData.currentUser.fullName.split(' ').first}',
                subtitle: 'Here\'s how the store is doing today',
              ),
              const SizedBox(height: AppSpacing.lg),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    label: "Today's Revenue",
                    value: currency.format(MockData.todayRevenue),
                    icon: HeroIcons.currencyDollar,
                    accent: colors.brand500,
                    delta: '12%',
                  ),
                  StatCard(
                    label: 'Transactions',
                    value: '${MockData.todayTransactions}',
                    icon: HeroIcons.shoppingCart,
                    accent: AppColors.info,
                    delta: '4%',
                  ),
                  StatCard(
                    label: '7-Day Revenue',
                    value: currency.format(MockData.weekRevenue),
                    icon: HeroIcons.arrowTrendingUp,
                    accent: AppColors.success,
                    delta: '8%',
                  ),
                  StatCard(
                    label: 'Low Stock Items',
                    value: '${MockData.lowStock().length}',
                    icon: HeroIcons.exclamationTriangle,
                    accent: AppColors.warning,
                    delta: '2',
                    deltaPositive: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Recent Sales',
                action: 'View all',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SalesScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...recentSales.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SaleListTile(sale: s),
                  )),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Low Stock Alerts',
                action: 'View all',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InventoryScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...lowStock.map((i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: LowStockTile(item: i),
                  )),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
