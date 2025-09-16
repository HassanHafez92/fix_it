
import 'service_entity.dart';
import 'pagination_entity.dart';

/// Entity for paginated services response
class PaginatedServices {
  final List<ServiceEntity> services;
  final PaginationEntity pagination;

  const PaginatedServices({
    required this.services,
    required this.pagination,
  });

  factory PaginatedServices.fromJson(Map<String, dynamic> json) {
    return PaginatedServices(
      services: (json['services'] as List)
          .map((service) => ServiceEntity.fromJson(service))
          .toList(),
      pagination: PaginationEntity.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((service) => service.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  PaginatedServices copyWith({
    List<ServiceEntity>? services,
    PaginationEntity? pagination,
  }) {
    return PaginatedServices(
      services: services ?? this.services,
      pagination: pagination ?? this.pagination,
    );
  }
}
