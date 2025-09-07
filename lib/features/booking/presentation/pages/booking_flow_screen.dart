import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/features/booking/presentation/bloc/booking_bloc/booking_bloc.dart';

import 'package:fix_it/features/booking/presentation/widgets/booking_step_indicator.dart';
import 'package:fix_it/features/booking/presentation/widgets/service_selection_step.dart';
import 'package:fix_it/features/booking/presentation/widgets/datetime_selection_step.dart';
import 'package:fix_it/features/booking/presentation/widgets/address_selection_step.dart';
import 'package:fix_it/features/booking/presentation/widgets/payment_selection_step.dart';
import 'package:fix_it/features/booking/presentation/widgets/booking_summary_step.dart';

class BookingFlowScreen extends StatefulWidget {
  final String? providerId;
  final String? serviceId;

  const BookingFlowScreen({
    super.key,
    this.providerId,
    this.serviceId,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize the booking with the provided provider or service after the
    // first frame to ensure provider availability.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.providerId != null) {
        safeAddEvent<BookingBloc>(context,
            StartBookingEvent(providerId: widget.providerId!));
      } else if (widget.serviceId != null) {
        safeAddEvent<BookingBloc>(context,
            StartBookingEvent(serviceId: widget.serviceId!));
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking successful!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to booking details screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.bookingDetails,
            (route) => false,
            arguments: {'bookingId': state.bookingId},
          );
        } else if (state is BookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book a Service'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookingStepIndicator(
                currentStep: _currentStep,
                onStepTapped: _onStepTapped,
              ),
            ),

            // Page view for booking steps
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ServiceSelectionStep(
                    onNext: _nextStep,
                  ),
                  DateTimeSelectionStep(
                    onNext: _nextStep,
                  ),
                  AddressSelectionStep(
                    onNext: _nextStep,
                  ),
                  PaymentSelectionStep(
                    onNext: _nextStep,
                  ),
                  BookingSummaryStep(
                    onNext: _nextStep,
                  ),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocBuilder<BookingBloc, BookingState>(
                      builder: (context, state) {
                        if (state is BookingLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ElevatedButton(
                          onPressed: _currentStep < 4
                              ? _nextStep
                                  : () {
                                  safeAddEvent<BookingBloc>(
                                    context,
                                    ConfirmBookingEvent(),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                              _currentStep < 4 ? 'Next' : 'Confirm Booking'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
