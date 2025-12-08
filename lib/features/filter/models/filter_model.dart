class FilterModel {
  final String? city;
  final String? district;
  final String? service;
  final double? minRating;
  final double? maxPrice;

  FilterModel({
    this.city,
    this.district,
    this.service,
    this.minRating,
    this.maxPrice,
  });

  bool get hasFilters {
    return city != null ||
        district != null ||
        service != null ||
        minRating != null ||
        maxPrice != null;
  }

  FilterModel copyWith({
    String? city,
    String? district,
    String? service,
    double? minRating,
    double? maxPrice,
  }) {
    return FilterModel(
      city: city ?? this.city,
      district: district ?? this.district,
      service: service ?? this.service,
      minRating: minRating ?? this.minRating,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  FilterModel clear() {
    return FilterModel();
  }
}

