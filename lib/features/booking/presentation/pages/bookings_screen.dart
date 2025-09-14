import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fix_it/core/utils/app_routes.dart';

import '../../domain/entities/booking_entity.dart';
import '../bloc/bookings_bloc.dart';
import '../../../../core/utils/bloc_utils.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_status_filter.dart';

/// BookingsScreen
///
/// Displays the current user's bookings with status filtering and
/// navigation to booking details or booking creation.
///
/// Business Rules:
/// - Loads user bookings on init via the BookingsBloc.
/// - Provides a status filter that narrows the displayed bookings.
/// - Navigates to booking details when a booking item is tapped.
///
/// Example:
/// ```dart
/// BookingsScreen();
/// ```
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  BookingStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          tr('myBookings'),
          style: GoogleFonts.cairo(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.primaryColor),
            onPressed: () {
              safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter
          BookingStatusFilter(
            selectedStatus: selectedStatus,
            onStatusChanged: (status) {
              setState(() {
                selectedStatus = status;
              });
              safeAddEvent<BookingsBloc>(
                  context, FilterBookingsEvent(status: status));
            },
          ),

          // Bookings List
          Expanded(
            child: BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, state) {
                if (state is BookingsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingsLoaded ||
                    state is BookingsFiltered) {
                  final bookings = state is BookingsLoaded
                      ? state.bookings
                      : (state as BookingsFiltered).bookings;
                  return _buildBookingsList(bookings);
                } else if (state is BookingsError) {
                  return _buildErrorWidget(state.message);
                } else if (state is BookingCancelling) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingCancelError) {
                  return _buildErrorWidget(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createBooking);
        },
        label: Text(tr('newBooking')),
        icon: const Icon(Icons.add),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildBookingsList(List<BookingEntity> bookings) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(
            booking: bookings[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.bookingDetails,
                arguments: bookings[index].id,
              );
            },
            onCancel: (bookingId, reason) {
              safeAddEvent<BookingsBloc>(
                context,
                CancelBookingEvent(bookingId: bookingId, reason: reason),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedStatus != null
                ? Icons.filter_list_off
                : Icons.calendar_today,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            selectedStatus != null
                ? 'No ${_getStatusDisplayName(selectedStatus!)} bookings'
                : 'No bookings yet',
            style: GoogleFonts.cairo(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedStatus != null
                ? 'Try changing the filter or create a new booking'
                : 'Book your first service to get started',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (selectedStatus != null)
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                });
                safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
              },
              child: const Text('Clear Filter'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createBooking);
              },
              child: const Text('Book a Service'),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
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
            'Oops! Something went wrong',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
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
              safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.inProgress:
        return 'in progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.rescheduled:
        return 'rescheduled';
    }
  }
}
