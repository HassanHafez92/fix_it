// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import '../../../services/presentation/bloc/services_bloc/services_bloc.dart';

/// Services tab of the main dashboard
///
/// Provides comprehensive service browsing functionality:
/// - Search services
/// - Filter by categories
/// - Browse all available services
/// - Quick access to popular services
class DashboardServicesTab extends StatefulWidget {
  const DashboardServicesTab({super.key});

  @override
  State<DashboardServicesTab> createState() => _DashboardServicesTabState();
}

class _DashboardServicesTabState extends State<DashboardServicesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  // Local state for bottom-sheet filter selections
  final Map<String, bool> _filterSelections = {};

  // Safely obtain a ServicesBloc: prefer the provider if available, else use DI.
  ServicesBloc _getServicesBloc(BuildContext ctx) {
    try {
      return ctx.read<ServicesBloc>();
    } catch (_) {
      return di.sl<ServicesBloc>();
    }
  }

  // Testing helpers
  @visibleForTesting
  Map<String, bool> get testFilterSelections => _filterSelections;

  @visibleForTesting
  Future<void> testApplyFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedKeys = _filterSelections.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    await prefs.setString('service_filters', selectedKeys.join(','));
  safeAddEvent<ServicesBloc>(context, ApplyServiceFiltersEvent(
    category: _selectedCategory == 'All' ? null : _selectedCategory,
    filters: _filterSelections));
  }

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
    // Load services (services bloc also derives categories from services)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ServicesBloc>(context, LoadServicesEvent());
    });
    // Load persisted filter selections
    _loadSavedFilters();
  }

  Future<void> _loadSavedFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final csv = prefs.getString('service_filters') ?? '';
      if (csv.isNotEmpty) {
        final keys = csv.split(',');
        for (final k in keys) {
          if (k.trim().isNotEmpty) {
            _filterSelections[k.trim()] = true;
          }
        }
      }
    } catch (_) {
      // ignore
    }
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
    _searchController.dispose();
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            _buildSearchSection(context, theme),
            _buildCategoryFilter(context, theme),
            Expanded(
              child: _buildServicesGrid(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Services',
        style: GoogleFonts.cairo(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: theme.primaryColor),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.search);
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: theme.primaryColor),
          onPressed: () {
            _showFilterBottomSheet(context);
          },
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context, ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for services...',
                hintStyle: GoogleFonts.cairo(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
              style: GoogleFonts.cairo(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child:
                    _buildQuickSearchChip('Popular', Icons.trending_up, theme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickSearchChip('Emergency', Icons.warning, theme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child:
                    _buildQuickSearchChip('Near Me', Icons.location_on, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchChip(String label, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.primaryColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, ThemeData theme) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      bloc: _getServicesBloc(context),
      builder: (context, state) {
        if (state is ServicesLoaded) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ['All', ...state.categories].length,
                itemBuilder: (context, index) {
                  final categories = ['All', ...state.categories];
                  final category = categories[index];
                  final isSelected = category == _selectedCategory;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _filterServicesByCategory(category);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildServicesGrid(BuildContext context, ThemeData theme) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      bloc: _getServicesBloc(context),
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ServicesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load services',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    safeAddEvent<ServicesBloc>(context, LoadServicesEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ServicesLoaded) {
          final services = state.services;

          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No services available',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for available services',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: Colors.grey[50],
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.serviceDetails,
                        arguments: service['id'],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['title'] ?? 'Service',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service['description'] ?? 'No description',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${service['price'] ?? '0'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service['category'] ?? 'General',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('Unknown state'),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    safeAddEvent<ServicesBloc>(context, LoadServicesEvent());
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      safeAddEvent<ServicesBloc>(context, LoadServicesEvent());
    } else {
      safeAddEvent<ServicesBloc>(context, SearchServicesEvent(query: query));
    }
  }

  void _filterServicesByCategory(String category) {
    if (category == 'All') {
      safeAddEvent<ServicesBloc>(context, FilterServicesByCategoryEvent(category: null));
    } else {
      // Dispatch filter event to the bloc which will update filteredServices
      safeAddEvent<ServicesBloc>(context, FilterServicesByCategoryEvent(category: category));
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(context),
    );
  }

  Widget _buildFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Services',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilterSection(
              'Sort By',
              [
                'Most Popular',
                'Highest Rated',
                'Nearest',
                'Price: Low to High',
                'Price: High to Low',
              ],
              theme,
            ),
            const SizedBox(height: 20),
            _buildFilterSection(
              'Availability',
              [
                'Available Now',
                'Available Today',
                'Available This Week',
              ],
              theme,
            ),
            const SizedBox(height: 20),
            _buildFilterSection(
              'Rating',
              [
                '4+ Stars',
                '3+ Stars',
                '2+ Stars',
              ],
              theme,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Clear filters
                      setState(() {
                        _filterSelections.clear();
                      });
                      // Persist cleared filters
                      SharedPreferences.getInstance()
                          .then((prefs) => prefs.remove('service_filters'));
            // Re-apply filters (none)
            safeAddEvent<ServicesBloc>(
            context,
            ApplyServiceFiltersEvent(
              category: _selectedCategory == 'All'
                ? null
                : _selectedCategory,
              filters: _filterSelections),
            );
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Filters'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      // Persist selections as a simple CSV of selected keys
                      final selectedKeys = _filterSelections.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();
                      SharedPreferences.getInstance().then((prefs) =>
                          prefs.setString(
                              'service_filters', selectedKeys.join(',')));
            // Dispatch apply filters event
            safeAddEvent<ServicesBloc>(
            context,
            ApplyServiceFiltersEvent(
              category: _selectedCategory == 'All'
                ? null
                : _selectedCategory,
              filters: _filterSelections),
            );
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected = _filterSelections[option] ?? false;
            return FilterChip(
              label: Text(option),
              selected: selected,
              onSelected: (isSelected) {
                setState(() {
                  _filterSelections[option] = isSelected;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
