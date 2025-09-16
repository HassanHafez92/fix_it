import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/theme/app_theme.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/features/providers/presentation/bloc/provider_search_bloc/provider_search_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/features/providers/domain/entities/provider_entity.dart';

import 'package:fix_it/features/providers/presentation/widgets/provider_card.dart';
import 'package:easy_localization/easy_localization.dart';

class ProviderSearchScreen extends StatefulWidget {
  final String? serviceId;
  final String? initialQuery;

  const ProviderSearchScreen({
    super.key,
    this.serviceId,
    this.initialQuery,
  });

  @override
  State<ProviderSearchScreen> createState() => _ProviderSearchScreenState();
}

class _ProviderSearchScreenState extends State<ProviderSearchScreen> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedSortOption = 'rating';
  bool _showFilters = false;

  // Filter options
  double _minRating = 0.0;
  bool _verifiedOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    // Load providers when the screen initializes (deferred)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ProviderSearchBloc>(context, LoadProvidersEvent());

      // Add filter events if needed
      if (widget.serviceId != null) {
        safeAddEvent<ProviderSearchBloc>(
          context,
          FilterProvidersByServiceEvent(service: widget.serviceId),
        );
      }

      if (widget.initialQuery != null) {
        safeAddEvent<ProviderSearchBloc>(
          context,
          SearchProvidersEvent(query: widget.initialQuery!),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('providers')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: BlocListener<ProviderSearchBloc, ProviderSearchState>(
        listener: (context, state) {
          if (state is ProviderSearchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${tr('oopsSomethingWrong')}: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search providers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onFieldSubmitted: (_) {
                    _performSearch();
                  },
                ),
              ),
            ),

            // Sort and filter options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Sort dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSortOption,
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: 'rating',
                              child: Text('${tr('sort')} by ${tr('rating')}'),
                            ),
                            DropdownMenuItem(
                              value: 'price_low',
                              child: Text('${tr('price')}: Low to High'),
                            ),
                            DropdownMenuItem(
                              value: 'price_high',
                              child: Text('${tr('price')}: High to Low'),
                            ),
                            DropdownMenuItem(
                              value: 'distance',
                              child: Text(tr('distance')),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedSortOption = value;
                              });
                              _performSearch();
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter toggle button
                  Container(
                    decoration: BoxDecoration(
                      color: _showFilters ? AppTheme.primaryColor : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: _showFilters ? Colors.white : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Filter panel
            if (_showFilters) _buildFilterPanel(),

            // Results count
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ProviderSearchBloc, ProviderSearchState>(
                builder: (context, state) {
                  if (state is ProviderSearchLoaded) {
                    return Text(
                      '${state.providers.length} providers found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Providers list
            Expanded(
              child: BlocBuilder<ProviderSearchBloc, ProviderSearchState>(
                builder: (context, state) {
                  if (state is ProviderSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProviderSearchLoaded) {
                    if (state.providers.isEmpty) {
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
                              'No providers found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _showFilters = true;
                                setState(() {});
                              },
                              child: Text(tr('tryAdjustingFilters')),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _performSearch();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: state.providers.length,
                        itemBuilder: (context, index) {
                          final providerMap = state.providers[index];
                          // Convert Map to ProviderEntity
                          final providerEntity = ProviderEntity(
                            id: providerMap['id'] ?? '',
                            name: providerMap['name'] ?? '',
                            email: providerMap['email'] ?? '',
                            phone: providerMap['phone'] ?? '',
                            profileImage: providerMap['profileImage'] ?? '',
                            bio: providerMap['bio'] ?? '',
                            rating: (providerMap['rating'] ?? 0.0).toDouble(),
                            reviewCount: providerMap['reviewCount'] ?? 0,
                            services: List<String>.from(
                                providerMap['services'] ?? []),
                            location: providerMap['location'] ?? '',
                            latitude:
                                (providerMap['latitude'] ?? 0.0).toDouble(),
                            longitude:
                                (providerMap['longitude'] ?? 0.0).toDouble(),
                            isVerified: providerMap['isVerified'] ?? false,
                            isAvailable: providerMap['isAvailable'] ?? false,
                            experienceYears:
                                providerMap['experienceYears'] ?? 0,
                            hourlyRate:
                                (providerMap['hourlyRate'] ?? 0.0).toDouble(),
                            workingHours: List<String>.from(
                                providerMap['workingHours'] ?? []),
                            joinedDate: providerMap['joinedDate'] != null
                                ? DateTime.parse(providerMap['joinedDate'])
                                : DateTime.now(),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ProviderCard(
                              provider: providerEntity,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.providerProfile,
                                  arguments: {'providerId': providerMap['id']},
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is ProviderSearchError) {
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
                              _performSearch();
                            },
                            child: Text(tr('tryAgain')),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: Text(tr('somethingWentWrong')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating filter
          const Text(
            'Minimum Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber[500],
              ),
              Expanded(
                child: Slider(
                  value: _minRating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: _minRating.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _minRating = value;
                    });
                  },
                ),
              ),
              Text(
                _minRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price range filter
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Min',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                    } else {}
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Max',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                    } else {}
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Verified only filter
          Row(
            children: [
              Checkbox(
                value: _verifiedOnly,
                onChanged: (value) {
                  setState(() {
                    _verifiedOnly = value ?? false;
                  });
                },
              ),
              const Text(
                'Verified Providers Only',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Apply filters button
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _minRating = 0.0;
                      _verifiedOnly = false;
                    });
                  },
                  child: Text(tr('reset')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = false;
                    });
                    _performSearch();
                  },
                  child: Text(tr('apply')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    if (_formKey.currentState!.validate()) {
      safeAddEvent<ProviderSearchBloc>(
        context,
        SearchProvidersEvent(query: _searchController.text.trim()),
      );

      // Apply additional filters
      if (widget.serviceId != null) {
        safeAddEvent<ProviderSearchBloc>(
          context,
          FilterProvidersByServiceEvent(service: widget.serviceId),
        );
      }

      if (_minRating > 0) {
        safeAddEvent<ProviderSearchBloc>(
          context,
          FilterProvidersByRatingEvent(minRating: _minRating),
        );
      }
    }
  }
}
