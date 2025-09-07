import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/bloc/locale_bloc.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/core/services/text_direction_service.dart';

/// A widget that wraps its child with the correct text direction
/// This ensures consistent RTL/LTR behavior across all parts of the app
/// Use this widget in screens or components that need to ensure proper text direction
class DirectionalityWrapper extends StatelessWidget {
  final Widget child;

  const DirectionalityWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to LocaleBloc so the wrapper rebuilds when locale changes.
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        final isRTL = localeState.locale.languageCode == 'ar';
        // Keep TextDirectionService updated for any legacy consumers.
        di.sl<TextDirectionService>().setTextDirection(localeState.locale);
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child,
        );
      },
    );
  }
}

/// A builder widget that provides the current text direction to its builder
/// Useful for widgets that need to adjust their layout based on text direction
class DirectionBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, TextDirection textDirection)
      builder;

  const DirectionBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        final isRTL = localeState.locale.languageCode == 'ar';
        // Keep the service in sync
        di.sl<TextDirectionService>().setTextDirection(localeState.locale);
        return builder(context, isRTL ? TextDirection.rtl : TextDirection.ltr);
      },
    );
  }
}
