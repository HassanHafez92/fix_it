import 'package:json_annotation/json_annotation.dart';

import '../../../features/services/data/models/service_model.dart';

part 'pagination_response_model.g.dart';

@JsonSerializable()
class PaginationResponseModel {
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
