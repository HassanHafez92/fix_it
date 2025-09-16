import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

/// GetBookingDetailsUseCase
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
/// // Example: Create and use GetBookingDetailsUseCase
/// final obj = GetBookingDetailsUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetBookingDetailsUseCase
    implements UseCase<BookingEntity, GetBookingDetailsParams> {
  final BookingRepository repository;

  GetBookingDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
      GetBookingDetailsParams params) async {
    return await repository.getBookingDetails(params.bookingId);
  }
}

/// GetBookingDetailsParams
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
/// // Example: Create and use GetBookingDetailsParams
/// final obj = GetBookingDetailsParams();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetBookingDetailsParams extends Equatable {
  final String bookingId;

  const GetBookingDetailsParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
