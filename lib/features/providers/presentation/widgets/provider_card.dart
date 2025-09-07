import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import '../../domain/entities/provider_entity.dart';

class ProviderCard extends StatelessWidget {
  final ProviderEntity provider;
  final VoidCallback? onTap;

  const ProviderCard({super.key, required this.provider, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ??
            () {
              Navigator.pushNamed(
                context,
                '/provider_details',
                arguments: provider.id,
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Provider Avatar
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: provider.profileImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (provider.isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Provider Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Availability
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            provider.name,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: provider.isAvailable
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            provider.isAvailable
                                ? AppLocalizations.of(context)!.availableLabel
                                : AppLocalizations.of(context)!.busyLabel,
                            style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Services
                    Text(
                      provider.services.take(2).join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Location + distance/ETA
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey[500], size: 14),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            provider.location,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (provider.distanceKm != null) ...[
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(Icons.route,
                                  size: 14, color: Colors.blueGrey),
                              const SizedBox(width: 2),
                              Text(
                                '${provider.distanceKm!.toStringAsFixed(1)} km',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                        if (provider.etaMinutes != null) ...[
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: Colors.blueGrey),
                              const SizedBox(width: 2),
                              Text(
                                '${provider.etaMinutes} min',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating, Experience, and Rate
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              '${provider.rating}',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              ' (${provider.reviewCount})',
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        // Experience
                        Text(
                          '${provider.experienceYears}y exp',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const Spacer(),

                        // Hourly Rate
                        Text(
                          '\$${provider.hourlyRate.toStringAsFixed(0)}/hr',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
