import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/location.dart';
import '../../core/models/professional.dart';
import '../../core/models/service.dart';
import '../../core/services/filter_service.dart';
import '../../core/services/api_service.dart';
import '../../shared/widgets/professional_card.dart';

class ServicesListScreen extends StatefulWidget {
  final String serviceName;

  const ServicesListScreen({
    super.key,
    required this.serviceName,
  });

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  String? _selectedCityId;
  final List<City> _cities = MoroccanCities.getCities();
  List<Professional> _allProfessionals = [];
  List<Professional> _filteredProfessionals = [];
  Service? _service;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServiceAndProfessionals();
  }

  Future<void> _loadServiceAndProfessionals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger le service pour obtenir l'icône et la couleur
      final services = await ApiService.getServices();
      final matchingService = services.firstWhere(
        (s) => s.name == widget.serviceName,
        orElse: () => Service(
          id: '',
          name: widget.serviceName,
          icon: '🔧',
          description: '',
          color: '#2196F3',
        ),
      );
      
      // Charger les professionnels
      final professionals = await MockData.getProfessionalsByServiceFromApi(widget.serviceName);
      if (mounted) {
        setState(() {
          _service = matchingService;
          _allProfessionals = professionals;
          _filteredProfessionals = _allProfessionals;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      // En cas d'erreur, utiliser les données mockées
      if (mounted) {
        setState(() {
          _service = Service(
            id: '',
            name: widget.serviceName,
            icon: '🔧',
            description: '',
            color: '#2196F3',
          );
          _allProfessionals = MockData.getProfessionalsByService(widget.serviceName);
          _filteredProfessionals = _allProfessionals;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadProfessionals() async {
    try {
      final professionals = await MockData.getProfessionalsByServiceFromApi(widget.serviceName);
      if (mounted) {
        setState(() {
          _allProfessionals = professionals;
          _filteredProfessionals = _allProfessionals;
        });
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des professionnels: $e');
      if (mounted) {
        setState(() {
          _allProfessionals = MockData.getProfessionalsByService(widget.serviceName);
          _filteredProfessionals = _allProfessionals;
        });
      }
    }
  }

  void _filterByCity(String? cityId) {
    setState(() {
      _selectedCityId = cityId;
      if (cityId == null) {
        _filteredProfessionals = _allProfessionals;
      } else {
        _filteredProfessionals = FilterService.getProfessionalsByLocation(
          _allProfessionals,
          cityId,
          null,
        );
      }
    });
  }

  String get serviceName => widget.serviceName;

  @override
  Widget build(BuildContext context) {
    final serviceIcon = _service?.icon ?? '🔧';
    final serviceColor = _service?.color ?? '#2196F3';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  serviceIcon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(serviceName),
            ),
          ],
        ),
        backgroundColor: Color(int.parse(serviceColor.replaceAll('#', '0xFF'))),
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section des filtres de localisation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filtrer par localisation',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    if (_selectedCityId != null) ...[
                      const Spacer(),
                      TextButton(
                        onPressed: () => _filterByCity(null),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Effacer',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCityChip(context, null, 'Toutes les villes'),
                      ..._cities.map((city) => _buildCityChip(
                            context,
                            city.id,
                            city.name,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Liste des professionnels
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredProfessionals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun professionnel trouvé',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedCityId != null
                                  ? 'Essayez une autre localisation'
                                  : 'Veuillez réessayer plus tard',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            if (_selectedCityId != null) ...[
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _filterByCity(null),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                ),
                                child: const Text('Réinitialiser les filtres'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProfessionals,
                        child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredProfessionals.length,
                          itemBuilder: (context, index) {
                            return ProfessionalCard(
                              professional: _filteredProfessionals[index],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityChip(BuildContext context, String? cityId, String label) {
    final isSelected = _selectedCityId == cityId;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          _filterByCity(cityId);
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
            ),
    );
  }
}

