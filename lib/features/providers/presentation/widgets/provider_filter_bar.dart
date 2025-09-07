import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';

class ProviderFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final bool showNearbyOnly;
  final Function(String?) onCategoryChanged;
  final Function(bool) onNearbyToggle;
  final void Function({double? minRating, double? maxPrice, String? sort})?
      onAdvancedFiltersChanged;

  const ProviderFilterBar({
    super.key,
    this.selectedCategory,
    required this.showNearbyOnly,
    required this.onCategoryChanged,
    required this.onNearbyToggle,
    this.onAdvancedFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Category filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip(
                  context: context,
                  label: AppLocalizations.of(context)!.allServices,
                  value: null,
                  isSelected: selectedCategory == null,
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'Plumbing',
                  value: 'plumbing',
                  isSelected: selectedCategory == 'plumbing',
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'Electrical',
                  value: 'electrical',
                  isSelected: selectedCategory == 'electrical',
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'Cleaning',
                  value: 'cleaning',
                  isSelected: selectedCategory == 'cleaning',
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'Painting',
                  value: 'painting',
                  isSelected: selectedCategory == 'painting',
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'Carpentry',
                  value: 'carpentry',
                  isSelected: selectedCategory == 'carpentry',
                ),
                _buildCategoryChip(
                  context: context,
                  label: 'AC Repair',
                  value: 'ac_repair',
                  isSelected: selectedCategory == 'ac_repair',
                ),
              ],
            ),
          ),

          // Quick filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Nearby toggle
                InkWell(
                  onTap: () => onNearbyToggle(!showNearbyOnly),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: showNearbyOnly
                          ? theme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: showNearbyOnly
                            ? theme.primaryColor
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color:
                              showNearbyOnly ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.nearby,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: showNearbyOnly
                                ? Colors.white
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Sort control (distance|rating|price)
                InkWell(
                  onTap: () async {
                    final sort = await _showSortSheet(context);
                    if (sort != null && onAdvancedFiltersChanged != null) {
                      onAdvancedFiltersChanged!(sort: sort);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.sort,
                            style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Rating/Price filter
                InkWell(
                  onTap: () async {
                    final result = await _showRatingPriceSheet(context);
                    if (result != null && onAdvancedFiltersChanged != null) {
                      onAdvancedFiltersChanged!(
                        minRating: result.minRating,
                        maxPrice: result.maxPrice,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.filters,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required String? value,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          onCategoryChanged(selected ? value : null);
        },
        selectedColor: theme.primaryColor,
        backgroundColor: Colors.grey[100],
        side: BorderSide(
          color: isSelected ? theme.primaryColor : Colors.grey[300]!,
        ),
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Future<String?> _showSortSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.route),
            title: Text(AppLocalizations.of(context)!.distance,
                style: GoogleFonts.cairo()),
            onTap: () => Navigator.pop(ctx, 'distance'),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(AppLocalizations.of(context)!.rating,
                style: GoogleFonts.cairo()),
            onTap: () => Navigator.pop(ctx, 'rating'),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(context)!.price,
                style: GoogleFonts.cairo()),
            onTap: () => Navigator.pop(ctx, 'price'),
          ),
        ],
      ),
    );
  }

  Future<_RatingPriceResult?> _showRatingPriceSheet(
      BuildContext context) async {
    double? minRating;
    double? maxPrice;
    final minRatingController = TextEditingController();
    final maxPriceController = TextEditingController();
    final result = await showDialog<_RatingPriceResult>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.filters,
            style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minRatingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.min} rating (1..5)'),
            ),
            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.max} ${AppLocalizations.of(context)!.price}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final r = double.tryParse(minRatingController.text.trim());
              final p = double.tryParse(maxPriceController.text.trim());
              minRating = r;
              maxPrice = p;
              Navigator.pop(
                ctx,
                _RatingPriceResult(minRating: minRating, maxPrice: maxPrice),
              );
            },
            child: Text(AppLocalizations.of(context)!.apply),
          )
        ],
      ),
    );
    return result;
  }
}

class _RatingPriceResult {
  final double? minRating;
  final double? maxPrice;
  _RatingPriceResult({this.minRating, this.maxPrice});
}
