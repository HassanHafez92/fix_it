import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_it/core/routes/app_routes.dart';

void main() {
  testWidgets('onGenerateRoute preserves name and arguments', (tester) async {
    final settings = RouteSettings(name: '/test-route', arguments: {'id': 123});
    final route = AppRoutes.onGenerateRoute(settings);

    expect(route.settings.name, '/test-route');
    expect(route.settings.arguments, isA<Map>());
    expect((route.settings.arguments as Map)['id'], 123);

    // Ensure argsAs helper returns the value when asked for Map
    final extracted = AppRoutes.argsAs<Map>(settings);
    expect(extracted, isNotNull);
    expect(extracted!['id'], 123);
  });
}
