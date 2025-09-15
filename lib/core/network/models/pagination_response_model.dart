import 'package:json_annotation/json_annotation.dart';

import '../../../features/services/data/models/service_model.dart';

part 'pagination_response_model.g.dart';

@JsonSerializable()

/// PaginationResponseModel
///
/// Simple wrapper for paginated service responses from the API.
///
/// Business Rules:
/// - Carries a page of [ServiceModel] objects alongside pagination
///   metadata used by the UI for paging controls.
class PaginationResponseModel {
  /// PaginationResponseModel
  ///
  /// Simple wrapper for paginated service responses from the API.
  ///
  /// Business Rules:
  /// - Carries a page of [ServiceModel] objects alongside pagination
  ///   metadata used by the UI for paging controls.
  final List<ServiceModel> services;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  PaginationResponseModel({
    required this.services,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseModelToJson(this);
}
