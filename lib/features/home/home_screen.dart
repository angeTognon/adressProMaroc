import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/locale/app_localizations.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/location.dart';
import '../../core/models/professional.dart';
import '../../core/models/service.dart';
import '../../core/utils/preferences_helper.dart';
import '../../core/services/filter_service.dart';
import '../../features/filter/models/filter_model.dart';
import '../../features/filter/filter_screen.dart';
import '../../shared/widgets/service_card.dart';
import '../../shared/widgets/professional_card.dart';
import '../../shared/widgets/language_floating_button.dart';
import '../services/services_list_screen.dart';
import '../auth/login_screen.dart';
import '../booking/my_bookings_screen.dart';
import '../legal/privacy_policy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isGuest = false;
  FilterModel _currentFilter = FilterModel();
  List<Professional> _filteredProfessionals = [];
  List<Service> _allServices = [];
  List<Service> _searchSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
    _loadProfessionals();
    _loadServices();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadServices() async {
    try {
      final services = await MockData.getServicesFromApi();
      if (mounted) {
        setState(() {
          _allServices = services;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des services: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
        _showSuggestions = false;
      });
    } else {
      setState(() {
        _searchSuggestions = _allServices
            .where((service) => 
                service.name.toLowerCase().contains(query) ||
                service.description.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = _searchFocusNode.hasFocus && _searchSuggestions.isNotEmpty;
      });
    }
  }

  Future<void> _checkGuestStatus() async {
    final isGuest = await PreferencesHelper.isGuest();
    setState(() {
      _isGuest = isGuest;
    });
  }

  Future<void> _loadProfessionals() async {
    try {
      final allProfessionals = await MockData.getProfessionalsFromApi(
        city: _currentFilter.city,
        available: true,
      );
      if (mounted) {
        setState(() {
          _filteredProfessionals = FilterService.filterProfessionals(
            allProfessionals,
            _currentFilter,
          );
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des professionnels: $e');
      // En cas d'erreur, utiliser les données mockées
      if (mounted) {
        final allProfessionals = MockData.getProfessionals();
        setState(() {
          _filteredProfessionals = FilterService.filterProfessionals(
            allProfessionals,
            _currentFilter,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await PreferencesHelper.clearAll();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToServicesList(String serviceName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServicesListScreen(serviceName: serviceName),
      ),
    );
  }

  void _openFilterScreen() async {
    final result = await Navigator.of(context).push<FilterModel>(
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          initialFilter: _currentFilter,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _currentFilter = result;
        _loadProfessionals();
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _currentFilter = FilterModel();
      _loadProfessionals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Utiliser FutureBuilder pour charger les services depuis l'API
    return FutureBuilder<List<Service>>(
      future: MockData.getServicesFromApi(),
      builder: (context, snapshot) {
        final services = snapshot.data ?? MockData.getServicesMock();
        final displayProfessionals = _filteredProfessionals.take(5).toList();
        
        return _buildHomeContent(context, localizations, services, displayProfessionals);
      },
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    AppLocalizations? localizations,
    List<Service> services,
    List<Professional> displayProfessionals,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('app_name') ?? 'Khadma'),
        actions: [
          // Bouton filtre
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_currentFilter.hasFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: localizations?.translate('filter') ?? 'Filtrer',
            onPressed: _openFilterScreen,
          ),
          if (_isGuest)
            IconButton(
              icon: const Icon(Icons.login),
              tooltip: localizations?.translate('login') ?? 'Se connecter',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            )
          else
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'bookings') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MyBookingsScreen(),
                    ),
                  );
                } else if (value == 'logout') {
                  _handleLogout();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'bookings',
                  child: Row(
                    children: [
                      const Icon(Icons.event_note, size: 20),
                      const SizedBox(width: 8),
                      Text(localizations?.translate('my_bookings') ?? 'Mes réservations'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, size: 20),
                      const SizedBox(width: 8),
                      Text(localizations?.translate('logout') ?? 'Déconnexion'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _loadProfessionals();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur de filtre actif
              if (_currentFilter.hasFilters)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getFilterText(localizations),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilter,
                        child: Text(
                          localizations?.translate('clear_filter') ?? 'Effacer',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              // Barre de recherche avec suggestions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: localizations?.translate('search_placeholder') ?? 'Rechercher un service...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _showSuggestions = false;
                                  });
                                  _searchFocusNode.unfocus();
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        _onSearchChanged();
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty && _searchSuggestions.isNotEmpty) {
                          _navigateToServicesList(_searchSuggestions.first.name);
                        }
                      },
                      onTap: () {
                        if (_searchController.text.isNotEmpty) {
                          setState(() {
                            _showSuggestions = true;
                          });
                        }
                      },
                    ),
                    // Suggestions de recherche
                    if (_showSuggestions && _searchSuggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _searchSuggestions.length,
                          itemBuilder: (context, index) {
                            final service = _searchSuggestions[index];
                            return ListTile(
                              leading: Text(service.icon, style: const TextStyle(fontSize: 24)),
                              title: Text(service.name),
                              subtitle: Text(
                                service.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                _searchController.clear();
                                _searchFocusNode.unfocus();
                                setState(() {
                                  _showSuggestions = false;
                                });
                                _navigateToServicesList(service.name);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // Services populaires
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations?.translate('popular_services') ?? 'Services Populaires',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      service: services[index],
                      onTap: () {
                        _navigateToServicesList(services[index].name);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Professionnels à proximité
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations?.translate('nearby_professionals') ?? 'Professionnels à Proximité',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              if (displayProfessionals.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations?.translate('no_results') ?? 'Aucun résultat',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations?.translate('no_results_message') ?? 'Aucun professionnel trouvé pour ces critères',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _clearFilter,
                        child: Text(localizations?.translate('clear_filter') ?? 'Effacer le filtre'),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayProfessionals.length,
                  itemBuilder: (context, index) {
                    return ProfessionalCard(professional: displayProfessionals[index]);
                  },
                ),
              const SizedBox(height: 32),
              // Footer avec lien politique de confidentialité
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(color: AppColors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    child: Text(
                      localizations?.translate('privacy_policy') ?? 'Politique de confidentialité',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: const LanguageFloatingButton(),
    );
  }

  String _getFilterText(AppLocalizations? localizations) {
    final parts = <String>[];
    if (_currentFilter.city != null) {
      final cities = MoroccanCities.getCities();
      final city = cities.firstWhere((c) => c.id == _currentFilter.city, orElse: () => cities.first);
      parts.add(city.name);
    }
    if (_currentFilter.district != null) {
      parts.add(_currentFilter.district!);
    }
    return parts.join(' - ');
  }
}
