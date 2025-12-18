import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/locale/app_localizations.dart';
import '../../../core/models/location.dart';
import '../../../core/utils/preferences_helper.dart';
import '../dashboard/professional_dashboard_screen.dart';
import 'models/professional_registration_data.dart';

class ProfessionalRegisterScreen extends StatefulWidget {
  const ProfessionalRegisterScreen({super.key});

  @override
  State<ProfessionalRegisterScreen> createState() => _ProfessionalRegisterScreenState();
}

class _ProfessionalRegisterScreenState extends State<ProfessionalRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  // Contrôleurs de formulaire
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _certificationController = TextEditingController();
  final _taxIdController = TextEditingController();

  // États
  String? _selectedService;
  String? _selectedCityId;
  String? _selectedDistrict;
  List<String> _selectedServices = [];
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasBusinessName = false;

  final List<City> _cities = MoroccanCities.getCities();
  List<String> _availableDistricts = [];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _certificationController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  void _updateDistricts() {
    if (_selectedCityId != null) {
      final city = _cities.firstWhere(
        (c) => c.id == _selectedCityId,
        orElse: () => _cities.first,
      );
      setState(() {
        _availableDistricts = city.districts;
      });
    } else {
      setState(() {
        _availableDistricts = [];
        _selectedDistrict = null;
      });
    }
  }

  bool _canContinueToNextStep() {
    switch (_currentStep) {
      case 0: // Informations personnelles
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _passwordController.text.length >= 6 &&
            _passwordController.text == _confirmPasswordController.text;
      case 1: // Informations professionnelles
        return _selectedService != null &&
            _selectedServices.isNotEmpty &&
            _addressController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty &&
            _priceController.text.isNotEmpty &&
            _selectedCityId != null;
      case 2: // Informations complémentaires
        return true; // Optionnel
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_canContinueToNextStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitRegistration();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      // TODO: Ajouter un indicateur de chargement
    });

    // Simuler l'inscription
    await Future.delayed(const Duration(seconds: 2));

    // Créer le compte professionnel
    final registrationData = ProfessionalRegistrationData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      businessName: _hasBusinessName && _businessNameController.text.isNotEmpty
          ? _businessNameController.text.trim()
          : null,
      service: _selectedService!,
      services: _selectedServices,
      city: _cities.firstWhere((c) => c.id == _selectedCityId).name,
      district: _selectedDistrict,
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
      basePrice: double.tryParse(_priceController.text) ?? 0.0,
      certificationNumber: _certificationController.text.trim().isEmpty
          ? null
          : _certificationController.text.trim(),
      taxId: _taxIdController.text.trim().isEmpty
          ? null
          : _taxIdController.text.trim(),
    );

    // Sauvegarder les données (en production, envoyer à l'API)
    await PreferencesHelper.setLoggedIn(true);
    await PreferencesHelper.setUserId('pro_${DateTime.now().millisecondsSinceEpoch}');
    await PreferencesHelper.setIsProfessional(true);

    if (!mounted) return;

    // Naviguer vers le dashboard avec un message de confirmation
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ProfessionalDashboardScreen(
          registrationData: registrationData,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('professional_registration') ?? 'Inscription Professionnel'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Indicateur de progression
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < 2 ? 8 : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Contenu
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalInfoStep(localizations),
                  _buildProfessionalInfoStep(localizations),
                  _buildAdditionalInfoStep(localizations),
                ],
              ),
            ),
            // Boutons de navigation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: Text(localizations?.translate('back') ?? 'Retour'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: _canContinueToNextStep() ? _nextStep : null,
                        child: Text(
                          _currentStep == 2
                              ? localizations?.translate('submit') ?? 'Soumettre'
                              : localizations?.translate('next') ?? 'Suivant',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep(AppLocalizations? localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.translate('personal_information') ?? 'Informations Personnelles',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('first_name') ?? 'Prénom',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('last_name') ?? 'Nom',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: localizations?.translate('email') ?? 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (!value.contains('@')) {
                return 'Email invalide';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: localizations?.translate('phone') ?? 'Téléphone',
              prefixIcon: const Icon(Icons.phone_outlined),
              hintText: '+212 6XX XXX XXX',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: localizations?.translate('password') ?? 'Mot de passe',
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
                return 'Requis';
              }
              if (value.length < 6) {
                return 'Minimum 6 caractères';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: localizations?.translate('confirm_password') ?? 'Confirmer le mot de passe',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoStep(AppLocalizations? localizations) {
    final services = [
      'Plomberie',
      'Électricité',
      'Peinture',
      'Menuiserie',
      'Nettoyage',
      'Jardinage',
      'Chauffage',
      'Climatisation',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.translate('professional_information') ?? 'Informations Professionnelles',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          // Nom d'entreprise (optionnel)
          Row(
            children: [
              Checkbox(
                value: _hasBusinessName,
                onChanged: (value) {
                  setState(() {
                    _hasBusinessName = value ?? false;
                  });
                },
              ),
              Text(localizations?.translate('has_business_name') ?? 'J\'ai un nom d\'entreprise'),
            ],
          ),
          if (_hasBusinessName) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: localizations?.translate('business_name') ?? 'Nom d\'entreprise',
                prefixIcon: const Icon(Icons.business),
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Service principal
          Text(
            localizations?.translate('main_service') ?? 'Service Principal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedService,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.build),
              hintText: 'Sélectionner un service',
            ),
            items: services.map((service) {
              return DropdownMenuItem(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedService = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Services offerts
          Text(
            localizations?.translate('services_offered') ?? 'Services Offerts',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) {
              final isSelected = _selectedServices.contains(service);
              return FilterChip(
                label: Text(service),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedServices.add(service);
                    } else {
                      _selectedServices.remove(service);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Localisation
          Text(
            localizations?.translate('location') ?? 'Localisation',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCityId,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_city),
              hintText: localizations?.translate('select_city') ?? 'Sélectionner une ville',
            ),
            items: _cities.map((city) {
              return DropdownMenuItem(
                value: city.id,
                child: Text(city.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCityId = value;
                _updateDistricts();
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              return null;
            },
          ),
          if (_selectedCityId != null && _availableDistricts.isNotEmpty) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: localizations?.translate('select_district') ?? 'Sélectionner un quartier (optionnel)',
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(localizations?.translate('all_districts') ?? 'Tous les quartiers'),
                ),
                ..._availableDistricts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDistrict = value;
                });
              },
            ),
          ],
          const SizedBox(height: 20),
          // Adresse
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: localizations?.translate('address') ?? 'Adresse complète',
              prefixIcon: const Icon(Icons.location_on),
              hintText: 'Rue, numéro, etc.',
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: localizations?.translate('description') ?? 'Description',
              prefixIcon: const Icon(Icons.description),
              hintText: 'Décrivez vos services...',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (value.length < 20) {
                return 'Minimum 20 caractères';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          // Prix de base
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: localizations?.translate('base_price') ?? 'Prix de base (MAD)',
              prefixIcon: const Icon(Icons.attach_money),
              hintText: '250',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (double.tryParse(value) == null) {
                return 'Montant invalide';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoStep(AppLocalizations? localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.translate('additional_information') ?? 'Informations Complémentaires (Optionnel)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            localizations?.translate('additional_info_note') ?? 'Ces informations faciliteront la vérification de votre compte',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _certificationController,
            decoration: InputDecoration(
              labelText: localizations?.translate('certification_number') ?? 'Numéro de certification',
              prefixIcon: const Icon(Icons.verified_user),
              hintText: 'Optionnel',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _taxIdController,
            decoration: InputDecoration(
              labelText: localizations?.translate('tax_id') ?? 'Numéro fiscal',
              prefixIcon: const Icon(Icons.receipt),
              hintText: 'Optionnel',
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: AppColors.secondary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text(
                        localizations?.translate('verification_process') ?? 'Processus de Vérification',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations?.translate('verification_info') ??
                        'Votre compte sera examiné par notre équipe. Vous recevrez une notification une fois votre compte vérifié. Cela peut prendre 24-48h.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

