import 'package:flutter_test/flutter_test.dart';
import 'package:fix_it/features/services/presentation/bloc/services_bloc/services_bloc.dart';

void main() {
  group('ServicesBloc filter behavior', () {
    test('FilterServicesByCategoryEvent filters services by category',
        () async {
      final bloc = ServicesBloc();

      // Load initial services
      bloc.add(const LoadServicesEvent());
      // wait for loading to complete (the bloc simulates a 1s delay)
      await Future.delayed(const Duration(milliseconds: 1200));

      expect(bloc.state, isA<ServicesLoaded>());

      final loaded = bloc.state as ServicesLoaded;
      expect(loaded.services.isNotEmpty, isTrue);

      // Apply category filter
      bloc.add(const FilterServicesByCategoryEvent(category: 'Plumbing'));
      await Future.delayed(const Duration(milliseconds: 400));

      final after = bloc.state as ServicesLoaded;
      // All filtered services should have category Plumbing
      expect(after.filteredServices.every((s) => s['category'] == 'Plumbing'),
          isTrue);

      await bloc.close();
    });

    test('ApplyServiceFiltersEvent with null category returns all services',
        () async {
      final bloc = ServicesBloc();
      bloc.add(const LoadServicesEvent());
      await Future.delayed(const Duration(milliseconds: 1200));

      expect(bloc.state, isA<ServicesLoaded>());
      final loaded = bloc.state as ServicesLoaded;

      // Apply filters with null category
      bloc.add(ApplyServiceFiltersEvent(category: null, filters: {}));
      await Future.delayed(const Duration(milliseconds: 400));

      final after = bloc.state as ServicesLoaded;
      expect(after.filteredServices.length, loaded.services.length);

      await bloc.close();
    });
  });
}
