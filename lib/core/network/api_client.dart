import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/services/data/models/service_model.dart';
import '../../features/providers/data/models/provider_model.dart';
import '../../features/providers/data/models/review_model.dart';
import '../../features/booking/data/models/booking_model.dart';
import 'models/pagination_response_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.fixit.com/api/v1")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints - Disabled in favor of Firebase Auth
  // @POST("/auth/signup")
  // Future<UserModel> signUp(@Body() Map<String, dynamic> userData);

  // @POST("/auth/signin")
  // Future<UserModel> signIn(@Body() Map<String, dynamic> credentials);

  // @POST("/auth/forgot-password")
  // Future<void> forgotPassword(@Body() Map<String, dynamic> data);

  // @POST("/auth/signout")
  // Future<void> signOut();

  // @GET("/users/me")
  // Future<UserModel> getCurrentUser();

  // @PUT("/users/me")
  // Future<UserModel> updateProfile(@Body() Map<String, dynamic> profileData);

  // @PUT("/users/me/change-password")
  // Future<void> changePassword(@Body() Map<String, dynamic> passwordData);

  // @POST("/auth/refresh-token")
  // Future<Map<String, dynamic>> refreshToken();

  // Services endpoints
  @GET("/services")
  Future<List<ServiceModel>> getServices(@Query("category") String? category);

  @GET("/services")
  Future<PaginationResponseModel> getServicesWithPagination({
    @Query("category") String? category,
    @Query("page") int page = 1,
    @Query("limit") int limit = 10,
  });

  @GET("/services/{id}")
  Future<ServiceModel> getServiceDetails(@Path("id") String serviceId);

  // Providers endpoints
  @GET("/providers")
  Future<List<ProviderModel>> searchProviders(
    @Query("search_query") String? query,
    @Query("service_id") String? serviceId,
    @Query("lat") double? latitude,
    @Query("lng") double? longitude,
    @Query("radius_km") double? radiusKm,
    @Query("min_rating") double? minRating,
    @Query("available_at") String? isoAvailableAt,
    @Query("max_price") double? maxPrice,
    @Query("sort") String? sort, // distance|rating|price
  );

  @GET("/providers/{id}")
  Future<ProviderModel> getProviderDetails(@Path("id") String providerId);

  @GET("/providers/{id}/reviews")
  Future<List<ReviewModel>> getProviderReviews(@Path("id") String providerId);

  @POST("/providers/{id}/reviews")
  Future<ReviewModel> submitProviderReview(
    @Path("id") String providerId,
    @Body() Map<String, dynamic> reviewData,
  );

  @GET("/providers/nearby")
  Future<List<ProviderModel>> getNearbyProviders(
    @Query("lat") double latitude,
    @Query("lng") double longitude,
    @Query("radius_km") double radiusKm,
  );

  @GET("/providers/featured")
  Future<List<ProviderModel>> getFeaturedProviders();

  @POST("/providers/{id}/favorite")
  Future<void> addProviderToFavorites(@Path("id") String providerId);

  @DELETE("/providers/{id}/favorite")
  Future<void> removeProviderFromFavorites(@Path("id") String providerId);

  @GET("/providers/favorites")
  Future<List<ProviderModel>> getFavoriteProviders();

  // @GET("/providers/{id}/availability")
  // Future<Map<String, dynamic>> getProviderAvailability(
  //     @Path("id") String providerId);

  // @GET("/providers/{id}/time-slots")
  // Future<List<dynamic>> getAvailableTimeSlots(
  //   @Path("id") String providerId,
  //   @Query("date") String date,
  // );

  // Bookings endpoints
  @POST("/bookings")
  Future<BookingModel> createBooking(@Body() Map<String, dynamic> bookingData);

  @GET("/bookings/me")
  Future<List<BookingModel>> getUserBookings(
    @Query("status") String? status,
    @Query("page") int? page,
    @Query("limit") int? limit,
  );

  @GET("/bookings/{id}")
  Future<BookingModel> getBookingDetails(@Path("id") String bookingId);

  @PATCH("/bookings/{id}/status")
  Future<BookingModel> updateBookingStatus(
    @Path("id") String bookingId,
    @Body() Map<String, dynamic> statusData,
  );
  // Cash flow
  @PUT("/bookings/{id}/accept")
  Future<BookingModel> providerAccept(@Path("id") String bookingId);

  @PUT("/bookings/{id}/decline")
  Future<BookingModel> providerDecline(@Path("id") String bookingId);

  @PATCH("/bookings/{id}/reschedule")
  Future<BookingModel> rescheduleBooking(
    @Path("id") String bookingId,
    @Body() Map<String, dynamic> rescheduleData,
  );

  @POST("/bookings/{id}/cancel")
  Future<void> cancelBooking(
    @Path("id") String bookingId,
    @Body() Map<String, dynamic> cancelData,
  );

  // Cash-only MVP: provider completes, client confirms completion
  @PUT("/bookings/{id}/complete")
  Future<BookingModel> providerCompleteJob(@Path("id") String bookingId);

  @PUT("/bookings/{id}/confirm-completion")
  Future<BookingModel> clientConfirmCompletion(@Path("id") String bookingId);

  // Payments endpoints
  // @POST("/payments/process")
  // Future<Map<String, dynamic>> processPayment(
  //     @Body() Map<String, dynamic> paymentData);

  // Notifications endpoints
  // @GET("/notifications/me")
  // Future<List<dynamic>> getNotifications();

  @PUT("/notifications/{id}/read")
  Future<void> markNotificationAsRead(@Path("id") String notificationId);

  // Support endpoints
  // @GET("/faqs")
  // Future<List<dynamic>> getFAQs();

  // @GET("/contact-info")
  // Future<Map<String, dynamic>> getContactInfo();
}
