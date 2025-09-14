import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/file_upload_service.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/time_slot_entity.dart';
import '../bloc/create_booking_bloc.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/time_slot_grid.dart';
import '../widgets/booking_form.dart';
import '../widgets/booking_summary_card.dart';
import '../../../auth/presentation/widgets/custom_button.dart';

class CreateBookingScreen extends StatefulWidget {
  final String? providerId;
  final String? serviceId;

  const CreateBookingScreen({
    super.key,
    this.providerId,
    this.serviceId,
  });

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  // convenience alias to service locator
  GetIt get sl => di.sl;
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Booking data
  DateTime? selectedDate;
  TimeSlotEntity? selectedTimeSlot;
  String? address;
  double? latitude;
  double? longitude;
  String? notes;
  bool isUrgent = false;
  List<String> attachments = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          tr('bookService'),
          style: GoogleFonts.cairo(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildStepIndicator(),
        ),
      ),
      body: BlocListener<CreateBookingBloc, CreateBookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            Navigator.pushReplacementNamed(
              context,
              '/booking_success',
              arguments: state.booking.id,
            );
          } else if (state is BookingCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDateSelectionStep(),
                  _buildTimeSelectionStep(),
                  _buildDetailsStep(),
                  _buildConfirmationStep(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) ...[
            _buildStepCircle(i),
            if (i < 3) _buildStepLine(i),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step) {
    final theme = Theme.of(context);
    final isActive = step <= _currentStep;
    final isCompleted = step < _currentStep;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? theme.primaryColor : Colors.grey[300],
        border: Border.all(
          color: isActive ? theme.primaryColor : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                '${step + 1}',
                style: GoogleFonts.cairo(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final theme = Theme.of(context);
    final isCompleted = step < _currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isCompleted ? theme.primaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildDateSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('selectDate'),
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('choosePreferredDate'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: DatePickerWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  selectedTimeSlot = null; // Reset time slot when date changes
                });

                if (widget.providerId != null) {
                  safeAddEvent<CreateBookingBloc>(
                    context,
                    GetAvailableTimeSlotsEvent(
                      providerId: widget.providerId!,
                      date: date,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('selectTime'),
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedDate != null
                ? tr('availableTimesForDate', namedArgs: {
                    'date': DateFormat('MMM dd, yyyy').format(selectedDate!)
                  })
                : tr('pleaseSelectDateFirst'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BlocBuilder<CreateBookingBloc, CreateBookingState>(
              builder: (context, state) {
                if (state is TimeSlotsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TimeSlotsLoaded) {
                  return TimeSlotGrid(
                    timeSlots: state.timeSlots,
                    selectedTimeSlot: selectedTimeSlot,
                    onTimeSlotSelected: (timeSlot) {
                      setState(() {
                        selectedTimeSlot = timeSlot;
                      });
                    },
                  );
                } else if (state is TimeSlotsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red[400]),
                        const SizedBox(height: 16),
                        Text(
                          tr('failedToLoadTimeSlots'),
                          style: GoogleFonts.cairo(
                              fontSize: 18, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: GoogleFonts.cairo(
                              fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedDate != null &&
                                widget.providerId != null) {
                              safeAddEvent<CreateBookingBloc>(
                                context,
                                GetAvailableTimeSlotsEvent(
                                  providerId: widget.providerId!,
                                  date: selectedDate!,
                                ),
                              );
                            }
                          },
                          child: Text(tr('retry')),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text(
                    tr('selectDateToViewSlots'),
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('bookingDetails'),
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('addLocationAndDetails'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BookingForm(
              address: address,
              notes: notes,
              isUrgent: isUrgent,
              attachments: attachments,
              onAddressChanged: (value) => setState(() => address = value),
              onNotesChanged: (value) => setState(() => notes = value),
              onUrgentChanged: (value) => setState(() => isUrgent = value),
              onAttachmentsChanged: (value) =>
                  setState(() => attachments = value),
              onLocationSelected: (lat, lng) {
                setState(() {
                  latitude = lat;
                  longitude = lng;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('confirmBooking'),
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('reviewBookingBeforeConfirming'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BookingSummaryCard(
              selectedDate: selectedDate,
              selectedTimeSlot: selectedTimeSlot,
              address: address,
              notes: notes,
              isUrgent: isUrgent,
              attachments: attachments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goToPreviousStep,
                child: Text(tr('back')),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<CreateBookingBloc, CreateBookingState>(
              builder: (context, state) {
                return CustomButton(
                  text: _currentStep == 3 ? tr('confirmBooking') : tr('next'),
                  enabled: _canProceed(),
                  onPressed: _handleNextStep,
                  isLoading: state is BookingCreating,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return selectedDate != null;
      case 1:
        return selectedTimeSlot != null;
      case 2:
        return address != null &&
            address!.isNotEmpty &&
            latitude != null &&
            longitude != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (_currentStep == 3) {
      _createBooking();
    } else {
      _goToNextStep();
    }
  }

  void _goToNextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createBooking() {
    if (widget.providerId != null &&
        widget.serviceId != null &&
        selectedDate != null &&
        selectedTimeSlot != null &&
        address != null &&
        latitude != null &&
        longitude != null) {
      _uploadAttachmentsAndSubmit();
    }
  }

  Future<void> _uploadAttachmentsAndSubmit() async {
    List<String>? uploadedUrls;

    if (attachments.isNotEmpty) {
      // Show a simple progress dialog while uploading
      // Keep using WillPopScope to guard against back button while the
      // upload is in progress. The new PopScope API exists in newer SDKs
      // but to maintain compatibility with this project's SDK version we
      // keep WillPopScope and locally ignore the deprecation lint.

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) =>
            // ignore: deprecated_member_use
            WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Uploading attachments...'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      try {
        final fileService = sl<FileUploadService>();
        // Convert local paths to Files
        final files = attachments.map((p) => File(p)).toList();

        // State holders for dialog
        final List<double> progresses = List<double>.filled(files.length, 0.0);
        final List<bool> completed = List<bool>.filled(files.length, false);
        final List<bool> cancelled = List<bool>.filled(files.length, false);
        final List<String?> resultUrls =
            List<String?>.filled(files.length, null);
        final List<String> uploadIds = List<String>.filled(files.length, '');

        bool started = false;

        // Show dialog with per-file progress and cancellation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => StatefulBuilder(
            builder: (ctx2, setState) {
              if (!started) {
                started = true;
                // Kick off uploads after first frame to ensure dialog is shown
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final List<Future<void>> uploadFutures = [];
                  for (int i = 0; i < files.length; i++) {
                    final file = files[i];
                    final id = '${DateTime.now().millisecondsSinceEpoch}_$i';
                    uploadIds[i] = id;

                    final fut = fileService.uploadFile(file, uploadId: id,
                        onProgress: (p) {
                      // update progress for this file
                      setState(() {
                        progresses[i] = p;
                      });
                    }).then((url) {
                      setState(() {
                        completed[i] = true;
                        resultUrls[i] = url;
                        if (url != null) progresses[i] = 1.0;
                      });
                    }).catchError((e) {
                      setState(() {
                        completed[i] = true;
                        resultUrls[i] = null;
                      });
                    });

                    uploadFutures.add(fut);
                  }

                  // Wait for all uploads to finish
                  await Future.wait(uploadFutures);
                  // After uploads done, proceed with closing dialog and returning
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                });
              }

              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: 320,
                      height: 240,
                      child: Column(
                        children: [
                          const Text('Uploading attachments...'),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, idx) {
                                final fname = files[idx]
                                    .path
                                    .split(Platform.pathSeparator)
                                    .last;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(fname,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            const SizedBox(height: 6),
                                            LinearProgressIndicator(
                                                value: progresses[idx]),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (!completed[idx])
                                        IconButton(
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.red),
                                          onPressed: () async {
                                            // mark cancelled locally and request cancellation from service
                                            setState(() {
                                              cancelled[idx] = true;
                                            });
                                            final id = uploadIds[idx];
                                            if (id.isNotEmpty) {
                                              await fileService
                                                  .cancelUpload(id);
                                            }
                                          },
                                        )
                                      else if (resultUrls[idx] != null)
                                        const Icon(Icons.check,
                                            color: Colors.green)
                                      else
                                        const Icon(Icons.error,
                                            color: Colors.orange),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );

        // After dialog closes (uploads finished), collect successful urls
        // Note: we awaited the closing by awaiting a small delay loop checking completed
        // Wait until all items have completed status
        while (!progresses.asMap().keys.every((i) => completed[i])) {
          // small delay to avoid tight loop
          await Future.delayed(const Duration(milliseconds: 100));
        }

        uploadedUrls = resultUrls.whereType<String>().toList();
      } catch (e) {
        uploadedUrls = null;
      } finally {
        // Remove the scoped will-pop callback and close the dialog only if
        // the widget is still mounted. If the widget was disposed while
        // uploading, avoid calling context-related APIs.
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }

      if (uploadedUrls == null || uploadedUrls.isEmpty) {
        // Upload failed — show a warning but allow user to proceed.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to upload attachments. Proceeding without them.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }

    if (!mounted) return;

    safeAddEvent<CreateBookingBloc>(
      context,
      CreateBookingSubmittedEvent(
        providerId: widget.providerId!,
        serviceId: widget.serviceId!,
        scheduledDate: selectedDate!,
        timeSlot:
            '${selectedTimeSlot!.startTime} - ${selectedTimeSlot!.endTime}',
        address: address!,
        latitude: latitude!,
        longitude: longitude!,
        notes: notes,
        attachments: (uploadedUrls != null && uploadedUrls.isNotEmpty)
            ? uploadedUrls
            : (attachments.isNotEmpty ? attachments : null),
        isUrgent: isUrgent,
      ),
    );
  }
}
