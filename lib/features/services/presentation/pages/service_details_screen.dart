// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/services/favorites_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import '../../domain/entities/service_entity.dart';
import '../bloc/service_details_bloc.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../../core/utils/bloc_utils.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
  // Avoid reading the bloc synchronously in init; use safeAddEvent so the
  // call is deferred if the provider isn't available yet.
    final fav = await FavoritesService.getInstance();
    final isFav = fav.isFavorite(widget.serviceId);
  if (!mounted) return;
  setState(() => _isFavorite = isFav);
  // request service details
  safeAddEvent<ServiceDetailsBloc>(context, GetServiceDetailsEvent(serviceId: widget.serviceId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<ServiceDetailsBloc>(),
      child: Scaffold(
        body: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
          builder: (context, state) {
            if (state is ServiceDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceDetailsLoaded) {
              return _buildServiceDetails(context, state.service);
            } else if (state is ServiceDetailsError) {
              return _buildErrorWidget(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildServiceDetails(BuildContext context, ServiceEntity service) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: theme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: service.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: service.images.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.build, size: 64),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.build, size: 64),
                  ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () async {
                final fav = await FavoritesService.getInstance();
                await fav.toggleFavorite(widget.serviceId);
                if (mounted) setState(() => _isFavorite = !_isFavorite);
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final uri = Uri.base;
                  final shareUrl =
                      uri.resolve('/service/${service.id}').toString();
                  final firstImage =
                      service.images.isNotEmpty ? service.images.first : null;
                  final buffer = StringBuffer()
                    ..writeln(service.name)
                    ..writeln()
                    ..writeln(service.description)
                    ..writeln()
                    ..writeln('Book: $shareUrl');
                  if (firstImage != null) buffer.writeln(firstImage);

                  await Share.share(buffer.toString(), subject: service.name);
                } catch (e) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Could not share service')),
                  );
                }
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Name and Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        service.isAvailable
                            ? AppLocalizations.of(context)!.available
                            : AppLocalizations.of(context)!.unavailable,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${service.rating}',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${service.reviewCount} reviews)',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price and Duration
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.price,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '\$${service.price.toStringAsFixed(2)}',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.duration,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${service.duration} mins',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  AppLocalizations.of(context)!.descriptionLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  service.description,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Category
                Row(
                  children: [
                    Icon(Icons.category, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!
                          .categoryLabel(service.category),
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Images Gallery
                if (service.images.length > 1) ...[
                  Text(
                    AppLocalizations.of(context)!.gallery,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: service.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: service.images[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Book Now Button
                CustomButton(
                  text: AppLocalizations.of(context)!.bookNow,
                  onPressed: service.isAvailable
                      ? () {
                          Navigator.pushNamed(
                            context,
                            '/book_service',
                            arguments: service.id,
                          );
                        }
                      : () {},
                ),

                const SizedBox(height: 16),

                // Contact Provider Button
                CustomButton(
                  text: AppLocalizations.of(context)!.contactProvider,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/provider_contact',
                      arguments: service.id,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  textColor: theme.primaryColor,
                  borderColor: theme.primaryColor,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.serviceDetails),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingService,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                safeAddEvent<ServiceDetailsBloc>(
                  context,
                  GetServiceDetailsEvent(serviceId: widget.serviceId),
                );
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
