import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;

/// Safely add an [event] to a bloc of type [T].
///
/// This helper attempts to call `context.read<T>().add(event)`. If the
/// provider isn't available yet (for example when called from `initState()`),
/// it defers the call to a post-frame callback and finally falls back to the
/// DI container (`di.sl`) if available.
void safeAddEvent<T>(BuildContext context, dynamic event) {
  try {
    final bloc = context.read<T>();
    if (bloc is Bloc) {
      (bloc as Bloc).add(event);
      return;
    }
    // Try dynamic add for non-Bloc types exposing an `add` method
    try {
      (bloc as dynamic).add(event);
      return;
    } catch (_) {}
  } catch (_) {
    // fallthrough to deferred attempt
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      final bloc = context.read<T>();
      if (bloc is Bloc) {
        (bloc as Bloc).add(event);
        return;
      }
      try {
        (bloc as dynamic).add(event);
        return;
      } catch (_) {}
    } catch (_) {
      // last-resort: try resolving from DI
      try {
        // Resolve from DI as a last resort. Use dynamic to avoid generic bounds
        final dynamic sl = di.sl;
        dynamic bloc;
        try {
          bloc = sl<T>();
        } catch (_) {
          try {
            bloc = sl.get<T>();
          } catch (_) {
            // Try with instance name for special cases like localBloc
            try {
              bloc = sl<T>(instanceName: 'localBloc');
            } catch (_) {
              bloc = null;
            }
          }
        }

        if (bloc != null) {
          try {
            (bloc as dynamic).add(event);
          } catch (_) {}
        }
      } catch (_) {}
    }
  });
}
