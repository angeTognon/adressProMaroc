import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/locale/app_localizations.dart';
import '../../core/models/location.dart';
import 'models/filter_model.dart';

class FilterScreen extends StatefulWidget {
  final FilterModel initialFilter;

  const FilterScreen({
    super.key,
    required this.initialFilter,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterModel _currentFilter;
  String? _selectedCityId;
  String? _selectedDistrict;

  final List<City> _cities = MoroccanCities.getCities();
  List<String> _availableDistricts = [];

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _selectedCityId = _currentFilter.city;
    _selectedDistrict = _currentFilter.district;
    
    if (_selectedCityId != null) {
      _updateDistricts();
    }
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

  void _applyFilter() {
    final result = _currentFilter.copyWith(
      city: _selectedCityId,
      district: _selectedDistrict,
    );
    Navigator.of(context).pop(result);
  }

  void _clearFilter() {
    setState(() {
      _selectedCityId = null;
      _selectedDistrict = null;
      _availableDistricts = [];
      _currentFilter = FilterModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('filter_by_location') ?? 'Filtrer par localisation'),
        actions: [
          if (_selectedCityId != null || _selectedDistrict != null)
            TextButton(
              onPressed: _clearFilter,
              child: Text(
                localizations?.translate('clear_filter') ?? 'Effacer',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélection de la ville
            Text(
              localizations?.translate('select_city') ?? 'Sélectionner une ville',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCityChip(
                  context,
                  null,
                  localizations?.translate('all_cities') ?? 'Toutes les villes',
                ),
                ..._cities.map((city) => _buildCityChip(context, city.id, city.name)),
              ],
            ),
            const SizedBox(height: 24),
            // Sélection du quartier
            if (_selectedCityId != null) ...[
              Text(
                localizations?.translate('select_district') ?? 'Sélectionner un quartier',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDistrictChip(
                    context,
                    null,
                    localizations?.translate('all_districts') ?? 'Tous les quartiers',
                  ),
                  ..._availableDistricts.map((district) => _buildDistrictChip(context, district, district)),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(localizations?.translate('cancel') ?? 'Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _applyFilter,
                  child: Text(localizations?.translate('apply_filter') ?? 'Appliquer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityChip(BuildContext context, String? cityId, String label) {
    final isSelected = _selectedCityId == cityId;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCityId = selected ? cityId : null;
          _currentFilter = _currentFilter.copyWith(city: _selectedCityId);
          _updateDistricts();
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildDistrictChip(BuildContext context, String? district, String label) {
    final isSelected = _selectedDistrict == district;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDistrict = selected ? district : null;
          _currentFilter = _currentFilter.copyWith(district: _selectedDistrict);
        });
      },
      selectedColor: AppColors.secondary.withOpacity(0.2),
      checkmarkColor: AppColors.secondary,
    );
  }
}

