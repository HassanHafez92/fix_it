import 'package:equatable/equatable.dart';

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
