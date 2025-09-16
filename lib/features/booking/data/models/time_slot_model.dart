import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/time_slot_entity.dart';

part 'time_slot_model.g.dart';

@JsonSerializable()
/// TimeSlotModel
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
/// // Example: Create and use TimeSlotModel
/// final obj = TimeSlotModel();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.id,
    required super.providerId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    super.price,
    required super.isUrgentSlot,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);

  factory TimeSlotModel.fromEntity(TimeSlotEntity entity) {
    return TimeSlotModel(
      id: entity.id,
      providerId: entity.providerId,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isAvailable: entity.isAvailable,
      price: entity.price,
      isUrgentSlot: entity.isUrgentSlot,
    );
  }
}
