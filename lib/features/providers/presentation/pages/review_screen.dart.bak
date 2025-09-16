import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fix_it/l10n/app_localizations.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/error/failures.dart';
import '../../domain/usecases/submit_provider_review_usecase.dart';

class ReviewScreen extends StatefulWidget {
  final String providerId;
  final String? bookingId;

  const ReviewScreen({super.key, required this.providerId, this.bookingId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final usecase = di.sl<SubmitProviderReviewUseCase>();
      final params = SubmitProviderReviewParams(
        providerId: widget.providerId,
        rating: _rating,
        comment: _commentController.text.trim(),
        bookingId: widget.bookingId,
      );
      final dartz.Either<Failure, dynamic> result = await usecase.call(params);
      if (!mounted) return;
      setState(() => _submitting = false);
      result.fold((failure) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      }, (r) {
        Navigator.pop(context, true);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.couldNotSubmitReview)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.leaveAReview),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.rateProvider,
                style: GoogleFonts.cairo(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () =>
                      setState(() => _rating = starIndex.toDouble()),
                  icon: Icon(
                    _rating >= starIndex ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.shareYourExperience,
                style: GoogleFonts.cairo(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: AppLocalizations.of(context)!.shareYourExperience,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.leaveAReview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
