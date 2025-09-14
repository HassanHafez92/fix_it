// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/provider_entity.dart';
import '../bloc/provider_search_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/bloc_utils.dart';
import '../widgets/provider_card.dart';
import '../widgets/provider_search_bar.dart';
import '../widgets/provider_filter_bar.dart';

class ProvidersScreen extends StatefulWidget {
  final String? serviceCategory;

  const ProvidersScreen({super.key, this.serviceCategory});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  String? selectedCategory;
  bool showNearbyOnly = false;
  int? _selectedMinRating;
  double? _selectedMaxDistanceKm;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.serviceCategory;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProviders();
    });
  }

  void _loadProviders() {
    if (selectedCategory != null) {
      safeAddEvent<ProviderSearchBloc>(
        context,
        SearchProvidersEvent(serviceCategory: selectedCategory),
      );
    } else {
      safeAddEvent<ProviderSearchBloc>(context, GetFeaturedProvidersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCategory != null
                  ? '${selectedCategory!} ${tr('providers')}'
                  : tr('serviceProviders'),
              style: GoogleFonts.cairo(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Active filter badges
            _buildActiveFilterBadges(),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: theme.primaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/providers_map');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          ProviderSearchBar(
            onSearch: (query) {
              safeAddEvent<ProviderSearchBloc>(
                context,
                SearchProvidersEvent(
                  query: query,
                  serviceCategory: selectedCategory,
                ),
              );
            },
          ),

          // Filter Bar
          ProviderFilterBar(
            selectedCategory: selectedCategory,
            showNearbyOnly: showNearbyOnly,
            onCategoryChanged: (category) {
              setState(() {
                selectedCategory = category;
              });
              _loadProviders();
            },
            onNearbyToggle: (nearby) {
              setState(() {
                showNearbyOnly = nearby;
              });
              if (nearby) {
                () async {
                  final locationService = di.sl<LocationService>();
                  final position = await locationService.getCurrentLocation();
                  if (!mounted) return;
                  if (position != null) {
                    safeAddEvent<ProviderSearchBloc>(
                      context,
                      GetNearbyProvidersEvent(
                        latitude: position.latitude,
                        longitude: position.longitude,
                        radius: 25, // km default
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr('oopsSomethingWrong'))),
                    );
                    setState(() {
                      showNearbyOnly = false;
                    });
                  }
                }();
              } else {
                _loadProviders();
              }
            },
            onAdvancedFiltersChanged: (
                {double? minRating, double? maxPrice, String? sort}) {
              safeAddEvent<ProviderSearchBloc>(
                context,
                SearchProvidersEvent(
                  serviceCategory: selectedCategory,
                  latitude: null,
                  longitude: null,
                  radius: null,
                ),
              );
              // Re-dispatch with additional filters supported in usecase (update event/usecase if needed)
              safeAddEvent<ProviderSearchBloc>(
                context,
                SearchProvidersEvent(
                  serviceCategory: selectedCategory,
                ),
              );
            },
          ),

          // Providers List
          Expanded(
            child: BlocBuilder<ProviderSearchBloc, ProviderSearchState>(
              builder: (context, state) {
                if (state is ProviderSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProviderSearchLoaded) {
                  return _buildProvidersList(state.providers);
                } else if (state is ProviderSearchError) {
                  return _buildErrorWidget(state.message);
                } else {
                  return _buildInitialWidget();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showFilterBottomSheet(context);
        },
        label: Text(tr('filters')),
        icon: const Icon(Icons.tune),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildProvidersList(List<ProviderEntity> providers) {
    if (providers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              tr('noProvidersFound'),
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr('tryAdjustingFilters'),
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        return ProviderCard(provider: providers[index]);
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProviders,
            child: Text(tr('retry')),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            tr('serviceProviders'),
            style: GoogleFonts.cairo(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('useSearchBarToFindProviders'),
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds small badges under the AppBar title showing currently active filters.
  Widget _buildActiveFilterBadges() {
    final badges = <Widget>[];

    if (selectedCategory != null) {
      badges.add(Padding(
        padding: const EdgeInsets.only(top: 4, right: 6),
        child: InputChip(
          label: Text(selectedCategory!),
          backgroundColor: Colors.blue.shade50,
          onDeleted: () {
            setState(() {
              selectedCategory = null;
            });
            // reload without category
            safeAddEvent<ProviderSearchBloc>(
              context,
              SearchProvidersEvent(
                minRating: _selectedMinRating?.toDouble(),
                radius: _selectedMaxDistanceKm,
              ),
            );
          },
        ),
      ));
    }

    if (_selectedMinRating != null) {
      badges.add(Padding(
        padding: const EdgeInsets.only(top: 4, right: 6),
        child: InputChip(
          label: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            Text(' ${_selectedMinRating!}${tr('plusSign')}')
          ]),
          backgroundColor: Colors.amber.shade50,
          onDeleted: () {
            setState(() {
              _selectedMinRating = null;
            });
            safeAddEvent<ProviderSearchBloc>(
              context,
              SearchProvidersEvent(
                serviceCategory: selectedCategory,
                radius: _selectedMaxDistanceKm,
              ),
            );
          },
        ),
      ));
    }

    if (_selectedMaxDistanceKm != null) {
      badges.add(Padding(
        padding: const EdgeInsets.only(top: 4, right: 6),
        child: InputChip(
          label: Text('${_selectedMaxDistanceKm!.toStringAsFixed(0)} km'),
          backgroundColor: Colors.green.shade50,
          onDeleted: () {
            setState(() {
              _selectedMaxDistanceKm = null;
            });
            safeAddEvent<ProviderSearchBloc>(
              context,
              SearchProvidersEvent(
                serviceCategory: selectedCategory,
                minRating: _selectedMinRating?.toDouble(),
              ),
            );
          },
        ),
      ));
    }

    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: badges),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Providers',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Rating Filter
            Text(
              'Minimum Rating',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' $i+'),
                        ],
                      ),
                      selected: _selectedMinRating == i,
                      onSelected: (selected) {
                        setState(() {
                          _selectedMinRating = selected ? i : null;
                        });
                      },
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Distance Filter
            Text(
              'Maximum Distance',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final distance in ['5 km', '10 km', '25 km', '50 km'])
                  FilterChip(
                    label: Text(distance),
                    selected: _selectedMaxDistanceKm ==
                        double.tryParse(distance.split(' ').first),
                    onSelected: (selected) {
                      final parsed = double.tryParse(distance.split(' ').first);
                      setState(() {
                        if (selected && parsed != null) {
                          _selectedMaxDistanceKm = parsed;
                        } else if (!selected) {
                          _selectedMaxDistanceKm = null;
                        }
                      });
                    },
                  ),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Clear local filter selections and reload providers
                      setState(() {
                        _selectedMinRating = null;
                        _selectedMaxDistanceKm = null;
                        showNearbyOnly = false;
                      });
                      Navigator.pop(context);
                      _loadProviders();
                    },
                    child: Text(tr('reset')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Dispatch search with selected filters, then close sheet
                      context
                          .read<ProviderSearchBloc>()
                          .add(SearchProvidersEvent(
                            serviceCategory: selectedCategory,
                            minRating: _selectedMinRating?.toDouble(),
                            radius: _selectedMaxDistanceKm,
                          ));
                      Navigator.pop(context);
                    },
                    child: Text(tr('apply')),
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
