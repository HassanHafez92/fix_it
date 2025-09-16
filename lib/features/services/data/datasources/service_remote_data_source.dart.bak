import '../../../../core/network/api_client.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';

import '../../domain/entities/paginated_services.dart';
import '../../domain/entities/pagination_entity.dart';

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
