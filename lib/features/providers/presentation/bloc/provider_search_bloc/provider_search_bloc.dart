import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'provider_search_event.dart';
part 'provider_search_state.dart';

class ProviderSearchBloc extends Bloc<ProviderSearchEvent, ProviderSearchState> {
  ProviderSearchBloc() : super(ProviderSearchInitial()) {
    on<LoadProvidersEvent>(_onLoadProviders);
    on<SearchProvidersEvent>(_onSearchProviders);
    on<FilterProvidersByServiceEvent>(_onFilterProvidersByService);
    on<FilterProvidersByLocationEvent>(_onFilterProvidersByLocation);
    on<FilterProvidersByRatingEvent>(_onFilterProvidersByRating);
  }

  void _onLoadProviders(
    LoadProvidersEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    emit(ProviderSearchLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock providers data
      final providers = [
        {
          'id': '1',
          'name': 'John Smith',
          'email': 'john.smith@example.com',
          'phone': '+1 (555) 123-4567',
          'profilePictureUrl': '',
          'bio': 'Experienced professional with over 10 years in the industry. Specialized in home repairs and maintenance.',
          'rating': 4.8,
          'totalRatings': 124,
          'totalBookings': 320,
          'yearsOfExperience': 10,
          'isVerified': true,
          'services': ['Plumbing', 'Electrical', 'HVAC'],
          'location': 'New York, NY',
          'joinedDate': DateTime(2018, 5, 15),
        },
        {
          'id': '2',
          'name': 'Sarah Johnson',
          'email': 'sarah.johnson@example.com',
          'phone': '+1 (555) 987-6543',
          'profilePictureUrl': '',
          'bio': 'Certified technician with expertise in electrical systems and home appliance repairs.',
          'rating': 4.6,
          'totalRatings': 89,
          'totalBookings': 210,
          'yearsOfExperience': 8,
          'isVerified': true,
          'services': ['Electrical', 'Appliance Repair'],
          'location': 'Brooklyn, NY',
          'joinedDate': DateTime(2019, 2, 20),
        },
        {
          'id': '3',
          'name': 'Michael Williams',
          'email': 'michael.williams@example.com',
          'phone': '+1 (555) 456-7890',
          'profilePictureUrl': '',
          'bio': 'HVAC specialist providing installation, maintenance, and repair services for all heating and cooling systems.',
          'rating': 4.9,
          'totalRatings': 156,
          'totalBookings': 410,
          'yearsOfExperience': 12,
          'isVerified': true,
          'services': ['HVAC'],
          'location': 'Queens, NY',
          'joinedDate': DateTime(2017, 8, 10),
        },
        {
          'id': '4',
          'name': 'Emily Davis',
          'email': 'emily.davis@example.com',
          'phone': '+1 (555) 234-5678',
          'profilePictureUrl': '',
          'bio': 'Professional painter offering interior and exterior painting services with attention to detail.',
          'rating': 4.7,
          'totalRatings': 67,
          'totalBookings': 180,
          'yearsOfExperience': 6,
          'isVerified': true,
          'services': ['Painting'],
          'location': 'Manhattan, NY',
          'joinedDate': DateTime(2020, 3, 5),
        },
        {
          'id': '5',
          'name': 'Robert Brown',
          'email': 'robert.brown@example.com',
          'phone': '+1 (555) 345-6789',
          'profilePictureUrl': '',
          'bio': 'Expert carpenter specializing in custom furniture, cabinets, and home renovation projects.',
          'rating': 4.5,
          'totalRatings': 92,
          'totalBookings': 230,
          'yearsOfExperience': 9,
          'isVerified': true,
          'services': ['Carpentry'],
          'location': 'Bronx, NY',
          'joinedDate': DateTime(2019, 11, 12),
        },
      ];

      // Get unique services and locations
      final services = providers
          .expand((provider) => (provider['services'] as List).cast<String>())
          .toSet()
          .toList();

      final locations = providers
          .map((provider) => provider['location'] as String)
          .toSet()
          .toList();

      emit(ProviderSearchLoaded(
        providers: providers,
        filteredProviders: providers,
        services: services,
        locations: locations,
        selectedService: null,
        selectedLocation: null,
        minRating: 0,
        searchQuery: '',
      ));
    } catch (e) {
      emit(ProviderSearchError(message: e.toString()));
    }
  }

