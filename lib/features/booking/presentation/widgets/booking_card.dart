import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/providers/domain/usecases/get_provider_details_usecase.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import '../../presentation/bloc/bookings_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/booking_entity.dart';
import 'booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onTap;
  final Function(String bookingId, String reason)? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
  });

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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Service Name and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.serviceName,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  BookingStatusBadge(status: booking.status),
                ],
              ),

              const SizedBox(height: 12),

              // Provider Info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: booking.providerImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 20),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 20),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tr('serviceProvider'),
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (booking.isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tr('urgent'),
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Schedule Info
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM dd, yyyy').format(booking.scheduledDate),
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    booking.timeSlot,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.address,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Price and Actions
              Row(
                children: [
                  Text(
                    '\$${booking.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  _buildActionButtons(context, booking),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, BookingEntity booking) {
    // use easy_localization tr() directly

    switch (booking.status) {
      case BookingStatus.pending:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _showCancelDialog(context, booking),
              child: Text(
                tr('cancel'),
                style: GoogleFonts.cairo(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final parentCtx = context;
                final messenger = ScaffoldMessenger.of(parentCtx);
                // use easy_localization tr() directly
                Navigator.pushNamed(
                  parentCtx,
                  AppRoutes.modifyBooking,
                  arguments: {'bookingId': booking.id},
                ).then((result) {
                  if (result == true) {
                    di.sl<BookingsBloc>().add(GetUserBookingsEvent());
                    messenger.showSnackBar(
                        SnackBar(content: Text(tr('bookingUpdated'))));
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(80, 32),
              ),
              child: Text(
                tr('modify'),
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );

      case BookingStatus.confirmed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _showCancelDialog(context, booking),
              child: Text(
                tr('cancel'),
                style: GoogleFonts.cairo(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                _showContactOptions(context, booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(80, 32),
              ),
              child: Text(
                tr('contactProvider'),
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );

      case BookingStatus.inProgress:
        final messenger = ScaffoldMessenger.of(context);
        final nav = Navigator.of(context);
        // use easy_localization tr() directly

        return ElevatedButton(
          onPressed: () {
            // Show a small action sheet: Track on map or Contact provider
            showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.map, color: Colors.blue),
                        title: Text(tr('trackProvider'),
                            style: GoogleFonts.cairo()),
                        onTap: () async {
                          nav.pop();
                          try {
                            final lat = booking.latitude;
                            final lng = booking.longitude;
                            if (lat != 0 && lng != 0) {
                              final uri = Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                messenger.showSnackBar(SnackBar(
                                    content: Text(tr('couldNotOpenMaps'))));
                              }
                            } else {
                              messenger.showSnackBar(SnackBar(
                                  content: Text(tr('locationNotAvailable'))));
                            }
                          } catch (e) {
                            messenger.showSnackBar(SnackBar(
                                content: Text(tr('couldNotOpenMaps'))));
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.green),
                        title: Text(tr('callProvider'),
                            style: GoogleFonts.cairo()),
                        onTap: () {
                          nav.pop();
                          _showContactOptions(context, booking);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(80, 32),
          ),
          child: Text(
            tr('track'),
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      case BookingStatus.completed:
        return ElevatedButton(
          onPressed: () {
            final parentCtx = context;
            final messenger = ScaffoldMessenger.of(parentCtx);
            Navigator.pushNamed(
              parentCtx,
              AppRoutes.review,
              arguments: {
                'providerId': booking.providerId,
                'bookingId': booking.id,
              },
            ).then((result) {
              if (result == true) {
                messenger.showSnackBar(
                    SnackBar(content: Text(tr('bookingUpdated'))));
              }
            }).catchError((_) {
              messenger.showSnackBar(
                  SnackBar(content: Text(tr('couldNotOpenReviewScreen'))));
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(80, 32),
          ),
          child: Text(
            tr('review'),
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      case BookingStatus.cancelled:
        return Text(
          tr('cancelled'),
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        );

      case BookingStatus.rescheduled:
        return Text(
          tr('rescheduled'),
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.orange[600],
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }

  void _showCancelDialog(BuildContext context, BookingEntity booking) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this booking?',
              style: GoogleFonts.cairo(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Cancellation Reason',
                hintText: 'Please provide a reason for cancellation',
                border: const OutlineInputBorder(),
                labelStyle: GoogleFonts.cairo(),
                hintStyle: GoogleFonts.cairo(),
              ),
              maxLines: 3,
              style: GoogleFonts.cairo(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              reasonController.dispose();
            },
            child: Text(
              'Keep Booking',
              style: GoogleFonts.cairo(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                Navigator.pop(context);
                onCancel?.call(booking.id, reason);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('pleaseProvideCancellationReason')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              reasonController.dispose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Cancel Booking',
              style: GoogleFonts.cairo(),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context, BookingEntity booking) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text('Call Provider', style: GoogleFonts.cairo()),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  nav.pop();
                  try {
                    final usecase = di.sl<GetProviderDetailsUseCase>();
                    final result = await usecase.call(GetProviderDetailsParams(
                        providerId: booking.providerId));
                    result.fold((failure) {
                      messenger.showSnackBar(const SnackBar(
                          content: Text('Could not fetch provider details')));
                    }, (provider) async {
                      final phone = provider.phone;
                      if (phone.isNotEmpty) {
                        final tel = Uri.parse('tel:$phone');
                        if (await canLaunchUrl(tel)) {
                          await launchUrl(tel);
                        } else {
                          messenger.showSnackBar(const SnackBar(
                              content: Text('Could not open dialer')));
                        }
                      } else {
                        messenger.showSnackBar(const SnackBar(
                            content: Text('Provider phone not available')));
                      }
                    });
                  } catch (e) {
                    messenger.showSnackBar(const SnackBar(
                        content: Text('Could not fetch provider details')));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.blue),
                title: Text('Message Provider', style: GoogleFonts.cairo()),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  nav.pop();
                  try {
                    final chatRepo = di.sl<ChatRepository>();
                    final result = await chatRepo.createChat(
                        otherUserId: booking.providerId);
                    result.fold((failure) {
                      messenger.showSnackBar(const SnackBar(
                          content: Text('Could not start chat')));
                    }, (chatId) {
                      if (chatId.isNotEmpty) {
                        nav.pushNamed(AppRoutes.chat, arguments: {
                          'chatId': chatId,
                          'otherUserId': booking.providerId,
                          'otherUserName': booking.providerName,
                        });
                      } else {
                        messenger.showSnackBar(const SnackBar(
                            content: Text('Could not start chat')));
                      }
                    });
                  } catch (e) {
                    messenger.showSnackBar(
                        const SnackBar(content: Text('Could not start chat')));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
