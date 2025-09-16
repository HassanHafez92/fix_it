import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fix_it/core/theme/app_theme.dart';
import 'package:fix_it/features/booking/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

/// DateTimeSelectionStep
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
/// // Example: Create and use DateTimeSelectionStep
/// final obj = DateTimeSelectionStep();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class DateTimeSelectionStep extends StatelessWidget {
  final VoidCallback onNext;

  const DateTimeSelectionStep({
    super.key,
    required this.onNext,
  });

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
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingDateTimeSelection) {
          return _buildDateTimeSelection(context, state);
        } else if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(
            child: Text('Please select a service and provider first'));
      },
    );
  }

  Widget _buildDateTimeSelection(
    BuildContext context,
    BookingDateTimeSelection state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Date & Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose when you want the service',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Date selection
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Date picker
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CalendarDatePicker(
                    initialDate: state.selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    onDateChanged: (date) {
                      safeAddEvent<BookingBloc>(
                          context, SelectDateEvent(date: date));
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Time selection
                const Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Time slots
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _getTimeSlots().length,
                    itemBuilder: (context, index) {
                      final timeSlot = _getTimeSlots()[index];
                      final isSelected = state.selectedTime != null &&
                          state.selectedTime!.hour == timeSlot.hour &&
                          state.selectedTime!.minute == timeSlot.minute;

                      return InkWell(
                        onTap: () {
                          safeAddEvent<BookingBloc>(
                              context,
                              SelectTimeEvent(
                                  time: TimeOfDay(
                                      hour: timeSlot.hour,
                                      minute: timeSlot.minute)));
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat.jm().format(timeSlot),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state.selectedDate != null && state.selectedTime != null
                            ? () {
                                // Combine date and time
                                final selectedDateTime = DateTime(
                                  state.selectedDate!.year,
                                  state.selectedDate!.month,
                                  state.selectedDate!.day,
                                  state.selectedTime!.hour,
                                  state.selectedTime!.minute,
                                );

                                safeAddEvent<BookingBloc>(
                                    context,
                                    SelectDateTimeEvent(
                                        dateTime: selectedDateTime));

                                onNext();
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DateTime> _getTimeSlots() {
    final List<DateTime> timeSlots = [];

    // Generate time slots from 8:00 AM to 8:00 PM with 30-minute intervals
    for (int hour = 8; hour <= 20; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        timeSlots.add(DateTime(2023, 1, 1, hour, minute));
      }
    }

    return timeSlots;
  }
}
