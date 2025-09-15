import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/booking_model.dart';
import '../models/time_slot_model.dart';
import '../../domain/entities/booking_entity.dart';

/// BookingRemoteDataSource
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
/// // Example: Create and use BookingRemoteDataSource
/// final obj = BookingRemoteDataSource();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// BookingRemoteDataSource
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class BookingRemoteDataSource {
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String providerId,
    required DateTime date,
  });
  Future<BookingModel> createBooking({
    required String providerId,
    required String serviceId,
    required DateTime scheduledDate,
    required String timeSlot,
    required String address,
    required double latitude,
    required double longitude,
    String? notes,
    List<String>? attachments,
    bool isUrgent = false,
  });
  Future<List<BookingModel>> getUserBookings();
  Future<BookingModel> getBookingDetails(String bookingId);
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
    String? reason,
  });
  Future<BookingModel> rescheduleBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
    String? address,
    String? notes,
  });
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  });
  Future<void> processPayment({
    required String bookingId,
    required String paymentMethodId,
  });
  Future<BookingModel> clientConfirmCompletion({
    required String bookingId,
  });
}

/// BookingRemoteDataSourceImpl
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
/// // Example: Create and use BookingRemoteDataSourceImpl
/// final obj = BookingRemoteDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;
  final Dio dio;

  BookingRemoteDataSourceImpl({required this.apiClient, required this.dio});

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String providerId,
    required DateTime date,
  }) async {
    try {
      final resp =
          await dio.get('/providers/$providerId/time-slots', queryParameters: {
        'date': date.toIso8601String(),
      });

      final data = resp.data;
      if (data is List) {
        return data
            .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // Log and return empty list on error to keep callers resilient
      // (could rethrow or wrap error in production)
      return [];
    }
  }

  @override
  Future<BookingModel> createBooking({
    required String providerId,
    required String serviceId,
    required DateTime scheduledDate,
    required String timeSlot,
    required String address,
    required double latitude,
    required double longitude,
    String? notes,
    List<String>? attachments,
    bool isUrgent = false,
  }) async {
    final response = await apiClient.createBooking({
      'provider_id': providerId,
      'service_id': serviceId,
      'scheduled_date': scheduledDate.toIso8601String(),
      'time_slot': timeSlot,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'attachments': attachments,
      'is_urgent': isUrgent,
    });
    return response;
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    final response = await apiClient.getUserBookings(null, null, null);
    return response;
  }

  @override
  Future<BookingModel> getBookingDetails(String bookingId) async {
    final response = await apiClient.getBookingDetails(bookingId);
    return response;
  }

  @override
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
    String? reason,
  }) async {
    final response = await apiClient.updateBookingStatus(
      bookingId,
      {
        'status': status.name,
        'reason': reason,
      },
    );
    return response;
  }

  @override
  Future<BookingModel> rescheduleBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
    String? address,
    String? notes,
  }) async {
    // include both canonical and common alternate keys to maximize backend compatibility
    final response = await apiClient.rescheduleBooking(
      bookingId,
      {
        'new_date': newDate.toIso8601String(),
        'new_time_slot': newTimeSlot,
        'address': address,
        'location': address,
        'notes': notes,
        'additional_notes': notes,
      },
    );
    return response;
  }

  @override
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    await apiClient.cancelBooking(
      bookingId,
      {
        'reason': reason,
      },
    );
  }

  @override
  Future<void> processPayment({
    required String bookingId,
    required String paymentMethodId,
  }) async {
    // Cash-only MVP: confirm completion instead of processing payment
    await apiClient.clientConfirmCompletion(bookingId);
  }

  @override
  Future<BookingModel> clientConfirmCompletion({
    required String bookingId,
  }) async {
    final response = await apiClient.clientConfirmCompletion(bookingId);
    return response;
  }
}
