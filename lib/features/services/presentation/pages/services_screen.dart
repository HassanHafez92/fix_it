import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import '../../domain/entities/service_entity.dart';
import '../bloc/services_bloc.dart';
import '../widgets/service_card.dart';
import '../widgets/category_filter.dart';

class ServicesScreen extends StatefulWidget {
  final String? categoryId;

  const ServicesScreen({super.key, this.categoryId});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.categoryId != null) {
        safeAddEvent<ServicesBloc>(
          context,
          GetServicesByCategoryEvent(categoryId: widget.categoryId!),
        );
      } else {
        safeAddEvent<ServicesBloc>(context, GetServicesEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.categoryId != null
              ? AppLocalizations.of(context)!.categories
              : AppLocalizations.of(context)!.allServices,
          style: GoogleFonts.cairo(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.primaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/search_services');
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.primaryColor),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories Filter
          if (widget.categoryId == null) const CategoryFilter(),

          // Services List
          Expanded(
            child: BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServicesLoaded) {
                  return _buildServicesList(state.services);
                } else if (state is ServicesLoaded) {
                  return _buildServicesList(state.services);
                } else if (state is ServicesError) {
                  return _buildErrorWidget(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<ServiceEntity> services) {
    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noServicesFound,
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryAdjustingSearch,
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
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceCard(service: services[index]);
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
            AppLocalizations.of(context)!.oopsSomethingWrong,
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
              onPressed: () {
                if (widget.categoryId != null) {
                  safeAddEvent<ServicesBloc>(
                    context,
                    GetServicesByCategoryEvent(categoryId: widget.categoryId!),
                  );
                } else {
                  safeAddEvent<ServicesBloc>(context, GetServicesEvent());
                }
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
        ],
      ),
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
              AppLocalizations.of(context)!.filterServices,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add filter options here
            Text(
              AppLocalizations.of(context)!.comingSoon,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
