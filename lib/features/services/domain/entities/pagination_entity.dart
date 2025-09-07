
/// Entity for pagination information
class PaginationEntity {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginationEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginationEntity.fromJson(Map<String, dynamic> json) {
    return PaginationEntity(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  PaginationEntity copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return PaginationEntity(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
