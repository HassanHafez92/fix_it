// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/l10n/app_localizations.dart';
import '../../../booking/presentation/bloc/bookings_bloc.dart';
import '../../../booking/presentation/widgets/booking_card.dart';
import '../../../booking/presentation/widgets/booking_status_filter.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../../../core/services/analytics_service.dart';

/// Bookings tab of the main dashboard.
///
/// This widget displays and manages a user's bookings. It is intentionally
/// defensive about how it obtains the required [BookingsBloc] because the
/// bookings UI can be used in multiple contexts (main tab, modal sheet,
/// calendar view). To avoid runtime crashes when the provider is not present
/// in the widget tree, the implementation prefers a provider obtained from
/// [BuildContext] but falls back to the application's DI container
/// (`di.sl`) if necessary.
///
/// Business rules
/// - Load the user's bookings after the first frame so that higher-level
///   providers have time to register (via `WidgetsBinding.instance.addPostFrameCallback`).
/// - When filtering, the UI performs client-side filtering of the already
///   loaded bookings list. The bloc remains the source of truth and should
///   be used for server-side filtering / reloading if required.
/// - Cancellation is fire-and-forget at the UI layer: the cancellation event
///   is sent to [BookingsBloc] and the UI expects the bloc to emit updated
///   states reflecting success/error.
///
/// Dependencies
/// - `BookingsBloc` (provided via context or DI)
/// - `di.sl` service locator for safe fallback
/// - `safeAddEvent<T>` utility for safe event dispatching that tolerates
///   missing providers
///
/// Usage example
/// ```dart
/// // In a page that already provides BookingsBloc in the widget tree:
/// Scaffold(
///   body: DashboardBookingsTab(),
/// );
///
/// // Or used inside a modal where provider might not be available; the
/// // widget will fall back to DI:
/// showModalBottomSheet(context: context, builder: (_) => DashboardBookingsTab());
/// ```
class DashboardBookingsTab extends StatefulWidget {
  const DashboardBookingsTab({super.key});

  @override
  State<DashboardBookingsTab> createState() => _DashboardBookingsTabState();
}

class _DashboardBookingsTabState extends State<DashboardBookingsTab> {
  BookingStatus? _selectedStatus;

  /// Safely obtain a [BookingsBloc].
  ///
  /// Parameters:
  /// - [ctx]: the [BuildContext] used to attempt to read a provider.
  ///
  /// Returns: an instance of [BookingsBloc]. If a provider is not present
  /// in the widget tree, the method falls back to `di.sl<BookingsBloc>()`.
  ///
  /// Error handling: this method swallows any exceptions from
  /// `ctx.read<BookingsBloc>()` and always returns a valid bloc instance.
  BookingsBloc _getBookingsBloc(BuildContext ctx) {
    try {
      return ctx.read<BookingsBloc>();
    } catch (_) {
      // Provider not available in this context; use DI fallback.
      return di.sl<BookingsBloc>();
    }
  }

