import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/usecases/get_booking_details_usecase.dart';
import '../../domain/usecases/get_available_time_slots_usecase.dart';
import '../../domain/usecases/reschedule_booking_usecase.dart';

/// ModifyBookingScreen
///
/// Screen used to reschedule or modify an existing booking. Loads booking
/// details and enables selection of a new date/time and address.
///
/// Business Rules:
/// - Prevents scheduling to past dates and validates available time slots.
class ModifyBookingScreen extends StatefulWidget {
  final String bookingId;

  const ModifyBookingScreen({super.key, required this.bookingId});

  @override
  State<ModifyBookingScreen> createState() => _ModifyBookingScreenState();
}

class _ModifyBookingScreenState extends State<ModifyBookingScreen> {
  bool _loading = true;
  bool _submitting = false;
  BookingEntity? _booking;
  DateTime? _selectedDate;
  TimeSlotEntity? _selectedTimeSlot;
  List<TimeSlotEntity> _timeSlots = [];
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  final DateFormat _dateFormat = DateFormat.yMMMMd();

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
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    setState(() => _loading = true);
    final getDetails = di.sl<GetBookingDetailsUseCase>();
    final result =
        await getDetails(GetBookingDetailsParams(bookingId: widget.bookingId));
    result.fold((failure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load booking: ${failure.message}')),
        );
        Navigator.pop(context);
      }
    }, (booking) async {
      _booking = booking;
      _selectedDate = booking.scheduledDate;
      _addressController.text = booking.address;
      _notesController.text = booking.notes ?? '';

      // load time slots for the provider/date
      await _loadTimeSlotsForDate(_selectedDate!);

      // pick the timeslot that matches booking.timeSlot if present
      TimeSlotEntity? match;
      for (final ts in _timeSlots) {
        if ('${ts.startTime} - ${ts.endTime}' == booking.timeSlot) {
          match = ts;
          break;
        }
      }
      if (match == null && _timeSlots.isNotEmpty) {
        match = _timeSlots.first;
      }
      _selectedTimeSlot = match;
      if (mounted) setState(() => _loading = false);
    });
  }

  Future<void> _loadTimeSlotsForDate(DateTime date) async {
    final getSlots = di.sl<GetAvailableTimeSlotsUseCase>();
    final result = await getSlots(GetAvailableTimeSlotsParams(
      providerId: _booking!.providerId,
      date: date,
    ));
    result.fold((failure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load time slots: ${failure.message}')),
        );
      }
    }, (slots) {
      _timeSlots = slots;
      if (mounted) setState(() {});
    });
  }

  Future<void> _pickDate() async {
    final initial = _selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
        _timeSlots = [];
      });
      await _loadTimeSlotsForDate(picked);
      if (mounted) setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a date and time slot')),
      );
      return;
    }
    setState(() => _submitting = true);
    final reschedule = di.sl<RescheduleBookingUseCase>();
    final result = await reschedule(RescheduleBookingParams(
      bookingId: widget.bookingId,
      newDate: _selectedDate!,
      newTimeSlot:
          '${_selectedTimeSlot!.startTime} - ${_selectedTimeSlot!.endTime}',
    ));
    result.fold((failure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reschedule: ${failure.message}')),
        );
        setState(() => _submitting = false);
      }
    }, (updatedBooking) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated')),
        );
        Navigator.pop(context, true);
      }
    });
  }

  @override
/// dispose
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
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
        title: Text('Modify Booking', style: GoogleFonts.cairo()),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_booking!.serviceName, style: GoogleFonts.cairo()),
                  const SizedBox(height: 16),
                  Text('Provider',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_booking!.providerName, style: GoogleFonts.cairo()),
                  const SizedBox(height: 16),
                  Text('Date',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            _selectedDate != null
                                ? _dateFormat.format(_selectedDate!)
                                : 'Select date',
                            style: GoogleFonts.cairo()),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Time slot',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _timeSlots.isEmpty
                      ? const Text('No time slots available',
                          style: TextStyle(color: Colors.grey))
                      : DropdownButton<TimeSlotEntity>(
                          isExpanded: true,
                          value: _selectedTimeSlot,
                          hint: const Text('Select a time slot'),
                          items: _timeSlots
                              .map(
                                (ts) => DropdownMenuItem<TimeSlotEntity>(
                                  value: ts,
                                  child:
                                      Text('${ts.startTime} - ${ts.endTime}'),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedTimeSlot = val),
                        ),
                  const SizedBox(height: 16),
                  Text('Address',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: _addressController),
                  const SizedBox(height: 16),
                  Text('Notes',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: _notesController, maxLines: 3),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submit,
                          child: _submitting
                              ? const CircularProgressIndicator()
                              : const Text('Save changes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
