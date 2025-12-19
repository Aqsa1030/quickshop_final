import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final String? hintText;
  final bool autoFocus;

  const SearchBar({
    super.key,
    required this.onSearch,
    this.hintText,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        autofocus: autoFocus,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search products...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.grey.shade500,
            ),
            onPressed: () {
              // Show filter options
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: onSearch,
      ),
    );
  }
}