  @override
  void initState() {
    super.initState();
    // Load user bookings after first frame to ensure providers are available.
    // Rationale: calling provider-dependent code in initState can crash when
    // the provider is injected higher in the tree after widget construction.
    // By scheduling this on the first frame we give the DI/provider layer a
    // chance to settle.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use safeAddEvent to tolerate contexts where the provider isn't
      // immediately available; safeAddEvent uses the same DI fallback
      // strategy as _getBookingsBloc.
      safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            _buildStatusFilter(context, theme),
            _buildBookingStats(context, theme),
            Expanded(
              child: _buildBookingsList(context, theme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.services);
        },
        icon: const Icon(Icons.add),
        label: Text(
          AppLocalizations.of(context)!.bookService,
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        AppLocalizations.of(context)!.myBookings,
        style: GoogleFonts.cairo(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_today, color: theme.primaryColor),
          onPressed: () {
            _showCalendarView(context);
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'history':
                _filterBookings(BookingStatus.completed);
                break;
              case 'upcoming':
                _filterBookings(BookingStatus.confirmed);
                break;
              case 'cancelled':
                _filterBookings(BookingStatus.cancelled);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'upcoming',
              child: Row(
                children: [
                  Icon(Icons.upcoming),
                  SizedBox(width: 8),
                  Text('Upcoming'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'history',
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8),
                  Text('History'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'cancelled',
              child: Row(
                children: [
                  Icon(Icons.cancel),
                  SizedBox(width: 8),
                  Text('Cancelled'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFilter(BuildContext context, ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BookingStatusFilter(
        selectedStatus: _selectedStatus,
        onStatusChanged: (status) {
          setState(() {
            _selectedStatus = status;
          });
          _filterBookings(status);
        },
      ),
    );
  }

  Widget _buildBookingStats(BuildContext context, ThemeData theme) {
    // Builds the small summary row showing counts for upcoming, in-progress
    // and completed bookings. The UI computes these counts from the snapshot
    // provided by the bloc; this is a presentation-only derivation and does
    // not trigger additional network calls.
    //
    // Returns: three stat cards when [BookingsLoaded] is available, otherwise
    // an empty widget.
    return BlocBuilder<BookingsBloc, BookingsState>(
      bloc: _getBookingsBloc(context),
      builder: (context, state) {
        if (state is BookingsLoaded) {
          final allBookings = state.bookings;
          final upcomingCount = allBookings
              .where((b) =>
                  b.status == BookingStatus.confirmed ||
                  b.status == BookingStatus.pending)
              .length;
          final inProgressCount = allBookings
              .where((b) => b.status == BookingStatus.inProgress)
              .length;
          final completedCount = allBookings
              .where((b) => b.status == BookingStatus.completed)
              .length;

          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Upcoming',
                    count: upcomingCount,
                    color: Colors.blue,
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'In Progress',
                    count: inProgressCount,
                    color: Colors.orange,
                    icon: Icons.construction,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Completed',
                    count: completedCount,
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, ThemeData theme) {
    // Builds the main bookings list view. Shows loading, error, empty and
    // normal list states depending on the bloc.
    return BlocBuilder<BookingsBloc, BookingsState>(
      bloc: _getBookingsBloc(context),
      builder: (context, state) {
        if (state is BookingsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is BookingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load bookings',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Retry triggers a fresh load via the bloc.
                    safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is BookingsLoaded) {
          var bookings = state.bookings;

          // Client-side filtering: the UI derives a filtered list from the
          // snapshot in state. Business rule: do not mutate `state.bookings`.
          if (_selectedStatus != null) {
            bookings = bookings.where((booking) {
              return booking.status == _selectedStatus;
            }).toList();
          }

          if (bookings.isEmpty) {
            // Empty state: encourage user to browse services if they have no
            // bookings yet. This branch intentionally provides an action to
            // navigate the user to the `AppRoutes.services` page.
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedStatus == null
                        ? 'No bookings yet'
                        : 'No ${_selectedStatus.toString().split('.').last} bookings',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedStatus == null
                        ? 'Book your first service to get started'
                        : 'Try selecting a different filter',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedStatus == null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.services);
                      },
                      child: const Text('Browse Services'),
                    ),
                  ],
                ],
              ),
            );
          }

          return Container(
            color: Colors.grey[50],
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookingCard(
                    booking: booking,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.bookingDetails,
                        arguments: booking.id,
                      );
                    },
                    onCancel: booking.status == BookingStatus.pending ||
                            booking.status == BookingStatus.confirmed
                        ? (bookingId, reason) =>
                            _cancelBooking(context, bookingId, reason)
                        : null,
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('Unknown state'),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    safeAddEvent<BookingsBloc>(context, GetUserBookingsEvent());
  }

  void _filterBookings(BookingStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    // The filtering is handled in the UI based on _selectedStatus
    // This method can be used to trigger additional bloc events if needed
  }

  void _showCalendarView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BlocBuilder<BookingsBloc, BookingsState>(
            bloc: _getBookingsBloc(this.context),
            builder: (context, state) {
              // The calendar view consumes the full bookings snapshot. If
              // the state is not [BookingsLoaded], an empty list is passed
              // to the calendar to avoid nulls downstream.
              return BookingCalendarView(
                bookings: state is BookingsLoaded ? state.bookings : [],
                scrollController: scrollController,
              );
            },
          ),
        ),
      ),
    );
  }

  void _cancelBooking(BuildContext context, String bookingId, String reason) {
    // Cancel a booking by emitting a cancellation event to the bloc.
    //
    // Parameters:
    // - [context]: build context used for dispatch and snackbars.
    // - [bookingId]: the id of the booking to cancel.
    // - [reason]: optional reason provided by the user.
    //
    // Behavior & error handling:
    // - This method dispatches [CancelBookingEvent] and immediately shows a
    //   confirmation snackbar. The actual success/failure is determined by
    //   subsequent states emitted by [BookingsBloc]. For a real product,
    //   consider awaiting an acknowledgement from the bloc or showing a
    //   transient 'pending' state until the bloc confirms the cancellation.
    safeAddEvent<BookingsBloc>(
      context,
      CancelBookingEvent(
        bookingId: bookingId,
        reason: reason.isNotEmpty ? reason : 'User cancelled',
      ),
    );

    // Optimistic UI: show immediate feedback. The bloc should correct the
    // UI if the cancellation fails (e.g., by emitting BookingsError).
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking cancelled successfully',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ignore: unused_element
  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              safeAddEvent<BookingsBloc>(
                context,
                CancelBookingEvent(
                  bookingId: bookingId,
                  reason: 'User cancelled',
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _rescheduleBooking(BuildContext context, String bookingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RescheduleBookingDialog(
        bookingId: bookingId,
        onReschedule: (newDate, newTime) {
          _performReschedule(context, bookingId, newDate, newTime);
        },
      ),
    );
  }

  void _performReschedule(BuildContext context, String bookingId,
      DateTime newDate, TimeOfDay newTime) {
    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    // Capture previous booking datetime so we can undo if needed
    final bloc = context.read<BookingsBloc>();
    BookingEntity? previousBooking;
    if (bloc.state is BookingsLoaded) {
      final list = (bloc.state as BookingsLoaded).bookings;
      for (final b in list) {
        if (b.id == bookingId) {
          previousBooking = b;
          break;
        }
      }
    }

    // Execute the reschedule booking action
    safeAddEvent<BookingsBloc>(
      context,
      RescheduleBookingEvent(
        bookingId: bookingId,
        newDate: newDateTime,
        newTimeSlot:
            '${newDateTime.hour.toString().padLeft(2, '0')}:${newDateTime.minute.toString().padLeft(2, '0')}',
      ),
    );
    // Log analytics event
    AnalyticsService().logEvent('booking_rescheduled', {
      'booking_id': bookingId,
      'new_date': newDateTime.toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Booking rescheduled successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            if (previousBooking != null) {
              final prevDate = previousBooking.scheduledDate;
              final prevTimeSlot =
                  '${prevDate.hour.toString().padLeft(2, '0')}:${prevDate.minute.toString().padLeft(2, '0')}';
              // Dispatch event to revert to previous date/time
              safeAddEvent<BookingsBloc>(
                context,
                RescheduleBookingEvent(
                  bookingId: bookingId,
                  newDate: prevDate,
                  newTimeSlot: prevTimeSlot,
                ),
              );

              // Log analytics for undo
              AnalyticsService().logEvent('booking_reschedule_undone', {
                'booking_id': bookingId,
                'restored_date': prevDate.toIso8601String(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Reschedule undone'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 4),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Unable to undo reschedule'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class BookingCalendarView extends StatefulWidget {
  final List<BookingEntity> bookings;
  final ScrollController scrollController;

  const BookingCalendarView({
    super.key,
    required this.bookings,
    required this.scrollController,
  });

  @override
  State<BookingCalendarView> createState() => _BookingCalendarViewState();
}

class _BookingCalendarViewState extends State<BookingCalendarView> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Calendar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        // Calendar content
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildMonthNavigation(),
              const SizedBox(height: 16),
              _buildCalendarGrid(),
              const SizedBox(height: 20),
              _buildSelectedDateBookings(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
            icon: const Icon(Icons.chevron_left, color: Colors.blue),
          ),
          Text(
            _getMonthYearString(_currentMonth),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
            icon: const Icon(Icons.chevron_right, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar days
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }

                final date = DateTime(
                    _currentMonth.year, _currentMonth.month, dayNumber);
                final hasBookings = _getBookingsForDate(date).isNotEmpty;
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : isToday
                                ? Colors.blue.withOpacity(0.2)
                                : hasBookings
                                    ? Colors.orange.withOpacity(0.3)
                                    : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : isToday
                                        ? Colors.blue
                                        : Colors.black87,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (hasBookings && !isSelected)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectedDateBookings() {
    final bookingsForDate = _getBookingsForDate(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Bookings for ${_getDateString(_selectedDate)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (bookingsForDate.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No bookings for this date',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            ...bookingsForDate.map((booking) => _buildBookingCard(booking)),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingEntity booking) {
    Color statusColor;
    IconData statusIcon;

    switch (booking.status) {
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case BookingStatus.inProgress:
        statusColor = Colors.blue;
        statusIcon = Icons.work;
        break;
      case BookingStatus.completed:
        statusColor = Colors.purple;
        statusIcon = Icons.task_alt;
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case BookingStatus.rescheduled:
        statusColor = Colors.amber;
        statusIcon = Icons.update;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        color: statusColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: ${_getTimeString(booking.scheduledDate)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Provider: ${booking.providerName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              booking.status.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BookingEntity> _getBookingsForDate(DateTime date) {
    return widget.bookings.where((booking) {
      return _isSameDay(booking.scheduledDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getDateString(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getTimeString(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class RescheduleBookingDialog extends StatefulWidget {
  final String bookingId;
  final Function(DateTime date, TimeOfDay time) onReschedule;

  const RescheduleBookingDialog({
    super.key,
    required this.bookingId,
    required this.onReschedule,
  });

  @override
  State<RescheduleBookingDialog> createState() =>
      _RescheduleBookingDialogState();
}

class _RescheduleBookingDialogState extends State<RescheduleBookingDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<String> _availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reschedule Booking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildDateSection(),
                  const SizedBox(height: 24),
                  _buildTimeSection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Select New Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedDate != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _formatSelectedDate(_selectedDate!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                'No date selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Choose Date'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Select New Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedTime != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTime!.format(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                'No time selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'Available Time Slots:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTimeSlots.map((timeSlot) {
              final time = _parseTimeSlot(timeSlot);
              final isSelected = _selectedTime == time;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canReschedule = _selectedDate != null && _selectedTime != null;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canReschedule ? _confirmReschedule : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm Reschedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[600],
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate =
        now.add(const Duration(days: 1)); // Can't reschedule for today
    final lastDate =
        now.add(const Duration(days: 365)); // Can reschedule up to 1 year ahead

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.blue,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _confirmReschedule() {
    if (_selectedDate != null && _selectedTime != null) {
      widget.onReschedule(_selectedDate!, _selectedTime!);
      Navigator.pop(context);
    }
  }

  TimeOfDay _parseTimeSlot(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timePart = parts[0];
    final period = parts[1];

    final timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatSelectedDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
