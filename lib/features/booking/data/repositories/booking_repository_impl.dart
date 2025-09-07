import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableTimeSlots({
    required String providerId,
    required DateTime date,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final timeSlots = await remoteDataSource.getAvailableTimeSlots(
          providerId: providerId,
          date: date,
        );
        await localDataSource.cacheTimeSlots(providerId, date, timeSlots);
        return Right(timeSlots);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final timeSlots =
            await localDataSource.getCachedTimeSlots(providerId, date);
        return Right(timeSlots);
      } catch (e) {
        return Left(CacheFailure('No cached time slots available'));
      }
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
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
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.createBooking(
          providerId: providerId,
          serviceId: serviceId,
          scheduledDate: scheduledDate,
          timeSlot: timeSlot,
          address: address,
          latitude: latitude,
          longitude: longitude,
          notes: notes,
          attachments: attachments,
          isUrgent: isUrgent,
        );
        await localDataSource.cacheBookingDetails(booking);
        return Right(booking);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings() async {
    if (await networkInfo.isConnected) {
      try {
        final bookings = await remoteDataSource.getUserBookings();
        await localDataSource.cacheBookings(bookings);
        return Right(bookings);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final bookings = await localDataSource.getCachedBookings();
        return Right(bookings);
      } catch (e) {
        return Left(CacheFailure('No cached bookings available'));
      }
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingDetails(
      String bookingId) async {
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.getBookingDetails(bookingId);
        await localDataSource.cacheBookingDetails(booking);
        return Right(booking);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final booking =
            await localDataSource.getCachedBookingDetails(bookingId);
        if (booking != null) {
          return Right(booking);
        } else {
          return Left(CacheFailure('No cached booking details available'));
        }
      } catch (e) {
        return Left(CacheFailure('No cached booking details available'));
      }
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
    String? reason,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.updateBookingStatus(
          bookingId: bookingId,
          status: status,
          reason: reason,
        );
        await localDataSource.cacheBookingDetails(booking);
        return Right(booking);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> rescheduleBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
    String? address,
    String? notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.rescheduleBooking(
          bookingId: bookingId,
          newDate: newDate,
          newTimeSlot: newTimeSlot,
          address: address,
          notes: notes,
        );
        await localDataSource.cacheBookingDetails(booking);
        return Right(booking);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cached = await localDataSource.getCachedBookingDetails(bookingId);
        if (cached != null) {
          final updatedModel = BookingModel(
            id: cached.id,
            userId: cached.userId,
            providerId: cached.providerId,
            serviceId: cached.serviceId,
            serviceName: cached.serviceName,
            providerName: cached.providerName,
            providerImage: cached.providerImage,
            scheduledDate: newDate,
            timeSlot: newTimeSlot,
            address: address ?? cached.address,
            latitude: cached.latitude,
            longitude: cached.longitude,
            totalAmount: cached.totalAmount,
            servicePrice: cached.servicePrice,
            taxes: cached.taxes,
            platformFee: cached.platformFee,
            status: cached.status,
            paymentStatus: cached.paymentStatus,
            notes: notes ?? cached.notes,
            cancellationReason: cached.cancellationReason,
            createdAt: cached.createdAt,
            updatedAt: DateTime.now(),
            attachments: cached.attachments,
            isUrgent: cached.isUrgent,
            estimatedDuration: cached.estimatedDuration,
          );

          await localDataSource.cacheBookingDetails(updatedModel);
          return Right(updatedModel);
        }
        return Left(NetworkFailure('No internet connection'));
      } catch (e) {
        return Left(NetworkFailure('No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelBooking(
          bookingId: bookingId,
          reason: reason,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> processPayment({
    required String bookingId,
    required String paymentMethodId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.processPayment(
          bookingId: bookingId,
          paymentMethodId: paymentMethodId,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> clientConfirmCompletion({
    required String bookingId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.clientConfirmCompletion(
          bookingId: bookingId,
        );
        await localDataSource.cacheBookingDetails(booking);
        return Right(booking);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
