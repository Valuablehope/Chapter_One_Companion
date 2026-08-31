import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_snapshot.dart';
import '../services/mobile_companion_api.dart';
import '../services/session_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import '../widgets/page_banner.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_header.dart';
import '../widgets/low_stock_tile.dart';
import 'inventory_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Session? _session;
  DashboardSnapshot? _snapshot;
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
    setState(() {
      _session = session;
      _error = null;
    });

    try {
      final snapshot = await MobileCompanionApi.fetchDashboard(session.token);
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
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
    final colors = context.colors;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 18 ? 'Good afternoon' : 'Good evening');
    final firstName = (_session?.fullName ?? '').split(' ').first;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    PageBanner(
                      icon: HeroIcons.home,
                      title: firstName.isEmpty ? greeting : '$greeting, $firstName',
                      subtitle: 'Here\'s how the store is doing today',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_error != null) _ErrorBanner(message: _error!)
                    else if (_snapshot != null) ..._buildContent(context, _snapshot!),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, DashboardSnapshot snapshot) {
    final colors = context.colors;
    final currency = NumberFormat.currency(symbol: '\$');

    return [
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
            value: currency.format(snapshot.todaySalesTotal),
            icon: HeroIcons.currencyDollar,
            accent: colors.brand500,
          ),
          StatCard(
            label: 'Transactions',
            value: '${snapshot.todayTransactionCount}',
            icon: HeroIcons.shoppingCart,
            accent: AppColors.info,
          ),
          StatCard(
            label: 'Avg. Ticket',
            value: currency.format(snapshot.averageTicket),
            icon: HeroIcons.arrowTrendingUp,
            accent: AppColors.success,
          ),
          StatCard(
            label: 'Low Stock Items',
            value: '${snapshot.lowStockItems.length}',
            icon: HeroIcons.exclamationTriangle,
            accent: AppColors.warning,
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xl),
      SectionHeader(title: 'Top Products Today'),
      const SizedBox(height: AppSpacing.md),
      if (snapshot.topProducts.isEmpty)
        Text('No sales yet today.', style: AppTextStyles.small(context))
      else
        ...snapshot.topProducts.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: const BorderSide(color: AppColors.border),
                ),
                title: Text(p.name, style: AppTextStyles.bodyMedium),
                subtitle: Text('${p.unitsSold} sold', style: AppTextStyles.small(context)),
                trailing: Text(currency.format(p.revenue), style: AppTextStyles.bodyMedium),
              ),
            )),
      const SizedBox(height: AppSpacing.lg),
      SectionHeader(
        title: 'Low Stock Alerts',
        action: snapshot.lowStockItems.isEmpty ? null : 'View all',
        onAction: snapshot.lowStockItems.isEmpty
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InventoryScreen()),
                ),
      ),
      const SizedBox(height: AppSpacing.md),
      if (snapshot.lowStockItems.isEmpty)
        Text('Nothing low on stock right now.', style: AppTextStyles.small(context))
      else
        ...snapshot.lowStockItems.take(5).map((i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: LowStockTile(item: i),
            )),
      const SizedBox(height: AppSpacing.lg),
      Text(
        'Updated ${_relativeTime(snapshot.generatedAt)}',
        style: AppTextStyles.caption,
      ),
      const SizedBox(height: AppSpacing.lg),
    ];
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat.MMMd().add_jm().format(time);
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(child: Text(message, style: AppTextStyles.small(context))),
        ],
      ),
    );
  }
}
