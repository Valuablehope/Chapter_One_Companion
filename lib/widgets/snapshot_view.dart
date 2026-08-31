import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../models/dashboard_snapshot.dart';
import '../screens/login_screen.dart';
import '../services/mobile_companion_api.dart';
import '../services/session_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';

/// Loads the store's dashboard snapshot and hands it to [builder], with
/// pull-to-refresh and the same loading/error/session-expiry handling used
/// across every screen that reads it (Dashboard, Sales, Inventory, Reports).
class SnapshotView extends StatefulWidget {
  final Widget Function(BuildContext context, DashboardSnapshot snapshot) builder;

  const SnapshotView({super.key, required this.builder});

  @override
  State<SnapshotView> createState() => _SnapshotViewState();
}

class _SnapshotViewState extends State<SnapshotView> {
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

    setState(() => _error = null);

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
    return RefreshIndicator(
      onRefresh: _load,
      child: _loading
          ? ListView(
              children: const [
                SizedBox(height: 240),
                Center(child: CircularProgressIndicator()),
              ],
            )
          : _error != null
              ? ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [_ErrorBanner(message: _error!)],
                )
              : widget.builder(context, _snapshot!),
    );
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
