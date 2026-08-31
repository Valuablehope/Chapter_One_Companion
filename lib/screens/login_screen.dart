import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../services/mobile_companion_api.dart';
import '../services/session_store.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeId = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _waitingForDesktop = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    SessionStore.storeId().then((saved) {
      if (saved != null && mounted) _storeId.text = saved;
    });
  }

  @override
  void dispose() {
    _storeId.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _waitingForDesktop = false;
      _error = null;
    });

    try {
      final result = await MobileCompanionApi.login(
        storeId: _storeId.text.trim(),
        username: _username.text.trim(),
        password: _password.text,
        onWaiting: () {
          if (mounted) setState(() => _waitingForDesktop = true);
        },
      );

      if (!mounted) return;

      if (!result.approved) {
        setState(() {
          _loading = false;
          _waitingForDesktop = false;
          _error = result.errorMessage;
        });
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _waitingForDesktop = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _waitingForDesktop = false;
        _error = 'Could not reach the activation server. Check your internet connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: colors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: AppShadows.brand,
                    ),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(child: Text('Chapter One', style: AppTextStyles.h1.copyWith(fontFamily: AppTextStyles.splashTitle.fontFamily))),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Sign in to your POS companion',
                    style: AppTextStyles.body.copyWith(color: colors.navMuted),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Store ID', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _storeId,
                        style: AppTextStyles.body,
                        decoration: const InputDecoration(
                          hintText: 'Found in Chapter One desktop → Settings',
                          prefixIcon: HeroIcon(HeroIcons.buildingStorefront, size: 20),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Store ID is required' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Username', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _username,
                        style: AppTextStyles.body,
                        decoration: const InputDecoration(
                          hintText: 'Enter your username',
                          prefixIcon: HeroIcon(HeroIcons.user, size: 20),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Username is required' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Password', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const HeroIcon(HeroIcons.lockClosed, size: 20),
                          suffixIcon: IconButton(
                            icon: HeroIcon(_obscure ? HeroIcons.eye : HeroIcons.eyeSlash, size: 20),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(_error!, style: AppTextStyles.small(context).copyWith(color: Colors.red)),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                      if (_waitingForDesktop) ...[
                        const SizedBox(height: AppSpacing.md),
                        Center(
                          child: Text(
                            'Waiting for your Chapter One desktop app to approve this login…',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.small(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    'Professional · Secure · Efficient',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
