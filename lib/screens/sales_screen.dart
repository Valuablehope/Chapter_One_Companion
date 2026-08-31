import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/mobile_companion_api.dart';
import '../services/session_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/sale_list_tile.dart';
import 'login_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  SaleStatus? _filter;
  String _query = '';
  List<Sale> _sales = [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = await SessionStore.loadSession();
    if (session == null) {
      _goToLogin();
      return;
    }

    setState(() => _error = null);

    try {
      final snapshot = await MobileCompanionApi.fetchDashboard(session.token);
      if (!mounted) return;
      setState(() {
        _sales = snapshot.recentSales;
        _loading = false;
      });
    } on SessionExpiredException {
      _goToLogin();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not reach the server. Check your internet connection.';
        _loading = false;
      });
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sales = _sales.where((s) {
      final matchesFilter = _filter == null || s.status == _filter;
      final matchesQuery = _query.isEmpty ||
          s.customerName.toLowerCase().contains(_query.toLowerCase()) ||
          s.receiptNumber.toLowerCase().contains(_query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    const PageBanner(
                      icon: HeroIcons.creditCard,
                      title: 'Sales',
                      subtitle: 'Track transactions across the store',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: Row(
                          children: [
                            const HeroIcon(HeroIcons.exclamationTriangle, color: AppColors.warning, size: 20),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: Text(_error!, style: AppTextStyles.small(context))),
                          ],
                        ),
                      )
                    else ...[
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
                            child: Text(
                              _sales.isEmpty ? 'No recent sales from the store yet' : 'No sales match your filters',
                              style: AppTextStyles.body.copyWith(color: context.colors.navMuted),
                            ),
                          ),
                        )
                      else
                        ...sales.map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: SaleListTile(sale: s, onTap: () => _showSaleDetail(context, s)),
                            )),
                    ],
                  ],
                ),
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
