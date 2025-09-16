import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const ProviderSearchBar({super.key, required this.onSearch});

  @override
  State<ProviderSearchBar> createState() => _ProviderSearchBarState();
}

class _ProviderSearchBarState extends State<ProviderSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onSubmitted: widget.onSearch,
        style: GoogleFonts.cairo(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search providers...',
          hintStyle: GoogleFonts.cairo(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch('');
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isEmpty) {
            widget.onSearch('');
          }
        },
      ),
    );
  }
}
