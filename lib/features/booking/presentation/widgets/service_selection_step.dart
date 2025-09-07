import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/features/booking/presentation/bloc/booking_bloc/booking_bloc.dart';

import 'package:fix_it/features/services/presentation/widgets/service_card.dart';
import 'package:fix_it/features/providers/presentation/widgets/provider_card.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

class ServiceSelectionStep extends StatelessWidget {
  final VoidCallback onNext;

  const ServiceSelectionStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingServiceSelection) {
          return _buildServiceSelection(context, state);
        } else if (state is BookingProviderSelection) {
          return _buildProviderSelection(context, state);
        } else if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading services
                    safeAddEvent<BookingBloc>(context, LoadServicesEvent());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Something went wrong'));
      },
    );
  }

  Widget _buildServiceSelection(
    BuildContext context,
    BookingServiceSelection state,
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
                'Select a Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose the service you need help with',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Services list
        Expanded(
          child: state.services.isEmpty
              ? const Center(
                  child: Text('No services available'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.services.length,
                  itemBuilder: (context, index) {
                    final service = state.services[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          safeAddEvent<BookingBloc>(
                              context, SelectServiceEvent(service: service));
                        },
                        child: ServiceCard(
                          service: service,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProviderSelection(
    BuildContext context,
    BookingProviderSelection state,
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
                'Select a Provider',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a provider for ${state.service.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Providers list
        Expanded(
          child: state.providers.isEmpty
              ? const Center(
                  child: Text('No providers available for this service'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.providers.length,
                  itemBuilder: (context, index) {
                    final provider = state.providers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProviderCard(
                        provider: provider,
                        onTap: () {
                          safeAddEvent<BookingBloc>(
                              context, SelectProviderEvent(provider: provider));
                          onNext();
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