  void _onSearchProviders(
    SearchProvidersEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    if (state is ProviderSearchLoaded) {
      final currentState = state as ProviderSearchLoaded;

      emit(ProviderSearchLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 300));

        // Filter providers based on search query
        final searchQuery = event.query.toLowerCase();
        var filteredProviders = currentState.providers.where((provider) {
          final name = provider['name'].toString().toLowerCase();
          final bio = provider['bio'].toString().toLowerCase();
          final services = (provider['services'] as List)
              .join(' ')
              .toLowerCase();

          return name.contains(searchQuery) || 
                 bio.contains(searchQuery) || 
                 services.contains(searchQuery);
        }).toList();

        // Apply existing filters
        if (currentState.selectedService != null) {
          filteredProviders = filteredProviders.where((provider) {
            return (provider['services'] as List).contains(currentState.selectedService);
          }).toList();
        }

        if (currentState.selectedLocation != null) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['location'] == currentState.selectedLocation;
          }).toList();
        }

        if (currentState.minRating > 0) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['rating'] >= currentState.minRating;
          }).toList();
        }

        emit(currentState.copyWith(
          filteredProviders: filteredProviders,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(ProviderSearchError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onFilterProvidersByService(
    FilterProvidersByServiceEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    if (state is ProviderSearchLoaded) {
      final currentState = state as ProviderSearchLoaded;

      emit(ProviderSearchLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 300));

        // Filter providers based on selected service
        var filteredProviders = currentState.providers;

        if (event.service != null && event.service != 'All') {
          filteredProviders = filteredProviders.where((provider) {
            return (provider['services'] as List).contains(event.service);
          }).toList();
        }

        // Apply existing filters
        if (currentState.searchQuery.isNotEmpty) {
          final searchQuery = currentState.searchQuery.toLowerCase();
          filteredProviders = filteredProviders.where((provider) {
            final name = provider['name'].toString().toLowerCase();
            final bio = provider['bio'].toString().toLowerCase();
            final services = (provider['services'] as List)
                .join(' ')
                .toLowerCase();

            return name.contains(searchQuery) || 
                   bio.contains(searchQuery) || 
                   services.contains(searchQuery);
          }).toList();
        }

        if (currentState.selectedLocation != null) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['location'] == currentState.selectedLocation;
          }).toList();
        }

        if (currentState.minRating > 0) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['rating'] >= currentState.minRating;
          }).toList();
        }

        emit(currentState.copyWith(
          filteredProviders: filteredProviders,
          selectedService: event.service,
        ));
      } catch (e) {
        emit(ProviderSearchError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onFilterProvidersByLocation(
    FilterProvidersByLocationEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    if (state is ProviderSearchLoaded) {
      final currentState = state as ProviderSearchLoaded;

      emit(ProviderSearchLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 300));

        // Filter providers based on selected location
        var filteredProviders = currentState.providers;

        if (event.location != null && event.location != 'All') {
          filteredProviders = filteredProviders.where((provider) {
            return provider['location'] == event.location;
          }).toList();
        }

        // Apply existing filters
        if (currentState.searchQuery.isNotEmpty) {
          final searchQuery = currentState.searchQuery.toLowerCase();
          filteredProviders = filteredProviders.where((provider) {
            final name = provider['name'].toString().toLowerCase();
            final bio = provider['bio'].toString().toLowerCase();
            final services = (provider['services'] as List)
                .join(' ')
                .toLowerCase();

            return name.contains(searchQuery) || 
                   bio.contains(searchQuery) || 
                   services.contains(searchQuery);
          }).toList();
        }

        if (currentState.selectedService != null) {
          filteredProviders = filteredProviders.where((provider) {
            return (provider['services'] as List).contains(currentState.selectedService);
          }).toList();
        }

        if (currentState.minRating > 0) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['rating'] >= currentState.minRating;
          }).toList();
        }

        emit(currentState.copyWith(
          filteredProviders: filteredProviders,
          selectedLocation: event.location,
        ));
      } catch (e) {
        emit(ProviderSearchError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onFilterProvidersByRating(
    FilterProvidersByRatingEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    if (state is ProviderSearchLoaded) {
      final currentState = state as ProviderSearchLoaded;

      emit(ProviderSearchLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 300));

        // Filter providers based on minimum rating
        var filteredProviders = currentState.providers;

        if (event.minRating > 0) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['rating'] >= event.minRating;
          }).toList();
        }

        // Apply existing filters
        if (currentState.searchQuery.isNotEmpty) {
          final searchQuery = currentState.searchQuery.toLowerCase();
          filteredProviders = filteredProviders.where((provider) {
            final name = provider['name'].toString().toLowerCase();
            final bio = provider['bio'].toString().toLowerCase();
            final services = (provider['services'] as List)
                .join(' ')
                .toLowerCase();

            return name.contains(searchQuery) || 
                   bio.contains(searchQuery) || 
                   services.contains(searchQuery);
          }).toList();
        }

        if (currentState.selectedService != null) {
          filteredProviders = filteredProviders.where((provider) {
            return (provider['services'] as List).contains(currentState.selectedService);
          }).toList();
        }

        if (currentState.selectedLocation != null) {
          filteredProviders = filteredProviders.where((provider) {
            return provider['location'] == currentState.selectedLocation;
          }).toList();
        }

        emit(currentState.copyWith(
          filteredProviders: filteredProviders,
          minRating: event.minRating,
        ));
      } catch (e) {
        emit(ProviderSearchError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
