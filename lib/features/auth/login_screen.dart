import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/locale/app_localizations.dart';
import '../../core/utils/preferences_helper.dart';
import '../home/home_screen.dart';
import '../professional/auth/professional_login_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // GlobalKeys pour les showcases (focus sur les options principales)
  final GlobalKey _guestButtonKey = GlobalKey();
  final GlobalKey _professionalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }

  Future<void> _checkAndShowTutorial() async {
    final isCompleted = await PreferencesHelper.isLoginTutorialCompleted();
    if (!isCompleted && mounted) {
      // Attendre que le widget soit complètement construit
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _guestButtonKey,
          _professionalKey,
        ]);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simuler une connexion
      await Future.delayed(const Duration(seconds: 1));

      // En production, vous feriez ici l'appel API
      await PreferencesHelper.setLoggedIn(true);
      await PreferencesHelper.setUserId('user_${DateTime.now().millisecondsSinceEpoch}');
      await PreferencesHelper.setGuest(false);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _continueAsGuest() async {
    await PreferencesHelper.setLoggedIn(false);
    await PreferencesHelper.setGuest(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        '🔧',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  AppStrings.login,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour accéder à tous les services',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: AppStrings.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!value.contains('@')) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppStrings.password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter la récupération de mot de passe
                    },
                    child: Text(AppStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppColors.white),
                            ),
                          )
                        : Text(AppStrings.login),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.grey.withOpacity(0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppStrings.or,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.grey.withOpacity(0.3))),
                  ],
                ),
                const SizedBox(height: 24),
                Showcase(
                  key: _guestButtonKey,
                  title: '✨ Continuer sans compte',
                  description: 'Explorez l\'application immédiatement sans créer de compte ! Parfait pour découvrir nos services et professionnels.',
                  targetShapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  tooltipBackgroundColor: AppColors.secondary,
                  textColor: AppColors.white,
                  disposeOnTap: false,
                  onTargetClick: () {
                    ShowCaseWidget.of(context).dismiss();
                    ShowCaseWidget.of(context).startShowCase([_professionalKey]);
                  },
                  child: OutlinedButton(
                    onPressed: _continueAsGuest,
                    child: Text(AppStrings.continueAsGuest),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(AppStrings.register),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: AppColors.grey.withOpacity(0.3)),
                const SizedBox(height: 16),
                Showcase(
                  key: _professionalKey,
                  title: '🚀 Devenir Professionnel',
                  description: 'Vous êtes un professionnel ? Rejoignez-nous ! Créez votre compte professionnel et commencez à proposer vos services à des milliers de clients au Maroc.',
                  targetShapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  tooltipBackgroundColor: AppColors.accent,
                  textColor: AppColors.textPrimary,
                  disposeOnTap: true,
                  onBarrierClick: () async {
                    await PreferencesHelper.setLoginTutorialCompleted(true);
                    ShowCaseWidget.of(context).dismiss();
                  },
                  onTargetClick: () async {
                    await PreferencesHelper.setLoginTutorialCompleted(true);
                    ShowCaseWidget.of(context).dismiss();
                  },
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfessionalLoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.build, size: 20),
                    label: Text(
                      localizations?.translate('become_professional') ?? 'Devenir Professionnel',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
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
