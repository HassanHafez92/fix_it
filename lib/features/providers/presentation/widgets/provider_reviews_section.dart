import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import '../../domain/entities/review_entity.dart';

class ProviderReviewsSection extends StatelessWidget {
  final String providerId;
  final List<ReviewEntity> reviews;
  final bool isLoadingReviews;
  final String? reviewsError;

  const ProviderReviewsSection({
    super.key,
    required this.providerId,
    required this.reviews,
    required this.isLoadingReviews,
    this.reviewsError,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.reviewsLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '(${reviews.length})',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoadingReviews)
              const Center(child: CircularProgressIndicator())
            else if (reviewsError != null)
              _buildErrorWidget(context, reviewsError!)
            else if (reviews.isEmpty)
              _buildEmptyWidget(context)
            else
              ...reviews.map((review) => _buildReviewItem(review)),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(ReviewEntity review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (index) => Icon(
                                  index < review.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                )),
                        const SizedBox(width: 8),
                        Text(
                          review.createdAt.toString().split(' ')[0],
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noReviewsYet,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.failedToLoadReviews,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
