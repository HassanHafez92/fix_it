import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/features/services/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:fix_it/features/services/presentation/widgets/search_service_card.dart';
import 'package:fix_it/features/providers/presentation/widgets/provider_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus on search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة أو فني...',
                prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        safeAddEvent<SearchBloc>(context, const ClearSearchEvent());
                      },
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  safeAddEvent<SearchBloc>(context, SearchQueryChangedEvent(query));
                } else {
                  safeAddEvent<SearchBloc>(context, const ClearSearchEvent());
                }
              },
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  safeAddEvent<SearchBloc>(context, PerformSearchEvent(query));
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('الخدمات'),
                    selected: true,
                    onSelected: (value) {
                      // Toggle services filter
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('الفنيين'),
                    selected: true,
                    onSelected: (value) {
                      // Toggle providers filter
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return _buildRecentSearches();
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchResultsLoaded) {
                  if (state.services.isEmpty && state.providers.isEmpty) {
                    return const Center(
                      child: Text('لا توجد نتائج للبحث'),
                    );
                  }
                  return _buildSearchResults(state);
                } else if (state is SearchError) {
                  return Center(
                    child: Text('حدث خطأ: ${state.message}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'عمليات البحث الأخيرة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildRecentSearchItem('سباك'),
              _buildRecentSearchItem('كهربائي'),
              _buildRecentSearchItem('نظافة'),
              _buildRecentSearchItem('تكييف'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem(String query) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(query),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _searchController.text = query;
        safeAddEvent<SearchBloc>(context, PerformSearchEvent(query));
      },
    );
  }

  Widget _buildSearchResults(SearchResultsLoaded state) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'الخدمات'),
              Tab(text: 'الفنيين'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildServicesTab(state.services),
                _buildProvidersTab(state.providers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab(List services) {
    if (services.isEmpty) {
      return const Center(
        child: Text('لا توجد خدمات مطابقة لبحثك'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return SearchServiceCard(service: services[index]);
      },
    );
  }

  Widget _buildProvidersTab(List providers) {
    if (providers.isEmpty) {
      return const Center(
        child: Text('لا يوجد فنيون مطابقون لبحثك'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        return ProviderCard(provider: providers[index]);
      },
    );
  }
}
