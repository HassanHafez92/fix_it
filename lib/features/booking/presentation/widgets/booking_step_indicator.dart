import 'package:flutter/material.dart';
import 'package:fix_it/core/theme/app_theme.dart';

class BookingStepIndicator extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStep(0, 'Service'),
        _buildConnector(0),
        _buildStep(1, 'Date & Time'),
        _buildConnector(1),
        _buildStep(2, 'Address'),
        _buildConnector(2),
        _buildStep(3, 'Payment'),
        _buildConnector(3),
        _buildStep(4, 'Summary'),
      ],
    );
  }

  Widget _buildStep(int step, String title) {
    final isActive = step <= currentStep;
    final isCompleted = step < currentStep;

    return Expanded(
      child: InkWell(
        onTap: () => onStepTapped(step),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Step circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryColor : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        '${step + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 8),

            // Step title
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppTheme.primaryColor : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(int step) {
    final isActive = step < currentStep;

    return Container(
      width: 24,
      height: 2,
      color: isActive ? AppTheme.primaryColor : Colors.grey[300],
    );
  }
}
