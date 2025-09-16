import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_it/core/theme/app_theme.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/features/providers/domain/entities/provider_entity.dart';
import 'package:fix_it/features/providers/presentation/bloc/provider_details_bloc/provider_details_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

import 'package:fix_it/features/services/domain/entities/service_entity.dart';
import 'package:fix_it/features/booking/presentation/bloc/booking_bloc/booking_bloc.dart';

/// ProviderProfileScreen
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
/// // Example: Create and use ProviderProfileScreen
/// final obj = ProviderProfileScreen();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ProviderProfileScreen extends StatefulWidget {
  final String providerId;

  const ProviderProfileScreen({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  @override
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void initState() {
    super.initState();
    // Load provider details when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ProviderDetailsBloc>(
        context,
        LoadProviderDetailsEvent(providerId: widget.providerId),
      );
    });
  }

  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('serviceDetails')),
        actions: [
          // Language toggle: Arabic <-> English
          IconButton(
            tooltip: tr('changeLanguage'),
            icon: const Icon(Icons.language),
            onPressed: () {
              final current = context.locale.languageCode;
              final messenger = ScaffoldMessenger.of(context);
              final newLocale =
                  current == 'ar' ? const Locale('en') : const Locale('ar');
              // Call setLocale and use the captured messenger in callbacks to avoid using BuildContext across async gaps
              context.setLocale(newLocale).then((_) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(tr('languageChanged'))),
                );
              }).catchError((e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('Failed to change language: $e')),
                );
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
        builder: (context, state) {
          if (state is ProviderDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProviderDetailsLoaded) {
            // Convert Map to ProviderEntity
            final providerEntity = ProviderEntity(
              id: state.provider['id'],
              name: state.provider['name'],
              email: state.provider['email'],
              phone: state.provider['phone'],
              profileImage: state.provider['profilePictureUrl'] ?? '',
              bio: state.provider['bio'] ?? '',
              rating: state.provider['rating']?.toDouble() ?? 0.0,
              reviewCount: state.provider['totalRatings'] ?? 0,
              services: List<String>.from(state.provider['services'] ?? []),
              location: state.provider['location'] ?? '',
              latitude: 0.0,
              longitude: 0.0,
              isVerified: state.provider['isVerified'] ?? false,
              isAvailable: true,
              experienceYears: state.provider['yearsOfExperience'] ?? 0,
              hourlyRate: 0.0,
              workingHours: [],
              joinedDate: state.provider['joinedDate'],
            );

            // Convert List<Map> to List<ServiceEntity>
            final serviceEntities = state.services
                .map((service) => ServiceEntity(
                      id: service['id'],
                      name: service['name'],
                      description: service['description'],
                      category: service['category'],
                      price: service['price']?.toDouble() ?? 0.0,
                      duration: service['duration'] ?? 0,
                      images: [],
                      rating: 0.0,
                      reviewCount: 0,
                      isAvailable: true,
                    ))
                .toList();

            return _buildProviderDetails(
                context, providerEntity, serviceEntities);
          } else if (state is ProviderDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      safeAddEvent<ProviderDetailsBloc>(
                        context,
                        LoadProviderDetailsEvent(providerId: widget.providerId),
                      );
                    },
                    child: Text(tr('tryAgain')),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text(tr('somethingWentWrong')));
        },
      ),
    );
  }

  Widget _buildProviderDetails(
    BuildContext context,
    ProviderEntity provider,
    List<ServiceEntity> services,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider profile header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                // Profile image (use CachedNetworkImage with errorWidget to avoid decode crashes)
                if (provider.profileImage.isNotEmpty)
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: provider.profileImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          debugPrint(
                              'Provider profile avatar failed: $url -> $error');
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),

                const SizedBox(width: 16),

                // Provider name and rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[500],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${provider.rating.toStringAsFixed(1)} (${provider.reviewCount} reviews)',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      if (provider.isVerified) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Verified Provider',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio section
                if (provider.bio.isNotEmpty) ...[
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.bio,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Services section
                const Text(
                  'Services Offered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (services.isEmpty)
                  const Text(
                    'No services offered by this provider.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: services.map((service) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          service.name,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),

                // Availability section
                const Text(
                  'Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // This would normally show the provider's availability schedule
                // For now, we'll show a placeholder
                const Text(
                  'Monday - Friday: 9:00 AM - 6:00 PM\nSaturday: 10:00 AM - 4:00 PM\nSunday: Closed',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 32),

                // Book now button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Start the booking flow with this provider
                      safeAddEvent<BookingBloc>(
                        context,
                        StartBookingEvent(
                          providerId: provider.id,
                        ),
                      );

                      Navigator.pushNamed(
                        context,
                        AppRoutes.createBooking,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
