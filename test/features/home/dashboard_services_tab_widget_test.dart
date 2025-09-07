import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fix_it/features/home/presentation/widgets/dashboard_services_tab.dart';
import 'package:fix_it/features/services/presentation/bloc/services_bloc/services_bloc.dart';

void main() {
  testWidgets(
      'DashboardServicesTab persists filters and dispatches ApplyServiceFiltersEvent',
      (WidgetTester tester) async {
    // Set mock shared preferences with a preselected filter
    SharedPreferences.setMockInitialValues(
        {'service_filters': 'Available Now'});

    final servicesBloc = ServicesBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ServicesBloc>.value(
          value: servicesBloc,
          child: const DashboardServicesTab(),
        ),
      ),
    );

    // Wait for initial load (ServicesBloc simulates 1s delay)
    await tester.pump(const Duration(milliseconds: 1100));

    // Use testing helper to apply filters deterministically
    final stateFinder = find.byType(DashboardServicesTab);
    expect(stateFinder, findsOneWidget);
    final dynamic state = tester.state(stateFinder);

    // Ensure persisted selection was loaded into widget state
    expect(state.testFilterSelections['Available Now'], isTrue);

    await state.testApplyFilters();

    // Allow small time for bloc to process (200ms used in bloc)
    await tester.pump(const Duration(milliseconds: 300));
    expect(servicesBloc.state, isA<ServicesLoaded>());

    await servicesBloc.close();
  });
}
