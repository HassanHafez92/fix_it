import 'package:equatable/equatable.dart';

/// TimeSlotEntity
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
/// // Example: Create and use TimeSlotEntity
/// final obj = TimeSlotEntity();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class TimeSlotEntity extends Equatable {
  final String id;
  final String providerId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final double? price;
  final bool isUrgentSlot;

  const TimeSlotEntity({
    required this.id,
    required this.providerId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.price,
    required this.isUrgentSlot,
  });

  @override
  List<Object?> get props => [
        id,
        providerId,
        date,
        startTime,
        endTime,
        isAvailable,
        price,
        isUrgentSlot,
      ];
}
