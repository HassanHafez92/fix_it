// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/features/providers/domain/usecases/get_provider_details_usecase.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';
import 'package:intl/intl.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import '../../domain/entities/booking_entity.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_status_badge.dart';
import '../widgets/payment_status_badge.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
/// BookingDetailsScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// BookingDetailsScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => context.read<BookingsBloc>()
        ..add(GetBookingDetailsEvent(bookingId: bookingId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            if (state is BookingDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingDetailsLoaded) {
              // Show success toast if this load is after confirm-completion
              final messenger = ScaffoldMessenger.of(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final snackBar = SnackBar(
                  content: Text(l10n.bookingConfirmedSuccess),
                  behavior: SnackBarBehavior.floating,
                );
                messenger.showSnackBar(snackBar);
              });
              return _buildBookingDetails(context, state.booking);
            } else if (state is BookingDetailsError) {
              return _buildErrorWidget(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context, BookingEntity booking) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        // App Bar with Status
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          backgroundColor: theme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              l10n.bookingDetails,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BookingStatusBadge(status: booking.status),
                    PaymentStatusBadge(status: booking.paymentStatus),
                  ],
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // Share booking details via native share sheet
                final summary = StringBuffer()
                  ..writeln(l10n.bookingId(booking.id))
                  ..writeln(l10n.service(booking.serviceName))
                  ..writeln(l10n.provider(booking.providerName))
                  ..writeln(l10n.when(
                      DateFormat('EEE, MMM dd yyyy')
                          .format(booking.scheduledDate),
                      booking.timeSlot))
                  ..writeln(l10n.address(booking.address))
                  ..writeln(l10n.total(booking.totalAmount.toStringAsFixed(2)));

                // Include first attachment if available
                if (booking.attachments.isNotEmpty) {
                  summary.writeln(l10n.attachment(booking.attachments.first));
                }

                Share.share(summary.toString(), subject: l10n.bookingDetails);
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
                // Service Info Card
                _buildServiceInfoCard(context, booking),

                const SizedBox(height: 16),

                // Provider Info Card
                _buildProviderInfoCard(context, booking),

                const SizedBox(height: 16),

                // Schedule Info Card
                _buildScheduleInfoCard(context, booking),

                const SizedBox(height: 16),

                // Location Info Card
                _buildLocationInfoCard(context, booking),

                const SizedBox(height: 16),

                // Price Breakdown Card
                _buildPriceBreakdownCard(context, booking),

                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildNotesCard(context, booking),
                ],

                if (booking.attachments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAttachmentsCard(context, booking),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(context, booking),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfoCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.serviceInformation,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.build, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.serviceName,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                if (booking.isUrgent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.urgent,
                      style: GoogleFonts.cairo(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.estimatedDuration(booking.estimatedDuration.toString()),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number,
                    color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.bookingId(booking.id),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderInfoCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.serviceProvider,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: booking.providerImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.providerName,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.serviceProvider,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Fetch provider details and open phone dialer
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          final usecase = di.sl<GetProviderDetailsUseCase>();
                          final result = await usecase.call(
                              GetProviderDetailsParams(
                                  providerId: booking.providerId));
                          result.fold((failure) {
                            messenger.showSnackBar(SnackBar(
                                content:
                                    Text(l10n.couldNotFetchProviderDetails)));
                          }, (provider) async {
                            final phone = provider.phone;
                            if (phone.isNotEmpty) {
                              final tel = Uri.parse('tel:$phone');
                              if (await canLaunchUrl(tel)) {
                                await launchUrl(tel);
                              } else {
                                messenger.showSnackBar(SnackBar(
                                    content: Text(l10n.couldNotOpenDialer)));
                              }
                            } else {
                              messenger.showSnackBar(SnackBar(
                                  content:
                                      Text(l10n.providerPhoneNotAvailable)));
                            }
                          });
                        } catch (e) {
                          messenger.showSnackBar(SnackBar(
                              content:
                                  Text(l10n.couldNotFetchProviderDetails)));
                        }
                      },
                      icon: const Icon(Icons.phone, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Create chat with provider and navigate to chat list
                        final chatRepo = di.sl<ChatRepository>();
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          final result = await chatRepo.createChat(
                              otherUserId: booking.providerId);
                          result.fold((failure) {
                            messenger.showSnackBar(SnackBar(
                                content: Text(l10n.couldNotStartChat)));
                          }, (chatId) {
                            if (chatId.isNotEmpty) {
                              Navigator.pushNamed(context, AppRoutes.chat,
                                  arguments: {
                                    'chatId': chatId,
                                    'otherUserId': booking.providerId,
                                    'otherUserName': booking.providerName,
                                  });
                            } else {
                              messenger.showSnackBar(SnackBar(
                                  content: Text(l10n.couldNotStartChat)));
                            }
                          });
                        } catch (e) {
                          messenger.showSnackBar(
                              SnackBar(content: Text(l10n.couldNotStartChat)));
                        }
                      },
                      icon: const Icon(Icons.message, color: Colors.blue),
                    ),
                  ],
                ), // end inner Row (icons)
              ], // end outer Row children
            ), // end outer Row
          ], // end Column children
        ), // end Column
      ), // end Padding
    ); // end Card
  }

  Widget _buildScheduleInfoCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.schedule,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMM dd, yyyy')
                      .format(booking.scheduledDate),
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  booking.timeSlot,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.location,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    // Capture messenger before async gaps
                    final messenger = ScaffoldMessenger.of(context);

                    // Open coordinates in maps (Google Maps / Apple Maps / browser)
                    final lat = booking.latitude;
                    final lng = booking.longitude;
                    final googleMapsUrl = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                    if (await canLaunchUrl(googleMapsUrl)) {
                      await launchUrl(googleMapsUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      // fallback to geo: scheme
                      final geoUrl = Uri.parse('geo:$lat,$lng');
                      if (await canLaunchUrl(geoUrl)) {
                        await launchUrl(geoUrl);
                      } else {
                        messenger.showSnackBar(
                          SnackBar(content: Text(l10n.couldNotOpenMaps)),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.map, size: 18),
                  label: Text(l10n.viewOnMap),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.address,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.priceBreakdown,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            _buildPriceRow(context, l10n.servicePrice, booking.servicePrice),
            _buildPriceRow(context, l10n.taxes, booking.taxes),
            _buildPriceRow(context, l10n.platformFee, booking.platformFee),
            const Divider(),
            _buildPriceRow(context, l10n.totalAmount, booking.totalAmount,
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, double amount,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[isTotal ? 800 : 700],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.cairo(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[isTotal ? 800 : 700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.additionalNotes,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              booking.notes!,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.attachments,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: booking.attachments.map((attachment) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attachment, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        l10n.attachmentLabel(
                            (booking.attachments.indexOf(attachment) + 1)
                                .toString()),
                        style: GoogleFonts.cairo(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, BookingEntity booking) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (booking.status == BookingStatus.pending ||
            booking.status == BookingStatus.confirmed) ...[
          CustomButton(
            text: l10n.reschedule,
            onPressed: () async {
              // Capture context-dependent objects before awaiting to avoid
              // using BuildContext across async gaps (use_build_context_synchronously).
              final messenger = ScaffoldMessenger.of(context);
              final bookingsBloc = context.read<BookingsBloc>();

              final result = await Navigator.pushNamed(
                context,
                AppRoutes.modifyBooking,
                arguments: {'bookingId': booking.id},
              );
              if (result == true) {
                // Refresh booking details using the captured bloc to avoid using
                // BuildContext after an await
                try {
                  bookingsBloc
                      .add(GetBookingDetailsEvent(bookingId: booking.id));
                  messenger.showSnackBar(
                      SnackBar(content: Text(l10n.bookingUpdated)));
                } catch (_) {}
              }
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: l10n.cancelBooking,
            backgroundColor: Colors.red,
            onPressed: () {
              _showCancelDialog(context, booking.id);
            },
          ),
        ],
        if (booking.status == BookingStatus.completed &&
            booking.paymentStatus == PaymentStatus.pending) ...[
          // Cash flow: show confirm completion for client
          CustomButton(
            text: l10n.confirmCompletionCash,
            onPressed: () {
              safeAddEvent<BookingsBloc>(
                  context, ClientConfirmCompletionEvent(bookingId: booking.id));
            },
          ),
          const SizedBox(height: 12),
        ],
        CustomButton(
          text: l10n.contactSupport,
          backgroundColor: Colors.grey[600],
          onPressed: () {
            // Navigate to centralized contact support screen
            Navigator.pushNamed(context, AppRoutes.contactSupport);
          },
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    final reasonController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.cancelBooking,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.areYouSureCancelBooking,
              style: GoogleFonts.cairo(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: l10n.reasonForCancellation,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.keepBooking),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                safeAddEvent<BookingsBloc>(
                    context,
                    CancelBookingEvent(
                      bookingId: bookingId,
                      reason: reasonController.text.trim(),
                    ));
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.cancelBooking),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.error),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              l10n.failedToLoadBookingDetails,
              style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                safeAddEvent<BookingsBloc>(
                    context, GetBookingDetailsEvent(bookingId: bookingId));
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
