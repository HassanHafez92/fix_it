// ignore_for_file: deprecated_member_use

import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/services_bloc.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ServicesBloc>(context, GetCategoriesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Categories',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          BlocBuilder<ServicesBloc, ServicesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return _buildCategoriesList(state.categories);
              } else if (state is CategoriesLoading) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is CategoriesError) {
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'Failed to load categories',
                      style: GoogleFonts.cairo(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(List<CategoryEntity> categories) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" category option
            return _buildCategoryChip(
              id: null,
              name: 'All',
              iconName: 'all',
              color: '#2196F3',
              serviceCount: 0,
              isSelected: selectedCategoryId == null,
            );
          }

          final category = categories[index - 1];
          return _buildCategoryChip(
            id: category.id,
            name: category.name,
            iconName: category.iconName,
            color: category.color,
            serviceCount: category.serviceCount,
            isSelected: selectedCategoryId == category.id,
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String? id,
    required String name,
    required String iconName,
    required String color,
    required int serviceCount,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final chipColor = _getColorFromHex(color);

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategoryId = id;
          });

          if (id == null) {
            safeAddEvent<ServicesBloc>(context, GetServicesEvent());
          } else {
            safeAddEvent<ServicesBloc>(
              context,
              GetServicesByCategoryEvent(categoryId: id),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? theme.primaryColor : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconFromName(iconName),
                size: 24,
                color: isSelected ? Colors.white : chipColor,
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
              if (serviceCount > 0 && id != null)
                Text(
                  '$serviceCount',
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[500],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue; // Default color
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'painting':
        return Icons.format_paint;
      case 'carpentry':
        return Icons.carpenter;
      case 'ac':
      case 'ac_repair':
        return Icons.ac_unit;
      case 'all':
        return Icons.apps;
      default:
        return Icons.build;
    }
  }
}
