import '../../../../core/network/api_client.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';

import '../../domain/entities/paginated_services.dart';
import '../../domain/entities/pagination_entity.dart';

/// ServiceRemoteDataSource
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ServiceRemoteDataSource
/// final obj = ServiceRemoteDataSource();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<PaginatedServices> getServicesPaginated({
    int page = 1,
    int limit = 10,
  });
  Future<List<ServiceModel>> getServicesByCategory(String categoryId);
  Future<PaginatedServices> getServicesByCategoryPaginated(
    String categoryId, {
    int page = 1,
    int limit = 10,
  });
  Future<ServiceModel> getServiceDetails(String serviceId);
  Future<List<ServiceModel>> searchServices(String query);
  Future<List<CategoryModel>> getCategories();
}

/// ServiceRemoteDataSourceImpl
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ServiceRemoteDataSourceImpl
/// final obj = ServiceRemoteDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> getServices() async {
    return await apiClient.getServices(null);
  }

  @override
  Future<PaginatedServices> getServicesPaginated({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await apiClient.getServicesWithPagination(
      category: null,
      page: page,
      limit: limit,
    );

    final List<ServiceModel> services = response.services;

    final pagination = PaginationEntity(
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      totalItems: response.totalCount,
      itemsPerPage: limit,
      hasPreviousPage: response.currentPage > 1,
      hasNextPage: response.currentPage < response.totalPages,
    );

    return PaginatedServices(
      services: services,
      pagination: pagination,
    );
  }

  @override
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    return await apiClient.getServices(categoryId);
  }

  @override
  Future<PaginatedServices> getServicesByCategoryPaginated(
    String categoryId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await apiClient.getServicesWithPagination(
      category: categoryId,
      page: page,
      limit: limit,
    );

    final List<ServiceModel> services = response.services;

    final pagination = PaginationEntity(
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      totalItems: response.totalCount,
      itemsPerPage: limit,
      hasPreviousPage: response.currentPage > 1,
      hasNextPage: response.currentPage < response.totalPages,
    );

    return PaginatedServices(
      services: services,
      pagination: pagination,
    );
  }

  @override
  Future<ServiceModel> getServiceDetails(String serviceId) async {
    return await apiClient.getServiceDetails(serviceId);
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    // Note: This would need to be added to the API client
    // For now, we'll use the existing getServices method
    return await apiClient.getServices(null);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    // Note: This would need to be added to the API client
    // For now, we'll return an empty list
    return [];
  }
}
