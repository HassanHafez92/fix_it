import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/time_slot_entity.dart';

part 'time_slot_model.g.dart';

@JsonSerializable()
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
